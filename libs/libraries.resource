*** Settings ***
Documentation       Imports utility libraries for api operations, fake data generation, and JSON handling

#libraries
Library             RequestsLibrary
Library             JSONLibrary
Library             Collections
Library             OperatingSystem
Library             FakerLibrary
Library             JsonValidator
#variables
Resource            ../resources/variables/variable.resource
#keywords
Resource            ../resources/keywords/action_keywords.resource
Resource            ../resources/keywords/utils.resource
#controllers
Resource            ../resources/controller/get_usuarios.resource
Resource            ../resources/controller/post_usuarios.resource
Resource            ../resources/controller/post_login.resource
Resource            ../resources/controller/put_usuarios.resource
Resource            ../resources/controller/delete_usuarios.resource
Resource            ../resources/controller/post_produtos.resource
Resource            ../resources/controller/get_produtos.resource


