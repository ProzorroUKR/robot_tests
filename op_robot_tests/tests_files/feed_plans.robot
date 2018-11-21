*** Settings ***
Resource        base_keywords.robot
Suite Setup     Test Suite Setup
Suite Teardown  Test Suite Teardown


*** Variables ***
${RESOURCE}             plans
@{USED_ROLES}           viewer
${FEED_ITEMS_NUMBER}    10

*** Test Cases ***
Можливість переглянути плани
  [Tags]   ${USERS.users['${viewer}'].broker}: Читання планів
  ...      viewer
  ...      ${USERS.users['${viewer}'].broker}
  ...      plan_feed
  ...      critical
  Можливість прочитати плани для користувача ${viewer}
