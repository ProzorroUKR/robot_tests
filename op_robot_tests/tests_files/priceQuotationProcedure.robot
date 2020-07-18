*** Settings ***
Resource        base_keywords.robot
Suite Setup     Test Suite Setup
Suite Teardown  Test Suite Teardown


*** Variables ***
${MODE}             priceQuotation
@{USED_ROLES}       tender_owner  provider  provider1  provider2  viewer
@{USED_PROVIDERS}   provider  provider1  provider2
${RESOURCE}         tenders

${NUMBER_OF_ITEMS}  ${1}
${NUMBER_OF_LOTS}   ${1}
${NUMBER_OF_MILESTONES}  ${0}
${TENDER_MEAT}      ${False}
${LOT_MEAT}         ${False}
${ITEM_MEAT}        ${False}
${MOZ_INTEGRATION}  ${False}
${VAT_INCLUDED}     ${True}
${ROAD_INDEX}       ${False}
${GMDN_INDEX}       ${False}
${PLAN_TENDER}      ${True}

*** Test Cases ***
Неможливість оголосити тендер з tenderPeriod:endDate < 2 робочих дні
  [Tags]   ${USERS.users['${tender_owner}'].broker}: Оголошення тендера
  ...      tender_owner
  ...      ${USERS.users['${tender_owner}'].broker}
  ...      create_tender_wrong_date  level1
  ...      critical
  [Teardown]  Оновити LAST_MODIFICATION_DATE
  Set Test Variable  ${WRONG_TENDER_DATE}  ${True}
  Run Keyword And Expect Error  *  Можливість оголосити тендер для негативних сценаріїв


Можливість оголосити тендер
  [Tags]   ${USERS.users['${tender_owner}'].broker}: Оголошення тендера
  ...      tender_owner
  ...      ${USERS.users['${tender_owner}'].broker}
  ...      create_tender  level1
  ...      critical
  [Teardown]  Оновити LAST_MODIFICATION_DATE
  Можливість оголосити тендер


Можливість знайти тендер по ідентифікатору
  [Tags]   ${USERS.users['${viewer}'].broker}: Пошук тендера
  ...      viewer  tender_owner  provider  provider1
  ...      ${USERS.users['${viewer}'].broker}  ${USERS.users['${tender_owner}'].broker}
  ...      ${USERS.users['${provider}'].broker}  ${USERS.users['${provider1}'].broker}
  ...      find_tender  level1
  ...      critical
  Можливість знайти тендер по ідентифікатору для усіх користувачів


Відображення заголовку тендера
  [Tags]   ${USERS.users['${viewer}'].broker}: Відображення основних даних тендера
  ...      viewer
  ...      ${USERS.users['${viewer}'].broker}
  ...      tender_view  level1
  ...      critical
  [Setup]  Дочекатись синхронізації з майданчиком  ${viewer}
  Звірити відображення поля title тендера для користувача ${viewer}


Відображення заголовку тендера російською мовою
  [Tags]   ${USERS.users['${viewer}'].broker}: Відображення основних даних тендера
  ...      viewer
  ...      ${USERS.users['${viewer}'].broker}
  ...      tender_view  level1
  ...      non-critical
  [Setup]  Дочекатись синхронізації з майданчиком  ${viewer}
  Звірити відображення поля title_ru тендера для користувача ${viewer}


Відсутнє відображення заголовку тендера англійською мовою якщо при створенні не вказувались дані
  [Tags]   ${USERS.users['${viewer}'].broker}: Відображення основних даних тендера
  ...      viewer
  ...      ${USERS.users['${viewer}'].broker}
  ...      tender_view  level1
  ...      non-critical
  [Setup]  Дочекатись синхронізації з майданчиком  ${viewer}
  Run Keyword And Expect Error  *  Звірити відображення поля title_en тендера для користувача ${viewer}


Відображення опису тендера
  [Tags]   ${USERS.users['${viewer}'].broker}: Відображення основних даних тендера
  ...      viewer
  ...      ${USERS.users['${viewer}'].broker}
  ...      tender_view  level2
  ...      non-critical
  Звірити відображення поля description тендера для користувача ${viewer}


Відображення бюджету тендера
  [Tags]   ${USERS.users['${viewer}'].broker}: Відображення основних даних тендера
  ...      viewer
  ...      ${USERS.users['${viewer}'].broker}
  ...      tender_view_value  level1
  ...      critical
  Звірити відображення поля value.amount тендера для усіх користувачів


Відображення валюти тендера
  [Tags]   ${USERS.users['${viewer}'].broker}: Відображення основних даних тендера
  ...      viewer
  ...      ${USERS.users['${viewer}'].broker}
  ...      tender_view_value  level2
  ...      non-critical
  Звірити відображення поля value.currency тендера для користувача ${viewer}


Відображення ПДВ в бюджеті тендера
  [Tags]   ${USERS.users['${viewer}'].broker}: Відображення основних даних тендера
  ...      viewer
  ...      ${USERS.users['${viewer}'].broker}
  ...      tender_view_value  level2
  ...      non-critical
  Звірити відображення поля value.valueAddedTaxIncluded тендера для користувача ${viewer}


Відображення дати початку доставки номенклатур тендера
  [Tags]   ${USERS.users['${viewer}'].broker}: Відображення номенклатури тендера
  ...      viewer
  ...      ${USERS.users['${viewer}'].broker}
  ...      tender_view_deliveryDate  level2
  ...      non-critical
  Звірити відображення дати deliveryDate.startDate усіх предметів для користувача ${viewer}


Відображення дати кінця доставки номенклатур тендера
  [Tags]   ${USERS.users['${viewer}'].broker}: Відображення номенклатури тендера
  ...      viewer
  ...      ${USERS.users['${viewer}'].broker}
  ...      tender_view_deliveryDate  level2
  ...      non-critical
  Звірити відображення дати deliveryDate.endDate усіх предметів для користувача ${viewer}


