*** Settings ***
Resource    base_keywords.robot
Suite Setup     Test Suite Setup
Suite Teardown  Test Suite Teardown Framework


*** Variables ***
@{USED_ROLES}   tender_owner  viewer  provider  provider1


*** Test Cases ***
Можливість створити фреймворк
  [Tags]   ${USERS.users['${tender_owner}'].broker}: Оголошення фреймворку
  ...      tender_owner
  ...      ${USERS.users['${tender_owner}'].broker}
  ...      create_framework
  ...      critical
  Можливість створити фреймворк
  Оновити QUALIFICATION_LAST_MODIFICATION_DATE
  Створити артефакт framework


Можливість знайти фреймворк по ідентифікатору
  [Tags]   ${USERS.users['${viewer}'].broker}: Пошук фреймворку
  ...      viewer  tender_owner
  ...      ${USERS.users['${viewer}'].broker}  ${USERS.users['${tender_owner}'].broker}
  ...      find_framework
  ...      critical
  Завантажити дані про фреймворк
  FOR  ${username}  IN  @{USED_ROLES}
    Run As  ${${username}}  Пошук фреймворку по ідентифікатору  ${QUALIFICATION['QUALIFICATION_UAID']}
  END


Відображення заголовку фреймворку
  [Tags]   ${USERS.users['${viewer}'].broker}: Відображення основних даних фреймворку
  ...      viewer
  ...      ${USERS.users['${viewer}'].broker}
  ...      framework_view  level1
  ...      critical
#  [Setup]  Дочекатись синхронізації з майданчиком  ${viewer}
  Звірити відображення поля title фреймворку для користувача ${viewer}


Відображення опису фреймворку
    [Tags]   ${USERS.users['${viewer}'].broker}: Відображення основних даних фреймворку
  ...      viewer
  ...      ${USERS.users['${viewer}'].broker}
  ...      framework_view  level2
  ...      non-critical
  Звірити відображення поля description фреймворку для користувача ${viewer}


Відображення імені замовника фреймворку
  [Tags]   ${USERS.users['${viewer}'].broker}: Відображення основних даних фреймворку
  ...      viewer
  ...      ${USERS.users['${viewer}'].broker}
  ...      framework_view  level2
  ...      critical
  Звірити відображення поля procuringEntity.name фреймворку для користувача ${viewer}


Відображення типу оголошеного фреймворку
  [Tags]   ${USERS.users['${viewer}'].broker}: Відображення основних даних фреймворку
  ...      viewer
  ...      ${USERS.users['${viewer}'].broker}
  ...      open_framework_view  level2
  ...      non-critical
  Звірити відображення поля frameworkType фреймворку для усіх користувачів


Відображення закінчення періоду фреймворку
  [Tags]   ${USERS.users['${viewer}'].broker}: Відображення основних даних фреймворку
  ...      viewer
  ...      ${USERS.users['${viewer}'].broker}
  ...      framework_view  level2
  ...      critical
  Звірити відображення поля qualificationPeriod.endDate фреймворку для усіх користувачів


Відображення схеми класифікації номенклатур фреймворку
  [Tags]   ${USERS.users['${viewer}'].broker}: Відображення номенклатури фреймворку
  ...      viewer
  ...      ${USERS.users['${viewer}'].broker}
  ...      framework_view
  ...      non-critical
  Звірити відображення поля classification.scheme фреймворку для користувача ${viewer}


Відображення ідентифікатора класифікації номенклатур фреймворку
  [Tags]   ${USERS.users['${viewer}'].broker}: Відображення номенклатури фреймворку
  ...      viewer
  ...      ${USERS.users['${viewer}'].broker}
  ...      framework_view
  ...      non-critical
  Звірити відображення поля classification.id фреймворку для користувача ${viewer}


Відображення опису класифікації номенклатур фреймворку
  [Tags]   ${USERS.users['${viewer}'].broker}: Відображення номенклатури фреймворку
  ...      viewer
  ...      ${USERS.users['${viewer}'].broker}
  ...      framework_view
  ...      non-critical
  Звірити відображення поля classification.description фреймворку для користувача ${viewer}


Можливість завантажити документ у фреймворк
  [Tags]   ${USERS.users['${tender_owner}'].broker}: Завантажити документ у кваліфікацію
  ...      tender_owner
  ...      ${USERS.users['${tender_owner}'].broker}
  ...      add_doc_to_framework
  ...      critical
  [Teardown]  Оновити QUALIFICATION_LAST_MODIFICATION_DATE
   ${file_path}  ${file_name}  ${file_content}=  create_fake_doc
   Run As  ${tender_owner}  Завантажити документ у фреймворк  ${file_path}
   ${framework_doc}=  Create Dictionary
   ...    doc_name=${file_name}
   ...    doc_content=${file_content}
   Set To Dictionary   ${USERS.users['${tender_owner}']}  framework_document=${framework_doc}
   Remove File  ${file_path}


