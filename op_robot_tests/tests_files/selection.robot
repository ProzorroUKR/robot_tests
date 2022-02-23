*** Settings ***
Resource        base_keywords.robot
Resource        aboveThreshold_keywords.robot
Suite Setup     Test Suite Setup
Suite Teardown  Test Suite Teardown


*** Variables ***
${MODE}             framework_selection
@{USED_ROLES}       tender_owner  provider  provider1  provider2  viewer

${NUMBER_OF_ITEMS}  ${1}
${NUMBER_OF_LOTS}   ${1}
${TENDER_MEAT}      ${True}
${LOT_MEAT}         ${False}
${ITEM_MEAT}        ${False}
${MOZ_INTEGRATION}  ${False}
${ROAD_INDEX}       ${False}
${GMDN_INDEX}       ${False}
${PLAN_TENDER}      ${False}

*** Test Cases ***
Можливість оголосити тендер другого етапу
  [Tags]   ${USERS.users['${tender_owner}'].broker}: Оголошення тендера
  ...      tender_owner
  ...      ${USERS.users['${tender_owner}'].broker}
  ...      create_tender
  ...      critical
  [Teardown]  Оновити LAST_MODIFICATION_DATE
  Завантажити дані про тендер
  Можливість оголосити тендер другого етапу


Можливість знайти тендер по ідентифікатору для замовника
  [Tags]   ${USERS.users['${tender_owner}'].broker}: Пошук тендера
  ...      tender_owner
  ...      ${USERS.users['${tender_owner}'].broker}
  ...      find_tender
  ...      critical
  [Setup]  Дочекатись синхронізації з майданчиком  ${tender_owner}
  Можливість знайти тендер по ідентифікатору для користувача ${tender_owner}


Відображення заголовку лоту для замовника
  [Tags]   ${USERS.users['${tender_owner}'].broker}: Відображення лоту тендера
  ...      tender_owner
  ...      ${USERS.users['${tender_owner}'].broker}
  ...      tender_view
  ...      critical
  Отримати дані із поля lots[0].title тендера для користувача ${tender_owner}


Відображення бюджету тендера для замовника
  [Tags]   ${USERS.users['${tender_owner}'].broker}: Відображення основних даних тендера
  ...      tender_owner
  ...      ${USERS.users['${tender_owner}'].broker}
  ...      tender_view
  ...      critical
  Отримати дані із поля value.amount тендера для користувача ${tender_owner}


Відображення бюджету лоту для замовника
  [Tags]   ${USERS.users['${tender_owner}'].broker}: Відображення основних даних тендера
  ...      tender_owner
  ...      ${USERS.users['${tender_owner}'].broker}
  ...      tender_view
  ...      critical
  Отримати дані із поля lots[0].value.amount тендера для користувача ${tender_owner}


Відображення мінімального кроку лоту для замовника
  [Tags]   ${USERS.users['${tender_owner}'].broker}: Відображення основних даних тендера
  ...      tender_owner
  ...      ${USERS.users['${tender_owner}'].broker}
  ...      tender_view
  ...      critical
  Отримати дані із поля lots[0].minimalStep.amount тендера для користувача ${tender_owner}


Відображення закінчення періоду подачі пропозицій для замовника
  [Tags]   ${USERS.users['${viewer}'].broker}: Відображення основних даних тендера
  ...      viewer
  ...      ${USERS.users['${viewer}'].broker}
  ...      tender_view  level1
  ...      critical
  Отримати дані із поля tenderPeriod.endDate тендера для користувача ${tender_owner}


Можливість змінити дату закінчення періоду подання пропозиції на 10 днів
  [Tags]   ${USERS.users['${tender_owner}'].broker}: Можливість редагувати тендер
  ...      tender_owner
  ...      ${USERS.users['${tender_owner}'].broker}
  ...      extend_tendering_period  level3
  ...      critical
  [Teardown]  Оновити LAST_MODIFICATION_DATE
  ${endDate}=  add_minutes_to_date  ${USERS.users['${tender_owner}'].tender_data.data.tenderPeriod.endDate}  10
  Можливість змінити поле tenderPeriod.endDate тендера на ${endDate}
  Remove From Dictionary  ${USERS.users['${tender_owner}'].tender_data.data.tenderPeriod}  endDate
  #Можливість продовжити період подання пропозиції на ${10} днів
  #Remove From Dictionary  ${USERS.users['${tender_owner}'].tender_data.data.tenderPeriod}  endDate


