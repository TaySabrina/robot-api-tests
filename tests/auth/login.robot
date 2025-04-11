*** Settings ***
Documentation       Tests for user login operations in the ServeRest API
Resource            ../../libs/libraries.resource
Suite Setup         Create And Register New User


*** Test Cases ***
Login
    [Documentation]    Logs in a user with valid credentials generated during creation and verifies successful authentication.
    [Tags]            login    post_usuarios
    ${response}       Login User
    Check Successful Response    ${response}    200    Login realizado com sucesso
    Log To Console    Status Code: ${response.status_code}
    Log To Console    Received Message: ${response.json()['message']}


Login With Invalid Password
    [Documentation]    Attempts to log in with a registered email and an incorrect password, expecting a failure.
    [Tags]            login    post_usuarios
    ${email}          Set Variable   ${user_data}[email]
    ${response}       Login User    ${email}    wrongpassword123
    Verify Error Response    ${response}    401    Email e/ou senha inválidos    message
    Log To Console    Failed Login Status: ${response.status_code}
    Log To Console    Failed Login Message: ${response.json()['message']}
