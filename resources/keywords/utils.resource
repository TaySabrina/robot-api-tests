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
    ${response}            Post new user    ${user_data}
    Set To Dictionary      ${user_data}    id=${response.json()}[_id]
    VAR    ${user_data}    ${user_data}    scope=GLOBAL
    Check successful response    ${response}    201    Cadastro realizado com sucesso
    Log              User created and register successfully
    RETURN                 ${user_data}    # Return the user data for further use

Check Successful Response
    [Documentation]    Verifies that a response matches the expected status code and message.
    [Arguments]    ${response}    ${expected_status}    ${expected_message}
    Should Be Equal As Integers
    ...    ${response.status_code}
    ...    ${expected_status}
    ...    Unexpected status code: ${response.status_code}
    Should Contain
    ...    ${response.json()}[message]
    ...    ${expected_message}
    ...    Expected message '${expected_message}' not in response: ${response.json()}

Check successful get by id
    [Documentation]    Verifies that a response matches the expected status code and message for GET by ID
    [Arguments]    ${response}    ${expected_status_code}    ${expected_message}
    Should Be Equal As Strings    ${response.status_code}    ${expected_status_code}    ${expected_message}
    Should Contain    ${response.json()}       nome    Failed: response doesn't contain 'nome'
    Should Contain    ${response.json()}       email    Failed: response doesn't contain 'email'
    Should Contain    ${response.json()}       password    Failed: response doesn't contain 'password'
    Should Contain    ${response.json()}       administrador    Failed: response doesn't contain 'administrador'
    Should Contain    ${response.json()}       _id    Failed: response doesn't contain '_id'

Verify Error Response
    [Documentation]    Verifies an error response's status code and message in a specified field.
    [Arguments]    ${response}    ${expected_status}    ${expected_message}    ${field}=message
    Should Be Equal As Integers
    ...    ${response.status_code}
    ...    ${expected_status}
    ...    Unexpected status code: ${response.status_code}
    ${error_message}    Get From Dictionary    ${response.json()}    ${field}    default=${None}
    IF    '${error_message}' == '${None}'
        Fail    Field '${field}' not found in response: ${response.json()}
    END
    Should Contain
    ...    ${error_message}
    ...    ${expected_message}
    ...    Expected '${expected_message}' not in '${error_message}'
