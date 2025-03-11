# Import necessary libraries and modules
import logging
import os
from dotenv import load_dotenv  # Load environment variables from .env file
from fastapi import FastAPI, HTTPException, Depends  # FastAPI framework for building APIs
from pymongo import MongoClient   # MongoDB client for database interactions
from datetime import datetime, timedelta  # For handling date and time
from typing import List  # For type hinting lists in API responses
from fastapi.security import OAuth2PasswordBearer, OAuth2PasswordRequestForm  # Authentication handling
from passlib.context import CryptContext  # Password hashing for security
import jwt  # JSON Web Token for authentication
from bson import ObjectId  # To work with MongoDB Object IDs
from model import User, UserResponse, Appointment, AppointmentResponse, Class, ClassResponse  # Import Pydantic models
from pymongo.server_api import ServerApi

# Load environment variables (e.g., database connection URI, secret key)
load_dotenv()
app = FastAPI()
logging.basicConfig(level=logging.INFO) # Set up logging for debugging and information purposes

############################ Running with uvicorn ############################
# uvicorn backend:app --host 0.0.0.0 --port 8080 --reload
############################ #################### ############################


############################ Database Connection ############################
# Fetch MongoDB URI from environment variables
MONGODB_URI = os.getenv("MONGODB_URI")
SECRET_KEY = os.getenv("SECRET_KEY")
MONGODB_USERNAME = os.getenv("MONGODB_USERNAME")
MONGODB_PASSWORD = os.getenv("MONGODB_PASSWORD")

# Establish connection with MongoDB
client = MongoClient(MONGODB_URI, server_api = ServerApi('1'))  # Connect to MongoDB using the provided URI
try:
    client.admin.command('ping')
    print("Pinged your deployment. You successfully connected to MongoDB!")
except Exception as e:
    print(e)

db = client['MeetMeDB']  # Use 'MeetMeDB' database
users_collection = db['users']  # Users collection
appointments_collection = db['appointments']  # Appointments collection
classes_collection = db['classes']  # Classes collection

############################ Security Setup ############################
# OAuth2 authentication scheme
oauth2_scheme = OAuth2PasswordBearer(tokenUrl="token")

# Password hashing configuration using bcrypt
pwd_context = CryptContext(schemes=["bcrypt"], deprecated="auto")

# JWT Secret Key and Algorithm
# SECRET_KEY = os.getenv("SECRET_KEY", "your_secret_key")  # Default key (should be changed in production)
ALGORITHM = "HS256"  # Secure hashing algorithm for JWT

############################ Helper Functions ############################
def verify_password(plain_password, hashed_password):
    """Verify if a given plain password matches the stored hashed password."""
    return pwd_context.verify(plain_password, hashed_password)

def get_password_hash(password):
    """Hash a password using bcrypt."""
    return pwd_context.hash(password)

def create_access_token(data: dict):
    """Generate a JWT access token with the provided user data."""
    to_encode = data.copy()
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
#######################################################################
@app.get("/")
async def read_root():
    return {"message": "Welcome to the FastAPI application!"}

# Post Requests (Creating new records)
@app.post("/accounts", response_model=UserResponse)
async def create_account(user: User):
    """
    Create a new user account.
    - Ensures the email is unique.
    - Hashes the password before storing.
    """
    if users_collection.find_one({"email": user.email}):
        raise HTTPException(status_code=400, detail="Email already registered")
    
    hashed_password = get_password_hash(user.password)  # Hash the password
    user_dict = user.dict()
    user_dict["password"] = hashed_password  # Store the hashed password
    users_collection.insert_one(user_dict)  # Insert the new user into the database

    return UserResponse(email=user.email, username=user.username, role=user.role)  # Return user info without password

@app.post("/login")
async def login(form_data: OAuth2PasswordRequestForm = Depends()):
    """
    Authenticate user and return a JWT access token.
    - Checks if the email exists in the database.
    - Verifies the password.
    - Generates a JWT token on successful authentication.
    """
    user = users_collection.find_one({"email": form_data.username})
    if not user or not verify_password(form_data.password, user['password']):
        raise HTTPException(status_code=401, detail="Invalid password")
    
    token = create_access_token(data={"sub": user['email']})  # Create JWT token
    return {"access_token": token, "token_type": "bearer"}  # Return token

