*** Settings ***
Documentation       Tests for user login operations in the ServeRest API
Resource            ../../libs/libraries.resource
Suite Setup         Create And Register New User
Test Tags           login    post_usuarios


*** Test Cases ***
Login
    [Documentation]    Logs in a user with valid credentials generated during creation and verifies successful authentication.
    ${response}       Login User
    Check Successful Response    ${response}    200    Login realizado com sucesso
    Log     Status Code: ${response.status_code}
    Log     Received Message: ${response.json()}[message]


Login With Invalid Password
    [Documentation]    Attempts to log in with a registered email and an incorrect password, expecting a failure.
    VAR    ${email} =       ${user_data}[email]
    ${response}       Login User    ${email}    wrongpassword123
    Verify Error Response    ${response}    401    Email e/ou senha inválidos    message
    Log     Failed Login Status: ${response.status_code}
    Log     Failed Login Message: ${response.json()}[message]

