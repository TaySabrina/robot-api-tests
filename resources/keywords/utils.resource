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

Create New User as Admin False
    [Documentation]    Generates and registers a new user with 'administrador' set to false, then saves it to a suite variable.
    ${not_admin_user}    Generate new user
    Set To Dictionary    ${not_admin_user}    administrador=false
    ${response}    Post new user    ${not_admin_user}
    Status Should Be    201    ${response}
    RETURN        ${not_admin_user}

Login registered user and save token
    [Documentation]    Creates a new user, logs in with the generated credentials, extracts the auth token,
    ...                and stores all user data (including the token) globally
    ${user_data}    Create And Register New User
    ${response}     Login User
    ...             ${user_data}[email]
    ...             ${user_data}[password]
    Check Successful Response
    ...             ${response}    200    Login realizado com sucesso
    #Extract the authentication token from the login response JSON.
    VAR    ${token}       ${response.json()}[authorization]
    Set To Dictionary    ${user_data}    token=${token}
    #Update the global variable with the new user_data (now containing the token)
    VAR             ${user_data}    ${user_data}    scope=GLOBAL
    Log             Status Code: ${response.status_code}
    Log             Received Message: ${response.json()}[message]
    RETURN          ${user_data}

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

Generate And Save Random Product Data
    [Documentation]    Creates random product data, converts to json file and saves it to a variable.
    VAR    &{create_product_data}
    ${random_name}=    FakerLibrary.Company
    ${random_price}=    FakerLibrary.Random Int    min=10    max=1000
    ${random_description}=    FakerLibrary.Paragraph    nb_sentences=2
    ${random_quantity}=    FakerLibrary.Random Int    min=1    max=100
    Set To Dictionary    ${create_product_data}    nome=${random_name}
    Set To Dictionary    ${create_product_data}    preco=${random_price}
    Set To Dictionary    ${create_product_data}    descricao=${random_description}
    Set To Dictionary    ${create_product_data}    quantidade=${random_quantity}
    # Save data to file
    ${product_data}    Convert To Json    ${create_product_data}
    RETURN    ${product_data}


Create And Register New Product
    [Documentation]    Generates a new user, registers it, and stores the data in the global user_data variable.
    Login registered user and save token
    ${product_data}    Generate And Save Random Product Data
    VAR    ${token}    ${user_data}[token]
    VAR    &{headers}=    Authorization=${token}    Content-Type=application/json
    ${response}    Post new product    ${product_data}    ${headers}
    Set To Dictionary    ${product_data}    id=${response.json()}[_id]
    Set To Dictionary    ${product_data}    raw_response_json=${response.json()}
    VAR    ${product_data}    ${product_data}    scope=GLOBAL
    Check successful response    ${response}    201    Cadastro realizado com sucesso
    RETURN    ${product_data}
