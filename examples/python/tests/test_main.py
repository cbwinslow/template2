"""
Test suite for the FastAPI example application.
"""

import pytest
from fastapi.testclient import TestClient
from src.main import app, users_db, User

# Create test client
client = TestClient(app)

class TestAPI:
    """Test cases for the API endpoints."""

    def test_root_endpoint(self):
        """Test the root endpoint."""
        response = client.get("/")
        assert response.status_code == 200
        data = response.json()
        assert "message" in data
        assert "docs" in data
        assert "health" in data

    def test_health_check(self):
        """Test the health check endpoint."""
        response = client.get("/health")
        assert response.status_code == 200
        data = response.json()
        assert data["status"] == "healthy"
        assert "version" in data
        assert "environment" in data

    def test_get_users(self):
        """Test getting all users."""
        response = client.get("/users")
        assert response.status_code == 200
        data = response.json()
        assert isinstance(data, list)
        assert len(data) >= 0

    def test_get_user_by_id(self):
        """Test getting a user by ID."""
        # Assume user with ID 1 exists
        response = client.get("/users/1")
        assert response.status_code == 200
        data = response.json()
        assert data["id"] == 1
        assert "name" in data
        assert "email" in data

    def test_get_nonexistent_user(self):
        """Test getting a non-existent user."""
        response = client.get("/users/999")
        assert response.status_code == 404
        assert "User not found" in response.json()["detail"]

    def test_create_user(self):
        """Test creating a new user."""
        new_user_data = {
            "name": "Test User",
            "email": "test@example.com",
            "age": 25
        }
        response = client.post("/users", json=new_user_data)
        assert response.status_code == 201
        data = response.json()
        assert data["name"] == new_user_data["name"]
        assert data["email"] == new_user_data["email"]
        assert data["age"] == new_user_data["age"]
        assert "id" in data

    def test_create_user_invalid_email(self):
        """Test creating a user with invalid email."""
        invalid_user_data = {
            "name": "Test User",
            "email": "invalid-email",
            "age": 25
        }
        response = client.post("/users", json=invalid_user_data)
        assert response.status_code == 422

    def test_create_user_invalid_age(self):
        """Test creating a user with invalid age."""
        invalid_user_data = {
            "name": "Test User",
            "email": "test@example.com",
            "age": -5
        }
        response = client.post("/users", json=invalid_user_data)
        assert response.status_code == 422

    def test_update_user(self):
        """Test updating an existing user."""
        # Create a user first
        create_response = client.post("/users", json={
            "name": "Update Test",
            "email": "update@example.com",
            "age": 30
        })
        user_id = create_response.json()["id"]

        # Update the user
        update_data = {
            "name": "Updated User",
            "email": "updated@example.com",
            "age": 35
        }
        response = client.put(f"/users/{user_id}", json=update_data)
        assert response.status_code == 200
        data = response.json()
        assert data["name"] == update_data["name"]
        assert data["email"] == update_data["email"]
        assert data["age"] == update_data["age"]

    def test_update_nonexistent_user(self):
        """Test updating a non-existent user."""
        update_data = {
            "name": "Non-existent User",
            "email": "nonexistent@example.com",
            "age": 25
        }
        response = client.put("/users/999", json=update_data)
        assert response.status_code == 404

    def test_delete_user(self):
        """Test deleting a user."""
        # Create a user first
        create_response = client.post("/users", json={
            "name": "Delete Test",
            "email": "delete@example.com",
            "age": 30
        })
        user_id = create_response.json()["id"]

        # Delete the user
        response = client.delete(f"/users/{user_id}")
        assert response.status_code == 204

        # Verify user is deleted
        get_response = client.get(f"/users/{user_id}")
        assert get_response.status_code == 404

    def test_delete_nonexistent_user(self):
        """Test deleting a non-existent user."""
        response = client.delete("/users/999")
        assert response.status_code == 404

    def test_protected_route_without_auth(self):
        """Test accessing protected route without authentication."""
        response = client.get("/protected")
        assert response.status_code == 403

    def test_protected_route_with_invalid_auth(self):
        """Test accessing protected route with invalid authentication."""
        headers = {"Authorization": "Bearer invalid-token"}
        response = client.get("/protected", headers=headers)
        assert response.status_code == 401

    def test_protected_route_with_valid_auth(self):
        """Test accessing protected route with valid authentication."""
        headers = {"Authorization": "Bearer valid-token"}
        response = client.get("/protected", headers=headers)
        assert response.status_code == 200
        data = response.json()
        assert "authenticated_user" in data["message"]


class TestUserModel:
    """Test cases for the User model."""

    def test_user_model_validation(self):
        """Test User model validation."""
        user = User(
            id=1,
            name="Test User",
            email="test@example.com",
            age=25
        )
        assert user.id == 1
        assert user.name == "Test User"
        assert user.email == "test@example.com"
        assert user.age == 25

    def test_user_model_invalid_email(self):
        """Test User model with invalid email."""
        with pytest.raises(ValueError):
            User(
                id=1,
                name="Test User",
                email="invalid-email",
                age=25
            )

    def test_user_model_invalid_age(self):
        """Test User model with invalid age."""
        with pytest.raises(ValueError):
            User(
                id=1,
                name="Test User",
                email="test@example.com",
                age=-5
            )


@pytest.fixture(autouse=True)
def reset_users_db():
    """Reset the users database before each test."""
    global users_db
    users_db.clear()
    users_db.extend([
        User(id=1, name="Alice Johnson", email="alice@example.com", age=30),
        User(id=2, name="Bob Smith", email="bob@example.com", age=25),
    ])
    yield
    users_db.clear()