*** Settings ***
Documentation       Imports utility libraries for api operations, fake data generation, and JSON handling

Library             RequestsLibrary
Library             JSONLibrary
Library             Collections
Library             OperatingSystem
Library             FakerLibrary
Resource            ../resources/variables/variable.resource
Resource            ../resources/keywords/action_keywords.resource
Resource            ../resources/keywords/utils.resource
Resource            ../resources/controller/get_usuarios.resource
Resource            ../resources/controller/post_usuarios.resource
Resource            ../resources/controller/post_login.resource
Resource            ../resources/controller/put_usuarios.resource
Resource            ../resources/controller/delete_usuarios.resource
