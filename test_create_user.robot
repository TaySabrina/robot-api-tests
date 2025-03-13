*** Settings ***
Library     RequestsLibrary
Library     FakerLibrary
Library     OperatingSystem
Library     JSONLibrary
Resource    variable.resource

*** Variables ***
${VAR_FILE}     user_data.json


*** Test Cases ***
Create New User
    ${nome}         FakerLibrary.Name
    ${email}        FakerLibrary.Email
    ${password}     FakerLibrary.Password

    ${data}    Create Dictionary
    ...    nome=${nome}
    ...    email=${email}
    ...    password=${password}
    ...    administrador=true

    ${response}    POST
    ...    ${BASE_URL}/usuarios
    ...    json=${data}
    ...    headers=${HEADERS}

    Should Be Equal As Strings    ${response.status_code}    201
    Should Contain    ${response.json()}    message
    Should Be Equal As Strings    ${response.json()}[message]    Cadastro realizado com sucesso


    # Save the data in JSON format
    ${user_data} =    Create Dictionary    email=${email}    password=${password}
    ${user_data_str} =    Evaluate    json.dumps(${user_data})    # Convert to JSON string
    Create File    ${VAR_FILE}    ${user_data_str}    encoding=UTF-8  # Save as JSON string