Відображення кількості номенклатур тендера
  [Tags]   ${USERS.users['${viewer}'].broker}: Відображення номенклатури тендера
  ...      viewer
  ...      ${USERS.users['${viewer}'].broker}
  ...      tender_view_quantity  level2
  ...      non-critical
  Звірити відображення поля quantity усіх предметів для користувача ${viewer}


Неможливість змінити дату закінчення періоду подання пропозиції на 1 день після публікації
  [Tags]   ${USERS.users['${tender_owner}'].broker}: Неможливість редагувати тендер
  ...      tender_owner
  ...      ${USERS.users['${tender_owner}'].broker}
  ...      extend_tendering_period  level3
  ...      critical
  [Teardown]  Оновити LAST_MODIFICATION_DATE
  ${endDate}=  add_minutes_to_date  ${USERS.users['${tender_owner}'].tender_data.data.tenderPeriod.endDate}  1
  Перевірити неможливість зміни поля tenderPeriod.endDate тендера на значення ${endDate} для користувача ${tender_owner}


Відображення зміни закінчення періоду прийому пропозицій тендера
  [Tags]   ${USERS.users['${viewer}'].broker}: Відображення основних даних тендера
  ...      viewer
  ...      ${USERS.users['${viewer}'].broker}
  ...      extend_tendering_period  level2
  ...      non-critical
  [Setup]  Дочекатись синхронізації з майданчиком  ${viewer}
  Звірити відображення дати tenderPeriod.endDate тендера для усіх користувачів


Можливість пройти процедуру валідації
  [Tags]   ${USERS.users['${viewer}'].broker}: Валідація тендера
  ...      viewer  tender_owner  provider  provider1
  ...      ${USERS.users['${viewer}'].broker}  ${USERS.users['${tender_owner}'].broker}
  ...      ${USERS.users['${provider}'].broker}  ${USERS.users['${provider1}'].broker}
  ...      successfully_tender_validation  level1
  ...      critical
  Дочекатись дати початку прийому пропозицій  ${provider}  ${TENDER['TENDER_UAID']}


Неможливість подати пропозицію з перевищеним лімітом
  [Tags]   ${USERS.users['${provider}'].broker}: Подання пропозиції
  ...      provider
  ...      ${USERS.users['${provider}'].broker}
  ...      impossible_make_bid_with_over_amount
  ...      non-critical
  [Setup]  Дочекатись синхронізації з майданчиком  ${provider}
  Set Test Variable  ${BID_OVER_LIMIT}  ${True}
  Run Keyword And Expect Error  *  Можливість подати цінову пропозицію priceQuotation користувачем ${provider}


Неможливість подати пропозицію при відсутності однієї з характеристик
  [Tags]   ${USERS.users['${provider}'].broker}: Подання пропозиції
  ...      provider
  ...      ${USERS.users['${provider}'].broker}
  ...      impossible_make_bid
  ...      non-critical
  [Setup]  Дочекатись синхронізації з майданчиком  ${provider}
  Set Test Variable  ${BID_ONE_OF_THE_CRITERIAS_IS_MISSING}  ${True}
  ${value}=  Run Keyword And Expect Error  *  Можливість подати цінову пропозицію priceQuotation користувачем ${provider}
  ${value}=  Convert To Lowercase  ${value}
  Should Contain  ${value}  missing references for criterias


Неможливість подати пропозицію, якщо більше однієї характеристики знаходяться в різних групах, але в одній критерії
  [Tags]   ${USERS.users['${provider}'].broker}: Подання пропозиції
  ...      provider
  ...      ${USERS.users['${provider}'].broker}
  ...      impossible_make_bid
  ...      non-critical
  [Setup]  Дочекатись синхронізації з майданчиком  ${provider}
  Set Test Variable  ${BID_SAME_GROUPS_DIFFERENT_CRITERIA}  ${True}
  ${value}=  Run Keyword And Expect Error  *  Можливість подати цінову пропозицію priceQuotation користувачем ${provider}
  ${value}=  Convert To Lowercase  ${value}
  Should Contain  ${value}  conflicting in criteria


Неможливість подати пропозицію, якщо характеристика не відповідає вимозі
  [Tags]   ${USERS.users['${provider}'].broker}: Подання пропозиції
  ...      provider
  ...      ${USERS.users['${provider}'].broker}
  ...      impossible_make_bid
  ...      non-critical
  [Setup]  Дочекатись синхронізації з майданчиком  ${provider}
  Set Test Variable  ${BID_INVALID_EXPECTED_VALUE}  ${True}
  ${value}=  Run Keyword And Expect Error  *  Можливість подати цінову пропозицію priceQuotation користувачем ${provider}
  ${value}=  Convert To Lowercase  ${value}
  Should Contain  ${value}  does not match expected value


Можливість подати пропозицію першим учасником
  [Tags]   ${USERS.users['${provider}'].broker}: Подання пропозиції
  ...      provider
  ...      ${USERS.users['${provider}'].broker}
  ...      make_bid_by_provider  level1
  ...      critical
  [Setup]  Дочекатись дати початку прийому пропозицій  ${provider}  ${TENDER['TENDER_UAID']}
  [Teardown]  Оновити LAST_MODIFICATION_DATE
  Можливість подати цінову пропозицію priceQuotation користувачем ${provider}


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


Можливість змінити документацію цінової пропозиції першим учасником
  [Tags]   ${USERS.users['${provider}'].broker}: Подання пропозиції
  ...      provider
  ...      ${USERS.users['${provider}'].broker}
  ...      add_doc_to_bid_by_provider
  ...      critical
  [Teardown]  Оновити LAST_MODIFICATION_DATE
  Можливість змінити документацію цінової пропозиції користувачем ${provider}


Можливість подати пропозицію другим учасником
  [Tags]   ${USERS.users['${provider1}'].broker}: Подання пропозиції
  ...      provider1
  ...      ${USERS.users['${provider1}'].broker}
  ...      make_bid_by_provider1  level1
  ...      critical
  [Setup]  Дочекатись дати початку прийому пропозицій  ${provider1}  ${TENDER['TENDER_UAID']}
  [Teardown]  Оновити LAST_MODIFICATION_DATE
  Можливість подати цінову пропозицію priceQuotation користувачем ${provider1}


