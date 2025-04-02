*** Settings ***
Documentation    Top-level test suite for user management and authentication in the ServeRest API.
Resource    ../libs/libraries_api.resource
Resource    ../libs/libraries_common.resource
Resource    ../resources/keywords/api_keywords.robot
Resource    ../resources/keywords/user_keywords.robot
Resource    ../resources/variables/variable.resource
Library     OperatingSystem
Suite Setup    Log    Starting user management and authentication suite
Suite Teardown    Log    User management and authentication suite completed
