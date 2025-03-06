# models.py
from pydantic import BaseModel
from datetime import datetime

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
    course_id: str
    course_name: str
    professor_name: str