Можливість подати пропозицію третім учасником
  [Tags]   ${USERS.users['${provider1}'].broker}: Подання пропозиції
  ...      provider1
  ...      ${USERS.users['${provider1}'].broker}
  ...      make_bid_by_provider2  level1
  ...      critical
  [Setup]  Дочекатись дати початку прийому пропозицій  ${provider2}  ${TENDER['TENDER_UAID']}
  [Teardown]  Оновити LAST_MODIFICATION_DATE
  Можливість подати цінову пропозицію priceQuotation користувачем ${provider2}


Можливість дочекатись дати початку періоду кваліфікації
  [Tags]  ${USERS.users['${provider}'].broker}: Подання кваліфікації
  ...     provider
  ...     ${USERS.users['${provider}'].broker}
  ...     awardPeriod_startDate
  ...     critical
  [Teardown]  Оновити LAST_MODIFICATION_DATE
  Дочекатись дати початку періоду кваліфікації  ${provider}  ${TENDER['TENDER_UAID']}


Можливість завантажити документ рішення кваліфікаційної комісії для підтвердження постачальника
  [Tags]  ${USERS.users['${tender_owner}'].broker}: Процес кваліфікації
  ...  tender_owner
  ...  ${USERS.users['${tender_owner}'].broker}
  ...  qualification_add_doc_to_first_award
  ...  critical
  ${file_path}  ${file_name}  ${file_content}=   create_fake_doc
  Run As   ${tender_owner}   Завантажити документ рішення кваліфікаційної комісії   ${file_path}   ${TENDER['TENDER_UAID']}   0
  Remove File  ${file_path}


Неможливість кваліфікуватися замовником
  [Tags]  ${USERS.users['${tender_owner}'].broker}: Процес кваліфікації
  ...     tender_owner
  ...     ${USERS.users['${tender_owner}'].broker}
  ...     impossible_approve_first_award_by_customer
  ...     critical
  [Setup]  Дочекатись синхронізації з майданчиком  ${tender_owner}
  [Teardown]  Оновити LAST_MODIFICATION_DATE
  ${file_path}  ${file_name}  ${file_content}=   create_fake_doc
  Run Keyword And Expect Error  *  Run As  ${tender_owner}  Завантажити документ рішення кваліфікаційної комісії  ${file_path}  ${TENDER['TENDER_UAID']}  0
  Run Keyword And Expect Error  *  Run As  ${tender_owner}  Підтвердити постачальника  ${TENDER['TENDER_UAID']}  0
  Remove File  ${file_path}


Можливість дискваліфікуватися постачальником
  [Tags]  ${USERS.users['${tender_owner}'].broker}: Процес кваліфікації
  ...  provider
  ...  provider1
  ...  provider2
  ...  disqualification_first_award_by_provider
  ...  critical
  ${user}=  Пошук постачальника пропозиції з awards по індексу  0
  Run As  ${user}  Дискваліфікувати постачальника  ${TENDER['TENDER_UAID']}  0


Можливість дискваліфікації другого постачальника, якщо 2 дні не було підтвердження
  [Tags]  ${USERS.users['${tender_owner}'].broker}: Процес кваліфікації
  ...  tender_owner
  ...  ${USERS.users['${tender_owner}'].broker}
  ...  qualification_reject_second_award_after_2_days
  ...  critical
  Дочекатись зміни статусу рішення  ${tender_owner}  unsuccessful  1


Можливість кваліфікувати постачальником першої пропозиції
  [Tags]  ${USERS.users['${tender_owner}'].broker}: Процес кваліфікації
  ...  provider
  ...  provider1
  ...  provider2
  ...  qualification_approve_first_award_by_provider
  ...  critical
  [Setup]  Дочекатись синхронізації з майданчиком  ${tender_owner}
  [Teardown]  Оновити LAST_MODIFICATION_DATE
  ${user}=  Пошук постачальника пропозиції з awards по індексу  0
  Run As  ${user}  Підтвердити постачальника  ${TENDER['TENDER_UAID']}  0


Можливість кваліфікувати постачальником другої пропозиції
  [Tags]  ${USERS.users['${tender_owner}'].broker}: Процес кваліфікації
  ...  provider
  ...  provider1
  ...  provider2
  ...  qualification_approve_second_award_by_provider
  ...  critical
  [Setup]  Дочекатись синхронізації з майданчиком  ${tender_owner}
  [Teardown]  Оновити LAST_MODIFICATION_DATE
  ${user}=  Пошук постачальника пропозиції з awards по індексу  1
  Run As  ${user}  Підтвердити постачальника  ${TENDER['TENDER_UAID']}  1


Можливість кваліфікувати третього постачальника
  [Tags]  ${USERS.users['${tender_owner}'].broker}: Процес кваліфікації
  ...  provider
  ...  provider1
  ...  provider2
  ...  qualification_approve_third_award_by_provider
  ...  critical
  [Setup]  Дочекатись синхронізації з майданчиком  ${tender_owner}
  [Teardown]  Оновити LAST_MODIFICATION_DATE
  ${user}=  Пошук постачальника пропозиції з awards по індексу  2
  Run As  ${user}  Підтвердити постачальника  ${TENDER['TENDER_UAID']}  2


Неможливість відмовитися постачальником від третього підтвердження
  [Tags]  ${USERS.users['${tender_owner}'].broker}: Процес кваліфікації
  ...  provider
  ...  provider1
  ...  provider2
  ...  ${USERS.users['${tender_owner}'].broker}
  ...  impossible_cancel_3_award_qualification_by_provider
  ...  critical
  ${user}=  Пошук постачальника пропозиції з awards по індексу  2
  Run Keyword And Expect Error  *  Run As  ${user}  Скасування рішення кваліфікаційної комісії  ${TENDER['TENDER_UAID']}  2


