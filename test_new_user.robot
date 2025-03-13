*** Settings ***
Library     RequestsLibrary


*** Variables ***
${BASE_URL}     https://serverest.dev
&{HEADERS}      Content-Type=application/json


*** Test Cases ***
Create new user
    ${nome}    Set Variable    Tayse Sabrina
    ${user_email}    Set Variable    tayse@email.com
    ${user_password}    Set Variable    123456
    ${administrador}    Set Variable    true

    ${data}    Create Dictionary
    ...    nome=${nome}
    ...    email=${user_email}
    ...    password=${user_password}
    ...    administrador=${administrador}

    ${response}    POST
    ...    ${BASE_URL}/usuarios
    ...    json=${data}
    ...    headers=${HEADERS}

    Should Be Equal As Strings    ${response.status_code}    201
    Should Contain    ${response.json()}    message
    Should Be Equal As Strings    ${response.json()}[message]    Cadastro realizado com sucesso

    ${user_id}    Set Variable    ${response.json()}[_id]

    Set Global Variable    ${user_email}
    Set Global Variable    ${user_password}
    Set Global Variable    ${user_id}

    Log To Console    \n Usuário Criado com Sucesso!
    Log To Console    ID: ${user_id}
    Log To Console    Email: ${user_email}
    Log To Console    Resposta: ${response.json()}

Get new user by _id
    ${response}    GET
    ...    ${BASE_URL}/usuarios/${user_id}
    ...    headers=${HEADERS}

    Should Be Equal As Strings    ${response.status_code}    200
    Should Contain    ${response.json()}    _id
    Should Be Equal As Strings    ${response.json()}[_id]    ${user_id}
    Should Be Equal As Strings    ${response.json()}[email]    ${user_email}

    Log To Console    \n Usuário encontrado com sucesso!
    Log To Console    Resposta: ${response.json()}

New user login
    ${data}    Create Dictionary
    ...    email=${user_email}
    ...    password=${user_password}

    ${response}    POST
    ...    ${BASE_URL}/login
    ...    json=${data}
    ...    headers=${HEADERS}

    Should Be Equal As Strings    ${response.status_code}    200
    Should Contain    ${response.json()}    message

    Log To Console    \n Login realizado com sucesso!
    Log To Console    Resposta: ${response.json()}[message]
