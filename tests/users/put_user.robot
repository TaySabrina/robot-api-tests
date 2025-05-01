*** Settings ***
Documentation       Test suite for creating and registering users in the ServeRest API
Resource            ../../libs/libraries.resource
Suite Setup         Run Keywords
...                 Create And Register New User
Test Tags           put_usuarios    usuarios

*** Test Cases ***

Update User By Id
    [Documentation]    Updates the name of a previously created user, reusing the original user_data and modifying only the name field.
    ${user_id}       Set Variable    ${user_data}[id]
    ${new_name}      FakerLibrary.Name
    # Create a copy of the original user data to modify
    &{updated_user}  Copy Dictionary    ${user_data}
    # Remove the 'id' field from the payload to avoid API error (400 Bad Request).
    # The API does not expect 'id' in the request body because it is passed in the URL.
    Remove From Dictionary    ${updated_user}    id
    # Update the name field with a new value
    Set To Dictionary    ${updated_user}    nome=${new_name}
    ${response}      Put user by id    ${user_id}    ${updated_user}
    Check successful response    ${response}    200    Registro alterado com sucesso
    Log        PUT Status Code: ${response.status_code}

Update User Without Providing Name
    [Documentation]    Attempts to update a user without providing the 'nome' field, expecting a validation error.
    [Tags]             negative    
    # Create a copy of the original user data to update
    ${update_user_data}    Copy Dictionary    ${user_data}
    # Remove 'nome' and 'id' from the update data
    Remove From Dictionary    ${update_user_data}    nome
    Remove From Dictionary    ${update_user_data}    id
    # Make the PUT request to update the user
    ${response}    Put user by id    ${user_data}[id]    ${update_user_data}
    Should Be Equal As Integers    ${response.status_code}    400    
    Should Contain    ${response.json()}[nome]    nome é obrigatório
    Log            PUT Status Code: ${response.status_code}