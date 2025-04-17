# models.py
from pydantic import BaseModel, EmailStr
from datetime import datetime
from typing import Optional

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
    professor_name: str
    appointment_date: datetime

class AppointmentResponse(Appointment):
    """Model for appointment response with an ID."""
    id: str

class Class(BaseModel):
    """Model representing a class."""
    course_code: str
    course_id: str
    professor_name: str
    course_description: str

class ClassResponse(Class):
    """Model for class response with an ID."""
    id: str

class Enrollment(BaseModel):
    user_email: EmailStr
    course_code: str
    role: str  # "professor" or "student"

class EnrollmentResponse(Enrollment):
    id: Optional[str]