*** Settings ***
Documentation       Provides keywords for making HTTP requests to the ServeRest API
Resource            ../../libs/libraries.resource


*** Keywords ***
Delete Product by Id
    [Documentation]    Deletes a product by sending a DELETE request to /produtos/${product_id}.
    [Arguments]    ${product_id}    ${HEADERS}
    ${response}    DELETE     ${BASE_URL}/produtos/${product_id}
    ...            headers=${HEADERS}
    ...            expected_status=any
    RETURN    ${response}