*** Settings ***
Documentation       Test suite for creating and registering users in the ServeRest API
Resource            ../../libs/libraries.resource

*** Test Cases ***
Create New User With Missing Email
    [Documentation]    Attempts to create a new user with missing email and verifies the error response.
    [Tags]    usuarios    post_usuarios
    ${user_partial_data}      Generate Partial User Data    email=${None}
    ${response}    Create new user    ${user_partial_data}
    Verify Error Response    ${response}    400    email é obrigatório    email
    Log To Console    Failed Create Status: ${response.status_code}
    Log To Console    Failed Create Message: ${response.json()}[email]


Create New User With Missing Password
    [Documentation]    Attempts to create a new user with missing password and verifies the error response.
    [Tags]    usuarios    post_usuarios
    ${user_partial_data}      Generate Partial User Data    password=${None}
    ${response}    Create new user    ${user_partial_data}
    Verify Error Response    ${response}    400    password é obrigatório    password
    Log To Console    Failed Create Status: ${response.status_code}
    Log To Console    Failed Create Message: ${response.json()}[password]