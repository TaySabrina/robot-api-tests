*** Settings ***
Documentation       Collection of keywords for managing user operations in the ServeRest API

Resource            ../../libs/libraries.resource


*** Keywords ***
Generate new user
    [Documentation]    Generates fake user data for testing purposes using FakerLibrary
    ${nome}    FakerLibrary.Name
    ${email}    FakerLibrary.Email
    ${password}    FakerLibrary.Password
    VAR    &{user_data}    nome=${nome}    email=${email}    password=${password}    administrador=true
    RETURN    ${user_data}

Generate Partial User Data
    [Documentation]    Generates a user data dictionary with optional fields; omits fields set to None.
    [Arguments]    ${nome}=${None}    ${email}=${None}    ${password}=${None}    ${administrador}=${None}
    ${base_data}    Generate new user
    &{args}         Create Dictionary    nome=${nome}    email=${email}    password=${password}    administrador=${administrador}
    &{user_data}    Create Dictionary
    FOR    ${field}    IN    @{args.keys()}
        ${value}    Get From Dictionary    ${args}    ${field}    ${None}
        Run Keyword If    '${value}' != 'None'    Set To Dictionary    ${user_data}    ${field}=${value}
    END
    Return From Keyword    ${user_data}

Create And Register New User
    [Documentation]        Generates a new user, registers it, and stores the data in the global user_data variable.
    ${user_data}           Generate new user
    ${response}            Create new user    ${user_data}
    Set To Dictionary      ${user_data}    id=${response.json()}[_id]
    Set Global Variable    ${user_data}
    Check successful response    ${response}    201    Cadastro realizado com sucesso
    Log To Console         User created and register successfully
    RETURN                 ${user_data}    # Return the user data for further use

Create new user
    [Documentation]    Creates a new user by sending a POST request with the provided user data
    [Arguments]        ${user_data}
    ${response}        Send Post Request    ${ENDPOINT_USUARIOS}    ${user_data}    ${HEADERS}
    RETURN             ${response}


# Ensure User Data Exists
#     [Documentation]    Ensures that user_data contains all required user data; creates a new user if any are missing.
#     Log To Console    Checking if user_data exists: ${user_data}
#     ${required_keys}    Create List    nome    email    password    id
#     ${missing}    Set Variable    False
#     FOR    ${key}    IN    @{required_keys}
#         ${has_key}    Run Keyword And Return Status    Dictionary Should Contain Key    ${user_data}    ${key}
#         Log To Console    Checking key ${key}: Has key = ${has_key}
#         ${has_value}    Run Keyword And Return Status    Run Keyword And Ignore Error    Should Not Be Empty    ${user_data[${key}]}
#         Log To Console    Value for ${key} is not empty: ${has_value}
#         Run Keyword If    not ${has_key} or not ${has_value}    Set Variable    ${missing}    True
#         Run Keyword If    not ${has_key} or not ${has_value}    Log To Console    Key ${key} is missing or empty!
#     END
#     Log To Console    Missing flag after check: ${missing}
#     Run Keyword If    ${missing}    Create And Register New User
#     Log To Console    After ensuring user data, current user_data: ${user_data}
    

Get user by id
    [Documentation]    Retrieves a user’s details by sending a GET request with the specified user ID
    [Arguments]    ${user_id}
    ${response}    Send Get Request    ${ENDPOINT_USUARIOS}/${user_id}    ${HEADERS}
    RETURN    ${response}

Login User
    [Documentation]    Performs a login request with optional custom credentials or defaults to stored user data.
    [Arguments]    ${email}=${None}     ${password}=${None}
    ${email}       Set Variable If      '${email}' == '${None}'    ${user_data}[email]    ${email}
    ${password}    Set Variable If      '${password}' == '${None}'    ${user_data}[password]    ${password}
    &{payload}     Create Dictionary    email=${email}    password=${password}
    ${response}    Send Post Request    ${ENDPOINT_LOGIN}    ${payload}    ${HEADERS}
    RETURN   ${response}

Check Successful Response
    [Documentation]    Verifies that a response matches the expected status code and message.
    [Arguments]    ${response}    ${expected_status}    ${expected_message}
    Should Be Equal As Integers
    ...    ${response.status_code}
    ...    ${expected_status}
    ...    Unexpected status code: ${response.status_code}
    ${response_json}    Set Variable    ${response.json()}
    Should Contain
    ...    ${response_json['message']}
    ...    ${expected_message}
    ...    Expected message '${expected_message}' not in response: ${response_json}

Check successful get by id
    [Documentation]    Verifies that a response matches the expected status code and message for GET by ID
    [Arguments]    ${response}    ${expected_status_code}    ${expected_message}
    Should Be Equal As Strings    ${response.status_code}    ${expected_status_code}    ${expected_message}
    ${response_data}    Set Variable    ${response.json()}
    Should Contain    ${response_data}    nome    Failed: response doesn't contain 'nome'
    Should Contain    ${response_data}    email    Failed: response doesn't contain 'email'
    Should Contain    ${response_data}    password    Failed: response doesn't contain 'password'
    Should Contain    ${response_data}    administrador    Failed: response doesn't contain 'administrador'
    Should Contain    ${response_data}    _id    Failed: response doesn't contain '_id'

Verify Error Response
    [Documentation]    Verifies an error response's status code and message in a specified field.
    [Arguments]    ${response}    ${expected_status}    ${expected_message}    ${field}=message
    Should Be Equal As Integers
    ...    ${response.status_code}
    ...    ${expected_status}
    ...    Unexpected status code: ${response.status_code}
    ${response_json}    Set Variable    ${response.json()}
    ${error_message}    Get From Dictionary    ${response_json}    ${field}    default=${None}
    IF    '${error_message}' == '${None}'
        Fail    Field '${field}' not found in response: ${response_json}
    END
    Should Contain
    ...    ${error_message}
    ...    ${expected_message}
    ...    Expected '${expected_message}' not in '${error_message}'