Можливість відмовитися замовником від третього підтвердження
  [Tags]  ${USERS.users['${tender_owner}'].broker}: Процес кваліфікації
  ...  tender_owner
  ...  ${USERS.users['${tender_owner}'].broker}
  ...  qualification_cancel_3_award_qualification_by_customer
  ...  critical
  Run As  ${tender_owner}  Скасування рішення кваліфікаційної комісії  ${TENDER['TENDER_UAID']}  2


Неможливість повторно кваліфікувати постачальником четверте підтвердження
  [Tags]  ${USERS.users['${tender_owner}'].broker}: Процес кваліфікації
  ...  provider
  ...  provider1
  ...  provider2
  ...  impossible_approve_fourth_award_by_provider
  ...  critical
  [Setup]  Дочекатись синхронізації з майданчиком  ${tender_owner}
  [Teardown]  Оновити LAST_MODIFICATION_DATE
  ${user}=  Пошук постачальника пропозиції з awards по індексу  3
  Run Keyword And Expect Error  *  Run As  ${user}  Підтвердити постачальника  ${TENDER['TENDER_UAID']}  3


Можливість підтвердженя постачальника замовником
  [Tags]  ${USERS.users['${tender_owner}'].broker}: Процес кваліфікації
  ...     tender_owner
  ...     ${USERS.users['${tender_owner}'].broker}
  ...     qualification_approve_4_award_by_customer
  ...     critical
  [Setup]  Дочекатись синхронізації з майданчиком  ${tender_owner}
  [Teardown]  Оновити LAST_MODIFICATION_DATE
  ${file_path}  ${file_name}  ${file_content}=   create_fake_doc
  Run As  ${tender_owner}  Завантажити документ рішення кваліфікаційної комісії  ${file_path}  ${TENDER['TENDER_UAID']}  3
  Run As  ${tender_owner}  Підтвердити постачальника  ${TENDER['TENDER_UAID']}  3
  Remove File  ${file_path}


Можливість відмовитися замовником від четвертого підтвердження
  [Tags]  ${USERS.users['${tender_owner}'].broker}: Процес кваліфікації
  ...  tender_owner
  ...  ${USERS.users['${tender_owner}'].broker}
  ...  qualification_cancel_4_award_qualification_by_customer
  ...  critical
  Run As  ${tender_owner}  Скасування рішення кваліфікаційної комісії  ${TENDER['TENDER_UAID']}  3


Можливість відхилити постачальника замовником
  [Tags]  ${USERS.users['${tender_owner}'].broker}: Процес кваліфікації
  ...  tender_owner
  ...  ${USERS.users['${tender_owner}'].broker}
  ...  qualification_reject_fifth_award
  ...  critical
  Run As  ${tender_owner}  Дискваліфікувати постачальника  ${TENDER['TENDER_UAID']}  4


Відображення статусу завершення тендеру
  [Tags]   ${USERS.users['${viewer}'].broker}: Завершення тендера
  ...      viewer  tender_owner  provider  provider1
  ...      ${USERS.users['${viewer}'].broker}  ${USERS.users['${tender_owner}'].broker}
  ...      ${USERS.users['${provider}'].broker}  ${USERS.users['${provider1}'].broker}
  ...      unsuccefully_tender  level1
  ...      critical
  Дочекатись зміни статусу unsuccessful  ${viewer}  ${TENDER['TENDER_UAID']}


Відображення статусу завершення, якщо не було подано коректного профайлу
  [Tags]   ${USERS.users['${viewer}'].broker}: Завершення тендера
  ...      viewer  tender_owner  provider  provider1
  ...      ${USERS.users['${viewer}'].broker}  ${USERS.users['${tender_owner}'].broker}
  ...      ${USERS.users['${provider}'].broker}  ${USERS.users['${provider1}'].broker}
  ...      unsuccessfully_tender_verification_wrong_profile  level1
  ...      critical
  Дочекатися припинення процесу  ${viewer}  ${TENDER['TENDER_UAID']}


Відображення статусу завершення, якщо не було подано жодних пропозицій
  [Tags]   ${USERS.users['${viewer}'].broker}: Завершення тендера
  ...      viewer  tender_owner  provider  provider1
  ...      ${USERS.users['${viewer}'].broker}  ${USERS.users['${tender_owner}'].broker}
  ...      ${USERS.users['${provider}'].broker}  ${USERS.users['${provider1}'].broker}
  ...      unsuccefully_tender_without_bids  level1
  ...      critical
  Дочекатись зміни статусу unsuccessful  ${viewer}  ${TENDER['TENDER_UAID']}


Відображення вартості угоди без урахування ПДВ
  [Tags]   ${USERS.users['${viewer}'].broker}: Відображення основних даних угоди
  ...      viewer
  ...      ${USERS.users['${viewer}'].broker}
  ...      contract_view
  ...      non-critical
  [Setup]  Дочекатись синхронізації з майданчиком  ${viewer}
  ${contract_index}=  Отримати останній індекс  contracts  ${tender_owner}  ${viewer}
  ${award}=  Отримати останній элемент  awards  ${tender_owner}  ${viewer}
  Log  ${award}
  ${contract}=  Отримати останній элемент  contracts  ${tender_owner}  ${viewer}
  Log  ${contract}
  Log  ${award.value.amount}
  Звірити відображення поля contracts[${contract_index}].value.amountNet тендера із ${award.value.amount} для користувача ${viewer}


Відображення вартості угоди
  [Tags]   ${USERS.users['${viewer}'].broker}: Відображення основних даних угоди
  ...      viewer
  ...      ${USERS.users['${viewer}'].broker}
  ...      contract_view
  ...      non-critical
  [Setup]  Дочекатись синхронізації з майданчиком  ${viewer}
  ${contract_index}=  Отримати останній індекс  contracts  ${tender_owner}  ${viewer}
  ${award}=  Отримати останній элемент  awards  ${tender_owner}  ${viewer}
  Log  ${award}
  ${contract}=  Отримати останній элемент  contracts  ${tender_owner}  ${viewer}
  Log  ${contract}
  Log  ${award.value.amount}
  Звірити відображення поля contracts[${contract_index}].value.amount тендера із ${award.value.amount} для користувача ${viewer}


