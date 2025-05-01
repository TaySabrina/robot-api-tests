*** Settings ***
Documentation       Test suite for creating and registering users in the ServeRest API
Resource            ../../libs/libraries.resource
Suite Setup         Run Keywords
...                 Create And Register New User
Test Tags           delete_usuarios    usuarios

*** Test Cases ***
Delete User By Id
    [Documentation]    Deletes a previously created user and verifies that the operation was successful.
    ${user_id}       Set Variable    ${user_data}[id]
    ${response}      Delete user by id    ${user_id}
    Check successful response    ${response}    200    Registro excluído com sucesso
    Log        DELETE Status Code: ${response.status_code}

    # Verify that the user no longer exists by attempting to retrieve it
    ${get_response}   Get user by id    ${user_id}
    Should Be Equal As Integers    ${get_response.status_code}    400
    Should Contain    ${get_response.json()}[message]    Usuário não encontrado

Delete User With Invalid Id
    [Documentation]    Attempts to delete a user using an invalid ID and expects a failure response.
    [Tags]             negative
    ${invalid_id}      Set Variable    123invalidID
    ${response}        Delete user by id    ${invalid_id}
    Should Be Equal As Integers    ${response.status_code}    200
    Should Contain     ${response.json()}[message]    Nenhum registro excluído