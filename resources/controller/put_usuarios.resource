*** Settings ***
Documentation       Provides keywords for making HTTP requests to the ServeRest API
Resource            ../../libs/libraries.resource


*** Keywords ***
Put user by id
    [Documentation]    Updates an existing user's data by sending a PUT request to the /usuarios/{id} endpoint.
    [Arguments]    ${user_id}    ${updated_user_data}
    ${response}    PUT    ${BASE_URL}/usuarios/${user_id}
    ...    json=${updated_user_data}
    ...    headers=${HEADERS}
    ...    expected_status=any
    RETURN    ${response}