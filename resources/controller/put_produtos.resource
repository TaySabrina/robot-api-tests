*** Settings ***
Documentation       Test suite for updating products in the ServeRest API
Resource            ../../libs/libraries.resource

*** Keywords ***
Put Product By Id
    [Arguments]    ${product_id}    ${updated_product_data}    ${headers}
    ${response}=    PUT    ${BASE_URL}/produtos/${product_id}
    ...    json=${updated_product_data}
    ...    headers=${headers}
    ...    expected_status=any
    RETURN    ${response}
