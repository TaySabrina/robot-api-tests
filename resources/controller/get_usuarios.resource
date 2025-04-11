*** Settings ***
Documentation       Provides keywords for making HTTP requests to the ServeRest API
Resource            ../../libs/libraries.resource


*** Keywords ***
Send Get Request
    [Documentation]    Sends a GET request to the specified endpoint using the given headers and optional query parameters.
    [Arguments]    ${endpoint}    ${headers}    ${params}=${None} 
    ${query_string}    Run Keyword If    '${params}' != '${None}'    Create Dictionary    @{params}
    ${response}    GET    ${BASE_URL}${endpoint}    
    ...    headers=${headers}    
    ...    params=${query_string}    
    ...    expected_status=any
    RETURN    ${response}