Неможливість зменшити ціну договору без ПДВ на суму більшу за 20% від ціни договору з ПДВ (закупівля з ПДВ)
# contract:value:amountNet can be <= contract:value:amount but no more than on contract:value:amount/1.2 if valueAddedTaxIncluded=ture
# lots:value:valueAddedTaxIncluded:true - contract:value:valueAddedTaxIncluded:true
  [Tags]   ${USERS.users['${tender_owner}'].broker}: Редагування угоди
  ...      tender_owner
  ...      ${USERS.users['${tender_owner}'].broker}
  ...      modify_contract_invalid_amountNet_tender_vat_true
  ...      critical
  [Setup]  Дочекатись синхронізації з майданчиком  ${tender_owner}
  ${award}=  Отримати останній элемент  awards  ${tender_owner}  ${viewer}
  ${contract_index}=  Отримати останній індекс  contracts  ${tender_owner}  ${viewer}
  ${invalid_amountNet}=  Evaluate  ${award.value.amount} / 2
  ${value}=  Require Failure  ${tender_owner}  Редагувати угоду
  ...      ${TENDER['TENDER_UAID']}
  ...      ${contract_index}
  ...      value.amountNet
  ...      ${invalid_amountNet}
  Should Contain  ${value}  Amount should be greater than amountNet and differ by no more than 20.0%


Можливість редагувати вартість угоди без урахування ПДВ
  [Tags]   ${USERS.users['${tender_owner}'].broker}: Редагування угоди
  ...      tender_owner
  ...      ${USERS.users['${tender_owner}'].broker}
  ...      modify_contract_amount_net
  ...      critical
  [Setup]  Дочекатись синхронізації з майданчиком  ${tender_owner}
  [Teardown]  Оновити LAST_MODIFICATION_DATE
  ${award}=  Отримати останній элемент  awards  ${tender_owner}  ${viewer}
  ${contract}=  Отримати останній элемент  contracts  ${tender_owner}  ${viewer}
  ${amount_net}=  create_fake_amount_net  ${award.value.amount}  ${award.value.valueAddedTaxIncluded}  ${contract.value.valueAddedTaxIncluded}
  ${contract_index}=  Отримати останній індекс  contracts  ${tender_owner}  ${viewer}
  Set to dictionary  ${USERS.users['${tender_owner}']}  new_amount_net=${amount_net}
  Run As  ${tender_owner}  Редагувати угоду
  ...      ${TENDER['TENDER_UAID']}
  ...      ${contract_index}
  ...      value.amountNet
  ...      ${amount_net}


Відображення відредагованої вартості угоди без урахування ПДВ
  [Tags]   ${USERS.users['${viewer}'].broker}: Відображення основних даних угоди
  ...      viewer
  ...      ${USERS.users['${viewer}'].broker}  ${USERS.users['${tender_owner}'].broker}
  ...      contract_view_new_amountNet
  ...      non-critical
  [Setup]  Дочекатись синхронізації з майданчиком  ${viewer}
  ${amount_net}=  Get Variable Value  ${USERS.users['${tender_owner}'].new_amount_net}
  ${contract_index}=  Отримати останній індекс  contracts  ${tender_owner}  ${viewer}
  ${amount_net_field}=  Set Variable  contracts[${contract_index}].value.amountNet
  Звірити відображення поля ${amount_net_field} тендера із ${amount_net} для користувача ${viewer}


Можливість редагувати вартість угоди
  ${viewer_data}=  Get From Dictionary  ${USERS.users}  ${viewer}
  ${tender_owner_data}=  Get From Dictionary  ${USERS.users}  ${tender_owner}
  [Tags]   ${tender_owner_data.broker}: Редагування угоди
  ...      tender_owner
  ...      ${tender_owner_data.broker}
  ...      modify_contract_value
  ...      critical
  [Setup]  Дочекатись синхронізації з майданчиком  ${tender_owner}
  [Teardown]  Оновити LAST_MODIFICATION_DATE
  ${award}=  Отримати останній элемент  awards  ${tender_owner}  ${viewer}
  ${contract}=  Отримати останній элемент  contracts  ${tender_owner}  ${viewer}
  ${amount}=  create_fake_amount  ${award.value.amount}  ${award.value.valueAddedTaxIncluded}  ${contract.value.valueAddedTaxIncluded}
  ${contract_index}=  Отримати останній індекс  contracts  ${tender_owner}  ${viewer}
  Set to dictionary  ${USERS.users['${tender_owner}']}  new_amount=${amount}
  Run As  ${tender_owner}  Редагувати угоду
  ...      ${TENDER['TENDER_UAID']}
  ...      ${contract_index}
  ...      value.amount
  ...      ${amount}


Відображення відредагованої вартості угоди
  [Tags]   ${USERS.users['${viewer}'].broker}: Відображення основних даних угоди
  ...      viewer
  ...      ${USERS.users['${viewer}'].broker} ${USERS.users['${tender_owner}'].broker}
  ...      contract_view_new_amount
  ...      non-critical
  [Setup]  Дочекатись синхронізації з майданчиком  ${viewer}
  ${amount}=  Get Variable Value  ${USERS.users['${tender_owner}'].new_amount}
  ${contract_index}=  Отримати останній індекс  contracts  ${tender_owner}  ${viewer}
  ${amount_field}=  Set Variable  contracts[${contract_index}].value.amount
  Звірити відображення поля ${amount_field} тендера із ${amount} для користувача ${viewer}


