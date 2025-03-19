*** Settings ***
Library     RequestsLibrary


*** Variables ***
${BASE_URL}     https://serverest.dev
&{HEADERS}      Content-Type=application/json


*** Test Cases ***
Login com Usuário Criado
    VAR    &{data}
    ...    email=tayse@email.com
    ...    password=123456

    ${response}    POST
    ...    ${BASE_URL}/login
    ...    json=${data}
    ...    headers=&{HEADERS}

    Should Be Equal As Strings    ${response.status_code}    200
    Should Contain    ${response.json()}    message
