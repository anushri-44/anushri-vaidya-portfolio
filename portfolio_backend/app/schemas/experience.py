from typing import List, Optional

from pydantic import BaseModel, Field


class ExperienceBase(BaseModel):
    role: str
    company: str
    location: str
    start_date: str
    end_date: str
    description: str
    bullets: List[str]
    technologies: List[str]
    order: int = Field(ge=1)


class ExperienceCreate(ExperienceBase):
    pass


class ExperienceUpdate(BaseModel):
    role: Optional[str] = None
    company: Optional[str] = None
    location: Optional[str] = None
    start_date: Optional[str] = None
    end_date: Optional[str] = None
    description: Optional[str] = None
    bullets: Optional[List[str]] = None
    technologies: Optional[List[str]] = None
    order: Optional[int] = Field(default=None, ge=1)
    active: Optional[bool] = None


class ExperienceResponse(ExperienceBase):
    id: str