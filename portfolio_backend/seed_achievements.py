import asyncio

from app.database.mongodb import database, connect_to_mongodb, close_mongodb_connection


achievements_data = [
    {
        "icon": "code",
        "title": "GSSoC ’26 Contributor",
        "subtitle": "Open Source",
        "description": (
            "Participating in open-source projects through issues, pull requests, "
            "code reviews and collaborative development workflows."
        ),
        "order": 1,
        "active": True,
    },
    {
        "icon": "emoji_events",
        "title": "Hackathons & Projects",
        "subtitle": "Problem Solving & Innovation",
        "description": (
            "Building and exploring software solutions for real-world problems "
            "across mobile development, backend systems and AI/ML."
        ),
        "order": 2,
        "active": True,
    },
    {
        "icon": "school",
        "title": "Continuous Learning",
        "subtitle": "Courses & Certifications",
        "description": (
            "Continuously developing skills through technical courses and "
            "certifications across software development, AI/ML, generative AI "
            "and modern tools."
        ),
        "order": 3,
        "active": True,
    },
]


async def seed_achievements():
    await connect_to_mongodb()

    achievements_collection = database["achievements"]

    await achievements_collection.delete_many({})
    result = await achievements_collection.insert_many(achievements_data)

    print(f"Inserted {len(result.inserted_ids)} achievement record(s).")

    await close_mongodb_connection()


if __name__ == "__main__":
    asyncio.run(seed_achievements())