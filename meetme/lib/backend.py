import os
from dotenv import load_dotenv
from fastapi import FastAPI, HTTPException, Depends
from pydantic import BaseModel
from pymongo import MongoClient
from datetime import datetime
from typing import List
from fastapi.security import OAuth2PasswordBearer, OAuth2PasswordRequestForm
from passlib.context import CryptContext
import jwt

# Load environment variables from .env
load_dotenv()
app = FastAPI()

# Get the MongoDB URI from environment variables
MONGODB_URI = os.getenv("MONGODB_URI")
if not MONGODB_URI:
    raise ValueError("MONGODB_URI is not set in the .env file")

# Connect to MongoDB
client = MongoClient(MONGODB_URI)
db = client['appointmentDB']
users_collection = db['users']
appointments_collection = db['appointments']
classes_collection = db['classes']

# Define models
class User(BaseModel):
    email: str
    username: str
    password: str
    role: str  # "professor" or "student"

class UserResponse(BaseModel):
    email: str
    username: str
    role: str

class Appointment(BaseModel):
    student_name: str
    student_email: str
    course_id: str
    course_name: str
    professor_name: str
    appointment_date: datetime

class AppointmentResponse(Appointment):
    id: str

class Class(BaseModel):
    course_id: str
    course_name: str
    professor_name: str

class ClassResponse(Class):
    id: str

# Security setup
oauth2_scheme = OAuth2PasswordBearer(tokenUrl="token")
pwd_context = CryptContext(schemes=["bcrypt"], deprecated="auto")

# Helper functions for authentication
def verify_password(plain_password, hashed_password):
    return pwd_context.verify(plain_password, hashed_password)

def get_password_hash(password):
    return pwd_context.hash(password)

# JWT token creation
SECRET_KEY = os.getenv("SECRET_KEY", "your_secret_key")
ALGORITHM = "HS256"

def create_access_token(data: dict):
    to_encode = data.copy()
    return jwt.encode(to_encode, SECRET_KEY, algorithm=ALGORITHM)

# Endpoint to create a new user (either professor or student)
@app.post("/accounts", response_model=UserResponse)
async def create_account(user: User):
    # Check if the email already exists
    if users_collection.find_one({"email": user.email}):
        raise HTTPException(status_code=400, detail="Email already registered")
    
    hashed_password = get_password_hash(user.password)
    user_dict = user.dict()
    user_dict["password"] = hashed_password
    
    # Insert the user into MongoDB
    users_collection.insert_one(user_dict)
    return UserResponse(email=user.email, username=user.username, role=user.role)

# Endpoint for user login and token generation
@app.post("/login")
async def login(form_data: OAuth2PasswordRequestForm = Depends()):
    user = users_collection.find_one({"email": form_data.username})
    if not user or not verify_password(form_data.password, user['password']):
        raise HTTPException(status_code=401, detail="Invalid credentials")
    
    token = create_access_token(data={"sub": user['email']})
    return {"access_token": token, "token_type": "bearer"}

# Endpoint to get a list of all classes
@app.get("/classes", response_model=List[ClassResponse])
async def get_classes():
    classes = list(classes_collection.find())
    if not classes:
        raise HTTPException(status_code=404, detail="No classes found")
    
    # Converting MongoDB's ObjectId to string
    for cls in classes:
        cls['id'] = str(cls['_id'])
        del cls['_id']  # Remove MongoDB's internal _id field
    return classes

# Endpoint to get a specific class by course_id
@app.get("/classes/{course_id}", response_model=ClassResponse)
async def get_class_by_id(course_id: str):
    cls = classes_collection.find_one({"course_id": course_id})
    if not cls:
        raise HTTPException(status_code=404, detail="Class not found")
    
    cls['id'] = str(cls['_id'])
    del cls['_id']
    return cls

# Endpoint to get all appointments
@app.get("/appointments", response_model=List[AppointmentResponse])
async def get_appointments():
    appointments = list(appointments_collection.find())
    if not appointments:
        raise HTTPException(status_code=404, detail="No appointments found")
    
    # Converting MongoDB's ObjectId to string
    for app in appointments:
        app['id'] = str(app['_id'])
        del app['_id']  # Remove MongoDB's internal _id field
    return appointments

# Endpoint to create a new appointment
@app.post("/appointments", response_model=AppointmentResponse)
async def create_appointment(appointment: Appointment):
    appointment_dict = appointment.dict()
    appointment_dict['appointment_date'] = appointment.appointment_date.isoformat()  # Convert datetime to ISO format

    # Insert the appointment into MongoDB
    result = appointments_collection.insert_one(appointment_dict)
    appointment_dict['id'] = str(result.inserted_id)

    return appointment_dict

# Endpoint to get a specific appointment by ID
@app.get("/appointments/{appointment_id}", response_model=AppointmentResponse)
async def get_appointment_by_id(appointment_id: str):
    appointment = appointments_collection.find_one({"_id": appointment_id})
    if not appointment:
        raise HTTPException(status_code=404, detail="Appointment not found")

    appointment['id'] = str(appointment['_id'])
    del appointment['_id']
    return appointment