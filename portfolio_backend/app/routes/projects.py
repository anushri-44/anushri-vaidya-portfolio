from bson import ObjectId
from fastapi import APIRouter, Depends, HTTPException, status

from app.auth.dependencies import get_current_admin
from app.database.mongodb import database
from app.schemas.project import (
    ProjectCreate,
    ProjectResponse,
    ProjectUpdate,
)


router = APIRouter()

projects_collection = database["projects"]


def project_to_response(item: dict) -> dict:
    return {
        "id": str(item["_id"]),
        "slug": item["slug"],
        "title": item["title"],
        "description": item["description"],
        "technologies": item["technologies"],
        "project_url": item.get("project_url"),
        "case_study_url": item.get("case_study_url"),
        "featured": item.get("featured", False),
        "order": item["order"],
    }


# ---------------------------------------------------------
# PUBLIC: Get all active projects
# ---------------------------------------------------------

@router.get("", response_model=list[ProjectResponse])
async def get_projects():
    cursor = projects_collection.find(
        {"active": True},
        {
            "_id": 1,
            "slug": 1,
            "title": 1,
            "description": 1,
            "technologies": 1,
            "project_url": 1,
            "case_study_url": 1,
            "featured": 1,
            "order": 1,
        },
    ).sort("order", 1)

    projects = []

    async for item in cursor:
        projects.append(project_to_response(item))

    return projects


# ---------------------------------------------------------
# ADMIN: Create project
# ---------------------------------------------------------

@router.post(
    "",
    response_model=ProjectResponse,
    status_code=status.HTTP_201_CREATED,
)
async def create_project(
    project: ProjectCreate,
    current_admin: str = Depends(get_current_admin),
):
    document = project.model_dump()

    document["active"] = True

    result = await projects_collection.insert_one(document)

    created_project = await projects_collection.find_one(
        {"_id": result.inserted_id}
    )

    if created_project is None:
        raise HTTPException(
            status_code=500,
            detail="Project was created but could not be retrieved",
        )

    return project_to_response(created_project)


# ---------------------------------------------------------
# ADMIN: Update project
# ---------------------------------------------------------

@router.put(
    "/{project_id}",
    response_model=ProjectResponse,
)
async def update_project(
    project_id: str,
    project: ProjectUpdate,
    current_admin: str = Depends(get_current_admin),
):
    if not ObjectId.is_valid(project_id):
        raise HTTPException(
            status_code=400,
            detail="Invalid project ID",
        )

    update_data = project.model_dump(exclude_unset=True)

    if not update_data:
        raise HTTPException(
            status_code=400,
            detail="No fields provided for update",
        )

    result = await projects_collection.update_one(
        {"_id": ObjectId(project_id)},
        {"$set": update_data},
    )

    if result.matched_count == 0:
        raise HTTPException(
            status_code=404,
            detail="Project not found",
        )

    updated_project = await projects_collection.find_one(
        {"_id": ObjectId(project_id)}
    )

    if updated_project is None:
        raise HTTPException(
            status_code=404,
            detail="Project not found",
        )

    return project_to_response(updated_project)


# ---------------------------------------------------------
# ADMIN: Delete project
# ---------------------------------------------------------

@router.delete(
    "/{project_id}",
)
async def delete_project(
    project_id: str,
    current_admin: str = Depends(get_current_admin),
):
    if not ObjectId.is_valid(project_id):
        raise HTTPException(
            status_code=400,
            detail="Invalid project ID",
        )

    result = await projects_collection.update_one(
        {"_id": ObjectId(project_id)},
        {"$set": {"active": False}},
    )

    if result.matched_count == 0:
        raise HTTPException(
            status_code=404,
            detail="Project not found",
        )

    return {
        "message": "Project deleted successfully",
    }