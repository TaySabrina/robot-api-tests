*** Settings ***
Documentation    Imports utility libraries for api operations, fake data generation, and JSON handling
Library          RequestsLibrary
Library          JSONLibrary
Library          Collections
Library          OperatingSystem
Library          FakerLibrary
Resource         ../resources/variables/variable.resource
Resource         ../resources/keywords/api_keywords.resource
Resource         ../resources/keywords/user_keywords.resource

