"""
FastAPI Example Application
A modern Python web API showcasing best practices.
"""

from fastapi import FastAPI, HTTPException, Depends
from fastapi.middleware.cors import CORSMiddleware
from fastapi.security import HTTPBearer, HTTPAuthorizationCredentials
from pydantic import BaseModel, Field
from typing import List, Optional
import uvicorn
import logging

# Configure logging
logging.basicConfig(level=logging.INFO)
logger = logging.getLogger(__name__)

# Initialize FastAPI app
app = FastAPI(
    title="Template2 Python Example API",
    description="A showcase of modern Python web development with FastAPI",
    version="1.0.0",
    docs_url="/docs",
    redoc_url="/redoc"
)

# Add CORS middleware
app.add_middleware(
    CORSMiddleware,
    allow_origins=["*"],
    allow_credentials=True,
    allow_methods=["*"],
    allow_headers=["*"],
)

# Security
security = HTTPBearer()

# Pydantic models
class User(BaseModel):
    """User model with validation."""
    id: int
    name: str = Field(..., min_length=1, max_length=100)
    email: str = Field(..., regex=r'^[^@]+@[^@]+\.[^@]+$')
    age: Optional[int] = Field(None, gt=0, le=150)

class UserCreate(BaseModel):
    """User creation model."""
    name: str = Field(..., min_length=1, max_length=100)
    email: str = Field(..., regex=r'^[^@]+@[^@]+\.[^@]+$')
    age: Optional[int] = Field(None, gt=0, le=150)

class HealthCheck(BaseModel):
    """Health check response model."""
    status: str
    version: str
    environment: str

# In-memory storage (replace with database in production)
users_db: List[User] = [
    User(id=1, name="Alice Johnson", email="alice@example.com", age=30),
    User(id=2, name="Bob Smith", email="bob@example.com", age=25),
]

# Dependency injection
async def get_current_user(credentials: HTTPAuthorizationCredentials = Depends(security)):
    """Validate authentication token."""
    # In a real application, validate the token here
    if credentials.credentials != "valid-token":
        raise HTTPException(status_code=401, detail="Invalid authentication token")
    return {"user_id": 1, "username": "authenticated_user"}

# Routes
@app.get("/", response_model=dict)
async def root():
    """Root endpoint."""
    return {
        "message": "Welcome to Template2 Python Example API",
        "docs": "/docs",
        "health": "/health"
    }

@app.get("/health", response_model=HealthCheck)
async def health_check():
    """Health check endpoint."""
    return HealthCheck(
        status="healthy",
        version="1.0.0",
        environment="development"
    )

@app.get("/users", response_model=List[User])
async def get_users():
    """Get all users."""
    logger.info("Fetching all users")
    return users_db

@app.get("/users/{user_id}", response_model=User)
async def get_user(user_id: int):
    """Get user by ID."""
    logger.info(f"Fetching user with ID: {user_id}")
    user = next((user for user in users_db if user.id == user_id), None)
    if not user:
        raise HTTPException(status_code=404, detail="User not found")
    return user

@app.post("/users", response_model=User, status_code=201)
async def create_user(user: UserCreate):
    """Create a new user."""
    logger.info(f"Creating new user: {user.name}")
    new_id = max(user.id for user in users_db) + 1 if users_db else 1
    new_user = User(id=new_id, **user.dict())
    users_db.append(new_user)
    return new_user

@app.put("/users/{user_id}", response_model=User)
async def update_user(user_id: int, user_update: UserCreate):
    """Update an existing user."""
    logger.info(f"Updating user with ID: {user_id}")
    user_index = next((i for i, user in enumerate(users_db) if user.id == user_id), None)
    if user_index is None:
        raise HTTPException(status_code=404, detail="User not found")
    
    updated_user = User(id=user_id, **user_update.dict())
    users_db[user_index] = updated_user
    return updated_user

@app.delete("/users/{user_id}", status_code=204)
async def delete_user(user_id: int):
    """Delete a user."""
    logger.info(f"Deleting user with ID: {user_id}")
    user_index = next((i for i, user in enumerate(users_db) if user.id == user_id), None)
    if user_index is None:
        raise HTTPException(status_code=404, detail="User not found")
    
    users_db.pop(user_index)
    return {"message": "User deleted successfully"}

@app.get("/protected", dependencies=[Depends(get_current_user)])
async def protected_route(current_user: dict = Depends(get_current_user)):
    """Protected route requiring authentication."""
    return {"message": f"Hello {current_user['username']}, this is a protected route!"}

# Error handlers
@app.exception_handler(ValueError)
async def value_error_handler(request, exc):
    """Handle value errors."""
    return {"error": "Invalid value provided", "detail": str(exc)}

def start_server():
    """Start the development server."""
    uvicorn.run(
        "src.main:app",
        host="0.0.0.0",
        port=8000,
        reload=True,
        log_level="info"
    )

if __name__ == "__main__":
    start_server()