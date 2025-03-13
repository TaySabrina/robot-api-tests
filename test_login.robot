*** Settings ***
Library     RequestsLibrary
Library     OperatingSystem
Library     JSONLibrary
Library     Collections
Variables   user_data.json
Resource    variable.resource


*** Test Cases ***
Login
    # Read data from json file
    ${data} =    Get File    user_data.json    encoding=UTF-8
    ${user_data} =    Evaluate    ${data}

    # Access the values from the dictionary using the Collections library
    ${email} =    Get From Dictionary    ${user_data}    email
    ${password} =    Get From Dictionary    ${user_data}    password

    ${data}     Create Dictionary
    ...    email=${email}  
    ...    password=${password}

    ${response}    POST
    ...    ${BASE_URL}/login
    ...    json=${data}
    ...    headers=${HEADERS}

    Should Be Equal As Strings    ${response.status_code}    200
    Should Contain    ${response.json()}    message