Можливість змінити кількість одиниць в предметі закупівлі
  [Tags]   ${USERS.users['${tender_owner}'].broker}: Можливість редагувати тендер
  ...      tender_owner
  ...      ${USERS.users['${tender_owner}'].broker}
  ...      modify_item
  ...      critical
  [Setup]  Дочекатись синхронізації з майданчиком  ${tender_owner}
  [Teardown]  Оновити LAST_MODIFICATION_DATE
  Отримати дані із поля items[0].quantity тендера для користувача ${tender_owner}
  ${items}=  Get From Dictionary  ${USERS.users['${tender_owner}'].tender_data.data}  items
  ${quantity}=  Get Variable Value  ${items[0].quantity}
  ${new_quantity}=  create_fake_number_float  ${1}  ${quantity}
  Можливість змінити поле items[0].quantity тендера на ${new_quantity}


Можливість збільшити мінімальний крок лоту на 5 процентів
  [Tags]   ${USERS.users['${tender_owner}'].broker}: Редагування тендера
  ...      tender_owner
  ...      ${USERS.users['${tender_owner}'].broker}
  ...      modify_lot
  ...      critical
  [Setup]  Дочекатись синхронізації з майданчиком  ${tender_owner}
  [Teardown]  Оновити LAST_MODIFICATION_DATE
  ${step_value}=  mult_and_round  ${USERS.users['${tender_owner}'].tender_data.data.lots[0].minimalStep.amount}  ${1.05}  precision=${2}
  Можливість змінити поле minimalStep.amount 0 лоту на ${step_value}


Можливість знайти тендер по ідентифікатору
  [Tags]   ${USERS.users['${viewer}'].broker}: Пошук тендера
  ...      viewer  tender_owner  provider  provider1
  ...      ${USERS.users['${viewer}'].broker}  ${USERS.users['${tender_owner}'].broker}
  ...      ${USERS.users['${provider}'].broker}  ${USERS.users['${provider1}'].broker}
  ...      find_tender
  ...      critical
  Можливість знайти тендер по ідентифікатору для усіх користувачів


Можливість додати документацію до тендера
  [Tags]   ${USERS.users['${tender_owner}'].broker}: Додання документації
  ...      tender_owner
  ...      ${USERS.users['${tender_owner}'].broker}
  ...      add_tender_doc
  ...      critical
  [Teardown]  Оновити LAST_MODIFICATION_DATE
  Можливість додати документацію до тендера


Можливість додати документацію до всіх лотів
  [Tags]   ${USERS.users['${tender_owner}'].broker}: Додання документації
  ...      tender_owner
  ...      ${USERS.users['${tender_owner}'].broker}
  ...      add_lot_doc
  ...      critical
  [Teardown]  Оновити LAST_MODIFICATION_DATE
  Можливість додати документацію до всіх лотів


Відображення заголовку документації до тендера
  [Tags]   ${USERS.users['${viewer}'].broker}: Відображення документації
  ...      viewer
  ...      ${USERS.users['${viewer}'].broker}
  ...      add_tender_doc
  ...      non-critical
  [Setup]  Дочекатись синхронізації з майданчиком  ${viewer}
  Звірити відображення поля title документа ${USERS.users['${tender_owner}']['tender_document']['doc_id']} із ${USERS.users['${tender_owner}'].tender_document.doc_name} для користувача ${viewer}


Відображення заголовку документації до всіх лотів
  [Tags]   ${USERS.users['${viewer}'].broker}: Відображення документації
  ...      viewer
  ...      ${USERS.users['${viewer}'].broker}
  ...      add_lot_doc
  ...      critical
  Звірити відображення заголовку документації до всіх лотів для користувача ${viewer}


