from bson import ObjectId
from fastapi import APIRouter, Depends, HTTPException, status

from app.auth.dependencies import get_current_admin
from app.database.mongodb import database
from app.schemas.experience import (
    ExperienceCreate,
    ExperienceResponse,
    ExperienceUpdate,
)


router = APIRouter()

experience_collection = database["experience"]


def experience_to_response(item: dict) -> dict:
    return {
        "id": str(item["_id"]),
        "role": item["role"],
        "company": item["company"],
        "location": item["location"],
        "start_date": item["start_date"],
        "end_date": item["end_date"],
        "description": item["description"],
        "bullets": item.get("bullets", []),
        "technologies": item.get("technologies", []),
        "order": item.get("order", 999),
    }


# ---------------------------------------------------------
# PUBLIC: Get active experience
# ---------------------------------------------------------

@router.get("", response_model=list[ExperienceResponse])
async def get_experience():
    cursor = experience_collection.find(
        {"active": True},
        {
            "_id": 1,
            "role": 1,
            "company": 1,
            "location": 1,
            "start_date": 1,
            "end_date": 1,
            "description": 1,
            "bullets": 1,
            "technologies": 1,
            "order": 1,
        },
    ).sort("order", 1)

    experience = []

    async for item in cursor:
        experience.append(experience_to_response(item))

    return experience


# ---------------------------------------------------------
# ADMIN: Create experience
# ---------------------------------------------------------

@router.post(
    "",
    response_model=ExperienceResponse,
    status_code=status.HTTP_201_CREATED,
)
async def create_experience(
    experience: ExperienceCreate,
    current_admin: str = Depends(get_current_admin),
):
    document = experience.model_dump()
    document["active"] = True

    result = await experience_collection.insert_one(document)

    created = await experience_collection.find_one(
        {"_id": result.inserted_id}
    )

    if created is None:
        raise HTTPException(
            status_code=500,
            detail="Experience was created but could not be retrieved",
        )

    return experience_to_response(created)


# ---------------------------------------------------------
# ADMIN: Update experience
# ---------------------------------------------------------

@router.put(
    "/{experience_id}",
    response_model=ExperienceResponse,
)
async def update_experience(
    experience_id: str,
    experience: ExperienceUpdate,
    current_admin: str = Depends(get_current_admin),
):
    if not ObjectId.is_valid(experience_id):
        raise HTTPException(
            status_code=400,
            detail="Invalid experience ID",
        )

    update_data = experience.model_dump(exclude_unset=True)

    if not update_data:
        raise HTTPException(
            status_code=400,
            detail="No fields provided for update",
        )

    result = await experience_collection.update_one(
        {"_id": ObjectId(experience_id)},
        {"$set": update_data},
    )

    if result.matched_count == 0:
        raise HTTPException(
            status_code=404,
            detail="Experience not found",
        )

    updated = await experience_collection.find_one(
        {"_id": ObjectId(experience_id)}
    )

    if updated is None:
        raise HTTPException(
            status_code=404,
            detail="Experience not found",
        )

    return experience_to_response(updated)


# ---------------------------------------------------------
# ADMIN: Soft delete experience
# ---------------------------------------------------------

@router.delete(
    "/{experience_id}",
)
async def delete_experience(
    experience_id: str,
    current_admin: str = Depends(get_current_admin),
):
    if not ObjectId.is_valid(experience_id):
        raise HTTPException(
            status_code=400,
            detail="Invalid experience ID",
        )

    result = await experience_collection.update_one(
        {"_id": ObjectId(experience_id)},
        {"$set": {"active": False}},
    )

    if result.matched_count == 0:
        raise HTTPException(
            status_code=404,
            detail="Experience not found",
        )

    return {
        "message": "Experience deleted successfully",
    }