*** Settings ***
Resource    base_keywords.robot
Suite Setup     Test Suite Setup
Suite Teardown  Test Suite Teardown Framework


*** Variables ***
@{USED_ROLES}   tender_owner  viewer  provider  provider1


*** Test Cases ***
Можливість створити кваліфікацію
  [Tags]   ${USERS.users['${tender_owner}'].broker}: Оголошення кваліфікації
  ...      tender_owner
  ...      ${USERS.users['${tender_owner}'].broker}
  ...      create_qualification
  ...      critical
  [Teardown]  Оновити QUALIFICATION_LAST_MODIFICATION_DATE
  Можливість створити кваліфікацію


Можливість знайти кваліфікацію по ідентифікатору
  [Tags]   ${USERS.users['${viewer}'].broker}: Пошук кваліфікації
  ...      viewer  tender_owner
  ...      ${USERS.users['${viewer}'].broker}  ${USERS.users['${tender_owner}'].broker}
  ...      find_qualification
  ...      critical
  Можливість знайти кваліфікацію по ідентифікатору