@app.post("/appointments", response_model=AppointmentResponse)
async def create_appointment(appointment: Appointment):
    """
    Create a new appointment.
    - Converts the date to ISO format before storing.
    - Ensures the appointment duration is exactly 30 minutes.
    """
    # Calculate the end time of the appointment
    start_time = appointment.appointment_date
    end_time = start_time + timedelta(minutes=30)
    
    # Check if the duration is exactly 30 minutes
    if (end_time - start_time).total_seconds() != 1800:
        raise HTTPException(status_code=400, detail="Appointment duration must be exactly 30 minutes")
    
    appointment_dict = appointment.dict()
    appointment_dict["appointment_date"] = start_time.isoformat()  # Convert date to string
    result = appointments_collection.insert_one(appointment_dict)  # Insert into database
    appointment_dict["id"] = str(result.inserted_id)  # Convert ObjectId to string for API response

    return {"id": appointment_dict["id"], "appointment_date": start_time.isoformat()}  # Return the newly created appointment

@app.post("/classes", response_model=ClassResponse)
async def create_class(cls: Class):
    """
    Create a new class entry.
    - Ensures the course ID is unique.
    """
    if classes_collection.find_one({"course_id": cls.course_id}):
        raise HTTPException(status_code=400, detail="Course ID already exists")

    class_dict = cls.dict()
    result = classes_collection.insert_one(class_dict)  # Insert class into the database
    class_dict["id"] = str(result.inserted_id)  # Convert ObjectId to string for response

    return class_dict  # Return the created class details

#######################################################################
# Get Requests (Retrieving records)
@app.get("/classes", response_model=List[ClassResponse])
async def get_classes():
    """
    Retrieve all available classes.
    - Returns a list of all classes.
    """
    classes = list(classes_collection.find())  # Fetch all classes
    if not classes:
        raise HTTPException(status_code=404, detail="No classes found")
    
    return [{"id": str(cls["_id"]), **cls} for cls in classes]  # Convert ObjectId to string and return

@app.get("/classes/{course_id}", response_model=ClassResponse)
async def get_class_by_id(course_id: str):
    """
    Retrieve details of a class by course ID.
    """
    cls = classes_collection.find_one({"course_id": course_id})
    if not cls:
        raise HTTPException(status_code=404, detail="Class not found")
    
    return {"id": str(cls["_id"]), **cls}  # Convert ObjectId to string and return

@app.get("/appointments", response_model=List[AppointmentResponse])
async def get_appointments():
    """
    Retrieve all appointments.
    - Returns a list of all scheduled appointments.
    """
    appointments = list(appointments_collection.find())  # Fetch all appointments
    if not appointments:
        raise HTTPException(status_code=404, detail="No appointments found")
    
    return [{"id": str(app["_id"]), **app} for app in appointments]  # Convert ObjectId to string and return

@app.get("/appointments/{appointment_id}", response_model=AppointmentResponse)
async def get_appointment_by_id(appointment_id: str):
    """
    Retrieve an appointment by its ID.
    """
    appointment = appointments_collection.find_one({"_id": ObjectId(appointment_id)})
    if not appointment:
        raise HTTPException(status_code=404, detail="Appointment not found")
    
    return {"id": str(appointment["_id"]), **appointment}  # Convert ObjectId to string and return

@app.get("/get_schedule", response_model=List[AppointmentResponse])
async def get_schedule(date: str):
    """
    Retrieve all appointments scheduled for a specific date.
    - Validates the date format.
    - Returns all appointments on that day.
    """
    try:
        # Validate if the date is in the correct format
        datetime.strptime(date, "%Y-%m-%d")
    except ValueError:
        raise HTTPException(status_code=400, detail="Invalid date format. Use YYYY-MM-DD")

    appointments = list(appointments_collection.find({"appointment_date": date}))  # Fetch appointments by date

    if not appointments:
        raise HTTPException(status_code=404, detail="No scheduled appointments for this day")

    return [{"id": str(app["_id"]), **app} for app in appointments]  # Convert ObjectId to string and return

#######################################################################
# Put Requests

#######################################################################
# Delete Requests
@app.delete("/classes/{course_id}", response_model=dict)
async def delete_class(course_id: str, current_user: dict = Depends(get_current_user)):
    """
    Delete a class by its course ID.
    - Only accessible by professors.
    """
    if current_user["role"] != "professor":
        raise HTTPException(status_code=403, detail="Not authorized to delete classes")

    result = classes_collection.delete_one({"course_id": course_id})
    if result.deleted_count == 0:
        raise HTTPException(status_code=404, detail="Class not found")

    return {"message": "Class deleted successfully"}

@app.delete("/appointments/{appointment_id}", response_model=dict)
async def delete_appointment(appointment_id: str, current_user: dict = Depends(get_current_user)):
    """
    Delete an appointment by its ID.
    - Only accessible by professors.
    """
    if current_user["role"] != "professor":
        raise HTTPException(status_code=403, detail="Not authorized to delete appointments")

    result = appointments_collection.delete_one({"_id": ObjectId(appointment_id)})
    if result.deleted_count == 0:
        raise HTTPException(status_code=404, detail="Appointment not found")

    return {"message": "Appointment deleted successfully"}