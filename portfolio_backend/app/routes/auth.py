from fastapi import APIRouter, HTTPException, status

from app.auth.dependencies import get_current_admin
from fastapi import Depends
from app.config import settings
from app.schemas.auth import LoginRequest, TokenResponse
from app.auth.security import create_access_token, verify_password


router = APIRouter()


@router.post("/login", response_model=TokenResponse)
async def login(credentials: LoginRequest):
    if credentials.username != settings.admin_username:
        raise HTTPException(
            status_code=status.HTTP_401_UNAUTHORIZED,
            detail="Invalid username or password",
        )

    if not verify_password(
        credentials.password,
        settings.admin_password_hash,
    ):
        raise HTTPException(
            status_code=status.HTTP_401_UNAUTHORIZED,
            detail="Invalid username or password",
        )

    access_token = create_access_token(credentials.username)

    return {
        "access_token": access_token,
        "token_type": "bearer",
    }

@router.get("/me")
async def get_admin_profile(
    current_admin: str = Depends(get_current_admin),
):
    return {
        "authenticated": True,
        "username": current_admin,
    }