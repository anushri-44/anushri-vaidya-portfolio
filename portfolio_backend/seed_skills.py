import asyncio

from app.database.mongodb import (
    connect_to_mongodb,
    close_mongodb_connection,
    database,
)


SKILLS = [
    {
        "category": "Languages",
        "icon": "code",
        "skills": [
            "Java",
            "Python",
            "Dart",
            "SQL",
        ],
        "order": 1,
    },
    {
        "category": "Development",
        "icon": "phone_android",
        "skills": [
            "Flutter",
            "Firebase",
            "FastAPI",
            "REST APIs",
            "JavaFX",
            "HTML/CSS",
            "JavaScript",
        ],
        "order": 2,
    },
    {
        "category": "AI / ML",
        "icon": "auto_awesome",
        "skills": [
            "Machine Learning",
            "NumPy",
            "Pandas",
            "Scikit-learn",
        ],
        "order": 3,
    },
    {
        "category": "Core CS & Tools",
        "icon": "storage",
        "skills": [
            "DSA",
            "OOP",
            "DBMS",
            "Operating Systems",
            "Git",
            "GitHub",
            "GitLab",
            "Postman",
        ],
        "order": 4,
    },
]


async def seed_skills():
    await connect_to_mongodb()

    collection = database["skills"]

    await collection.delete_many({})
    await collection.insert_many(SKILLS)

    print("Skills seeded successfully.")

    await close_mongodb_connection()


if __name__ == "__main__":
    asyncio.run(seed_skills())