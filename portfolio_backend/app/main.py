from contextlib import asynccontextmanager

from app.routes.auth import router as auth_router

from app.routes.certifications import router as certifications_router

from app.routes.messages import router as messages_router

from app.routes.achievements import router as achievements_router

from app.routes.education import router as education_router

from app.routes.experience import router as experience_router

from app.routes.skills import router as skills_router

from fastapi.middleware.cors import CORSMiddleware

from app.routes.projects import router as projects_router

from fastapi import FastAPI

from app.database.mongodb import (
    connect_to_mongodb,
    close_mongodb_connection,
)


@asynccontextmanager
async def lifespan(app: FastAPI):
    await connect_to_mongodb()

    yield

    await close_mongodb_connection()


app = FastAPI(
    title="Anushri Vaidya Portfolio API",
    description="Backend API for Anushri Vaidya's portfolio.",
    version="1.0.0",
    lifespan=lifespan,
)

from fastapi.middleware.cors import CORSMiddleware

app.add_middleware(
    CORSMiddleware,
    allow_origin_regex=r"^https?://(localhost|127\.0\.0\.1)(:\d+)?$",
    allow_credentials=True,
    allow_methods=["*"],
    allow_headers=["*"],
)

app.include_router(
    projects_router,
    prefix="/api/projects",
    tags=["Projects"],
)

app.include_router(
    skills_router,
    prefix="/api/skills",
    tags=["Skills"],
)

app.include_router(
    experience_router,
    prefix="/api/experience",
    tags=["Experience"],
)

app.include_router(
    education_router,
    prefix="/api/education",
    tags=["Education"],
)

app.include_router(
    achievements_router,
    prefix="/api/achievements",
    tags=["Achievements"],
)

app.include_router(
    messages_router,
    prefix="/api/messages",
    tags=["Messages"],
)

app.include_router(
    certifications_router,
    prefix="/api/certifications",
    tags=["Certifications"],
)

app.include_router(
    auth_router,
    prefix="/api/auth",
    tags=["Authentication"],
)

@app.get("/")
async def root():
    return {
        "message": "Anushri Vaidya Portfolio API is running"
    }


@app.get("/health")
async def health():
    return {
        "status": "healthy"
    }