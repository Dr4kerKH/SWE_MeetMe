# Import necessary libraries and modules
import logging
import os
from dotenv import load_dotenv
from fastapi import FastAPI, HTTPException, Depends, WebSocket, WebSocketDisconnect
from pymongo import MongoClient
from pymongo.server_api import ServerApi
from fastapi.security import OAuth2PasswordBearer, OAuth2PasswordRequestForm
from datetime import datetime, timedelta
from passlib.context import CryptContext
from typing import List, Dict
import jwt
from bson import ObjectId
import random
import string

from model import (
    User, UserResponse, Appointment, AppointmentResponse,
    Class, ClassResponse, UserLogin, Enrollment, EnrollmentResponse, Avaliable, AvaliableResponse
)
# For WebSockets
class ConnectionManager:
    def __init__(self):
        self.active_connections: Dict[str, List[WebSocket]] = {}

    async def connect(self, websocket: WebSocket, user_id: str):
        await websocket.accept()
        if user_id not in self.active_connections:
            self.active_connections[user_id] = []
        self.active_connections[user_id].append(websocket)
        logging.info(f"🔌 User connected: {user_id}")

    def disconnect(self, websocket: WebSocket, user_id: str):
        if user_id in self.active_connections:
            self.active_connections[user_id].remove(websocket)
            if not self.active_connections[user_id]:
                del self.active_connections[user_id]
        logging.info(f"❌ User disconnected: {user_id}")

    async def send_personal_message(self, message: str, user_id: str):
        if user_id in self.active_connections:
            for connection in self.active_connections[user_id]:
                await connection.send_text(message)

    async def broadcast(self, message: str):
        for conns in self.active_connections.values():
            for connection in conns:
                await connection.send_text(message)

manager = ConnectionManager()

# Load env variables
load_dotenv()
app = FastAPI()
logging.basicConfig(level=logging.INFO)
logger = logging.getLogger(__name__)

############################ Database Connection ############################
MONGODB_URI = os.getenv("MONGODB_URI")
SECRET_KEY = os.getenv("SECRET_KEY")
client = MongoClient(MONGODB_URI, server_api=ServerApi('1'))

try:
    client.admin.command('ping')
    print("Connected to MongoDB!")
except Exception as e:
    print("MongoDB connection error:", e)

db = client['MeetMeDB']
users_collection = db['users']
appointments_collection = db['appointments']
classes_collection = db['classes']
enroll_collection = db['enrollments']
time_avaliable_collection = db ['time_avaliable']
chat_messages_collection = db["chat_messages"]
notifications_collection = db["notifications"]

############################ Security Setup ############################
oauth2_scheme = OAuth2PasswordBearer(tokenUrl="token")
pwd_context = CryptContext(schemes=["bcrypt"], deprecated="auto")
ALGORITHM = "HS256"

@app.on_event("startup")
async def startup_event():
    logger.info("🚀 FastAPI server starting up...")

############################ Helper Functions ############################
def verify_password(plain_password, hashed_password):
    return pwd_context.verify(plain_password, hashed_password)

def get_password_hash(password):
    return pwd_context.hash(password)

def create_access_token(data: dict, expires_delta: timedelta = timedelta(hours=1)):
    to_encode = data.copy()
    to_encode.update({"exp": datetime.utcnow() + expires_delta})
    return jwt.encode(to_encode, SECRET_KEY, algorithm=ALGORITHM)

def get_current_user(token: str = Depends(oauth2_scheme)):
    try:
        payload = jwt.decode(token, SECRET_KEY, algorithms=[ALGORITHM])
        user_email = payload.get("sub")
        if user_email is None:
            raise HTTPException(status_code=401, detail="Invalid token")
        user = users_collection.find_one({"email": user_email})
        if user is None:
            raise HTTPException(status_code=401, detail="User not found")
        return {"email": user_email, "role": user["role"]}
    except jwt.PyJWTError:
        raise HTTPException(status_code=401, detail="Invalid token")

############################ API Endpoints ############################
@app.get("/")
async def read_root():
    return {"message": "Welcome to the FastAPI application!"}

# --- Account Management ---
@app.post("/accounts", response_model=UserResponse)
async def create_account(user: User):
    if users_collection.find_one({"email": user.email}):
        raise HTTPException(status_code=400, detail="Email already registered")
    user_dict = user.dict()
    user_dict["password"] = get_password_hash(user.password)
    users_collection.insert_one(user_dict)
    return UserResponse(email=user.email, username=user.username, role=user.role)

