*** Settings ***
Library     RequestsLibrary
Library     FakerLibrary    locale=pt_BR
Library     Collections


*** Variables ***
${BASE_URL}     https://serverest.dev
&{HEADERS}      Content-Type=application/json


*** Test Cases ***
Create new user
    ${nome}    FakerLibrary.Name
    ${user_email}    FakerLibrary.Email
    ${user_password}    FakerLibrary.Password
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

    ${user_id}    Get From Dictionary    ${response.json()}    _id

    Set Global Variable    ${user_email}    ${user_email}
    Set Global Variable    ${user_password}    ${user_password}
    Set Global Variable    ${user_id}    ${user_id}

    Log To Console    \n Usuário Criado com Sucesso!
    Log To Console    ID: ${user_id}
    Log To Console    Email: ${user_email}
    Log To Console    Resposta: ${response.json()}[message]

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
