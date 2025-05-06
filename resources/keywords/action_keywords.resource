*** Settings ***
Documentation       Collection of keywords for managing user operations in the ServeRest API

Resource            ../../libs/libraries.resource


*** Keywords ***

Post new user
    [Documentation]    Creates a new user by sending a POST request with the provided user data
    [Arguments]        ${user_data}
    ${response}        Post Usuarios     ${user_data}    ${HEADERS}
    RETURN             ${response}   

Get user by id
    [Arguments]    ${user_id}
    ${response}    GET    ${BASE_URL}/usuarios/${user_id}    
    ...    headers=${HEADERS}    
    ...    expected_status=any
    RETURN    ${response}

Login User
    [Documentation]    Performs a login request with optional custom credentials or defaults to stored user data.
    [Arguments]    ${email}=${None}     ${password}=${None}
    ${email}       Set Variable If      '${email}' == '${None}'    ${user_data}[email]    ${email}
    ${password}    Set Variable If      '${password}' == '${None}'    ${user_data}[password]    ${password}
    VAR    &{payload}         email=${email}    password=${password}
    ${response}    Post Login       ${payload}    ${HEADERS}
    RETURN   ${response}

