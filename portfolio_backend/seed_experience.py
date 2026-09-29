import asyncio

from app.database.mongodb import (
    connect_to_mongodb,
    close_mongodb_connection,
    database,
)


EXPERIENCE = [
    {
        "role": "Flutter Developer Intern",
        "company": "Incubators Pvt. Ltd.",
        "location": "Pune",
        "start_date": "Aug 2025",
        "end_date": "Dec 2025",
        "description": (
            "Worked on Flutter-based application development, "
            "building responsive user interfaces and translating "
            "application requirements into functional mobile interfaces."
        ),
        "bullets": [
            "Built 10+ responsive UI screens using Flutter and Dart.",
            "Implemented reusable widgets, layouts and application navigation.",
            "Translated application requirements into functional and responsive mobile interfaces.",
            "Collaborated on application development and UI implementation.",
        ],
        "technologies": [
            "Flutter",
            "Dart",
            "Responsive UI",
            "Git",
        ],
        "order": 1,
    }
]


async def seed_experience():
    await connect_to_mongodb()

    collection = database["experience"]

    await collection.delete_many({})
    await collection.insert_many(EXPERIENCE)

    print("Experience seeded successfully.")

    await close_mongodb_connection()


if __name__ == "__main__":
    asyncio.run(seed_experience())