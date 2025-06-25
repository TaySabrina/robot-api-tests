*** Settings ***
Documentation       Provides keywords for making HTTP requests to the ServeRest API
Resource            ../../libs/libraries.resource


*** Keywords ***
Get Users
    [Documentation]    Sends a GET request to the specified endpoint using the given headers and optional query parameters.
    [Arguments]    ${headers}    ${params}=${None} 
    ${query_string}    Run Keyword If    ${params} != None    Set Variable    ${params}
    ${response}    GET    ${BASE_URL}/usuarios    
    ...    headers=${headers}    
    ...    params=${query_string}
    ...    expected_status=any
    RETURN    ${response}
