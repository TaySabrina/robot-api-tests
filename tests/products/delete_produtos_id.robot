*** Settings ***
Documentation       Test suite for creating and registering produscts in the ServeRest API
Resource            ../../libs/libraries.resource              
Test Tags           delete_products    products

*** Test Cases ***
Delete Product By Id
    [Documentation]    Deletes a previously created product and verifies that the operation was successful.
    ${product_data}    ${token}    Create And Register New Product
    VAR     ${product_id}        ${product_data}[id]
    VAR     &{HEADERS}    Authorization=${token}    Content-Type=application/json
    ${response}      Delete Product by Id    ${product_id}    ${HEADERS}
    Check successful response    ${response}    200    Registro excluído com sucesso
    # Contract validation for 200 response
    VAR    ${schema_path}=    ${CURDIR}/../../resources/schemas/delete_produtos_200.json
    Validate JsonSchema From File    ${response.text}    ${schema_path}
    Log        DELETE Status Code: ${response.status_code}
    # Verify that the product no longer exists by attempting to retrieve it
    ${get_response}   Get product by id    ${product_id}    ${HEADERS}
    Should Be Equal As Integers    ${get_response.status_code}    400
    Should Contain    ${get_response.json()}[message]    Produto não encontrado
   
Delete Product By Id - Unauthorized
    [Documentation]    Attempt to delete a product without authorization token, expect 401 Unauthorized
    [Tags]    negative
    ${product_data}    Create And Register New Product    return_token=${False}
    VAR      ${product_id}    ${product_data}[id]    
    ${response}    Delete Product by Id    ${product_id}    ${HEADERS}
    Status Should Be    401    ${response}
    Should Be Equal    ${response.json()}[message]    Token de acesso ausente, inválido, expirado ou usuário do token não existe mais
    # Contract validation for 401 response
    VAR     ${schema_path}=    ${CURDIR}/../../resources/schemas/delete_produtos_401.json
    Validate JsonSchema From File    ${response.text}    ${schema_path}
    Log        Response message: ${response.json()}[message]

