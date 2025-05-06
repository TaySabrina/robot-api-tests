*** Settings ***
Documentation       Test suite for creating and registering users in the ServeRest API
Resource            ../../libs/libraries.resource
Test Tags           post_usuarios    usuarios    negative

*** Test Cases ***
Create New User With Missing Email
    [Documentation]    Attempts to create a new user with missing email and verifies the error response.         
    ${user_partial_data}      Generate Partial User Data    email=${None}
    ${response}    Post new user    ${user_partial_data}
    Verify Error Response    ${response}    400    email é obrigatório    email
    Log       Failed Create Status: ${response.status_code}
    Log       Failed Create Message: ${response.json()}[email]


Create New User With Missing Password
    [Documentation]    Attempts to create a new user with missing password and verifies the error response.
    ${user_partial_data}      Generate Partial User Data    password=${None}
    ${response}    Post new user    ${user_partial_data}
    Verify Error Response    ${response}    400    password é obrigatório    password
    Log        Failed Create Status: ${response.status_code}
    Log        Failed Create Message: ${response.json()}[password]