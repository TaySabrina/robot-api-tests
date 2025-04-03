*** Settings ***
Documentation    Provides keywords for making HTTP requests to the ServeRest API
Resource         ../../libs/libraries.resource

*** Keywords ***
Send Post Request
    [Documentation]    Sends a POST request to the specified endpoint with the given payload and headers
    [Arguments]    ${endpoint}    ${payload}    ${headers}
    ${response}    POST    ${BASE_URL}${endpoint}    json=${payload}    headers=${HEADERS}    expected_status=any
    RETURN    ${response}

Send Get Request
    [Documentation]    Sends a GET request to the specified endpoint using the given headers
    [Arguments]  ${endpoint}    ${headers}
    ${response}    GET    ${BASE_URL}${endpoint}    headers=${HEADERS}    expected_status=any
    RETURN    ${response}

