import asyncio

from app.database.mongodb import database, connect_to_mongodb, close_mongodb_connection


education_data = [
    {
        "degree": "Bachelor of Engineering in Computer Engineering",
        "institution": "NBNSTIC",
        "location": "Ambegaon, Pune",
        "start_date": "2023",
        "end_date": "2027",
        "status": "Expected graduation: 2027",
        "description": (
            "Building a strong foundation in software development, data structures "
            "and algorithms, databases, operating systems, and application development "
            "through academic and project work."
        ),
        "order": 1,
        "active": True,
    }
]


async def seed_education():
    await connect_to_mongodb()

    education_collection = database["education"]

    await education_collection.delete_many({})
    result = await education_collection.insert_many(education_data)

    print(f"Inserted {len(result.inserted_ids)} education record(s).")

    await close_mongodb_connection()


if __name__ == "__main__":
    asyncio.run(seed_education())