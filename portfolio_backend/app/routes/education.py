from bson import ObjectId
from fastapi import APIRouter, Depends, HTTPException, status

from app.auth.dependencies import get_current_admin
from app.database.mongodb import database
from app.schemas.education import (
    EducationCreate,
    EducationResponse,
    EducationUpdate,
)


router = APIRouter()

education_collection = database["education"]


def education_to_response(item: dict) -> dict:
    return {
        "id": str(item["_id"]),
        "degree": item["degree"],
        "institution": item["institution"],
        "location": item["location"],
        "start_date": item["start_date"],
        "end_date": item["end_date"],
        "status": item["status"],
        "description": item["description"],
        "order": item.get("order", 999),
    }


# ---------------------------------------------------------
# PUBLIC
# ---------------------------------------------------------

@router.get("", response_model=list[EducationResponse])
async def get_education():
    cursor = education_collection.find(
        {"active": True},
        {
            "_id": 1,
            "degree": 1,
            "institution": 1,
            "location": 1,
            "start_date": 1,
            "end_date": 1,
            "status": 1,
            "description": 1,
            "order": 1,
        },
    ).sort("order", 1)

    education = []

    async for item in cursor:
        education.append(education_to_response(item))

    return education


# ---------------------------------------------------------
# ADMIN: CREATE
# ---------------------------------------------------------

@router.post(
    "",
    response_model=EducationResponse,
    status_code=status.HTTP_201_CREATED,
)
async def create_education(
    education: EducationCreate,
    current_admin: str = Depends(get_current_admin),
):
    document = education.model_dump()
    document["active"] = True

    result = await education_collection.insert_one(document)

    created = await education_collection.find_one(
        {"_id": result.inserted_id}
    )

    if created is None:
        raise HTTPException(
            status_code=500,
            detail="Education was created but could not be retrieved",
        )

    return education_to_response(created)


# ---------------------------------------------------------
# ADMIN: UPDATE
# ---------------------------------------------------------

@router.put(
    "/{education_id}",
    response_model=EducationResponse,
)
async def update_education(
    education_id: str,
    education: EducationUpdate,
    current_admin: str = Depends(get_current_admin),
):
    if not ObjectId.is_valid(education_id):
        raise HTTPException(
            status_code=400,
            detail="Invalid education ID",
        )

    update_data = education.model_dump(exclude_unset=True)

    if not update_data:
        raise HTTPException(
            status_code=400,
            detail="No fields provided for update",
        )

    result = await education_collection.update_one(
        {"_id": ObjectId(education_id)},
        {"$set": update_data},
    )

    if result.matched_count == 0:
        raise HTTPException(
            status_code=404,
            detail="Education record not found",
        )

    updated = await education_collection.find_one(
        {"_id": ObjectId(education_id)}
    )

    if updated is None:
        raise HTTPException(
            status_code=404,
            detail="Education record not found",
        )

    return education_to_response(updated)


# ---------------------------------------------------------
# ADMIN: SOFT DELETE
# ---------------------------------------------------------

@router.delete(
    "/{education_id}",
)
async def delete_education(
    education_id: str,
    current_admin: str = Depends(get_current_admin),
):
    if not ObjectId.is_valid(education_id):
        raise HTTPException(
            status_code=400,
            detail="Invalid education ID",
        )

    result = await education_collection.update_one(
        {"_id": ObjectId(education_id)},
        {"$set": {"active": False}},
    )

    if result.matched_count == 0:
        raise HTTPException(
            status_code=404,
            detail="Education record not found",
        )

    return {
        "message": "Education record deleted successfully",
    }