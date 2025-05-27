*** Variables ***
${PROJECT_ROOT}             ${CURDIR}/../../    # Adjust based on file location
${DATA_DIR}                 ${PROJECT_ROOT}/data
${BASE_URL}                 https://serverest.dev
${ENDPOINT_USUARIOS}        /usuarios
${ENDPOINT_LOGIN}           /login
${ENDPOINT_PRODUTOS}        /produtos
&{HEADERS}                  Content-Type=application/json
${EXPECTED_STATUS_CODE}     ${EMPTY}
${EXPECTED_MESSAGE}         ${EMPTY}
&{user_data}                nome=None    email=None    password=None    id=None    # Inicializa com valores padrão
${NOT_ADMIN_DATA}           None
