*** Settings ***
Documentation    Collection of keywords for managing user operations in the ServeRest API
Resource    ../../libs/libraries_api.resource
Resource    ../../libs/libraries_api.resource
Resource    ../../libs/libraries_common.resource
Resource    api_keywords.robot


*** Keywords ***
Generate new user
    [Documentation]    Generates fake user data for testing purposes using FakerLibrary
    ${nome}        FakerLibrary.Name
    ${email}       FakerLibrary.Email
    ${password}    FakerLibrary.Password
    VAR    &{user_data}    nome=${nome}    email=${email}    password=${password}    administrador=true
    RETURN    ${user_data}

Create new user
    [Documentation]    Creates a new user by sending a POST request with the provided user data
    [Arguments]    ${user_data}
    ${response}    Send Post Request    ${ENDPOINT_USUARIOS}    ${user_data}    ${HEADERS}
    RETURN    ${response}

Create And Register New User
    [Documentation]    Generates a new user, registers it, and saves the data with ID to user_data.json.
    ${user_data}    Generate new user
    ${response}     Create new user    ${user_data}
    Save user data  ${user_data}
    ${user_id}      Get From Dictionary    ${response.json()}    _id
    Save User ID    ${user_id}
    Check successful response    ${response}    201    Cadastro realizado com sucesso
    RETURN    ${user_data}  # Return the user data for further use

Save user data
    [Documentation]    Saves the provided user data to a JSON file for persistent storage
    [Arguments]    ${user_data}
    ${user_data_str}    Evaluate    json.dumps($user_data)    # Convert to JSON string
    Create File    ${DATA_DIR}/user_data.json    ${user_data_str}    encoding=UTF-8    # Save as JSON string

Save User ID
    [Documentation]    Updates the stored user data by adding the user ID to the JSON file
    [Arguments]    ${user_id}
    ${existing_data}    Load user data  # Load current user_data.json
    Set To Dictionary    ${existing_data}    id=${user_id}  # Add _id to the dictionary
    ${updated_data_str} =    Evaluate    json.dumps($existing_data)  # Convert back to JSON string
    Create File    ${DATA_DIR}/user_data.json    ${updated_data_str}    encoding=UTF-8  # Overwrite file

Load user data
    [Documentation]    Loads user data from the JSON file into a dictionary
    ${json_str}     Get File    ${DATA_DIR}/user_data.json    encoding=UTF-8
    ${user_data}    Evaluate    json.loads('${json_str}')    modules=json
    RETURN    ${user_data}

Get user by id
    [Documentation]    Retrieves a user’s details by sending a GET request with the specified user ID
    [Arguments]    ${user_id}
    ${response}    Send Get Request       ${ENDPOINT_USUARIOS}/${user_id}    ${HEADERS}
    RETURN    ${response}

Login User
    [Documentation]    Performs a login request with optional custom credentials or defaults to stored user data.
    [Arguments]    ${email}=${None}    ${password}=${None}
    ${user_data}    Run Keyword If    '${email}' == '${None}'    Load user data    ELSE    Create Dictionary    email=${email}    password=${password}
    ${email}        Run Keyword If    '${email}' == '${None}'    Get From Dictionary    ${user_data}    email    ELSE    Set Variable    ${email}
    ${password}     Run Keyword If    '${password}' == '${None}'    Get From Dictionary    ${user_data}    password    ELSE    Set Variable    ${password}
    &{login_payload}    Create Dictionary    email=${email}    password=${password}
    ${response}    Send Post Request    ${ENDPOINT_LOGIN}    ${login_payload}    ${HEADERS}
    RETURN    ${response}

Check successful response
    [Documentation]    Verifies that a response matches the expected status code and message
    [Arguments]    ${response}    ${expected_status_code}    ${expected_message}
    Should Be Equal As Strings    ${response.status_code}    ${EXPECTED_STATUS_CODE}
    ${response_message}    Get From Dictionary    ${response.json()}    message
    Should Be Equal As Strings    ${response_message}    ${EXPECTED_MESSAGE}

Check successful get by id
    [Documentation]    Verifies that a response matches the expected status code and message for GET by ID
    [Arguments]    ${response}    ${expected_status_code}    ${expected_message}
    Should Be Equal As Strings    ${response.status_code}    ${expected_status_code}    ${expected_message}
    ${response_data}     Set Variable    ${response.json()}
    Should Contain    ${response_data}    nome             Failed: response doesn't contain 'nome'
    Should Contain    ${response_data}    email            Failed: response doesn't contain 'email'
    Should Contain    ${response_data}    password         Failed: response doesn't contain 'password'
    Should Contain    ${response_data}    administrador    Failed: response doesn't contain 'administrador'
    Should Contain    ${response_data}    _id              Failed: response doesn't contain '_id'

Verify Error Response
    [Documentation]    Verifies that an error response matches the expected status code and contains the expected message in either 'message' or 'email' field.
    [Arguments]    ${response}    ${expected_status_code}    ${expected_message}
    Should Be Equal As Integers    ${response.status_code}    ${expected_status_code}    Failed to verify error: Unexpected status code
    ${response_json}    Set Variable    ${response.json()}
    Log    Response JSON: ${response_json}  # Debug log
    ${message_field}    Get From Dictionary    ${response_json}    message    default=${None}
    ${email_field}      Get From Dictionary    ${response_json}    email      default=${None}
    ${error_field}      Set Variable If    '${message_field}' != '${None}'    ${message_field}    ${email_field}
    Run Keyword If    '${error_field}' == '${None}'    Fail    No 'message' or 'email' field in response: ${response_json}
    Should Contain    ${error_field}    ${expected_message}    Failed to verify error: Expected message '${expected_message}' not found in '${error_field}'