Неможливість вказати ціну договору з ПДВ більше ніж результат проведення аукціону
# contract:value:amount should be <= award.value.amount if valueAddedTaxIncluded=ture
# lots:value:valueAddedTaxIncluded:true - contract:value:valueAddedTaxIncluded:true
# lots:value:valueAddedTaxIncluded:true - contract:value:valueAddedTaxIncluded:false
# lots:value:valueAddedTaxIncluded:false - contract:value:valueAddedTaxIncluded:false
  [Tags]   ${USERS.users['${tender_owner}'].broker}: Редагування угоди
  ...      tender_owner
  ...      ${USERS.users['${tender_owner}'].broker}
  ...      modify_contract_invalid_amount
  ...      critical
  [Setup]  Дочекатись синхронізації з майданчиком  ${tender_owner}
  ${award}=  Отримати останній элемент  awards  ${tender_owner}  ${viewer}
  ${contract}=  Отримати останній элемент  contracts  ${tender_owner}  ${viewer}
  ${contract_index}=  Отримати останній індекс  contracts  ${tender_owner}  ${viewer}
  ${amount}=  Evaluate  ${award.value.amount} * 2
  ${value}=  Require Failure  ${tender_owner}  Редагувати угоду
  ...      ${TENDER['TENDER_UAID']}
  ...      ${contract_index}
  ...      value.amount
  ...      ${amount}
  Run Keyword IF  '${award.value.valueAddedTaxIncluded}' == '${True}' and '${contract.value.valueAddedTaxIncluded}' == '${True}' and '${MODE}' == 'open_esco'
  ...      Should Contain  ${value}  Can't update amount for contract value
  ...      ELSE
  ...      Should Contain  ${value}  Amount should be less or equal to awarded amount
  Run Keyword IF  '${award.value.valueAddedTaxIncluded}' == '${True}' and '${contract.value.valueAddedTaxIncluded}' == '${False}'
  ...      Should Contain  ${value}  Amount should be less or equal to awarded amount
  Run Keyword IF  '${award.value.valueAddedTaxIncluded}' == '${False}' and '${contract.value.valueAddedTaxIncluded}' == '${False}'
  ...      Should Contain  ${value}  Amount should be less or equal to awarded amount


Можливість встановити дату підписання угоди
  [Tags]   ${USERS.users['${tender_owner}'].broker}: Редагування угоди
  ...      tender_owner
  ...      ${USERS.users['${tender_owner}'].broker}
  ...      modify_contract
  ...      critical
  [Setup]  Дочекатись синхронізації з майданчиком  ${tender_owner}
  [Teardown]  Оновити LAST_MODIFICATION_DATE
  ${contract_index}=  Отримати останній індекс  contracts  ${tender_owner}  ${viewer}
  ${dateSigned}=  create_fake_date
  Set to dictionary  ${USERS.users['${tender_owner}']}  dateSigned=${dateSigned}
  Run As  ${tender_owner}  Встановити дату підписання угоди  ${TENDER['TENDER_UAID']}  ${contract_index}  ${dateSigned}


Можливість вказати період дії угоди
  [Tags]   ${USERS.users['${tender_owner}'].broker}: Редагування угоди
  ...      tender_owner
  ...      ${USERS.users['${tender_owner}'].broker}
  ...      modify_contract
  ...      critical
  [Setup]  Дочекатись синхронізації з майданчиком  ${tender_owner}
  [Teardown]  Оновити LAST_MODIFICATION_DATE
  ${contract_index}=  Отримати останній індекс  contracts  ${tender_owner}  ${viewer}
  ${startDate}=  create_fake_date
  ${endDate}=  add_minutes_to_date  ${startDate}  10
  Set to dictionary  ${USERS.users['${tender_owner}']}  contract_startDate=${startDate}  contract_endDate=${endDate}
  Run As  ${tender_owner}  Вказати період дії угоди  ${TENDER['TENDER_UAID']}  ${contract_index}  ${startDate}  ${endDate}


Можливість укласти угоду для закупівлі
  [Tags]   ${USERS.users['${tender_owner}'].broker}: Процес укладання угоди
  ...      tender_owner
  ...      ${USERS.users['${tender_owner}'].broker}
  ...      contract_sign  level1
  ...      critical
  [Setup]  Дочекатись синхронізації з майданчиком  ${tender_owner}
  [Teardown]  Оновити LAST_MODIFICATION_DATE
  ${contract_index}=  Отримати останній індекс  contracts  ${tender_owner}  ${viewer}
  Run As  ${tender_owner}  Підтвердити підписання контракту  ${TENDER['TENDER_UAID']}  ${contract_index}


Відображення статусу підписаної угоди з постачальником закупівлі
  [Tags]   ${USERS.users['${viewer}'].broker}: Відображення основних даних угоди
  ...      viewer
  ...      ${USERS.users['${viewer}'].broker}
  ...      contract_sign
  ...      critical
  [Setup]  Дочекатись синхронізації з майданчиком  ${viewer}
  ${contract_index}=  Отримати останній індекс  contracts  ${tender_owner}  ${viewer}
  Run As  ${viewer}  Оновити сторінку з тендером  ${TENDER['TENDER_UAID']}
  Звірити відображення поля contracts[${contract_index}].status тендера із active для користувача ${viewer}


Можливість знайти закупівлю по ідентифікатору
  [Tags]   ${USERS.users['${viewer}'].broker}: Пошук тендера
  ...      ${USERS.users['${tender_owner}'].broker}: Пошук тендера
  ...      viewer  tender_owner
  ...      ${USERS.users['${viewer}'].broker}  ${USERS.users['${tender_owner}'].broker}
  ...      find_tender_contract
  ${contract_index}=  Отримати останній індекс  contracts  ${tender_owner}  ${viewer}
  ${CONTRACT_UAID}=  Get variable value  ${USERS.users['${tender_owner}'].tender_data.data.contracts[${contract_index}].contractID}
  Set Suite Variable  ${CONTRACT_UAID}


Можливість знайти договір по ідентифікатору
  [Tags]   ${USERS.users['${viewer}'].broker}: Пошук договору
  ...      ${USERS.users['${tender_owner}'].broker}: Пошук договору
  ...      viewer  tender_owner
  ...      ${USERS.users['${viewer}'].broker}  ${USERS.users['${tender_owner}'].broker}
  ...      find_contract
  :FOR  ${username}  IN  @{used_roles}
  \  Run As  ${${username}}  Пошук договору по ідентифікатору  ${CONTRACT_UAID}


