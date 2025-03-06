# main.py
import os
from dotenv import load_dotenv
from fastapi import FastAPI, HTTPException, Depends
from pymongo import MongoClient
from datetime import datetime
from typing import List
from fastapi.security import OAuth2PasswordBearer, OAuth2PasswordRequestForm
from passlib.context import CryptContext
import jwt
from bson import ObjectId
from model import User, UserResponse, Appointment, AppointmentResponse, Class, ClassResponse  # Import models

# Load environment variables from .env
load_dotenv()
app = FastAPI()

############################ Database Connection ############################
MONGODB_URI = os.getenv("MONGODB_URI")
if not MONGODB_URI:
    raise ValueError("MONGODB_URI is not set in the .env file")

client = MongoClient(MONGODB_URI)
db = client['appointmentDB']
users_collection = db['users']
appointments_collection = db['appointments']
classes_collection = db['classes']

############################ Security Setup ############################
oauth2_scheme = OAuth2PasswordBearer(tokenUrl="token")
pwd_context = CryptContext(schemes=["bcrypt"], deprecated="auto")
SECRET_KEY = os.getenv("SECRET_KEY", "your_secret_key")
ALGORITHM = "HS256"

############################ Helper Functions ############################
def verify_password(plain_password, hashed_password):
    return pwd_context.verify(plain_password, hashed_password)

def get_password_hash(password):
    return pwd_context.hash(password)

def create_access_token(data: dict):
    to_encode = data.copy()
    return jwt.encode(to_encode, SECRET_KEY, algorithm=ALGORITHM)


############################ API Endpoints ############################
#######################################################################
# Post Requests
@app.post("/accounts", response_model=UserResponse)
async def create_account(user: User):
    if users_collection.find_one({"email": user.email}):
        raise HTTPException(status_code=400, detail="Email already registered")
    
    hashed_password = get_password_hash(user.password)
    user_dict = user.dict()
    user_dict["password"] = hashed_password
    users_collection.insert_one(user_dict)

    return UserResponse(email=user.email, username=user.username, role=user.role)

@app.post("/login")
async def login(form_data: OAuth2PasswordRequestForm = Depends()):
    user = users_collection.find_one({"email": form_data.username})
    if not user or not verify_password(form_data.password, user['password']):
        raise HTTPException(status_code=401, detail="Invalid password")
    
    token = create_access_token(data={"sub": user['email']})

    return {"access_token": token, "token_type": "bearer"}

@app.post("/appointments", response_model=AppointmentResponse)
async def create_appointment(appointment: Appointment):
    appointment_dict = appointment.dict()
    appointment_dict["appointment_date"] = appointment.appointment_date.isoformat()
    result = appointments_collection.insert_one(appointment_dict)
    appointment_dict["id"] = str(result.inserted_id)
    
    return appointment_dict

# Get Requests
@app.get("/classes", response_model=List[ClassResponse])
async def get_classes():
    classes = list(classes_collection.find())
    if not classes:
        raise HTTPException(status_code=404, detail="No classes found")
    
    return [{"id": str(cls["_id"]), **cls} for cls in classes]

@app.get("/classes/{course_id}", response_model=ClassResponse)
async def get_class_by_id(course_id: str):
    cls = classes_collection.find_one({"course_id": course_id})
    if not cls:
        raise HTTPException(status_code=404, detail="Class not found")
    
    return {"id": str(cls["_id"]), **cls}

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

# Put Requests