Відображення вмісту документації до тендера
  [Tags]   ${USERS.users['${viewer}'].broker}: Відображення документації
  ...      viewer
  ...      ${USERS.users['${viewer}'].broker}
  ...      add_tender_doc
  ...      non-critical
  Звірити відображення вмісту документа ${USERS.users['${tender_owner}'].tender_document.doc_id} із ${USERS.users['${tender_owner}'].tender_document.doc_content} для користувача ${viewer}


Відображення вмісту документації до всіх лотів
  [Tags]   ${USERS.users['${viewer}'].broker}: Відображення документації
  ...      viewer
  ...      ${USERS.users['${viewer}'].broker}
  ...      add_lot_doc
  ...      critical
  Звірити відображення вмісту документації до всіх лотів для користувача ${viewer}


##############################################################################################
#             Відображення основних даних тендера
##############################################################################################

Відображення заголовку тендера
  [Tags]   ${USERS.users['${viewer}'].broker}: Відображення основних даних тендера
  ...      viewer
  ...      ${USERS.users['${viewer}'].broker}
  ...      tender_view 
  ...      critical
  [Setup]  Дочекатись синхронізації з майданчиком  ${viewer}
  Отримати дані із поля title тендера для користувача ${viewer}


Відображення опису тендера
  [Tags]   ${USERS.users['${viewer}'].broker}: Відображення основних даних тендера
  ...      viewer
  ...      ${USERS.users['${viewer}'].broker}
  ...      tender_view
  ...      non-critical
  Отримати дані із поля description тендера для користувача ${viewer}


Відображення бюджету тендера
  [Tags]   ${USERS.users['${viewer}'].broker}: Відображення основних даних тендера
  ...      viewer  tender_owner  provider  provider1
  ...      ${USERS.users['${viewer}'].broker}  ${USERS.users['${tender_owner}'].broker}
  ...      ${USERS.users['${provider}'].broker}  ${USERS.users['${provider1}'].broker}
  ...      tender_view 
  ...      critical
  Отримати дані із поля value.amount тендера для усіх користувачів


Відображення валюти тендера
  [Tags]   ${USERS.users['${viewer}'].broker}: Відображення основних даних тендера
  ...      viewer  tender_owner  provider  provider1
  ...      ${USERS.users['${viewer}'].broker}  ${USERS.users['${tender_owner}'].broker}
  ...      ${USERS.users['${provider}'].broker}  ${USERS.users['${provider1}'].broker}
  ...      tender_view
  ...      non-critical
  Отримати дані із поля value.currency тендера для усіх користувачів


Відображення ПДВ в бюджеті тендера
  [Tags]   ${USERS.users['${viewer}'].broker}: Відображення основних даних тендера
  ...      viewer  tender_owner  provider  provider1
  ...      ${USERS.users['${viewer}'].broker}  ${USERS.users['${tender_owner}'].broker}
  ...      ${USERS.users['${provider}'].broker}  ${USERS.users['${provider1}'].broker}
  ...      tender_view
  ...      non-critical
  Отримати дані із поля value.valueAddedTaxIncluded тендера для усіх користувачів


Відображення ідентифікатора тендера
  [Tags]   ${USERS.users['${viewer}'].broker}: Відображення основних даних тендера
  ...      viewer  tender_owner  provider  provider1
  ...      ${USERS.users['${viewer}'].broker}  ${USERS.users['${tender_owner}'].broker}
  ...      ${USERS.users['${provider}'].broker}  ${USERS.users['${provider1}'].broker}
  ...      tender_view
  ...      critical
  Звірити відображення поля tenderID тендера із ${TENDER['TENDER_UAID']} для користувача ${viewer}


