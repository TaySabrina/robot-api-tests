*** Settings ***
Documentation       Tests for user login operations in the ServeRest API
Resource            ../../libs/libraries.resource
Suite Setup         Ensure User Data Exists


*** Test Cases ***
Login
    [Documentation]    Logs in a user with valid credentials generated during creation and verifies successful authentication.
    [Tags]             smoke    login    auth
    ${response}        Login User
    Check Successful Response    ${response}    200    Login realizado com sucesso
    Log To Console     Status Code: ${response.status_code}
    Log To Console     Received Message: ${response.json()['message']}

Login With Invalid Password
    [Documentation]    Attempts to log in with a registered email and an incorrect password, expecting a failure.
    [Tags]             smoke    login    auth
    ${user_data}       Load user data
    ${email}           Get From Dictionary    ${user_data}    email
    ${response}        Login User    ${email}    wrongpassword123
    Verify Error Response    ${response}    401    Email e/ou senha inválidos    message
    Log To Console     Failed Login Status: ${response.status_code}
    Log To Console     Failed Login Message: ${response.json()['message']}
