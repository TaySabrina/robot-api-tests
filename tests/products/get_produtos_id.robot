*** Settings ***
Documentation       Test suite for retrieving product details by ID in the ServeRest API
Resource            ../../libs/libraries.resource
Suite Setup         Create And Register New User        
Test Tags           get_products_id    products

*** Test Cases ***
GET Product By ID
   [Documentation]    Create a product and validate that it can be retrieved by its ID
    ${product_data}    Create And Register New Product
    VAR    ${token}    ${user_data}[token]
    VAR    &{headers}=    Authorization=${token}    Content-Type=application/json
    ${response}    Get product by id    ${product_data}[id]    ${headers}
    Status Should Be    200    ${response}
    Should Be Equal    ${response.json()}[nome]         ${product_data}[nome]
    Should Be Equal    ${response.json()}[descricao]    ${product_data}[descricao]
    Should Be Equal    ${response.json()}[preco]        ${product_data}[preco]
    Should Be Equal    ${response.json()}[quantidade]   ${product_data}[quantidade]
    # Contract validation
    VAR    ${schema_path}=    ${CURDIR}/../../resources/schemas/get_produtos_id_200.json
    Validate JsonSchema From File    ${response.text}    ${schema_path}
    Log    GET response validated successfully: ${response.json()}

GET Product By ID - Product Not Found
    [Documentation]    Verify that a 400 status and "Produto não encontrado" message are returned for an invalid product ID
    [Tags]    negative
    VAR    ${token}      ${user_data}[token]
    VAR    &{headers}       Authorization=${token}    Content-Type=application/json
    # Use an invalid/non-existent product ID
    VAR    ${invalid_id}   0000000000000000
    ${response}     Get product by id    ${invalid_id}    ${headers}
    # Assert that the response status code is 400 (Bad Request)
    Status Should Be    400    ${response}
    # Assert that the response contains the expected error message
    Should Be Equal    ${response.json()}[message]    Produto não encontrado
     # Contract validation
    VAR    ${schema_path}=    ${CURDIR}/../../resources/schemas/get_produtos_id_400.json
    Validate JsonSchema From File    ${response.text}    ${schema_path}
    Log    Response 400 with expected message: ${response.json()}

