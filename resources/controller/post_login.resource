*** Settings ***
Documentation       Provides keywords for making HTTP requests to the ServeRest API

Resource            ../../libs/libraries.resource


*** Keywords ***
Post Login
    [Documentation]    Sends a POST request to the specified endpoint with the given payload and headers
    [Arguments]    ${payload}    ${headers}
    ${response}    POST    ${BASE_URL}/login    json=${payload}    headers=${HEADERS}    expected_status=any
    RETURN    ${response}