Можливість отримати доступ до договору
  [Tags]   ${USERS.users['${tender_owner}'].broker}: Отримання прав доступу до договору
  ...      tender_owner
  ...      ${USERS.users['${tender_owner}'].broker}
  ...      access_contract
  Run As  ${tender_owner}  Отримати доступ до договору  ${CONTRACT_UAID}


Можливість внести зміну до умов договору
  [Tags]   ${USERS.users['${tender_owner}'].broker}: Внесення зміни
  ...      tender_owner
  ...      ${USERS.users['${tender_owner}'].broker}
  ...      submit_change
  [Teardown]  Оновити LAST_MODIFICATION_DATE
  ${change_data}=  Підготувати дані про зміну до договору  ${tender_owner}
  Run As  ${tender_owner}  Внести зміну в договір  ${CONTRACT_UAID}  ${change_data}


Відображення опису причини зміни договору
  [Tags]   ${USERS.users['${viewer}'].broker}: Відображення зміни договору
  ...      tender_owner
  ...      ${USERS.users['${viewer}'].broker}
  ...      view_change
  [Setup]  Дочекатись синхронізації з майданчиком  ${viewer}
  Звірити відображення поля rationale зміни до договору для користувача ${viewer}


Відображення причин зміни договору
  [Tags]   ${USERS.users['${viewer}'].broker}: Відображення зміни договору
  ...      tender_owner
  ...      ${USERS.users['${viewer}'].broker}
  ...      view_change
  Звірити відображення причин зміни договору


Відображення непідтвердженого статусу зміни договору
  [Tags]   ${USERS.users['${viewer}'].broker}: Відображення зміни договору
  ...      tender_owner
  ...      ${USERS.users['${viewer}'].broker}
  ...      view_change
  Звірити поле зміни до договору із значенням
  ...      ${viewer}
  ...      ${CONTRACT_UAID}
  ...      pending
  ...      status


Можливість додати документацію до зміни договору
  [Tags]   ${USERS.users['${tender_owner}'].broker}: Редагування договору
  ...      tender_owner
  ...      ${USERS.users['${tender_owner}'].broker}
  ...      upload_change_document
  [Teardown]  Оновити LAST_MODIFICATION_DATE
  Додати документацію до зміни договору


Відображення заголовку документації до зміни договору
  [Tags]   ${USERS.users['${viewer}'].broker}: Відображення документації
  ...      viewer
  ...      ${USERS.users['${viewer}'].broker}
  ...      upload_change_document
  [Setup]  Дочекатись синхронізації з майданчиком  ${viewer}
  Звірити відображення поля title документа ${USERS.users['${tender_owner}']['change_doc']['id']} до договору з ${USERS.users['${tender_owner}']['change_doc']['name']} для користувача ${viewer}


Відображення вмісту документації до зміни договору
  [Tags]   ${USERS.users['${viewer}'].broker}: Відображення документації
  ...      viewer
  ...      ${USERS.users['${viewer}'].broker}
  ...      upload_change_document
  Звірити відображення вмісту документа ${USERS.users['${tender_owner}']['change_doc']['id']} до договору з ${USERS.users['${tender_owner}']['change_doc']['content']} для користувача ${viewer}


Можливість редагувати опис причини зміни договору
  [Tags]   ${USERS.users['${tender_owner}'].broker}: Редагування зміни
  ...      tender_owner
  ...      ${USERS.users['${tender_owner}'].broker}
  ...      modify_change
  [Teardown]  Оновити LAST_MODIFICATION_DATE
  ${new_rationale}=  create_fake_sentence
  Set to dictionary  ${USERS.users['${tender_owner}']}  new_rationale=${new_rationale}
  Run As  ${tender_owner}  Редагувати зміну  ${CONTRACT_UAID}  rationale  ${new_rationale}


Можливість редагувати вартість договору без ПДВ
  [Tags]   ${USERS.users['${tender_owner}']}: Редагування договору
  ...      tender_owner
  ...      ${USERS.users['${tender_owner}']}
  ...      change_contract_amountNet
  [Teardown]  Оновити LAST_MODIFICATION_DATE
  ${award}=  Отримати останній элемент  awards  ${tender_owner}  ${viewer}
  ${amount_net}=  create_fake_amount_net
  ...      ${USERS.users['${tender_owner}'].contract_data.data.value.amount}
  ...      ${award.value.valueAddedTaxIncluded}
  ...      ${USERS.users['${tender_owner}'].contract_data.data.value.valueAddedTaxIncluded}
  Set to dictionary  ${USERS.users['${tender_owner}']}  new_amount_net=${amount_net}
  Run As  ${tender_owner}  Редагувати поле договору  ${CONTRACT_UAID}  value.amountNet  ${amount_net}


Можливість редагувати вартість договору
  [Tags]   ${USERS.users['${tender_owner}']}: Редагування договору
  ...      tender_owner
  ...      ${USERS.users['${tender_owner}']}
  ...      change_contract_amount
  [Teardown]  Оновити LAST_MODIFICATION_DATE
  ${award}=  Отримати останній элемент  awards  ${tender_owner}  ${viewer}
  ${amount}=  create_fake_amount
  ...      ${USERS.users['${tender_owner}'].contract_data.data.value.amount}
  ...      ${award.value.valueAddedTaxIncluded}
  ...      ${USERS.users['${tender_owner}'].contract_data.data.value.valueAddedTaxIncluded}
  Set to dictionary  ${USERS.users['${tender_owner}']}  new_amount=${amount}
  Run As  ${tender_owner}  Редагувати поле договору  ${CONTRACT_UAID}  value.amount  ${amount}


Можливість застосувати зміну договору
  [Tags]   ${USERS.users['${tender_owner}'].broker}: Редагування договору
  ...      tender_owner
  ...      ${USERS.users['${tender_owner}'].broker}
  ...      apply_change
  [Teardown]  Оновити LAST_MODIFICATION_DATE
  [Setup]  Дочекатись синхронізації з майданчиком  ${tender_owner}
  ${dateSigned}=  create_fake_date
  Run As  ${tender_owner}  Застосувати зміну  ${CONTRACT_UAID}  ${dateSigned}
  Set to dictionary  ${USERS.users['${tender_owner}'].change_data.data}  status=active


