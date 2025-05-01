*** Settings ***
Documentation       Provides keywords for making HTTP requests to the ServeRest API
Resource            ../../libs/libraries.resource


*** Keywords ***
Delete user by id
    [Documentation]    Deletes a user by sending a DELETE request to /usuarios/${user_id}.
    ...                Requires a valid user ID in the URL.
    [Arguments]        ${user_id}
    ${response}        DELETE    ${BASE_URL}/usuarios/${user_id}
    ...                headers=${HEADERS}
    ...                expected_status=any
    RETURN             ${response}