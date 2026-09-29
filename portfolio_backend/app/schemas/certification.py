from typing import Optional

from pydantic import BaseModel, Field


class CertificationResponse(BaseModel):
    id: str
    title: str
    issuer: Optional[str] = None
    date: Optional[str] = None
    credential_url: Optional[str] = None
    order: int = Field(ge=1)