@app.post("/login")
async def login(login_data: UserLogin):
    user = users_collection.find_one({"email": login_data.email})
    if not user or not verify_password(login_data.password, user['password']):
        raise HTTPException(status_code=401, detail="Invalid email or password")
    token = create_access_token(data={"sub": user['email']})
    return {"role": user["role"], "access_token": token, "token_type": "bearer"}

# --- Appointment ---
@app.post("/appointments", response_model=AppointmentResponse)
async def create_appointment(appointment: Appointment, current_user: dict = Depends(get_current_user)):
    start_time = appointment.appointment_date
    end_time = start_time + timedelta(minutes=29)
    if (end_time - start_time).total_seconds() != 1740:
        raise HTTPException(status_code=400, detail="Appointment duration must be exactly 30 minutes")
    appointment_dict = appointment.dict()
    appointment_dict["appointment_date"] = start_time.isoformat()
    appointment_dict["user_email"] = current_user["email"]  # Track who created it
    result = appointments_collection.insert_one(appointment_dict)
    appointment_dict["id"] = str(result.inserted_id)
    return {"id": appointment_dict["id"], "appointment_date": start_time.isoformat()}

@app.get("/appointments", response_model=List[AppointmentResponse])
async def get_appointments():
    appointments = list(appointments_collection.find())
    if not appointments:
        raise HTTPException(status_code=404, detail="No appointments found")
    return [{"id": str(app["_id"]), **app} for app in appointments]

@app.get("/appointments/{appointment_id}", response_model=AppointmentResponse)
async def get_appointment_by_id(appointment_id: str):
    appointment = appointments_collection.find_one({"_id": ObjectId(appointment_id)})
    if not appointment:
        raise HTTPException(status_code=404, detail="Appointment not found")
    return {"id": str(appointment["_id"]), **appointment}

@app.get("/get_schedule", response_model=List[AppointmentResponse])
async def get_schedule(date: str):
    try:
        datetime.strptime(date, "%Y-%m-%d")
    except ValueError:
        raise HTTPException(status_code=400, detail="Invalid date format. Use YYYY-MM-DD")
    appointments = list(appointments_collection.find({"appointment_date": date}))
    if not appointments:
        raise HTTPException(status_code=404, detail="No appointments found for this date")
    return [{"id": str(app["_id"]), **app} for app in appointments]

# --- Class Management ---
@app.post("/classes", response_model=ClassResponse)
async def create_class(cls: Class, current_user: dict = Depends(get_current_user)):
    if current_user["role"] != "Professor":
        raise HTTPException(status_code=403, detail="Only professors can create classes")

    def generate_unique_course_code():
        while True:
            code = ''.join(random.choices(string.ascii_uppercase + string.digits, k=8))
            if not classes_collection.find_one({"course_code": code}):
                return code

    cls.course_code = generate_unique_course_code()
    if classes_collection.find_one({"course_code": cls.course_code}):
        raise HTTPException(status_code=400, detail="Course code already exists")
    class_dict = {
        "course_code": cls.course_code,
        "course_name": cls.course_name,
        "professor_name": cls.professor_name,
        "course_description": cls.course_description,
    }
    try:
        # Insert the class into the database
        result = classes_collection.insert_one(class_dict)
        class_dict["id"] = str(result.inserted_id)

        # Enroll the professor in the class
        enroll_collection.insert_one({
            "user_email": current_user["email"],
            "course_code": cls.course_code,
            "role": "professor"
        })
    except Exception as e:
        raise HTTPException(status_code=500, detail=f"An error occurred: {str(e)}")
    # Return the created class details
    return ClassResponse(**class_dict)

@app.get("/classes", response_model=List[ClassResponse])
async def get_classes():
    classes = list(classes_collection.find())
    if not classes:
        raise HTTPException(status_code=404, detail="No classes found")
    return [{"id": str(cls["_id"]), **cls} for cls in classes]

@app.get("/classes/{course_code}", response_model=ClassResponse)
async def get_class_by_id(course_code: str):
    cls = classes_collection.find_one({"course_code": course_code})
    if not cls:
        raise HTTPException(status_code=404, detail="Class not found")
    return {"id": str(cls["_id"]), **cls}

