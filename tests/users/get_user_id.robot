*** Settings ***
Documentation       Test suite for getting user details by ID
Resource            ../../libs/libraries.resource
Suite Setup         Run Keywords
...                 Create And Register New User
Test Tags           get_usuarios    usuarios


*** Test Cases ***
 Get User By Id
    [Documentation]    Get user by ID generated during creation and verify the response
    ${user_id}     Set Variable    ${user_data}[id]    # Get the user ID from user_data.json
    ${response}    Get user by id    ${user_id}
    Check successful get by id    ${response}    200    Failed to retrieve user: Unexpected status code
    Log            GET Status Code: ${response.status_code}
    
    
Get User By Invalid Id
    [Documentation]    Attempts to retrieve a user with an invalid ID, expecting a failure.
    [Tags]             negative   
    ${invalid_id}      Set Variable    invalidid1234567    # Example of an invalid ID
    ${response}        Get user by id    ${invalid_id}
    Verify Error Response    ${response}    400    Usuário não encontrado
    Log                Failed GET Status: ${response.status_code}
    Log                Failed GET Message: ${response.json()}[message]
