from fastapi import APIRouter

from app.database.mongodb import database
from app.schemas.certification import CertificationResponse


router = APIRouter()


@router.get("", response_model=list[CertificationResponse])
async def get_certifications():
    certifications_collection = database["certifications"]

    cursor = certifications_collection.find(
        {"active": True},
        {
            "_id": 1,
            "title": 1,
            "issuer": 1,
            "date": 1,
            "credential_url": 1,
            "order": 1,
        },
    ).sort("order", 1)

    certifications = []

    async for item in cursor:
        certifications.append(
            {
                "id": str(item["_id"]),
                "title": item["title"],
                "issuer": item["issuer"],
                "date": item["date"],
                "credential_url": item.get("credential_url"),
                "order": item["order"],
            }
        )

    return certifications