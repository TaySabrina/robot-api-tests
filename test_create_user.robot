*** Settings ***
Library     RequestsLibrary


*** Variables ***
${BASE_URL}     https://serverest.dev
&{HEADERS}      Content-Type=application/json


*** Test Cases ***
Criar Novo Usuário - Teste Simples
    VAR    &{data}
    ...    nome=Tayse Sabrina
    ...    email=tayse@email.com
    ...    password=123456
    ...    administrador=true

    ${response}    POST
    ...    ${BASE_URL}/usuarios
    ...    json=${data}
    ...    headers=${HEADERS}

    Should Be Equal As Strings    ${response.status_code}    201
    Should Be Equal As Strings    ${response.json()}[message]    Cadastro realizado com sucesso
