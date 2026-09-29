from bson import ObjectId
from fastapi import APIRouter, Depends, HTTPException, status

from app.auth.dependencies import get_current_admin
from app.database.mongodb import database
from app.schemas.achievement import (
    AchievementCreate,
    AchievementResponse,
    AchievementUpdate,
)


router = APIRouter()

achievements_collection = database["achievements"]


def achievement_to_response(item: dict) -> dict:
    return {
        "id": str(item["_id"]),
        "icon": item["icon"],
        "title": item["title"],
        "subtitle": item["subtitle"],
        "description": item["description"],
        "order": item.get("order", 999),
    }


# ---------------------------------------------------------
# PUBLIC
# ---------------------------------------------------------

@router.get("", response_model=list[AchievementResponse])
async def get_achievements():
    cursor = achievements_collection.find(
        {"active": True},
        {
            "_id": 1,
            "icon": 1,
            "title": 1,
            "subtitle": 1,
            "description": 1,
            "order": 1,
        },
    ).sort("order", 1)

    achievements = []

    async for item in cursor:
        achievements.append(
            achievement_to_response(item)
        )

    return achievements


# ---------------------------------------------------------
# ADMIN: CREATE
# ---------------------------------------------------------

@router.post(
    "",
    response_model=AchievementResponse,
    status_code=status.HTTP_201_CREATED,
)
async def create_achievement(
    achievement: AchievementCreate,
    current_admin: str = Depends(get_current_admin),
):
    document = achievement.model_dump()
    document["active"] = True

    result = await achievements_collection.insert_one(document)

    created = await achievements_collection.find_one(
        {"_id": result.inserted_id}
    )

    if created is None:
        raise HTTPException(
            status_code=500,
            detail="Achievement was created but could not be retrieved",
        )

    return achievement_to_response(created)


# ---------------------------------------------------------
# ADMIN: UPDATE
# ---------------------------------------------------------

@router.put(
    "/{achievement_id}",
    response_model=AchievementResponse,
)
async def update_achievement(
    achievement_id: str,
    achievement: AchievementUpdate,
    current_admin: str = Depends(get_current_admin),
):
    if not ObjectId.is_valid(achievement_id):
        raise HTTPException(
            status_code=400,
            detail="Invalid achievement ID",
        )

    update_data = achievement.model_dump(
        exclude_unset=True
    )

    if not update_data:
        raise HTTPException(
            status_code=400,
            detail="No fields provided for update",
        )

    result = await achievements_collection.update_one(
        {"_id": ObjectId(achievement_id)},
        {"$set": update_data},
    )

    if result.matched_count == 0:
        raise HTTPException(
            status_code=404,
            detail="Achievement not found",
        )

    updated = await achievements_collection.find_one(
        {"_id": ObjectId(achievement_id)}
    )

    if updated is None:
        raise HTTPException(
            status_code=404,
            detail="Achievement not found",
        )

    return achievement_to_response(updated)


# ---------------------------------------------------------
# ADMIN: SOFT DELETE
# ---------------------------------------------------------

@router.delete(
    "/{achievement_id}",
)
async def delete_achievement(
    achievement_id: str,
    current_admin: str = Depends(get_current_admin),
):
    if not ObjectId.is_valid(achievement_id):
        raise HTTPException(
            status_code=400,
            detail="Invalid achievement ID",
        )

    result = await achievements_collection.update_one(
        {"_id": ObjectId(achievement_id)},
        {"$set": {"active": False}},
    )

    if result.matched_count == 0:
        raise HTTPException(
            status_code=404,
            detail="Achievement not found",
        )

    return {
        "message": "Achievement deleted successfully",
    }