Відображення вмісту документації до фреймворку
  [Tags]   ${USERS.users['${viewer}'].broker}: Відображення документації
  ...      viewer
  ...      ${USERS.users['${viewer}'].broker}
  ...      add_doc_to_framework
  Звірити відображення вмісту документа ${USERS.users['${tender_owner}']['documents']['data']} до фреймворку з ${USERS.users['${tender_owner}']['framework_document']['doc_content']} для користувача ${viewer}


Можливість активувати фреймворк
  [Tags]   ${USERS.users['${tender_owner}'].broker}: Процес кваліфікації
  ...      tender_owner
  ...      ${USERS.users['${tender_owner}'].broker}
  ...      activate_framework  level1
  ...      critical
  [Teardown]  Оновити QUALIFICATION_LAST_MODIFICATION_DATE
  Run As  ${tender_owner}  Aктивувати фреймворк


Відображення початку періоду уточнення фреймворку
  [Tags]   ${USERS.users['${viewer}'].broker}: Відображення номенклатури фреймворку
  ...      viewer
  ...      ${USERS.users['${viewer}'].broker}
  ...      framework_view
  ...      non-critical
  Звірити наявність поля enquiryPeriod.startDate фреймворку для усіх користувачів


Відображення закінчення періоду уточнення фреймворку
  [Tags]   ${USERS.users['${viewer}'].broker}: Відображення номенклатури фреймворку
  ...      viewer
  ...      ${USERS.users['${viewer}'].broker}
  ...      framework_view
  ...      non-critical
  Звірити наявність поля enquiryPeriod.endDate фреймворку для усіх користувачів


Відображення дати початку періоду блокування перед початком кваліфікації:
  [Tags]   ${USERS.users['${viewer}'].broker}: Відображення номенклатури фреймворку
  ...      viewer
  ...      ${USERS.users['${viewer}'].broker}
  ...      framework_view
  ...      non-critical
  Звірити наявність поля qualificationPeriod.startDate фреймворку для усіх користувачів


Відображення дати закінчення періоду блокування кваліфікації:
  [Tags]   ${USERS.users['${viewer}'].broker}: Відображення номенклатури фреймворку
  ...      viewer
  ...      ${USERS.users['${viewer}'].broker}
  ...      framework_view
  ...      non-critical
  Звірити наявність поля qualificationPeriod.endDate фреймворку для усіх користувачів


Відображення дати початку періоду подання заявки
  [Tags]   ${USERS.users['${viewer}'].broker}: Відображення номенклатури фреймворку
  ...      viewer
  ...      ${USERS.users['${viewer}'].broker}
  ...      framework_view
  ...      non-critical
  Звірити наявність поля period.startDate фреймворку для усіх користувачів


Відображення дати закінчення періоду подання заявки
  [Tags]   ${USERS.users['${viewer}'].broker}: Відображення номенклатури фреймворку
  ...      viewer
  ...      ${USERS.users['${viewer}'].broker}
  ...      framework_view
  ...      non-critical
  Звірити наявність поля period.endDate фреймворку для усіх користувачів


Можливість змінити значеня поля телефон для замовника
  [Tags]   ${USERS.users['${tender_owner}'].broker}: Редагування фреймворку
  ...      tender_owner
  ...      ${USERS.users['${tender_owner}'].broker}
  ...      modify_framework_contactPoint_phone
  ...      critical
  [Teardown]  Оновити QUALIFICATION_LAST_MODIFICATION_DATE
  ${field_name}=  Set Variable    telephone
  ${patch_data}=  get_payload_for_patching_framework  ${field_name}
  Set to dictionary  ${USERS.users['${tender_owner}'].initial_data.data.procuringEntity.contactPoint}  telephone=${patch_data.data.procuringEntity.contactPoint.telephone}
  Run As  ${tender_owner}  Редагувати фреймворк  ${patch_data}


Відображення змінене поле телефон у фреймворку
  [Tags]   ${USERS.users['${viewer}'].broker}: Відображення основних даних фреймворку
  ...      tender_owner
  ...      ${USERS.users['${viewer}'].broker}
  ...      open_framework_view  level2
  ...      non-critical
  Звірити відображення поля procuringEntity.contactPoint.telephone фреймворку для користувача ${tender_owner}


