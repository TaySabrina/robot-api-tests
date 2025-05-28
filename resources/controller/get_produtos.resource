*** Settings ***
Documentation       Provides keywords for making HTTP requests to the ServeRest API
Resource            ../../libs/libraries.resource


*** Keywords ***
Get Products
    [Documentation]    Retrieves product details from the ServeRest API, either by ID or all products.
    [Arguments]    ${headers}    ${product_id}=${EMPTY}    ${params}=${NONE}
    # Define URL based on product ID presence
    ${url}    Set Variable If    "${product_id}" != "${EMPTY}"    ${BASE_URL}/produtos/${product_id}    ${BASE_URL}/produtos
    # Use query parameters only when not fetching by specific ID
    ${use_params}    Set Variable If    "${product_id}" == "${EMPTY}"    ${params}    ${NONE}
    ${response}    GET    ${url}    
    ...    headers=${headers}    
    ...    params=${use_params}
    ...    expected_status=any
    
    RETURN    ${response}