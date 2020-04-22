*** Settings ***
Resource        base_keywords.robot
Suite Setup     Test Suite Setup
Suite Teardown  Test Suite Teardown

*** Variables ***
@{USED_ROLES}       tender_owner  viewer  provider  provider1  provider2
${MOZ_INTEGRATION}  ${False}
${VAT_INCLUDED}     ${True}
${NUMBER_OF_MILESTONES}  ${1}
${ROAD_INDEX}       ${False}
${GMDN_INDEX}       ${False}
${PLAN_TENDER}      ${True}

*** Test Cases ***
Можливість оголосити тендер
  [Tags]   ${USERS.users['${tender_owner}'].broker}: Оголошення тендера
  ...      tender_owner
  ...      ${USERS.users['${tender_owner}'].broker}
  ...      create_tender
  [Teardown]  Оновити LAST_MODIFICATION_DATE
  Можливість оголосити тендер


Можливість знайти тендер по ідентифікатору
  [Tags]   ${USERS.users['${viewer}'].broker}: Пошук тендера
  ...      viewer  tender_owner
  ...      ${USERS.users['${viewer}'].broker}  ${USERS.users['${tender_owner}'].broker}
  ...      find_tender
  [Teardown]  Оновити LAST_MODIFICATION_DATE
  :FOR  ${username}  IN  ${tender_owner}  ${viewer}
  \  Можливість знайти тендер по ідентифікатору для користувача ${username}


Можливість подати пропозицію першим учасником
  [Tags]  ${USERS.users['${provider}'].broker}: Подання пропозиції
  ...     provider
  ...     ${USERS.users['${provider}'].broker}
  ...     make_bid_by_provider
  ...     critical
  [Setup]  Дочекатись дати початку прийому пропозицій  ${provider}  ${TENDER['TENDER_UAID']}
  [Teardown]  Оновити LAST_MODIFICATION_DATE
  Можливість подати цінову пропозицію користувачем ${provider}


Можливість подати пропозицію другим учасником
  [Tags]  ${USERS.users['${provider1}'].broker}: Подання пропозиції
  ...     provider1
  ...     ${USERS.users['${provider1}'].broker}
  ...     make_bid_by_provider1
  ...     critical
  [Setup]  Дочекатись дати початку прийому пропозицій  ${provider1}  ${TENDER['TENDER_UAID']}
  [Teardown]  Оновити LAST_MODIFICATION_DATE
  Можливість подати цінову пропозицію користувачем ${provider1}


Можливість подати пропозицію третім учасником
  [Tags]   ${USERS.users['${provider1}'].broker}: Подання пропозиції
  ...      provider2
  ...      ${USERS.users['${provider1}'].broker}
  ...      make_bid_by_provider2  level1
  ...      critical
  [Setup]  Дочекатись дати початку прийому пропозицій  ${provider2}  ${TENDER['TENDER_UAID']}
  [Teardown]  Оновити LAST_MODIFICATION_DATE
  Можливість подати цінову пропозицію користувачем ${provider2}


Дочекатися кінця complaint періоду тендера
  [Tags]   ${USERS.users['${tender_owner}'].broker}: Скасування тендера
  ...      tender_owner
  ...      ${USERS.users['${tender_owner}'].broker}
  ...      tender_complaintPeriond_stand_still
  ...      critical
  Дочекатись дати  ${USERS.users['${tender_owner}'].tender_data.data.complaintPeriod.endDate}
  Sleep  30s
  Оновити LAST_MODIFICATION_DATE

##############################################################################################
#             LOT CANCELLATION
##############################################################################################

Можливість скасувати лот
  [Tags]  ${USERS.users['${tender_owner}'].broker}: Скасування лота
  ...  tender_owner
  ...  ${USERS.users['${tender_owner}'].broker}
  ...  lot_cancellation
  [Teardown]  Оновити LAST_MODIFICATION_DATE
  Можливість скасувати 0 лот


Дочекатися закічення complait періоду скасування лота
  [Tags]   ${USERS.users['${tender_owner}'].broker}: Скасування тендера
  ...      tender_owner
  ...      ${USERS.users['${tender_owner}'].broker}
  ...      lot_cancellation_stand_still
  ...      critical
  Log  ${TENDER['TENDER_UAID']}
  ${cancellation_index}=  Отримати останній індекс  cancellations  ${tender_owner}
  Дочекатись зміни статусу cancellations  ${tender_owner}  ${TENDER['TENDER_UAID']}  active  ${cancellation_index}


