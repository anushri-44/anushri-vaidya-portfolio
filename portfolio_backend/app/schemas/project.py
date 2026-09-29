from typing import List, Optional

from pydantic import BaseModel, Field


class ProjectBase(BaseModel):
    slug: str
    title: str
    description: str
    technologies: List[str]
    project_url: Optional[str] = None
    case_study_url: Optional[str] = None
    featured: bool = False
    order: int = Field(ge=1)


class ProjectCreate(ProjectBase):
    pass


class ProjectUpdate(BaseModel):
    slug: Optional[str] = None
    title: Optional[str] = None
    description: Optional[str] = None
    technologies: Optional[List[str]] = None
    project_url: Optional[str] = None
    case_study_url: Optional[str] = None
    featured: Optional[bool] = None
    order: Optional[int] = Field(default=None, ge=1)
    active: Optional[bool] = None


class ProjectResponse(ProjectBase):
    id: str