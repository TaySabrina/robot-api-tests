*** Settings ***
Documentation    Test suite for getting user details by ID
Resource    ../../libs/libraries.resource


*** Test Cases ***
 Get User By Id
    [Documentation]    Get user by ID generated during creation and verify the response
    [Tags]            smoke    regression   users
    [Setup]            Ensure User Data Exists  # Ensure user data exists before running the test
    ${user_data}       Load user data  # Load the user data from the JSON file
    ${user_id}         Get From Dictionary    ${user_data}    id  # Get the user ID from user_data.json
    ${response}        Get user by id    ${user_id}
    Check successful get by id     ${response}     200    Failed to retrieve user: Unexpected status code
    Log To Console     GET Status Code: ${response.status_code}
    Log To Console     GET Response: ${response.json()}
    
Get User By Invalid Id
    [Documentation]    Attempts to retrieve a user with an invalid ID, expecting a failure.
    [Tags]            smoke    regression   users
    ${invalid_id}      Set Variable    invalid-id-123
    ${response}        Get user by id    ${invalid_id}
    Verify Error Response    ${response}    400    Usuário não encontrado
    Log To Console    Failed GET Status: ${response.status_code}
    Log To Console    Failed GET Message: ${response.json()['message']}