Відображення активного статусу скасування лота
  [Tags]  ${USERS.users['${viewer}'].broker}: Відображення скасування лота
  ...  viewer
  ...  ${USERS.users['${viewer}'].broker}
  ...  lot_cancellation_view
  [Setup]  Дочекатись синхронізації з майданчиком  ${viewer}
  ${cancellation_index}=  Отримати останній індекс  cancellations  ${tender_owner}  ${viewer}
  Звірити поле тендера із значенням  ${viewer}  ${TENDER['TENDER_UAID']}
  ...      active
  ...      cancellations[${cancellation_index}].status


Відображення причини скасування лота
  [Tags]  ${USERS.users['${viewer}'].broker}: Відображення скасування лота
  ...  viewer
  ...  ${USERS.users['${viewer}'].broker}
  ...  lot_cancellation_view
  ${cancellation_index}=  Отримати останній індекс  cancellations  ${tender_owner}  ${viewer}
  Звірити поле тендера із значенням  ${viewer}  ${TENDER['TENDER_UAID']}
  ...      ${USERS.users['${tender_owner}']['lot_cancellation_data']['cancellation_reason']}
  ...      cancellations[${cancellation_index}].reason


Відображення опису документа до скасування лота
  [Tags]  ${USERS.users['${viewer}'].broker}: Відображення скасування лота
  ...  viewer
  ...  ${USERS.users['${viewer}'].broker}
  ...  lot_cancellation_view
  Звірити відображення поля description документа ${USERS.users['${tender_owner}']['lot_cancellation_data']['document']['doc_id']} до скасування ${USERS.users['${tender_owner}']['lot_cancellation_data']['cancellation_id']} із ${USERS.users['${tender_owner}']['lot_cancellation_data']['description']} для користувача ${viewer}


Відображення заголовку документа до скасування лота
  [Tags]  ${USERS.users['${viewer}'].broker}: Відображення скасування лота
  ...  viewer
  ...  ${USERS.users['${viewer}'].broker}
  ...  lot_cancellation_view
  Звірити відображення поля title документа ${USERS.users['${tender_owner}']['lot_cancellation_data']['document']['doc_id']} до скасування ${USERS.users['${tender_owner}']['lot_cancellation_data']['cancellation_id']} із ${USERS.users['${tender_owner}']['lot_cancellation_data']['document']['doc_name']} для користувача ${viewer}


Відображення вмісту документа до скасування лота
  [Tags]  ${USERS.users['${viewer}'].broker}: Відображення скасування лота
  ...  viewer
  ...  ${USERS.users['${viewer}'].broker}
  ...  lot_cancellation_view
  Звірити відображення вмісту документа ${USERS.users['${tender_owner}']['lot_cancellation_data']['document']['doc_id']} до скасування ${USERS.users['${tender_owner}']['lot_cancellation_data']['cancellation_id']} з ${USERS.users['${tender_owner}']['lot_cancellation_data']['document']['doc_content']} для користувача ${viewer}

##############################################################################################
#             TENDER CANCELLATION
##############################################################################################

Можливість скасувати тендер
  [Tags]  ${USERS.users['${tender_owner}'].broker}: Скасування тендера
  ...  tender_owner
  ...  ${USERS.users['${tender_owner}'].broker}
  ...  tender_cancellation
  [Teardown]  Оновити LAST_MODIFICATION_DATE
  Можливість скасувати тендер


Дочекатися закічення complait періоду скасування тендера
  [Tags]   ${USERS.users['${tender_owner}'].broker}: Скасування тендера
  ...      tender_owner
  ...      ${USERS.users['${tender_owner}'].broker}
  ...      tender_cancellation_stand_still
  ...      critical
  Log  ${TENDER['TENDER_UAID']}
  ${cancellation_index}=  Отримати останній індекс  cancellations  ${tender_owner}
  Дочекатись зміни статусу cancellations  ${tender_owner}  ${TENDER['TENDER_UAID']}  active  ${cancellation_index}


Відображення причини скасування тендера
  [Tags]  ${USERS.users['${viewer}'].broker}: Відображення скасування тендера
  ...  viewer
  ...  ${USERS.users['${viewer}'].broker}
  ...  tender_cancellation_view
  ${cancellation_index}=  Отримати останній індекс  cancellations  ${tender_owner}  ${viewer}
  Звірити поле тендера із значенням  ${viewer}  ${TENDER['TENDER_UAID']}
  ...      ${USERS.users['${tender_owner}']['tender_cancellation_data']['cancellation_reason']}
  ...      cancellations[${cancellation_index}].reason


Відображення опису документа до скасування тендера
  [Tags]  ${USERS.users['${viewer}'].broker}: Відображення скасування тендера
  ...  viewer
  ...  ${USERS.users['${viewer}'].broker}
  ...  tender_cancellation_view
  Звірити відображення поля description документа ${USERS.users['${tender_owner}']['tender_cancellation_data']['document']['doc_id']} до скасування ${USERS.users['${tender_owner}']['tender_cancellation_data']['cancellation_id']} із ${USERS.users['${tender_owner}']['tender_cancellation_data']['description']} для користувача ${viewer}


