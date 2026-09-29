from pydantic import BaseModel, EmailStr


class MessageCreate(BaseModel):
    name: str
    email: EmailStr
    message: str


class MessageResponse(BaseModel):
    id: str
    name: str
    email: str
    message: str
    created_at: str