Відображення підтвердженого статусу зміни договору
  [Tags]   ${USERS.users['${viewer}'].broker}: Відображення зміни договору
  ...      tender_owner
  ...      ${USERS.users['${viewer}'].broker}
  ...      apply_change
  [Setup]  Дочекатись синхронізації з майданчиком  ${viewer}
  Delete From Dictionary  ${USERS.users['${viewer}'].contract_data.data.changes[0]}  status
  Звірити поле зміни до договору із значенням
  ...      ${viewer}
  ...      ${CONTRACT_UAID}
  ...      active
  ...      status


Можливість завантажити документацію до договору
  [Tags]   ${USERS.users['${tender_owner}'].broker}: Додання документації до договору
  ...      tender_owner
  ...      ${USERS.users['${tender_owner}'].broker}
  ...      add_contract_doc
  [Teardown]  Оновити LAST_MODIFICATION_DATE
  Додати документацію до договору


Відображення заголовку документації до договору
  [Tags]   ${USERS.users['${viewer}'].broker}: Відображення документації
  ...      viewer
  ...      ${USERS.users['${viewer}'].broker}
  ...      add_contract_doc
  [Setup]  Дочекатись синхронізації з майданчиком  ${viewer}
  Звірити відображення поля title документа ${USERS.users['${tender_owner}']['contract_doc']['id']} до договору з ${USERS.users['${tender_owner}']['contract_doc']['name']} для користувача ${viewer}


Відображення вмісту документації до договору
  [Tags]   ${USERS.users['${viewer}'].broker}: Відображення документації
  ...      viewer
  ...      ${USERS.users['${viewer}'].broker}
  ...      add_contract_doc
  Звірити відображення вмісту документа ${USERS.users['${tender_owner}']['contract_doc']['id']} до договору з ${USERS.users['${tender_owner}']['contract_doc']['content']} для користувача ${viewer}


Відображення належності документа до договору
  [Tags]   ${USERS.users['${viewer}'].broker}: Відображення документації
  ...      viewer
  ...      ${USERS.users['${viewer}'].broker}
  ...      add_contract_doc
  Звірити відображення поля documentOf документа ${USERS.users['${tender_owner}']['contract_doc']['id']} до договору з contract для користувача ${viewer}


Відображення статусу успішного завершення тендера
  [Tags]   ${USERS.users['${viewer}'].broker}: Відображення основних даних угоди
  ...      viewer
  ...      ${USERS.users['${viewer}'].broker}
  ...      agreement_registration
  ...      critical
  [Setup]  Дочекатись синхронізації з майданчиком  ${viewer}
  Звірити відображення поля status тендера із complete для користувача ${viewer}


Можливість скасувати тендер
  [Tags]  ${USERS.users['${tender_owner}'].broker}: Скасування тендера
  ...  tender_owner
  ...  ${USERS.users['${tender_owner}'].broker}
  ...  tender_cancellation
  [Teardown]  Оновити LAST_MODIFICATION_DATE
  Можливість скасувати тендер


Відображення активного статусу скасування тендера
  [Tags]  ${USERS.users['${viewer}'].broker}: Відображення скасування тендера
  ...  viewer
  ...  ${USERS.users['${viewer}'].broker}
  ...  tender_cancellation
  [Setup]  Дочекатись синхронізації з майданчиком  ${viewer}
  ${cancellation_index}=  Отримати останній індекс  cancellations  ${tender_owner}  ${viewer}
  Звірити поле тендера із значенням  ${viewer}  ${TENDER['TENDER_UAID']}
  ...      active
  ...      cancellations[${cancellation_index}].status


Відображення причини скасування тендера
  [Tags]  ${USERS.users['${viewer}'].broker}: Відображення скасування тендера
  ...  viewer
  ...  ${USERS.users['${viewer}'].broker}
  ...  tender_cancellation
  ${cancellation_index}=  Отримати останній індекс  cancellations  ${tender_owner}  ${viewer}
  Звірити поле тендера із значенням  ${viewer}  ${TENDER['TENDER_UAID']}
  ...      ${USERS.users['${tender_owner}']['tender_cancellation_data']['cancellation_reason']}
  ...      cancellations[${cancellation_index}].reason


Відображення опису документа до скасування тендера
  [Tags]  ${USERS.users['${viewer}'].broker}: Відображення скасування тендера
  ...  viewer
  ...  ${USERS.users['${viewer}'].broker}
  ...  tender_cancellation
  Звірити відображення поля description документа ${USERS.users['${tender_owner}']['tender_cancellation_data']['document']['doc_id']} до скасування ${USERS.users['${tender_owner}']['tender_cancellation_data']['cancellation_id']} із ${USERS.users['${tender_owner}']['tender_cancellation_data']['description']} для користувача ${viewer}


*** Keywords ***
Пошук постачальника пропозиції з awards по індексу
    [Arguments]  ${index}
    :FOR  ${user_role}  IN  @{USED_PROVIDERS}
    \  ${user_name}=  Get Variable Value  ${BROKERS['${BROKER}'].roles['${user_role}']}
    \  ${bid_id}=  Отримати дані із тендера  ${user_name}  ${TENDER['TENDER_UAID']}  awards[${index}].bid_id
    \  ${bid_id_by_user}=  Get Variable Value  ${USERS.users['${user_name}'].bidresponses.bid.data.id}
    \  Exit For Loop If  '${bid_id}' == '${bid_id_by_user}'
    [Return]  ${user_name}


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


Звірити відображення поля ${field} документа ${doc_id} до скасування ${cancel_id} із ${left} для користувача ${username}
  ${right}=  Run As  ${username}  Отримати інформацію із документа до скасування  ${TENDER['TENDER_UAID']}  ${cancel_id}  ${doc_id}  ${field}
  Порівняти об'єкти  ${left}  ${right}
