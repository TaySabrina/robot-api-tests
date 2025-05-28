*** Settings ***
Documentation       Test suite for updating products in the ServeRest API
Resource            ../../libs/libraries.resource
Test Tags           put_produtos      produtos


*** Test Cases ***
Update Product - Success
    [Documentation]    Updates an existing product's name and validates the response against a JSON schema.
    # Create And Register New Product
    ${product_data}    ${token}    Create And Register New Product
    # Set headers for the PUT request
    # The token is used for authorization in the request headers.
    VAR    &{HEADERS}    Authorization=${token}    Content-Type=application/json
    VAR   ${product_id}    ${product_data}[id]
    # Generate a new product name using Faker
    ${new_product_name}    FakerLibrary.Company
    # Create a copy of the original product data to modify
    &{updated_product}    Copy Dictionary    ${product_data}
    # Remove the 'id' and 'raw_response_json' fields from the payload to avoid API error (400 Bad Request).
    Remove From Dictionary    ${updated_product}    id
    Remove From Dictionary    ${updated_product}    raw_response_json
    # Update the name field with a new value
    Set To Dictionary    ${updated_product}    nome=${new_product_name}
    Log    ${updated_product}
    ${response}    Put Product By Id   ${product_id}    ${updated_product}    ${HEADERS}
    Status Should Be    200    ${response}
    # Contract validation for 200 response
    VAR    ${schema_path}=    ${CURDIR}/../../resources/schemas/put_produtos_200.json
    Validate JsonSchema From File    ${response.text}    ${schema_path}
    Log    PUT Status Code: ${response.status_code}
    # Validate that the updated product data matches the expected values
    ${get_response}    Get Product By Id    ${product_id}    ${HEADERS}
    Should Be Equal As Strings    ${get_response.json()}[nome]    ${new_product_name}
    Log    Validation via GET: name successfully updated to ${new_product_name}

Update Product With Duplicate Name - Fail
    [Documentation]    Attempts to update a product with a duplicate name, expects 400 and validates error schema.
    [Tags]    negative
    # Create first product
    ${product1_data}    ${token}    Create And Register New Product
    # Create second product with a different random name
    ${product2_data}    Create And Register New Product    return_token=${False}
    # Extract second product name and first product id
    ${duplicate_name}    Get From Dictionary    ${product2_data}    nome
    ${product1_id}    Get From Dictionary    ${product1_data}    id
    # Prepare updated data for first product with name from second product (duplicate)
    &{updated_product}    Copy Dictionary    ${product1_data}
    Remove From Dictionary    ${updated_product}    id
    Remove From Dictionary    ${updated_product}    raw_response_json
    Set To Dictionary    ${updated_product}    nome=${duplicate_name}
    # Prepare headers
    VAR    &{headers}=    Authorization=${token}    Content-Type=application/json
    # Attempt to update first product with duplicate name
    ${response}    Put Product By Id    ${product1_id}    ${updated_product}    ${headers}
    # Validate 400 status
    Status Should Be    400    ${response}
    # Contract validation for 400 response
    VAR    ${schema_path}=    ${CURDIR}/../../resources/schemas/put_produtos_400.json
    Validate JsonSchema From File    ${response.text}    ${schema_path}

Update Product - Access Denied for Non-Admin User
    [Documentation]    Validate that non-admin user receives 403 when trying to update a product
    [Tags]    negative
    # First create a product with admin user to have something to update
    ${product_data}    Create And Register New Product    return_token=${False}
    ${product_id}      Get From Dictionary    ${product_data}    id
    # Create non-admin user
    ${non_admin_user}    Create New User as Admin False
    # Login with non-admin user
    VAR    &{login_headers}    Content-Type=application/json
    VAR    &{login_payload}    email=${non_admin_user}[email]    password=${non_admin_user}[password]
    ${login_response}    Post Login    ${login_payload}    ${login_headers}
    Status Should Be    200    ${login_response}
    # Extract token from login response
    VAR    ${non_admin_token}    ${login_response.json()}[authorization]
    VAR    &{headers}    Authorization=${non_admin_token}    Content-Type=application/json
    # Prepare updated product data
    ${updated_product_data}    Generate And Save Random Product Data
    # Attempt to update product with non-admin user
    ${response}    Put Product By Id    ${product_id}    ${updated_product_data}    ${headers}
    Status Should Be    403    ${response}  
    # Validate response message
    Should Be Equal    ${response.json()}[message]    Rota exclusiva para administradores
    # Contract validation for 403 response
    VAR    ${schema_path}=    ${CURDIR}/../../resources/schemas/put_produtos_403.json
    Validate JsonSchema From File    ${response.text}    ${schema_path}
    Log    Non-admin PUT access properly blocked: ${response.json()}    