Відображення ідентифікатора угоди
  [Tags]   ${USERS.users['${viewer}'].broker}: Відображення основних даних тендера
  ...      viewer  tender_owner  provider  provider1
  ...      ${USERS.users['${viewer}'].broker}  ${USERS.users['${tender_owner}'].broker}
  ...      ${USERS.users['${provider}'].broker}  ${USERS.users['${provider1}'].broker}
  ...      tender_view
  ...      critical
  Отримати дані із поля agreements[0].agreementID тендера для усіх користувачів


Відображення імені замовника тендера
  [Tags]   ${USERS.users['${viewer}'].broker}: Відображення основних даних тендера
  ...      viewer
  ...      ${USERS.users['${viewer}'].broker}
  ...      tender_view
  ...      critical
  Звірити відображення поля procuringEntity.name тендера для користувача ${viewer}


Відображення початку періоду уточнення тендера
  [Tags]   ${USERS.users['${viewer}'].broker}: Відображення основних даних тендера
  ...      viewer  tender_owner  provider  provider1
  ...      ${USERS.users['${viewer}'].broker}  ${USERS.users['${tender_owner}'].broker}
  ...      ${USERS.users['${provider}'].broker}  ${USERS.users['${provider1}'].broker}
  ...      tender_view
  ...      non-critical
  Отримати дані із поля enquiryPeriod.startDate тендера для усіх користувачів


Відображення закінчення періоду уточнення тендера
  [Tags]   ${USERS.users['${viewer}'].broker}: Відображення основних даних тендера
  ...      viewer  tender_owner  provider  provider1
  ...      ${USERS.users['${viewer}'].broker}  ${USERS.users['${tender_owner}'].broker}
  ...      ${USERS.users['${provider}'].broker}  ${USERS.users['${provider1}'].broker}
  ...      tender_view
  ...      critical
  Отримати дані із поля enquiryPeriod.endDate тендера для усіх користувачів


Відображення початку періоду прийому пропозицій тендера
  [Tags]   ${USERS.users['${viewer}'].broker}: Відображення основних даних тендера
  ...      viewer  tender_owner  provider  provider1
  ...      ${USERS.users['${viewer}'].broker}  ${USERS.users['${tender_owner}'].broker}
  ...      ${USERS.users['${provider}'].broker}  ${USERS.users['${provider1}'].broker}
  ...      tender_view
  ...      non-critical
  Отримати дані із поля tenderPeriod.startDate тендера для усіх користувачів


Відображення закінчення періоду прийому пропозицій тендера
  [Tags]   ${USERS.users['${viewer}'].broker}: Відображення основних даних тендера
  ...      viewer  tender_owner  provider  provider1
  ...      ${USERS.users['${viewer}'].broker}  ${USERS.users['${tender_owner}'].broker}
  ...      ${USERS.users['${provider}'].broker}  ${USERS.users['${provider1}'].broker}
  ...      tender_view
  ...      critical
  Отримати дані із поля tenderPeriod.endDate тендера для усіх користувачів


Відображення мінімального кроку тендера
  [Tags]   ${USERS.users['${viewer}'].broker}: Відображення основних даних тендера
  ...      viewer  tender_owner  provider  provider1
  ...      ${USERS.users['${viewer}'].broker}  ${USERS.users['${tender_owner}'].broker}
  ...      ${USERS.users['${provider}'].broker}  ${USERS.users['${provider1}'].broker}
  ...      tender_view
  ...      critical
  Отримати дані із поля minimalStep.amount тендера для усіх користувачів


Відображення типу оголошеного тендера
  [Tags]   ${USERS.users['${viewer}'].broker}: Відображення основних даних тендера
  ...      viewer  tender_owner  provider  provider1
  ...      ${USERS.users['${viewer}'].broker}  ${USERS.users['${tender_owner}'].broker}
  ...      ${USERS.users['${provider}'].broker}  ${USERS.users['${provider1}'].broker}
  ...      open_tender_view
  ...      non-critical
  Звірити відображення поля procurementMethodType тендера для усіх користувачів


##############################################################################################
#             Відображення основних даних предмету
##############################################################################################

