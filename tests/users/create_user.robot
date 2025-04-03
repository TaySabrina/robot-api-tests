*** Settings ***
Documentation    Test suite for creating and registering users in the ServeRest API
Resource    ../../libs/libraries.resource


*** Test Cases ***
Create New User
   [Documentation]    Creates a new user, stores their data, and verifies successful registration.
   [Tags]             smoke    regression   users
   Create And Register New User
   Log To Console     User created and register successfully

Create New User With Missing Email
    [Documentation]    Attempts to create a new user with missing email and verifies the error response.
    [Tags]             smoke    regression   users
    ${full_user_data}   Generate new user
    ${nome_fake}        Get From Dictionary    ${full_user_data}    nome
    ${password_fake}    Get From Dictionary    ${full_user_data}    password
    ${user_data_fake}   Create Dictionary    nome=${nome_fake}    password=${password_fake}    administrador=true
    ${response}         Create new user    ${user_data_fake}
    Verify Error Response    ${response}    400    email é obrigatório    email
    Log To Console      Failed Create Status: ${response.status_code}
    Log To Console      Failed Create Message: ${response.json()['email']}  # Changed to 'email' field
   