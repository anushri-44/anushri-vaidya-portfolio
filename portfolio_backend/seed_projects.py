import asyncio

from app.database.mongodb import (
    connect_to_mongodb,
    close_mongodb_connection,
    database,
)


PROJECTS = [
    {
        "slug": "air-guard",
        "title": "Air Guard",
        "description": (
            "AI-powered air quality platform that combines AQI monitoring, "
            "location-based insights, air quality prediction, health "
            "recommendations, alerts, and interactive visualizations to help "
            "users understand and respond to air pollution."
        ),
        "technologies": [
            "Flutter",
            "FastAPI",
            "Python",
            "Machine Learning",
            "Firebase",
        ],
        "project_url": None,
        "case_study_url": None,
        "featured": True,
        "order": 1,
        "active": True,
    },
    {
        "slug": "localhands",
        "title": "LocalHands",
        "description": (
            "Flutter-based domestic services platform connecting users with "
            "service providers for household and personal services, with "
            "Firebase authentication, service discovery, availability, "
            "ratings, booking management, and role-based workflows."
        ),
        "technologies": [
            "Flutter",
            "Firebase",
            "Firestore",
        ],
        "project_url": "https://gitlab.com/pixelpulse/localhands",
        "case_study_url": None,
        "featured": False,
        "order": 2,
        "active": True,
    },
    {
        "slug": "s-nova",
        "title": "S'Nova",
        "description": (
            "Age-adaptive personal growth and wellness platform built with "
            "JavaFX, combining goal tracking, habit building, journaling, "
            "wellness tools, productivity timers, gamification, and progress "
            "analytics in one application."
        ),
        "technologies": [
            "Java",
            "JavaFX",
            "FXML",
            "CSS",
            "Local Storage",
        ],
        "project_url": None,
        "case_study_url": (
            "https://docs.google.com/document/d/"
            "1FJiPYLFvZnWLsuedTMc5zQK8XooSBs7YmS9vHIkhamo/edit"
        ),
        "featured": False,
        "order": 3,
        "active": True,
    },
]


async def seed_projects():
    await connect_to_mongodb()

    collection = database["projects"]

    for project in PROJECTS:
        await collection.update_one(
            {"slug": project["slug"]},
            {"$set": project},
            upsert=True,
        )

    print("Projects seeded successfully.")

    await close_mongodb_connection()


if __name__ == "__main__":
    asyncio.run(seed_projects())