Відображення опису номенклатур тендера
  [Tags]   ${USERS.users['${viewer}'].broker}: Відображення номенклатури тендера
  ...      viewer  tender_owner  provider  provider1
  ...      ${USERS.users['${viewer}'].broker}  ${USERS.users['${tender_owner}'].broker}
  ...      ${USERS.users['${provider}'].broker}  ${USERS.users['${provider1}'].broker}
  ...      tender_view
  ...      critical
  Звірити відображення поля description усіх предметів для усіх користувачів


Відображення дати початку доставки номенклатур тендера
  [Tags]   ${USERS.users['${viewer}'].broker}: Відображення номенклатури тендера
  ...      viewer
  ...      ${USERS.users['${viewer}'].broker}
  ...      tender_view
  ...      non-critical
  Звірити відображення дати deliveryDate.startDate усіх предметів для користувача ${viewer}


Відображення дати кінця доставки номенклатур тендера
  [Tags]   ${USERS.users['${viewer}'].broker}: Відображення номенклатури тендера
  ...      viewer
  ...      ${USERS.users['${viewer}'].broker}
  ...      tender_view
  ...      non-critical
  Звірити відображення дати deliveryDate.endDate усіх предметів для користувача ${viewer}


Відображення координати доставки номенклатур тендера
  [Tags]   ${USERS.users['${viewer}'].broker}: Відображення номенклатури тендера
  ...      viewer
  ...      ${USERS.users['${viewer}'].broker}
  ...      tender_view_coordinates
  ...      non-critical
  Звірити відображення координат усіх предметів для користувача ${viewer}


Відображення країни доставки номенклатур тендера
  [Tags]   ${USERS.users['${viewer}'].broker}: Відображення номенклатури тендера
  ...      viewer
  ...      ${USERS.users['${viewer}'].broker}
  ...      tender_view
  ...      non-critical
  Звірити відображення поля deliveryAddress.countryName усіх предметів для користувача ${viewer}


Відображення пошт. коду доставки номенклатур тендера
  [Tags]   ${USERS.users['${viewer}'].broker}: Відображення номенклатури тендера
  ...      viewer
  ...      ${USERS.users['${viewer}'].broker}
  ...      tender_view
  ...      non-critical
  Звірити відображення поля deliveryAddress.postalCode усіх предметів для користувача ${viewer}


Відображення регіону доставки номенклатур тендера
  [Tags]   ${USERS.users['${viewer}'].broker}: Відображення номенклатури тендера
  ...      viewer
  ...      ${USERS.users['${viewer}'].broker}
  ...      tender_view
  ...      non-critical
  Звірити відображення поля deliveryAddress.region усіх предметів для користувача ${viewer}


Відображення назви нас. пункту доставки номенклатур тендера
  [Tags]   ${USERS.users['${viewer}'].broker}: Відображення номенклатури тендера
  ...      viewer
  ...      ${USERS.users['${viewer}'].broker}
  ...      tender_view
  ...      non-critical
  Звірити відображення поля deliveryAddress.locality усіх предметів для користувача ${viewer}


Відображення вулиці доставки номенклатур тендера
  [Tags]   ${USERS.users['${viewer}'].broker}: Відображення номенклатури тендера
  ...      viewer
  ...      ${USERS.users['${viewer}'].broker}
  ...      tender_view
  ...      non-critical
  Звірити відображення поля deliveryAddress.streetAddress усіх предметів для користувача ${viewer}


Відображення схеми класифікації номенклатур тендера
  [Tags]   ${USERS.users['${viewer}'].broker}: Відображення номенклатури тендера
  ...      viewer
  ...      ${USERS.users['${viewer}'].broker}
  ...      tender_view
  ...      non-critical
  Звірити відображення поля classification.scheme усіх предметів для користувача ${viewer}
  Run Keyword If  "${USERS.users['${tender_owner}'].initial_data.data['items'][0]['classification']['id']}" == "33600000-6"
  ...      Звірити відображення поля additionalClassifications[0].scheme усіх предметів для користувача ${viewer}


