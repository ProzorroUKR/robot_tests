*** Settings ***
Documentation      Test API methods
Library            Selenium2Library
Library            Collections
Library            RequestsLibrary
Resource           mhc_resource.robot
Library            DateTime
Library            String
Library            OperatingSystem
Library            Process
Library            AristaLibrary

*** Variables ***

*** Test Cases ***

Check connection to health with GET method
    [Documentation]  Sends GET HTTP request to /health, HTTP status code 200 expects
    [Tags]  health method
    ${base_url} =  Catenate  http://${BASE_URL}
    log to console  ${base_url}
    Create Session  base  ${base_url}
    ${resp}=  Get Request    base  /api/${API_VERSION}/health
    Log To Console  ${base_url}
    Should Be Equal As Strings  ${resp.status_code}  200
    ${resp_dict}    evaluate  json.loads('''${resp.text}''')    json
    Should Be Equal As Strings  ${resp_dict['method']}  GET
    Should Be Equal As Strings  ${resp_dict['success']}  True

Check content type of health response
    [Documentation]  Checks Content Type header of health response, have to JSON
    [Tags]  health method
    ${base_url} =  Catenate  http://${BASE_URL}
    Create Session  base  ${base_url}
    ${resp}=  Get Request  base  /api/${API_VERSION}/health
    ${content_type}=  Get Variable Value   ${resp.headers['Content-Type']}
    log to console  ${content_type}
    should be equal as strings  ${content_type}  application/json

Check connection to health with HEAD method
    [Documentation]  Sends GET HTTP request to /health, HTTP status code 200 expects
    [Tags]  health method
    ${base_url} =  Catenate  http://${BASE_URL}
    log to console  ${base_url}
    Create Session  base  ${base_url}
    ${resp}=  Head Request  base  /api/${API_VERSION}/health
    log to console  ${resp.status_code}
    Should Be Equal As Strings  ${resp.status_code}  200

Check connection to health with POST method
    [Documentation]  Sends POST HTTP request to /health, HTTP status code 412 expects
    [Tags]  health method
    ${base_url} =  Catenate  http://${BASE_URL}
    log to console  ${base_url}
    Create Session  base  ${base_url}
    ${resp}=  Post Request  base  /api/${API_VERSION}/health
    log to console  ${resp.status_code}
    Should Be Equal As Strings  ${resp.status_code}  412

Check connection to health with PUT method
    [Documentation]  Sends PUT HTTP request to /health, HTTP status code 412 expects
    [Tags]  health method
    ${base_url} =  Catenate  http://${BASE_URL}
    log to console  ${base_url}
    Create Session  base  ${base_url}
    ${resp}=  Put Request  base  /api/${API_VERSION}/health
    log to console  ${resp.status_code}
    Should Be Equal As Strings  ${resp.status_code}  412

Check content type of health response
    [Documentation]  Checks Content Type header of registry response, have to JSON
    [Tags]  registry method
    ${base_url} =  Catenate  http://${BASE_URL}
    Create Session  base  ${base_url}
    ${resp}=  Head Request  base  /api/${API_VERSION}/registry/inn.json
    ${content_type}=  Get Variable Value   ${resp.headers['Content-Type']}
    log to console  ${content_type}
    should be equal as strings  ${content_type}  application/json

Check health response content lenght, expects len of json response greater than 2
    [Documentation]  Checks health response content length
     [Tags]  health method
    ${base_url} =  Catenate  http://${BASE_URL}
    log to console  ${base_url}
    Create Session  base  ${base_url}
    ${resp}=  Get Request  base  /api/${API_VERSION}/health
    ${resp_len}  Get Length  ${resp.text}
    log to console  ${resp_len}
    should be true  ${resp_len} > 2