Відображення заголовку документа до скасування тендера
  [Tags]  ${USERS.users['${viewer}'].broker}: Відображення скасування тендера
  ...  viewer
  ...  ${USERS.users['${viewer}'].broker}
  ...  tender_cancellation_view
  Звірити відображення поля title документа ${USERS.users['${tender_owner}']['tender_cancellation_data']['document']['doc_id']} до скасування ${USERS.users['${tender_owner}']['tender_cancellation_data']['cancellation_id']} із ${USERS.users['${tender_owner}']['tender_cancellation_data']['document']['doc_name']} для користувача ${viewer}


Відображення вмісту документа до скасування тендера
  [Tags]  ${USERS.users['${viewer}'].broker}: Відображення скасування тендера
  ...  viewer
  ...  ${USERS.users['${viewer}'].broker}
  ...  tender_cancellation_view
  Звірити відображення вмісту документа ${USERS.users['${tender_owner}']['tender_cancellation_data']['document']['doc_id']} до скасування ${USERS.users['${tender_owner}']['tender_cancellation_data']['cancellation_id']} з ${USERS.users['${tender_owner}']['tender_cancellation_data']['document']['doc_content']} для користувача ${viewer}


Відображення активного статусу скасування тендера
  [Tags]  ${USERS.users['${viewer}'].broker}: Відображення скасування тендера
  ...  viewer
  ...  ${USERS.users['${viewer}'].broker}
  ...  tender_cancellation_view
  [Setup]  Дочекатись синхронізації з майданчиком  ${viewer}
  ${cancellation_index}=  Отримати останній індекс  cancellations  ${tender_owner}  ${viewer}
  Звірити поле тендера із значенням  ${viewer}  ${TENDER['TENDER_UAID']}
  ...      active
  ...      cancellations[${cancellation_index}].status

##############################################################################################
#             DELETING LOT
##############################################################################################

Неможливість видалення лоту
  [Tags]   ${USERS.users['${tender_owner}'].broker}: Редагування тендера
  ...      tender_owner
  ...      ${USERS.users['${tender_owner}'].broker}
  ...      delete_lot
  [Teardown]  Оновити LAST_MODIFICATION_DATE
  Run Keyword And Expect Error  *  Можливість видалення 1 лоту


*** Keywords ***
Можливість скасувати тендер
  ${cancellation_data}=  Підготувати дані про скасування  ${USERS.users['${tender_owner}'].initial_data.data.procurementMethodType}
  Run As  ${tender_owner}
  ...      Скасувати закупівлю
  ...      ${TENDER['TENDER_UAID']}
  ...      ${cancellation_data['cancellation_reason']}
  ...      ${cancellation_data['cancellation_reasonType']}
  ...      ${cancellation_data['document']['doc_path']}
  ...      ${cancellation_data['description']}
  Set To Dictionary  ${USERS.users['${tender_owner}']}  tender_cancellation_data=${cancellation_data}


Можливість скасувати ${index} лот
  ${cancellation_data}=  Підготувати дані про скасування  ${USERS.users['${tender_owner}'].initial_data.data.procurementMethodType}
  ${lot_id}=  get_id_from_object  ${USERS.users['${tender_owner}'].initial_data.data.lots[${index}]}
  Run As  ${tender_owner}
  ...      Скасувати лот
  ...      ${TENDER['TENDER_UAID']}
  ...      ${lot_id}
  ...      ${cancellation_data['cancellation_reason']}
  ...      ${cancellation_data['cancellation_reasonType']}
  ...      ${cancellation_data['document']['doc_path']}
  ...      ${cancellation_data['description']}
  Set To Dictionary  ${USERS.users['${tender_owner}']}  lot_cancellation_data=${cancellation_data}


Звірити відображення поля ${field} документа ${doc_id} до скасування ${cancel_id} із ${left} для користувача ${username}
  ${right}=  Run As  ${username}  Отримати інформацію із документа до скасування  ${TENDER['TENDER_UAID']}  ${cancel_id}  ${doc_id}  ${field}
  Порівняти об'єкти  ${left}  ${right}


Звірити відображення вмісту документа ${doc_id} до скасування ${cancel_id} з ${left} для користувача ${username}
  ${file_name}=  Run as  ${username}  Отримати документ до скасування  ${TENDER['TENDER_UAID']}  ${cancel_id}  ${doc_id}
  ${right}=  Get File  ${OUTPUT_DIR}${/}${file_name}
  Порівняти об'єкти  ${left}  ${right}
