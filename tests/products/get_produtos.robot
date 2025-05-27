*** Settings ***
Documentation       Test suite for retrieving product details by ID in the ServeRest API
Resource            ../../libs/libraries.resource
Suite Setup         Create And Register New User        
Test Tags           get_products    products   

*** Test Cases ***
GET All Products - No Filters
    [Documentation]    Create a product and validate that it appears in the list of all products
    ${product_data}    Create And Register New Product
    VAR    ${token}    ${user_data}[token]
    VAR    &{headers}=    Authorization=${token}    Content-Type=application/json
    ${response}    Get Produtos    ${headers}    ${EMPTY}    ${NONE}
    Status Should Be    200    ${response}
    VAR    ${product_id}     ${product_data}[id]
    ${all_products} =    Evaluate    [p for p in ${response.json()['produtos']} if p['_id'] == '${product_id}']
    Length Should Be    ${all_products}    1
    VAR    ${retrieved_product}    ${all_products}[0]
    Should Be Equal    ${retrieved_product}[nome]         ${product_data}[nome]
    Should Be Equal    ${retrieved_product}[descricao]    ${product_data}[descricao]
    Should Be Equal    ${retrieved_product}[preco]        ${product_data}[preco]
    Should Be Equal    ${retrieved_product}[quantidade]   ${product_data}[quantidade]
    Log    All products response validated successfully: ${response.json()}

GET All Products - Filter By Quantity
    [Documentation]    Create a product with quantity=2 and verify API returns only products with quantity = 2
    # Create a new product with quantity 2 (adjust your keyword to accept quantity if needed)
    ${product_data}    Generate And Save Random Product Data
    Set To Dictionary    ${product_data}    quantidade=2
    # Create product with quantity=2
    VAR    ${token}        ${user_data}[token]
    VAR    &{headers}       Authorization=${token}    Content-Type=application/json
    ${response}   Post new product    ${product_data}    ${headers}
    Status Should Be    201    ${response}
    # Request products filtered by quantity=2
    ${response}    Get Produtos    headers=${headers}    product_id=${EMPTY}    params=quantidade=2
    Status Should Be    200    ${response}
    # Check that all products have quantity == 2 using Python all()
    ${all_quantity_2}=    Evaluate    all(p['quantidade'] == 2 for p in ${response.json()}[produtos])
    Should Be True    ${all_quantity_2}
    Log    All returned products have quantity 2: ${response.json()}[produtos]
