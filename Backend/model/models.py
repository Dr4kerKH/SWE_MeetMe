# models.py
from pydantic import BaseModel, EmailStr
from datetime import datetime

class User(BaseModel):
    """Model representing a user."""
    email: EmailStr
    username: str
    password: str
    role: str  # "professor" or "student"

class UserLogin(BaseModel):
    """Model representing a user when login."""
    email: EmailStr
    password: str

class UserResponse(BaseModel):
    """Model for user response without password."""
    email: EmailStr
    username: str
    role: str

class Appointment(BaseModel):
    """Model representing an appointment."""
    student_name: str
    student_email: EmailStr
    course_id: str
    course_name: str
    professor_name: str
    appointment_date: datetime

class AppointmentResponse(Appointment):
    """Model for appointment response with an ID."""
    id: str

class Class(BaseModel):
    """Model representing a class."""
    course_id: str
    course_name: str
    professor_name: str

class ClassResponse(Class):
    """Model for class response with an ID."""
    id: str