Відображення ідентифікатора класифікації номенклатур тендера
  [Tags]   ${USERS.users['${viewer}'].broker}: Відображення номенклатури тендера
  ...      viewer
  ...      ${USERS.users['${viewer}'].broker}
  ...      tender_view
  ...      non-critical
  Звірити відображення поля classification.id усіх предметів для користувача ${viewer}
  Run Keyword If  "${USERS.users['${tender_owner}'].initial_data.data['items'][0]['classification']['id']}" == "33600000-6"
  ...      Звірити відображення поля additionalClassifications[0].id усіх предметів для користувача ${viewer}


Відображення опису класифікації номенклатур тенедра
  [Tags]   ${USERS.users['${viewer}'].broker}: Відображення номенклатури тендера
  ...      viewer
  ...      ${USERS.users['${viewer}'].broker}
  ...      tender_view
  ...      non-critical
  Звірити відображення поля classification.description усіх предметів для користувача ${viewer}
  Run Keyword If  "${USERS.users['${tender_owner}'].initial_data.data['items'][0]['classification']['id']}" == "33600000-6"
  ...      Звірити відображення поля additionalClassifications[0].description усіх предметів для користувача ${viewer}


Відображення назви одиниці номенклатур тендера
  [Tags]   ${USERS.users['${viewer}'].broker}: Відображення номенклатури тендера
  ...      viewer
  ...      ${USERS.users['${viewer}'].broker}
  ...      tender_view
  ...      non-critical
  Звірити відображення поля unit.name усіх предметів для користувача ${viewer}


Відображення коду одиниці виміру номенклатур тендера
  [Tags]   ${USERS.users['${viewer}'].broker}: Відображення номенклатури тендера
  ...      viewer
  ...      ${USERS.users['${viewer}'].broker}
  ...      tender_view_unit_code
  ...      non-critical
  Звірити відображення поля unit.code усіх предметів для користувача ${viewer}


Відображення кількості номенклатур тендера
  [Tags]   ${USERS.users['${viewer}'].broker}: Відображення номенклатури тендера
  ...      viewer  tender_owner  provider  provider1
  ...      ${USERS.users['${viewer}'].broker}  ${USERS.users['${tender_owner}'].broker}
  ...      ${USERS.users['${provider}'].broker}  ${USERS.users['${provider1}'].broker}
  ...      tender_view
  ...      non-critical
  Отримати дані із поля items[0].quantity тендера для усіх користувачів

##############################################################################################
#             Відображення основних даних лоту
##############################################################################################

Відображення заголовку лотів
  [Tags]   ${USERS.users['${viewer}'].broker}: Відображення лоту тендера
  ...      viewer  tender_owner  provider  provider1
  ...      ${USERS.users['${viewer}'].broker}  ${USERS.users['${tender_owner}'].broker}
  ...      ${USERS.users['${provider}'].broker}  ${USERS.users['${provider1}'].broker}
  ...      lot_view  level1
  ...      critical
  Звірити відображення поля title усіх лотів другого етапу для усіх користувачів


Відображення опису лотів
  [Tags]   ${USERS.users['${viewer}'].broker}: Відображення лоту тендера
  ...      viewer
  ...      ${USERS.users['${viewer}'].broker}
  ...      lot_view
  ...      critical
  Звірити відображення поля description усіх лотів другого етапу для усіх користувачів


Відображення бюджету лотів
  [Tags]   ${USERS.users['${viewer}'].broker}: Відображення лоту тендера
  ...      viewer  tender_owner  provider  provider1
  ...      ${USERS.users['${viewer}'].broker}  ${USERS.users['${tender_owner}'].broker}
  ...      ${USERS.users['${provider}'].broker}  ${USERS.users['${provider1}'].broker}
  ...      lot_view
  ...      critical
  Звірити відображення поля value.amount усіх лотів другого етапу для усіх користувачів


Відображення валюти лотів
  [Tags]   ${USERS.users['${viewer}'].broker}: Відображення лоту тендера
  ...      viewer
  ...      ${USERS.users['${viewer}'].broker}
  ...      lot_view
  ...      non-critical
  Звірити відображення поля value.currency усіх лотів другого етапу для усіх користувачів


