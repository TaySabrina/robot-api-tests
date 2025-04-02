*** Settings ***
Resource    ../../libs/libraries_api.resource
Resource    ../../libs/libraries_common.resource
Resource    ../../resources/keywords/api_keywords.robot
Resource    ../../resources/keywords/user_keywords.robot
Resource    ../../resources/variables/variable.resource

*** Test Cases ***
Login
    [Documentation]    Logs in an user with valid credentials generated during creation and verifies successful authentication.
    ${file_exists}     Run Keyword And Return Status    File Should Exist    ${DATA_DIR}/user_data.json   # Check if the file exists
    Run Keyword If     not ${file_exists}   Create And Register New User      # Create a new user if the file doesn't exist
    ${response}        Login User  # Use the existing Login User keyword
    Check successful response     ${response}     200    Login realizado com sucesso
    Log To Console     Status Code: ${response.status_code}
    Log To Console     Received Message: ${response.json()['message']}

Login With Invalid Password
    [Documentation]    Attempts to log in with a valid email and an incorrect password, expecting a failure.
    ${full_user_data}   Generate new user
    ${email_fake}       Get From Dictionary    ${full_user_data}    email
    ${response}         Login User    ${email_fake}    wrongpassword123  # Pass custom credentials
    Verify Error Response    ${response}    401    Email e/ou senha inválidos
    Log To Console    Failed Login Status: ${response.status_code}
    Log To Console    Failed Login Message: ${response.json()['message']}