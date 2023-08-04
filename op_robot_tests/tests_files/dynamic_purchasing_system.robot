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
  Можливість створити кваліфікацію
  Оновити QUALIFICATION_LAST_MODIFICATION_DATE
  Створити артефакт framework


Можливість знайти кваліфікацію по ідентифікатору
  [Tags]   ${USERS.users['${viewer}'].broker}: Пошук кваліфікації
  ...      viewer  tender_owner
  ...      ${USERS.users['${viewer}'].broker}  ${USERS.users['${tender_owner}'].broker}
  ...      find_qualification
  ...      critical
  Завантажити дані про кваліфікацію
  FOR  ${username}  IN  @{USED_ROLES}
    Run As  ${${username}}  Пошук кваліфікаціi по ідентифікатору  ${QUALIFICATION['QUALIFICATION_UAID']}
  END


Відображення заголовку кваліфікаціi
  [Tags]   ${USERS.users['${viewer}'].broker}: Відображення основних даних кваліфікаціi
  ...      viewer
  ...      ${USERS.users['${viewer}'].broker}
  ...      qualification_view  level1
  ...      critical
#  [Setup]  Дочекатись синхронізації з майданчиком  ${viewer}
  Звірити відображення поля title кваліфікаціi для користувача ${viewer}


Відображення опису кваліфікаціi