@app.get("/my_classes", response_model=List[ClassResponse])
async def get_my_classes(current_user: dict = Depends(get_current_user)):
    enrollments = list(enroll_collection.find({"user_email": current_user["email"]}))
    if not enrollments:
        raise HTTPException(status_code=404, detail="User is not enrolled in any classes")

    course_codes = [en["course_code"] for en in enrollments]
    classes = list(classes_collection.find({"course_code": {"$in": course_codes}}))
    return [{"id": str(cls["_id"]), **cls} for cls in classes]

# --- Delete ---
@app.delete("/classes/{course_code}", response_model=dict)
async def delete_class(course_code: str, current_user: dict = Depends(get_current_user)):
    if current_user["role"] != "professor":
        raise HTTPException(status_code=403, detail="Not authorized to delete classes")

    result = classes_collection.delete_one({"course_code": course_code})
    if result.deleted_count == 0:
        raise HTTPException(status_code=404, detail="Class not found")
    return {"message": "Class deleted successfully"}

@app.delete("/appointments/{appointment_id}", response_model=dict)
async def delete_appointment(appointment_id: str, current_user: dict = Depends(get_current_user)):
    if current_user["role"] != "professor":
        raise HTTPException(status_code=403, detail="Not authorized to delete appointments")

    result = appointments_collection.delete_one({"_id": ObjectId(appointment_id)})
    if result.deleted_count == 0:
        raise HTTPException(status_code=404, detail="Appointment not found")
    return {"message": "Appointment deleted successfully"}

@app.post("/classTimeAvailable", response_model=AvaliableResponse)
async def set_or_append_available_time(payload: Avaliable):
    course_code = payload.course_code
    time = payload.time

    existing = time_avaliable_collection.find_one({"course_code": course_code})
    if existing:
        time_avaliable_collection.update_one(
            {"course_code": course_code},
            {"$set": {"time": sorted(time)}}
        )

        return AvaliableResponse(
            id=str(existing["_id"]),
            course_code=course_code,
            time=sorted(time)
        )
    else:
        time_avaliable = {
            "course_code": course_code,
            "time": time
        }
        result = time_avaliable_collection.insert_one(time_avaliable)
        return AvaliableResponse(
            id=str(result.inserted_id),
            course_code=course_code,
            time=time
        )
    
@app.get("/getClassTimeAvailable", response_model=Avaliable)
async def get_available_time(course_code: str):
    existing = time_avaliable_collection.find_one({"course_code": course_code})
    if existing:
        return Avaliable(
            course_code=course_code,
            time=existing.get("time", [])
        )
    else:
        return Avaliable(
            course_code=course_code,
            time=[]
        )
    

@app.websocket("/ws/{user_id}")
async def websocket_endpoint(websocket: WebSocket, user_id: str):
    await manager.connect(websocket, user_id)
    try:
        while True:
            data = await websocket.receive_text()
            logging.info(f"📩 Message from {user_id}: {data}")
            # Example: Echo message back to sender (can enhance later)
            await manager.send_personal_message(f"You said: {data}", user_id)
    except WebSocketDisconnect:
        manager.disconnect(websocket, user_id)

connected_users: Dict[str, WebSocket] = {}

@app.websocket("/ws/chat/{user_id}")
async def websocket_endpoint(websocket: WebSocket, user_id: str):
    await websocket.accept()
    connected_users[user_id] = websocket
    try:
        while True:
            data = await websocket.receive_json()
            # Save to MongoDB
            chat_messages_collection.insert_one({
                "sender_id": data["sender_id"],
                "receiver_id": data["receiver_id"],
                "message": data["message"],
                "timestamp": datetime.utcnow().isoformat()
            })

            # Forward message to recipient if connected
            receiver_ws = connected_users.get(data["receiver_id"])
            if receiver_ws:
                await receiver_ws.send_json(data)
    except WebSocketDisconnect:
        connected_users.pop(user_id, None)

@app.get("/chat/history")
def get_chat_history(user1: str, user2: str):
    messages = list(chat_messages_collection.find({
        "$or": [
            {"sender_id": user1, "receiver_id": user2},
            {"sender_id": user2, "receiver_id": user1},
        ]
    }).sort("timestamp", 1))

    for msg in messages:
        msg["id"] = str(msg["_id"])
        del msg["_id"]
    return messages

@app.get("/notifications/{email}")
async def get_notifications(email: str):
    raw_notifications = notifications_collection.find({"recipient_email": email}).sort("timestamp", -1)
    
    notifications = []
    for n in raw_notifications:
        n["_id"] = str(n["_id"])  # Convert ObjectId to string
        notifications.append(n)
    
    return notifications