Check connection to registry without credentials
    [Documentation]  Sends GET HTTP request to /registry/inn.json without any credentials, HTTP status code 403 expects
    [Tags]  registry method
    ${base_url} =  Catenate  http://${BASE_URL}
    Create Session  base  ${base_url}
    ${resp}=  Get Request  base  /api/${API_VERSION}/registry/inn.json
    log to console  ${resp.status_code}
    Should Be Equal As Strings  ${resp.status_code}  403
    ${resp_dict}=  Get variable value   ${resp.text}
    ${dict}    evaluate  json.loads('''${resp_dict}''')    json
    ${dict_type}=  Evaluate    type($dict)
    should be equal as strings  ${dict['status']}  error

Check connection to registry with invalid username
    [Documentation]  Sends GET HTTP request to /registry/inn.json with wrong username, HTTP status code 403 expects
    [Tags]  registry method
    ${wrong_username}=  Set Variable  wrong
    log to console  ${wrong_username}
    ${auth_base_url} =  Catenate  http://${wrong_username}:${PASSWORD}@${BASE_URL}
    Create Session  base  ${auth_base_url}
    ${resp}=  Get Request  base  /api/${API_VERSION}/registry/inn.json
    #log to console  ${resp.text}
    Should Be Equal As Strings  ${resp.status_code}  403

Check connection to registry with invalid password
    [Documentation]  Sends GET HTTP request to /registry/inn.json with wrong password, HTTP status code 403 expects
    [Tags]  registry method
    ${wrong_password}=  Set Variable  wrong
    log to console  ${wrong_password}
    ${auth_base_url} =  Catenate  http://${USERNAME}:${wrong_password}@${BASE_URL}
    Create Session  base  ${auth_base_url}
    ${resp}=  Get Request  base  /api/${API_VERSION}/registry/inn.json
    #log to console  ${resp.text}
    Should Be Equal As Strings  ${resp.status_code}  403

Check connection to registry with valid credentials
    [Documentation]  Sends GET HTTP request to /registry/inn.json with valid credentials, HTTP status code 403 expects
    [Tags]  registry method
    ${auth_base_url} =  Catenate  http://${USERNAME}:${PASSWORD}@${BASE_URL}
    Create Session  base  ${auth_base_url}
    ${resp}=  Get Request  base  /api/${API_VERSION}/registry/inn.json
    #log to console  ${resp.text}
    Should Be Equal As Strings  ${resp.status_code}  200

Check all JSON formats from regisrty
    [Documentation]  Sends GET request for each JSON format with valid credentials, status code 200 expects for each
    [Tags]  registry method
    ${formats}  Create list  atc  inn  inn2atc  atc2inn
    log to console  ${formats}
    ${auth_base_url} =  Catenate  http://${USERNAME}:${PASSWORD}@${BASE_URL}
    : for  ${format}  in  @{formats}
    \    Create Session  base  ${auth_base_url}
    \    ${url} =  Catenate  /api/${API_VERSION}/registry/${format}.json
    \    ${resp} =  Get Request  base  ${url}
    \    Should Be Equal As Strings  ${resp.status_code}  200

Check servers date time
    [Documentation]  Check servers date time
    [Tags]  health method
    ${base_url} =  Catenate  http://${BASE_URL}
    Create Session  base  ${base_url}
    ${resp}=  Head Request  base  /api/${API_VERSION}/health
    ${servers_datetime}=  Get Variable Value   ${resp.headers['Date']}
    ${local_time}=  Get Current Date  UTC
    ${formatted_local_time}=  Convert Date  ${local_time}  %a, %d %b %Y %H:%M:%S %Z
    ${op1}=  Get Substring  ${servers_datetime}  0  -3
    ${op2}=  Convert to String  ${formatted_local_time}
    should be equal as strings  ${op1}  ${op2}

Check registry response content lenght, expects len of json response greater than 2
    [Documentation]  Checks registry response content
    [Tags]  registry method
    ${auth_base_url} =  Catenate  http://${USERNAME}:${PASSWORD}@${BASE_URL}
    Create Session  base  ${auth_base_url}
    ${resp}=  Get Request  base  /api/${API_VERSION}/registry/inn.json
    ${resp_len}  Get Length  ${resp.text}
    log to console  ${resp_len}
    should be true  ${resp_len} > 2

