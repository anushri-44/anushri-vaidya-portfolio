from typing import Optional

from pydantic import BaseModel, Field


class EducationBase(BaseModel):
    degree: str
    institution: str
    location: str
    start_date: str
    end_date: str
    status: str
    description: str
    order: int = Field(ge=1)


class EducationCreate(EducationBase):
    pass


class EducationUpdate(BaseModel):
    degree: Optional[str] = None
    institution: Optional[str] = None
    location: Optional[str] = None
    start_date: Optional[str] = None
    end_date: Optional[str] = None
    status: Optional[str] = None
    description: Optional[str] = None
    order: Optional[int] = Field(default=None, ge=1)
    active: Optional[bool] = None


class EducationResponse(EducationBase):
    id: str