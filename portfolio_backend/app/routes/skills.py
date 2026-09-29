from bson import ObjectId
from fastapi import APIRouter, Depends, HTTPException, status

from app.auth.dependencies import get_current_admin
from app.database.mongodb import database
from app.schemas.skill import (
    SkillCreate,
    SkillResponse,
    SkillUpdate,
)


router = APIRouter()

skills_collection = database["skills"]


def skill_to_response(item: dict) -> dict:
    return {
        "id": str(item["_id"]),
        "category": item["category"],
        "icon": item["icon"],
        "skills": item["skills"],
        "order": item["order"],
    }


# ---------------------------------------------------------
# PUBLIC: Get active skills
# ---------------------------------------------------------

@router.get("", response_model=list[SkillResponse])
async def get_skills():
    cursor = skills_collection.find(
        {"active": True},
        {
            "_id": 1,
            "category": 1,
            "icon": 1,
            "skills": 1,
            "order": 1,
        },
    ).sort("order", 1)

    skills = []

    async for item in cursor:
        skills.append(skill_to_response(item))

    return skills


# ---------------------------------------------------------
# ADMIN: Create skill category
# ---------------------------------------------------------

@router.post(
    "",
    response_model=SkillResponse,
    status_code=status.HTTP_201_CREATED,
)
async def create_skill(
    skill: SkillCreate,
    current_admin: str = Depends(get_current_admin),
):
    document = skill.model_dump()
    document["active"] = True

    result = await skills_collection.insert_one(document)

    created_skill = await skills_collection.find_one(
        {"_id": result.inserted_id}
    )

    if created_skill is None:
        raise HTTPException(
            status_code=500,
            detail="Skill was created but could not be retrieved",
        )

    return skill_to_response(created_skill)


# ---------------------------------------------------------
# ADMIN: Update skill category
# ---------------------------------------------------------

@router.put(
    "/{skill_id}",
    response_model=SkillResponse,
)
async def update_skill(
    skill_id: str,
    skill: SkillUpdate,
    current_admin: str = Depends(get_current_admin),
):
    if not ObjectId.is_valid(skill_id):
        raise HTTPException(
            status_code=400,
            detail="Invalid skill ID",
        )

    update_data = skill.model_dump(exclude_unset=True)

    if not update_data:
        raise HTTPException(
            status_code=400,
            detail="No fields provided for update",
        )

    result = await skills_collection.update_one(
        {"_id": ObjectId(skill_id)},
        {"$set": update_data},
    )

    if result.matched_count == 0:
        raise HTTPException(
            status_code=404,
            detail="Skill category not found",
        )

    updated_skill = await skills_collection.find_one(
        {"_id": ObjectId(skill_id)}
    )

    if updated_skill is None:
        raise HTTPException(
            status_code=404,
            detail="Skill category not found",
        )

    return skill_to_response(updated_skill)


# ---------------------------------------------------------
# ADMIN: Soft delete skill category
# ---------------------------------------------------------

@router.delete(
    "/{skill_id}",
)
async def delete_skill(
    skill_id: str,
    current_admin: str = Depends(get_current_admin),
):
    if not ObjectId.is_valid(skill_id):
        raise HTTPException(
            status_code=400,
            detail="Invalid skill ID",
        )

    result = await skills_collection.update_one(
        {"_id": ObjectId(skill_id)},
        {"$set": {"active": False}},
    )

    if result.matched_count == 0:
        raise HTTPException(
            status_code=404,
            detail="Skill category not found",
        )

    return {
        "message": "Skill category deleted successfully",
    }