Check registry inn2atc data format, is values in json are lists
    [Documentation]  Checks registry response content
    [Tags]  registry method
    ${auth_base_url} =  Catenate  http://${USERNAME}:${PASSWORD}@${BASE_URL}
    Create Session  base  ${auth_base_url}
    ${resp}=  Get Request  base  /api/${API_VERSION}/registry/inn2atc.json
    ${resp_len}  Get Length  ${resp.text}
    ${resp_dict}    evaluate  json.loads('''${resp.text}''')    json
    ${drug_key}=  Set Variable  ${resp_dict.keys()[1]}
    ${drug_value}=  Get From Dictionary  ${resp_dict}  ${drug_key}
    ${drug_value_type}    Evaluate    type($drug_value)
    should be equal as strings  ${drug_value_type}  <type 'list'>

Check registry atc2inn data format, is values in json are lists
    [Documentation]  Checks registry response content
    [Tags]  registry method
    ${auth_base_url} =  Catenate  http://${USERNAME}:${PASSWORD}@${BASE_URL}
    Create Session  base  ${auth_base_url}
    ${resp}=  Get Request  base  /api/${API_VERSION}/registry/atc2inn.json
    ${resp_len}  Get Length  ${resp.text}
    ${resp_dict}    evaluate  json.loads('''${resp.text}''')    json
    ${drug_key}=  Set Variable  ${resp_dict.keys()[1]}
    ${drug_value}=  Get From Dictionary  ${resp_dict}  ${drug_key}
    ${drug_value_type}    Evaluate    type($drug_value)
    should be equal as strings  ${drug_value_type}  <type 'list'>

Check registry atc data format, is values in json are lists
    [Documentation]  Checks registry response content
    [Tags]  registry method
    ${auth_base_url} =  Catenate  http://${USERNAME}:${PASSWORD}@${BASE_URL}
    Create Session  base  ${auth_base_url}
    ${resp}=  Get Request  base  /api/${API_VERSION}/registry/atc.json
    ${resp_len}  Get Length  ${resp.text}
    ${resp_dict}    evaluate  json.loads('''${resp.text}''')    json
    ${drug_key}=  Set Variable  ${resp_dict.keys()[1]}
    ${drug_value}=  Get From Dictionary  ${resp_dict}  ${drug_key}
    ${drug_value_type}    Evaluate    type($drug_value)
    should be equal as strings  ${drug_value_type}  <type 'unicode'>

Check registry inn data format, is values in json are lists
    [Documentation]  Checks registry response content
    [Tags]  registry method
    ${auth_base_url} =  Catenate  http://${USERNAME}:${PASSWORD}@${BASE_URL}
    Create Session  base  ${auth_base_url}
    ${resp}=  Get Request  base  /api/${API_VERSION}/registry/inn.json
    ${resp_len}  Get Length  ${resp.text}
    ${resp_dict}    evaluate  json.loads('''${resp.text}''')    json
    ${drug_key}=  Set Variable  ${resp_dict.keys()[1]}
    ${drug_value}=  Get From Dictionary  ${resp_dict}  ${drug_key}
    ${drug_value_type}    Evaluate    type($drug_value)
    should be equal as strings  ${drug_value_type}  <type 'unicode'>

Check response from invalid URL parameter, HTTP status code 400 expected
    [Documentation]  Checks invalid parameter URL
    [Tags]  registry method
    ${auth_base_url} =  Catenate  http://${USERNAME}:${PASSWORD}@${BASE_URL}
    Create Session  base  ${auth_base_url}
    ${resp}=  Get Request  base  /api/${API_VERSION}/registry/mnn.json
    Should Be Equal As Strings  ${resp.status_code}  400

*** Keywords ***