Відображення ПДВ в бюджеті лотів
  [Tags]   ${USERS.users['${viewer}'].broker}: Відображення лоту тендера
  ...      viewer
  ...      ${USERS.users['${viewer}'].broker}
  ...      lot_view
  ...      non-critical
  Звірити відображення поля value.valueAddedTaxIncluded усіх лотів другого етапу для усіх користувачів


Відображення мінімального кроку лотів
  [Tags]   ${USERS.users['${viewer}'].broker}: Відображення лоту тендера
  ...      viewer  tender_owner  provider  provider1
  ...      ${USERS.users['${viewer}'].broker}  ${USERS.users['${tender_owner}'].broker}
  ...      ${USERS.users['${provider}'].broker}  ${USERS.users['${provider1}'].broker}
  ...      lot_view
  ...      non-critical
  Звірити відображення поля minimalStep.amount усіх лотів другого етапу для усіх користувачів

Відображення валюти мінімального кроку лотів
  [Tags]   ${USERS.users['${viewer}'].broker}: Відображення лоту тендера
  ...      viewer
  ...      ${USERS.users['${viewer}'].broker}
  ...      lot_view
  ...      non-critical
  Звірити відображення поля minimalStep.currency усіх лотів другого етапу для усіх користувачів


Відображення ПДВ в мінімальному кроці лотів
  [Tags]   ${USERS.users['${viewer}'].broker}: Відображення лоту тендера
  ...      viewer
  ...      ${USERS.users['${viewer}'].broker}
  ...      lot_view
  ...      non-critical
  Звірити відображення поля minimalStep.valueAddedTaxIncluded усіх лотів другого етапу для усіх користувачів

##############################################################################################
#             Відображення основних даних предмету
##############################################################################################

Відображення заголовку нецінових показників
  [Tags]   ${USERS.users['${viewer}'].broker}: Відображення нецінових показників
  ...      viewer  tender_owner  provider  provider1
  ...      ${USERS.users['${viewer}'].broker}  ${USERS.users['${tender_owner}'].broker}
  ...      ${USERS.users['${provider}'].broker}  ${USERS.users['${provider1}'].broker}
  ...      meat_view
  ...      critical
  Отримати дані із поля title нецінових показників для усіх користувачів


Відображення опису нецінових показників
  [Tags]   ${USERS.users['${viewer}'].broker}: Відображення нецінових показників
  ...      viewer  tender_owner  provider  provider1
  ...      ${USERS.users['${viewer}'].broker}  ${USERS.users['${tender_owner}'].broker}
  ...      ${USERS.users['${provider}'].broker}  ${USERS.users['${provider1}'].broker}
  ...      meat_view
  ...      critical
  Отримати дані із поля description нецінових показників для усіх користувачів


Відображення відношення нецінових показників
  [Tags]   ${USERS.users['${viewer}'].broker}: Відображення нецінових показників
  ...      viewer  tender_owner  provider  provider1
  ...      ${USERS.users['${viewer}'].broker}  ${USERS.users['${tender_owner}'].broker}
  ...      ${USERS.users['${provider}'].broker}  ${USERS.users['${provider1}'].broker}
  ...      meat_view
  ...      non-critical
  Отримати дані із поля featureOf нецінових показників для усіх користувачів

##############################################################################################
#             BIDDING
##############################################################################################

Можливість подати пропозицію першим учасником
  [Tags]   ${USERS.users['${provider}'].broker}: Подання пропозиції
  ...      provider
  ...      ${USERS.users['${provider}'].broker}
  ...      make_bid_by_provider
  ...      critical
  [Setup]  Дочекатись дати початку прийому пропозицій  ${provider}  ${TENDER['TENDER_UAID']}
  [Teardown]  Оновити LAST_MODIFICATION_DATE
  Можливість подати цінову пропозицію на другому етапі рамкової угоди користувачем  ${provider}  ${0}


