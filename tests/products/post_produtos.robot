*** Settings ***
Documentation       Test suite for creating and registering users in the ServeRest API
Resource            ../../libs/libraries.resource
Test Tags           post_produtos      produtos


*** Test Cases ***
Create New Product - Success
    ${product_data}    Create And Register New Product
    Dictionary Should Contain Key    ${product_data}    id
    Log    product_id: ${product_data}[id]
    VAR    ${schema_path}=     ${CURDIR}/../../resources/schemas/post_produtos_201.json
    Validate JsonSchema From File    ${product_data}[raw_response_json]    ${schema_path}


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
    # Create product and register (this already creates and registers a product)
    ${product_data}    Create And Register New Product
    ${token}    Set Variable    ${user_data}[token]
    VAR    &{headers}        Authorization=${token}    Content-Type=application/json
    # Generate a fresh new product data with the **same name** as before
    # To test duplicate, we need the same name. So reuse the name from ${product_data}
    ${duplicate_product_data}    Generate And Save Random Product Data
    Set To Dictionary    ${duplicate_product_data}    nome=${product_data}[nome]
    # Try to create the duplicate product
    ${second_response}    Post new product    ${duplicate_product_data}    ${headers}
    Status Should Be    400    ${second_response}
    Dictionary Should Contain Key    ${second_response.json()}    message
    Should Be Equal    ${second_response.json()}[message]    Já existe produto com esse nome
    # Contract validation
    VAR    ${schema_path}     ${CURDIR}/../../resources/schemas/post_produtos_400.json
    Validate JsonSchema From File    ${second_response.text}    ${schema_path}
    Log    Error message: ${second_response.json()}[message]


Create New Product - Access Denied for Non-Admin User
    [Documentation]    Verify that a non-admin user cannot create a product and receives a 403 response.
    [Tags]             negative
    # Create a non-admin user and login to get token
    ${not_admin_user}    Create New User as Admin False
    ${response}    Login User    ${not_admin_user}[email]    ${not_admin_user}[password]
    ${token}    Set Variable    ${response.json()}[authorization]
    &{headers}    Create Dictionary    Authorization=${token}    Content-Type=application/json
    # Generate product data (reusable) and attempt to create product
    ${product_data}    Generate And Save Random Product Data
    ${response}    Post new product    ${product_data}    ${headers}
    # Verify 403 Forbidden response and error message
    Status Should Be    403    ${response}
    Should Be Equal    ${response.json()}[message]    Rota exclusiva para administradores
    # Validate error response schema
    Validate JsonSchema From File    ${response.text}    ${CURDIR}/../../resources/schemas/post_produtos_403.json
