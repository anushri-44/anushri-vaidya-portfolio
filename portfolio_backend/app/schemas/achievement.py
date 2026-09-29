from typing import Optional

from pydantic import BaseModel, Field


class AchievementBase(BaseModel):
    icon: str
    title: str
    subtitle: str
    description: str
    order: int = Field(ge=1)


class AchievementCreate(AchievementBase):
    pass


class AchievementUpdate(BaseModel):
    icon: Optional[str] = None
    title: Optional[str] = None
    subtitle: Optional[str] = None
    description: Optional[str] = None
    order: Optional[int] = Field(default=None, ge=1)
    active: Optional[bool] = None


class AchievementResponse(AchievementBase):
    id: str