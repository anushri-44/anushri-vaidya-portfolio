from typing import List, Optional

from pydantic import BaseModel, Field


class SkillBase(BaseModel):
    category: str
    icon: str
    skills: List[str]
    order: int = Field(ge=1)


class SkillCreate(SkillBase):
    pass


class SkillUpdate(BaseModel):
    category: Optional[str] = None
    icon: Optional[str] = None
    skills: Optional[List[str]] = None
    order: Optional[int] = Field(default=None, ge=1)
    active: Optional[bool] = None


class SkillResponse(SkillBase):
    id: str