Можливість зменшити пропозицію на 5% першим учасником
  [Tags]   ${USERS.users['${provider}'].broker}: Подання пропозиції
  ...      provider
  ...      ${USERS.users['${provider}'].broker}
  ...      modify_bid_by_provider
  ...      critical
  [Teardown]  Оновити LAST_MODIFICATION_DATE
  Можливість зменшити пропозицію до 95 відсотків користувачем ${provider}


Можливість завантажити документ в пропозицію першим учасником
  [Tags]   ${USERS.users['${provider}'].broker}: Подання пропозиції
  ...      provider
  ...      ${USERS.users['${provider}'].broker}
  ...      add_doc_to_bid_by_provider
  ...      critical
  [Teardown]  Оновити LAST_MODIFICATION_DATE
  Можливість завантажити документ в пропозицію користувачем ${provider}


Можливість подати пропозицію другим учасником
  [Tags]   ${USERS.users['${provider1}'].broker}: Подання пропозиції
  ...      provider1
  ...      ${USERS.users['${provider1}'].broker}
  ...      make_bid_by_provider1
  ...      critical
  [Setup]  Дочекатись дати початку прийому пропозицій  ${provider1}  ${TENDER['TENDER_UAID']}
  [Teardown]  Оновити LAST_MODIFICATION_DATE
  Можливість подати цінову пропозицію на другому етапі рамкової угоди користувачем  ${provider1}  ${1}


Можливість зменшити пропозицію на 5% другим учасником
  [Tags]   ${USERS.users['${provider1}'].broker}: Подання пропозиції
  ...      provider1
  ...      ${USERS.users['${provider1}'].broker}
  ...      modify_bid_by_provider1
  [Teardown]  Оновити LAST_MODIFICATION_DATE
  Можливість зменшити пропозицію до 95 відсотків користувачем ${provider1}


Неможливість завантажити документ першим учасником після закінчення прийому пропозицій
  [Tags]   ${USERS.users['${provider}'].broker}: Подання пропозиції
  ...      provider
  ...      ${USERS.users['${provider}'].broker}
  ...      add_bid_doc_after_tendering_period_by_provider
  ...      non-critical
  [Setup]  Дочекатись дати закінчення прийому пропозицій  ${provider}  ${TENDER['TENDER_UAID']}
  Run Keyword And Expect Error  *  Можливість завантажити документ в пропозицію користувачем ${provider}


###################################################################
#           Відображення посилання на аукціон
###################################################################

Можливість вичитати посилання на аукціон для глядача
  [Tags]   ${USERS.users['${viewer}'].broker}: Процес аукціону
  ...      viewer
  ...      ${USERS.users['${viewer}'].broker}
  ...      auction_url_viewer
  ...      critical
  [Setup]  Дочекатись дати початку періоду аукціону  ${viewer}  ${TENDER['TENDER_UAID']}
  Можливість отримати посилання на аукціон для глядача


Можливість вичитати посилання на аукціон для першого учасника
  [Tags]   ${USERS.users['${provider}'].broker}: Процес аукціону
  ...      provider
  ...      ${USERS.users['${provider}'].broker}
  ...      auction_url_provider
  ...      critical
  [Setup]  Дочекатись синхронізації з майданчиком  ${provider}
  Можливість отримати посилання на аукціон для учасника ${provider}


Можливість вичитати посилання на аукціон для другого учасника
  [Tags]   ${USERS.users['${provider1}'].broker}: Процес аукціону
  ...      provider1
  ...      ${USERS.users['${provider1}'].broker}
  ...      auction_url_provider1
  ...      critical
  [Setup]  Дочекатись синхронізації з майданчиком  ${provider1}
  Можливість отримати посилання на аукціон для учасника ${provider1}


Можливість вичитати посилання на аукціон для третього учасника
  [Tags]   ${USERS.users['${provider2}'].broker}: Процес аукціону
  ...      provider1
  ...      ${USERS.users['${provider2}'].broker}
  ...      auction_url_provider2
  ...      critical
  [Setup]  Дочекатись синхронізації з майданчиком  ${provider2}
  Можливість отримати посилання на аукціон для учасника ${provider2}

