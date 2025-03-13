*** Settings ***
Library     RequestsLibrary
Resource    variable.resource


*** Variables ***
${BASE_URL}     https://serverest.dev
&{HEADERS}      Content-Type=application/json


*** Test Cases ***
Login
    ${data}    Create Dictionary
    ...    email=tayse@email.com
    ...    password=${PASSWORD}

    ${response}    POST
    ...    ${BASE_URL}/login
    ...    json=${data}
    ...    headers=&{HEADERS}

    Should Be Equal As Strings    ${response.status_code}    200
    Should Contain    ${response.json()}    message