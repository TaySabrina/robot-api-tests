*** Settings ***
Resource    ../../libs/libraries_api.resource
Resource    ../../libs/libraries_common.resource
Resource    ../../resources/keywords/api_keywords.robot


*** Test Cases ***
Create New User
   [Documentation]    Creates a new user, stores their data, and verifies successful registration.
   Create And Register New User
   Log To Console   User created and register successfully

Create New User With Missing Email
    [Documentation]    Attempts to create a new user with missing email and verifies the error response.
    ${full_user_data}   Generate new user
    ${nome_fake}        Get From Dictionary    ${full_user_data}    nome
    ${password_fake}    Get From Dictionary    ${full_user_data}    password
    ${user_data_fake}   Create Dictionary    nome=${nome_fake}    password=${password_fake}    administrador=true
    ${response}         Create new user    ${user_data_fake}
    Verify Error Response    ${response}    400    email é obrigatório
    Log To Console      Failed Create Status: ${response.status_code}
    Log To Console      Failed Create Message: ${response.json()['email']}  # Changed to 'email' field
   
Get User By Id
    [Documentation]    Get user by ID generated during creation and verify the response
    ${user_data}       Load user data  # Load the user data from the JSON file
    ${user_id}         Get From Dictionary    ${user_data}    id  # Get the user ID from user_data.json
    ${response}        Get user by id    ${user_id}
    Check successful get by id     ${response}     200    Failed to retrieve user: Unexpected status code
    Log To Console     GET Status Code: ${response.status_code}
    Log To Console     GET Response: ${response.json()}
    
Get User By Invalid Id
    [Documentation]    Attempts to retrieve a user with an invalid ID, expecting a failure.
    ${invalid_id}      Set Variable    invalid-id-123
    ${response}        Get user by id    ${invalid_id}
    Verify Error Response    ${response}    400    Usuário não encontrado
    Log To Console    Failed GET Status: ${response.status_code}
    Log To Console    Failed GET Message: ${response.json()['message']}