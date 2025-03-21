*** Settings ***
Library     RequestsLibrary
Resource    variable.resource


*** Variables ***
${BASE_URL}     https://serverest.dev
&{HEADERS}      Content-Type=application/json


*** Test Cases ***
Create New User
    VAR    &{data}
    ...    nome=Tayse Sabrina
    ...    email=tayse@email.com
    ...    password=${PASSWORD}
    ...    administrador=true

    ${response}    POST
    ...    ${BASE_URL}/usuarios
    ...    json=${data}
    ...    headers=${HEADERS}

    Should Be Equal As Strings    ${response.status_code}    201
    Should Be Equal As Strings    ${response.json()}[message]    Cadastro realizado com sucesso
