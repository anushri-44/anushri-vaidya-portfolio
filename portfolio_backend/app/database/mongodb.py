from pymongo import AsyncMongoClient
from pymongo.server_api import ServerApi

from app.config import settings


client = AsyncMongoClient(
    settings.mongodb_uri,
    server_api=ServerApi(
        "1",
        strict=True,
        deprecation_errors=True,
    ),
)

database = client[settings.database_name]


async def connect_to_mongodb() -> None:
    await client.admin.command("ping")
    print("MongoDB connected successfully.")


async def close_mongodb_connection() -> None:
    await client.close()
    print("MongoDB connection closed.")