Можливість змінити значеня поля назва для замовника
  [Tags]   ${USERS.users['${tender_owner}'].broker}: Редагування фреймворку
  ...      tender_owner
  ...      ${USERS.users['${tender_owner}'].broker}
  ...      modify_framework_contactPoint_name
  ...      critical
  [Teardown]  Оновити QUALIFICATION_LAST_MODIFICATION_DATE
  ${field_name}=  Set Variable    name
  ${patch_data}=  get_payload_for_patching_framework  ${field_name}
  Set to dictionary  ${USERS.users['${tender_owner}'].initial_data.data.procuringEntity.contactPoint}  name=${patch_data.data.procuringEntity.contactPoint.name}
  Run As  ${tender_owner}  Редагувати фреймворк  ${patch_data}


Відображення змінене поле назва у фреймворку
  [Tags]   ${USERS.users['${viewer}'].broker}: Відображення основних даних фреймворку
  ...      tender_owner
  ...      ${USERS.users['${viewer}'].broker}
  ...      open_framework_view  level2
  ...      non-critical
  Звірити відображення поля procuringEntity.contactPoint.name фреймворку для користувача ${tender_owner}


Можливість змінити значеня поля пошта для замовника
  [Tags]   ${USERS.users['${tender_owner}'].broker}: Редагування фреймворку
  ...      tender_owner
  ...      ${USERS.users['${tender_owner}'].broker}
  ...      modify_framework_contactPoint_email
  ...      critical
  [Teardown]  Оновити QUALIFICATION_LAST_MODIFICATION_DATE
  ${field_name}=  Set Variable    email
  ${patch_data}=  get_payload_for_patching_framework  ${field_name}
  Set to dictionary  ${USERS.users['${tender_owner}'].initial_data.data.procuringEntity.contactPoint}  email=${patch_data.data.procuringEntity.contactPoint.email}
  Run As  ${tender_owner}  Редагувати фреймворк  ${patch_data}


Відображення змінене поле пошта у фреймворку
  [Tags]   ${USERS.users['${viewer}'].broker}: Відображення основних даних фреймворку
  ...      tender_owner
  ...      ${USERS.users['${viewer}'].broker}
  ...      open_framework_view  level2
  ...      non-critical
  Звірити відображення поля procuringEntity.contactPoint.email фреймворку для користувача ${tender_owner}


Можливість змінити значеня поля опис для замовника
  [Tags]   ${USERS.users['${tender_owner}'].broker}: Редагування фреймворку
  ...      tender_owner
  ...      ${USERS.users['${tender_owner}'].broker}
  ...      modify_framework_description
  ...      critical
  [Teardown]  Оновити QUALIFICATION_LAST_MODIFICATION_DATE
  ${patch_data}=  get_description_for_patching_framework
  Set to dictionary  ${USERS.users['${tender_owner}'].initial_data.data}  description=${patch_data.data.description}
  Run As  ${tender_owner}  Редагувати фреймворк  ${patch_data}


Відображення змінене поле опис у фреймворку
  [Tags]   ${USERS.users['${viewer}'].broker}: Відображення основних даних фреймворку
  ...      tender_owner
  ...      ${USERS.users['${viewer}'].broker}
  ...      open_framework_view  level2
  ...      non-critical
  Звірити відображення поля description фреймворку для користувача ${tender_owner}


Можливість зареєструвати заявку
  [Tags]   ${USERS.users['${tender_owner}'].broker}: Реєстрація заявки
  ...      tender_owner
  ...      ${USERS.users['${tender_owner}'].broker}
  ...      registration_submission
  ...      critical
  [Teardown]  Оновити QUALIFICATION_LAST_MODIFICATION_DATE
  Можливість зареєструвати заявку


Можливість завантажити документ по заявці
  [Tags]   ${USERS.users['${tender_owner}'].broker}: Завантажити документ у заявці
  ...      tender_owner
  ...      ${USERS.users['${tender_owner}'].broker}
  ...      add_doc_to_submission
  ...      critical
  [Teardown]  Оновити QUALIFICATION_LAST_MODIFICATION_DATE
   ${file_path}  ${file_name}  ${file_content}=  create_fake_doc
   Run As  ${tender_owner}  Завантажити документ по заявці  ${file_path}
   ${submission_doc}=  Create Dictionary
   ...    doc_name=${file_name}
   ...    doc_content=${file_content}
   Set To Dictionary   ${USERS.users['${tender_owner}']}  submission_document=${submission_doc}
   Remove File  ${file_path}


Відображення вмісту документації до фреймворку
  [Tags]   ${USERS.users['${viewer}'].broker}: Відображення документації
  ...      viewer
  ...      ${USERS.users['${viewer}'].broker}
  ...      add_doc_to_submission1
  Звірити відображення вмісту документа ${USERS.users['${tender_owner}']['documents']['data']} до фреймворку з ${USERS.users['${tender_owner}']['submission_document']['doc_content']} для користувача ${viewer}

