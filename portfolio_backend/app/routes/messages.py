from bson import ObjectId
from fastapi import APIRouter, Depends, HTTPException, status

from app.auth.dependencies import get_current_admin
from app.database.mongodb import database
from app.schemas.message import MessageCreate, MessageResponse


router = APIRouter()

messages_collection = database["messages"]


# ---------------------------------------------------------
# PUBLIC: Submit a message
# ---------------------------------------------------------

@router.post(
    "",
    response_model=MessageResponse,
)
async def create_message(message: MessageCreate):
    from datetime import datetime, timezone

    document = {
        "name": message.name.strip(),
        "email": str(message.email),
        "message": message.message.strip(),
        "created_at": datetime.now(timezone.utc).isoformat(),
    }

    result = await messages_collection.insert_one(document)

    return {
        "id": str(result.inserted_id),
        "name": document["name"],
        "email": document["email"],
        "message": document["message"],
        "created_at": document["created_at"],
    }


# ---------------------------------------------------------
# ADMIN: View messages
# ---------------------------------------------------------

@router.get(
    "",
    response_model=list[MessageResponse],
)
async def get_messages(
    current_admin: str = Depends(get_current_admin),
):
    cursor = messages_collection.find().sort(
        "created_at",
        -1,
    )

    messages = []

    async for item in cursor:
        messages.append(
            {
                "id": str(item["_id"]),
                "name": item["name"],
                "email": item["email"],
                "message": item["message"],
                "created_at": item["created_at"],
            }
        )

    return messages


# ---------------------------------------------------------
# ADMIN: Delete message
# ---------------------------------------------------------

@router.delete(
    "/{message_id}",
)
async def delete_message(
    message_id: str,
    current_admin: str = Depends(get_current_admin),
):
    if not ObjectId.is_valid(message_id):
        raise HTTPException(
            status_code=status.HTTP_400_BAD_REQUEST,
            detail="Invalid message ID",
        )

    result = await messages_collection.delete_one(
        {"_id": ObjectId(message_id)}
    )

    if result.deleted_count == 0:
        raise HTTPException(
            status_code=status.HTTP_404_NOT_FOUND,
            detail="Message not found",
        )

    return {
        "message": "Message deleted successfully",
    }