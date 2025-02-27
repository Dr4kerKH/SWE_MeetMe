import os
from dotenv import load_dotenv
from fastapi import FastAPI, HTTPException
from pydantic import BaseModel
from pymongo import MongoClient
from datetime import datetime
from typing import List

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
appointments_collection = db['appointments']

# Define the Appointment model using Pydantic
class Appointment(BaseModel):
    client_name: str
    provider_name: str
    appointment_date: datetime

# Define the response model for MongoDB (without MongoDB-specific fields)
class AppointmentResponse(Appointment):
    id: str

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

