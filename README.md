# robot-api-tests
## 🚀 API Test Automation with Robot Framework

This repository contains automated API tests for the [ServeRest API](https://serverest.dev/) using Robot Framework. The tests cover user management (creation and retrieval) and authentication operations, ensuring robust validation of both successful and error scenarios.

### 📌 Technologies Used
- **Framework**: [Robot Framework](https://robotframework.org/)
- **Library**: [RequestsLibrary](https://marketsquare.github.io/robotframework-requests/)
- **Language**: Python 3.x
- **API**: [ServeRest API](https://serverest.dev/)
- **Faker**: [FakerLibrary](https://github.com/peritus/robotframework-faker) for generating test data

---

## 📂 Project Structure

```bash
ROBOT-API-TESTS/
│
├── .env                         # Environment variables
├── .gitignore                  # Git ignored files
│
├── libs/
│   └── libraries.resource      # Shared keyword libraries
│
├── resources/
│   ├── controller/             # Endpoint-specific resource files
│   │   ├── delete_usuarios.resource
│   │   ├── get_usuarios.resource
│   │   ├── post_login.resource
│   │   ├── post_usuarios.resource
│   │   └── put_usuarios.resource
│   │
│   ├── keywords/               # Custom reusable keywords
│   │   ├── action_keywords.resource
│   │   ├── user_keywords.resource
│   │   └── utils.resource
│   │
│   └── variables/
│       └── variable.resource   # Global variables
│
├── tests/                      # Test cases organized by feature
│   ├── login/
│   │   └── post_login.robot
│   │
│   ├── users/
│   │   ├── get_user_id.robot
│   │   └── post_user.robot
│   │
│   └── usuarios/
│       ├── get_user_id.robot
│       ├── post_user.robot
│       ├── put_user.robot
│       └── __init__.robot     # Optional initialization file
│
└── README.md                   # Project documentation
```
## ✅ Folder Purpose
- libs/ – Contains shared keyword libraries.
- resources/controller/ – Contains resource files specific to each API endpoint.
- resources/keywords/ – Contains reusable keyword definitions.
- resources/variables/ – Stores global and configurable variables.

---

## ✨ Features
- **User Management**:
  - Create users with valid data.
  - Handle errors (e.g., missing email, invalid IDs).
  - Retrieve user details by ID.
- **Authentication**:
  - Login with valid credentials.
  - Test invalid login attempts (e.g., wrong password).
- **Dynamic Data**: Uses FakerLibrary to generate realistic test data.
- **Error Handling**: Validates API error responses (e.g., `400`, `401`).

---

## ⚙️ Prerequisites
- **Python 3.12.9: Installed on your system.
- **Robot Framework**: Install via pip:
  ```bash
  pip install robotframework
- **RequestsLibrary: For API calls:** 
  ```bash
  pip install robotframework-requests
- **FakerLibrary: For fake data generation:** 
  ```bash
  pip install robotframework-faker

---

## Running the Tests
- **Run the full test suite**
  ```bash
  robot -d result tests

- **Running only login test suite**
  ```bash
  robot -d result tests/auth

- **Running only users test suite**
  ```bash
  robot -d result tests/users

- **Running tests with a specific tag**
  ```bash
  robot --include login tests/

- **Running tests with a multiple tags**
  ```bash
  robot --include login,post_usuarios tests/

- **Running tests that do not have a specific tag**
  ```bash
  robot --exclude login tests/
