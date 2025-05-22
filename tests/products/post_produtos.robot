*** Settings ***
Documentation       Test suite for creating and registering users in the ServeRest API
Resource            ../../libs/libraries.resource
Test Tags           post_produtos      produtos


*** Test Cases ***
Create New Product - Success
    [Documentation]    Create a new product and verify the response
    Login registered user and save token
    ${product_data}    Generate And Save Random Product Data
    VAR    ${token}    ${user_data.token}
    # Prepare headers with the token
    VAR    &{headers}=    Authorization=${token}    Content-Type=application/json
    ${response}    Post new product       ${product_data}    ${headers}
    Status Should Be    201    ${response}
    Should Be Equal    ${response.json()}[message]    Cadastro realizado com sucesso
    Dictionary Should Contain Key    ${response.json()}    _id
    # Store product ID for later use
    Set Suite Variable    ${CREATED_PRODUCT_ID}    ${response.json()}[_id]
    # Contract validation
    VAR    ${schema_path}=     ${CURDIR}/../../resources/schemas/post_produtos_201.json
    Validate JsonSchema From File    ${response.text}    ${schema_path}
    Log        message: ${response.json()}[message]
    Log        product_id: ${response.json()}[_id]    


Create New Product - Fail Unauthorized
    [Documentation]    Attempt to create a product without authorization token, expect 401 Unauthorized
    [Tags]    negative
    ${product_data}    Generate And Save Random Product Data
    # Prepare headers WITHOUT token
    ${response}    Post new product    ${product_data}    ${headers}
    Status Should Be    401    ${response}
    Should Be Equal    ${response.json()}[message]    Token de acesso ausente, inválido, expirado ou usuário do token não existe mais
    # Contract validation for 401 error response
    VAR    ${schema_path}=    ${CURDIR}/../../resources/schemas/post_produtos_401.json
    Validate JsonSchema From File    ${response.text}    ${schema_path}
    Log    Response message: ${response.json()}[message]
    Log    Validation: Contract for 401 error response successfully validated


Create New Product - Error With Duplicate Product
    [Documentation]    Attempt to create a product with a name that already exists and verify error response
    [Tags]    negative
    Login registered user and save token
    ${product_data}    Generate And Save Random Product Data
    VAR    ${token}    ${user_data.token}
    # Prepare headers with the token
    VAR    &{headers}=    Authorization=${token}    Content-Type=application/json
    # First create a product successfully
    ${first_response}    Post new product    ${product_data}    ${headers}
    Status Should Be    201    ${first_response}
    # Try to create the same product again
    ${second_response}    Post new product    ${product_data}    ${headers}
    Status Should Be    400    ${second_response}
    Should Be Equal    ${second_response.json()}[message]    Já existe produto com esse nome
    # Contract validation for error response
    VAR    ${schema_path}    ${CURDIR}/../../resources/schemas/post_produtos_400.json
    Validate JsonSchema From File    ${second_response.text}    ${schema_path}
    Log    Error message: ${second_response.json()}[message]


Create New Product - Access Denied for Non-Admin User
    [Documentation]    Verifies that a non-admin user cannot create a product and receives a 403 response.
    [Tags]             negative
    # Create a non-admin user
    Create New User as Admin False
    # Log in with the newly created user
    ${response}    Login User    ${NOT_ADMIN_USER.email}    ${NOT_ADMIN_USER.password}
    VAR    ${token}    ${response.json()}[authorization]
    VAR    &{headers}    Authorization=${token}    Content-Type=application/json
    # Generate product data and attempt creation
    ${product_data}    Generate And Save Random Product Data
    ${response}    Post new product    ${product_data}    ${headers}
    # Validate the response and schema
    Status Should Be    403    ${response}
    Should Be Equal    ${response.json()}[message]    Rota exclusiva para administradores
    Validate JsonSchema From File    ${response.text}    ${CURDIR}/../../resources/schemas/post_produtos_403.json
