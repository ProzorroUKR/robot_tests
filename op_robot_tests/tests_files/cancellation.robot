*** Settings ***
Resource        base_keywords.robot
Resource        aboveThreshold_keywords.robot
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


Можливість оголосити тендер другого етапу
  [Tags]   ${USERS.users['${tender_owner}'].broker}: Оголошення тендера
  ...      tender_owner
  ...      ${USERS.users['${tender_owner}'].broker}
  ...      create_tender_stage2
  ...      critical
  [Teardown]  Оновити LAST_MODIFICATION_DATE
  Завантажити дані про тендер
  Можливість оголосити тендер другого етапу


Можливість знайти тендер по ідентифікатору для замовника
  [Tags]   ${USERS.users['${tender_owner}'].broker}: Пошук тендера
  ...      tender_owner
  ...      ${USERS.users['${tender_owner}'].broker}
  ...      find_tender_tender_owner
  ...      critical
  [Setup]  Дочекатись синхронізації з майданчиком  ${tender_owner}
  Можливість знайти тендер по ідентифікатору для користувача ${tender_owner}


Можливість знайти тендер по ідентифікатору
  [Tags]   ${USERS.users['${viewer}'].broker}: Пошук тендера
  ...      viewer  tender_owner  provider  provider1
  ...      ${USERS.users['${viewer}'].broker}  ${USERS.users['${tender_owner}'].broker}
  ...      ${USERS.users['${provider}'].broker}  ${USERS.users['${provider1}'].broker}
  ...      find_tender
  ...      critical
  Можливість знайти тендер по ідентифікатору для усіх користувачів


Можливість подати пропозицію першим учасником
  [Tags]  ${USERS.users['${provider}'].broker}: Подання пропозиції
  ...     provider
  ...     ${USERS.users['${provider}'].broker}
  ...     make_bid_by_provider
  ...     critical
  [Setup]  Дочекатись дати початку прийому пропозицій  ${provider}  ${TENDER['TENDER_UAID']}
  [Teardown]  Оновити LAST_MODIFICATION_DATE
  Можливість подати цінову пропозицію користувачем ${provider}


Можливість подати пропозицію першим учасником 2 етап рамкової угоди
  [Tags]   ${USERS.users['${provider}'].broker}: Подання пропозиції
  ...      provider
  ...      ${USERS.users['${provider}'].broker}
  ...      selection_make_bid_by_provider
  ...      critical
  [Setup]  Дочекатись дати початку прийому пропозицій  ${provider}  ${TENDER['TENDER_UAID']}
  [Teardown]  Оновити LAST_MODIFICATION_DATE
  Можливість подати цінову пропозицію на другому етапі рамкової угоди користувачем  ${provider}  ${0}


Можливість подати пропозицію другим учасником
  [Tags]  ${USERS.users['${provider1}'].broker}: Подання пропозиції
  ...     provider1
  ...     ${USERS.users['${provider1}'].broker}
  ...     make_bid_by_provider1
  ...     critical
  [Setup]  Дочекатись дати початку прийому пропозицій  ${provider1}  ${TENDER['TENDER_UAID']}
  [Teardown]  Оновити LAST_MODIFICATION_DATE
  Можливість подати цінову пропозицію користувачем ${provider1}


Можливість подати пропозицію другим учасником 2 етап рамкової угоди
  [Tags]   ${USERS.users['${provider1}'].broker}: Подання пропозиції
  ...      provider1
  ...      ${USERS.users['${provider1}'].broker}
  ...      selection_make_bid_by_provider1
  ...      critical
  [Setup]  Дочекатись дати початку прийому пропозицій  ${provider1}  ${TENDER['TENDER_UAID']}
  [Teardown]  Оновити LAST_MODIFICATION_DATE
  Можливість подати цінову пропозицію на другому етапі рамкової угоди користувачем  ${provider1}  ${1}


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
#             PRE-QUALIFICATION
##############################################################################################

Дочекатись початку періоду пре-кваліфікації
  [Tags]   ${USERS.users['${tender_owner}'].broker}: Очікування початку періоду пре-кваліфікації учасників
  ...      tender_owner
  ...      ${USERS.users['${tender_owner}'].broker}
  ...      wait_active_pre-qualification_start
  Дочекатись дати початку періоду прекваліфікації  ${tender_owner}  ${TENDER['TENDER_UAID']}


Відображення статусу першої пропозиції кваліфікації
  [Tags]   ${USERS.users['${tender_owner}'].broker}: Кваліфікація
  ...      tender_owner
  ...      ${USERS.users['${tender_owner}'].broker}
  ...      pre-qualification_view
  ...      non-critical
  [Setup]  Дочекатись дати початку періоду прекваліфікації  ${tender_owner}  ${TENDER['TENDER_UAID']}
  Звірити відображення поля qualifications[0].status тендера із pending для користувача ${tender_owner}


Відображення статусу другої пропозиції кваліфікації
  [Tags]   ${USERS.users['${tender_owner}'].broker}: Кваліфікація
  ...      tender_owner
  ...      ${USERS.users['${tender_owner}'].broker}
  ...      pre-qualification_view
  ...      non-critical
  [Setup]  Дочекатись дати початку періоду прекваліфікації  ${tender_owner}  ${TENDER['TENDER_UAID']}
  Звірити відображення поля qualifications[1].status тендера із pending для користувача ${tender_owner}


Відображення статусу третьої пропозиції кваліфікації
  [Tags]   ${USERS.users['${tender_owner}'].broker}: Кваліфікація
  ...      tender_owner
  ...      ${USERS.users['${tender_owner}'].broker}
  ...      pre-qualification_view
  ...      non-critical
  [Setup]  Дочекатись дати початку періоду прекваліфікації  ${tender_owner}  ${TENDER['TENDER_UAID']}
  Звірити відображення поля qualifications[2].status тендера із pending для користувача ${tender_owner}


Можливість підтвердити першу пропозицію кваліфікації
  [Tags]   ${USERS.users['${tender_owner}'].broker}: Кваліфікація
  ...      tender_owner
  ...      ${USERS.users['${tender_owner}'].broker}
  ...      pre-qualification_approve_first_bid  level1
  ...      critical
  [Setup]  Дочекатись дати початку періоду прекваліфікації  ${tender_owner}  ${TENDER['TENDER_UAID']}
  [Teardown]  Оновити LAST_MODIFICATION_DATE
  Можливість підтвердити 0 пропозицію кваліфікації


Можливість підтвердити другу пропозицію кваліфікації
  [Tags]   ${USERS.users['${tender_owner}'].broker}: Кваліфікація
  ...      tender_owner
  ...      ${USERS.users['${tender_owner}'].broker}
  ...      pre-qualification_approve_second_bid  level1
  ...      critical
  [Teardown]  Оновити LAST_MODIFICATION_DATE
  Можливість підтвердити 1 пропозицію кваліфікації


Можливість підтвердити третю пропозицію кваліфікації
  [Tags]   ${USERS.users['${tender_owner}'].broker}: Кваліфікація
  ...      tender_owner
  ...      ${USERS.users['${tender_owner}'].broker}
  ...      pre-qualification_approve_third_bid  level1
  ...      critical
  [Teardown]  Оновити LAST_MODIFICATION_DATE
  Можливість підтвердити 2 пропозицію кваліфікації


Можливість підтвердити четверту пропозицію кваліфікації
  [Tags]   ${USERS.users['${tender_owner}'].broker}: Кваліфікація
  ...      tender_owner
  ...      ${USERS.users['${tender_owner}'].broker}
  ...      pre-qualification_approve_fourth_bid  level1
  ...      critical
  [Teardown]  Оновити LAST_MODIFICATION_DATE
  Можливість підтвердити 3 пропозицію кваліфікації


Можливість підтвердити п'яту пропозицію кваліфікації
  [Tags]   ${USERS.users['${tender_owner}'].broker}: Кваліфікація
  ...      tender_owner
  ...      ${USERS.users['${tender_owner}'].broker}
  ...      pre-qualification_approve_fifth_bid  level1
  ...      critical
  [Teardown]  Оновити LAST_MODIFICATION_DATE
  Можливість підтвердити 4 пропозицію кваліфікації


Можливість підтвердити шосту пропозицію кваліфікації
  [Tags]   ${USERS.users['${tender_owner}'].broker}: Кваліфікація
  ...      tender_owner
  ...      ${USERS.users['${tender_owner}'].broker}
  ...      pre-qualification_approve_sixth_bid  level1
  ...      critical
  [Teardown]  Оновити LAST_MODIFICATION_DATE
  Можливість підтвердити 5 пропозицію кваліфікації


Можливість затвердити остаточне рішення кваліфікації
  [Tags]   ${USERS.users['${tender_owner}'].broker}: Кваліфікація
  ...      tender_owner
  ...      ${USERS.users['${tender_owner}'].broker}
  ...      pre-qualification_approve_qualifications  level1
  ...      critical
  [Setup]  Дочекатись синхронізації з майданчиком  ${tender_owner}
  [Teardown]  Оновити LAST_MODIFICATION_DATE
  Можливість затвердити остаточне рішення кваліфікації


Відображення статусу блокування перед початком аукціону
  [Tags]   ${USERS.users['${tender_owner}'].broker}: Кваліфікація
  ...      tender_owner
  ...      ${USERS.users['${tender_owner}'].broker}
  ...      pre-qualification_view
  ...      non-critical
  [Setup]  Дочекатись синхронізації з майданчиком  ${tender_owner}
  Звірити статус тендера  ${tender_owner}  ${TENDER['TENDER_UAID']}  active.pre-qualification.stand-still


Відображення дати закінчення періоду блокування перед початком аукціону
  [Tags]   ${USERS.users['${tender_owner}'].broker}: Кваліфікація
  ...      tender_owner
  ...      ${USERS.users['${tender_owner}'].broker}
  ...      pre-qualification_view
  ...      non-critical
  [Teardown]  Дочекатись дати закінчення періоду прекваліфікації  ${tender_owner}  ${TENDER['TENDER_UAID']}
  Отримати дані із поля qualificationPeriod.endDate тендера для усіх користувачів

##############################################################################################
#             SECOND STAGE
##############################################################################################

Можливість дочекатися початку періоду очікування
  [Tags]   ${USERS.users['${tender_owner}'].broker}: Процес очікування оскаржень
  ...      tender_owner
  ...      ${USERS.users['${tender_owner}'].broker}
  ...      stage2_pending_status_view
  ...      critical
  Отримати дані із поля qualificationPeriod.endDate тендера для усіх користувачів
  Дочекатись дати закінчення періоду прекваліфікації  ${tender_owner}  ${TENDER['TENDER_UAID']}
  Звірити статус тендера  ${tender_owner}  ${TENDER['TENDER_UAID']}  active.stage2.pending


Можливість перевести тендер в статус очікування обробки мостом
  [Tags]   ${USERS.users['${tender_owner}'].broker}: Процес переведення статусу у active.stage2.waiting.
  ...      tender_owner
  ...      ${USERS.users['${tender_owner}'].broker}
  ...      stage2_pending_status_view
  ...      critical
  [Setup]  Дочекатись синхронізації з майданчиком  ${tender_owner}
  [Teardown]  Оновити LAST_MODIFICATION_DATE
  Можливість перевести тендер на статус очікування обробки мостом


Можливість дочекатися завершення роботи мосту
  [Tags]   ${USERS.users['${viewer}'].broker}: Процес очікування обробки мостом
  ...      viewer
  ...      ${USERS.users['${viewer}'].broker}
  ...      wait_bridge_for_work
  ...      critical
  Дочекатися створення нового етапу мостом  ${tender_owner}  ${TENDER['TENDER_UAID']}
  Звірити статус тендера  ${tender_owner}  ${TENDER['TENDER_UAID']}  complete


Можливість активувати тендер другого етапу
  [Tags]   ${USERS.users['${viewer}'].broker}: Активувати тендер другого етапу
  ...      tender_owner
  ...      ${USERS.users['${tender_owner}'].broker}
  ...      activate_second_stage
  ...      critical
  [Setup]  Дочекатись синхронізації з майданчиком  ${tender_owner}
  Активувати тендер другого етапу


Можливість знайти тендер другого етапу по ідентифікатору для усіх користувачів
  [Tags]   ${USERS.user['${tender_owner}'].broker}: Пошук тендера другого етапу
  ...      viewer  tender_owner  provider  provider1
  ...      ${USERS.users['${viewer}'].broker}  ${USERS.users['${tender_owner}'].broker}
  ...      ${USERS.users['${provider}'].broker}  ${USERS.users['${provider1}'].broker}
  ...      get_second_stage
  ...      critical
  Можливість знайти тендер другого етапу по ідентифікатору для усіх користувачів


Відображення заголовку тендера другого етапу
  [Tags]   ${USERS.user['${tender_owner}'].broker}: Відображення основних даних тендера другого етапу
  ...      viewer  tender_owner  provider  provider1
  ...      ${USERS.users['${viewer}'].broker}  ${USERS.users['${tender_owner}'].broker}
  ...      ${USERS.users['${provider}'].broker}  ${USERS.users['${provider1}'].broker}
  ...      compare_stages
  ...      critical
  Отримати дані із поля title тендера другого етапу для усіх користувачів


Відображення мінімального кроку закупівлі другого етапу
  [Tags]   ${USERS.user['${tender_owner}'].broker}: Відображення основних даних тендера другого етапу
  ...      viewer  tender_owner  provider  provider1
  ...      ${USERS.users['${viewer}'].broker}  ${USERS.users['${tender_owner}'].broker}
  ...      ${USERS.users['${provider}'].broker}  ${USERS.users['${provider1}'].broker}
  ...      compare_stages
  ...      critical
  Отримати дані із поля minimalStep.amount тендера другого етапу для усіх користувачів


Відображення доступного бюджету закупівлі другого етапу
  [Tags]   ${USERS.user['${tender_owner}'].broker}: Відображення основних даних тендера другого етапу
  ...      viewer  tender_owner  provider  provider1
  ...      ${USERS.users['${viewer}'].broker}  ${USERS.users['${tender_owner}'].broker}
  ...      ${USERS.users['${provider}'].broker}  ${USERS.users['${provider1}'].broker}
  ...      compare_stages
  ...      critical
  Отримати дані із поля value.amount тендера другого етапу для усіх користувачів


Відображення опису закупівлі другого етапу
  [Tags]   ${USERS.user['${tender_owner}'].broker}: Відображення основних даних тендера другого етапу
  ...      viewer  tender_owner  provider  provider1
  ...      ${USERS.users['${viewer}'].broker}  ${USERS.users['${tender_owner}'].broker}
  ...      ${USERS.users['${provider}'].broker}  ${USERS.users['${provider1}'].broker}
  ...      compare_stages
  ...      non-critical
  Отримати дані із поля description тендера другого етапу для усіх користувачів


Відображення імені замовника тендера для другого етапу
  [Tags]   ${USERS.user['${tender_owner}'].broker}: Відображення основних даних тендера другого етапу
  ...      viewer  tender_owner  provider  provider1
  ...      ${USERS.users['${viewer}'].broker}  ${USERS.users['${tender_owner}'].broker}
  ...      ${USERS.users['${provider}'].broker}  ${USERS.users['${provider1}'].broker}
  ...      compare_stages
  ...      critical
  Отримати дані із поля procuringEntity.name тендера другого етапу для усіх користувачів


Відображення початку періоду прийому пропозицій тендера другого етапу
  [Tags]   ${USERS.users['${viewer}'].broker}: Відображення основних даних тендера другого етапу
  ...      viewer  tender_owner  provider  provider1
  ...      ${USERS.users['${viewer}'].broker}  ${USERS.users['${tender_owner}'].broker}
  ...      ${USERS.users['${provider}'].broker}  ${USERS.users['${provider1}'].broker}
  ...      compare_stages
  ...      critical
  Отримати дані із поля tenderPeriod.startDate тендера другого етапу для усіх користувачів


Відображення закінчення періоду прийому пропозицій тендера другого етапу
  [Tags]   ${USERS.users['${viewer}'].broker}: Відображення основних даних тендера другого етапу
  ...      viewer  tender_owner  provider  provider1
  ...      ${USERS.users['${viewer}'].broker}  ${USERS.users['${tender_owner}'].broker}
  ...      ${USERS.users['${provider}'].broker}  ${USERS.users['${provider1}'].broker}
  ...      compare_stages
  ...      critical
  Отримати дані із поля tenderPeriod.endDate тендера другого етапу для усіх користувачів


Можливість подати пропозицію першим учасником на другому етапі
  [Tags]   ${USERS.users['${provider}'].broker}: Подання пропозиції
  ...      provider
  ...      ${USERS.users['${provider}'].broker}
  ...      make_bid_by_provider_second_stage
  ...      critical
  [Setup]  Дочекатись дати початку прийому пропозицій  ${provider}  ${TENDER['TENDER_UAID']}
  [Teardown]  Оновити LAST_MODIFICATION_DATE
  Можливість подати цінову пропозицію на другий етап користувачем ${provider}


Можливість подати пропозицію другим учасником на другому етапі
  [Tags]   ${USERS.users['${provider1}'].broker}: Подання пропозиції на другий етап
  ...      provider1
  ...      ${USERS.users['${provider1}'].broker}
  ...      make_bid_by_provider1_second_stage
  ...      critical
  [Teardown]  Оновити LAST_MODIFICATION_DATE
  Можливість подати цінову пропозицію на другий етап користувачем ${provider1}


Можливість підтвердити першу пропозицію кваліфікації на другому етапі
  [Tags]   ${USERS.users['${tender_owner}'].broker}: Кваліфікація на другому етапі
  ...      tender_owner
  ...      ${USERS.users['${tender_owner}'].broker}
  ...      pre-qualification_approve_first_bid_second_stage
  [Setup]  Дочекатись дати початку періоду прекваліфікації  ${tender_owner}  ${TENDER['TENDER_UAID']}
  [Teardown]  Оновити LAST_MODIFICATION_DATE
  Можливість підтвердити 0 пропозицію кваліфікації


Можливість підтвердити другу пропозицію кваліфікації на другогму етапі
  [Tags]   ${USERS.users['${tender_owner}'].broker}: Кваліфікація на другому етапі
  ...      tender_owner
  ...      ${USERS.users['${tender_owner}'].broker}
  ...      pre-qualification_approve_second_bid_second_stage
  [Teardown]  Оновити LAST_MODIFICATION_DATE
  Можливість підтвердити -1 пропозицію кваліфікації


Можливість затвердити остаточне рішення кваліфікації на другому етапі
  [Tags]   ${USERS.users['${tender_owner}'].broker}: Кваліфікація на другому етапі
  ...      tender_owner
  ...      ${USERS.users['${tender_owner}'].broker}
  ...      pre-qualification_approve_qualifications_second_stage
  [Setup]  Дочекатись синхронізації з майданчиком  ${tender_owner}
  [Teardown]  Оновити LAST_MODIFICATION_DATE
  Можливість затвердити остаточне рішення кваліфікації

##############################################################################################
#             QUALIFICATION
##############################################################################################

Дочекатись початку періоду кваліфікації
  [Tags]   ${USERS.users['${tender_owner}'].broker}: Очікування початку періоду кваліфікації учасників
  ...      tender_owner
  ...      ${USERS.users['${tender_owner}'].broker}
  ...      wait_active_qualification_start
  Дочекатись дати початку періоду кваліфікації  ${tender_owner}  ${TENDER['TENDER_UAID']}


Можливість підтвердити постачальника
  [Tags]  ${USERS.users['${tender_owner}'].broker}: Процес кваліфікації
  ...  tender_owner
  ...  ${USERS.users['${tender_owner}'].broker}
  ...  qualification_approve_first_award
  ...  critical
  [Setup]  Дочекатись дати початку періоду кваліфікації  ${tender_owner}  ${TENDER['TENDER_UAID']}
  Run As  ${tender_owner}  Підтвердити постачальника  ${TENDER['TENDER_UAID']}  0


Можливість підтвердити другого постачальника
  [Tags]  ${USERS.users['${tender_owner}'].broker}: Процес кваліфікації
  ...  tender_owner
  ...  ${USERS.users['${tender_owner}'].broker}
  ...  qualification_approve_second_award
  ...  critical
  Run As  ${tender_owner}  Підтвердити постачальника  ${TENDER['TENDER_UAID']}  1


Дочекатись початку періоду підписання угоди
  [Tags]   ${USERS.users['${tender_owner}'].broker}: Очікування початку періоду підписання угоди
  ...      tender_owner
  ...      ${USERS.users['${tender_owner}'].broker}
  ...      wait_active_awarded_start
  Дочекатись дати початку періоду підписання угоди  ${tender_owner}  ${TENDER['TENDER_UAID']}


Відображення закінчення періоду подачі скарг на пропозицію
  [Tags]   ${USERS.users['${tender_owner}'].broker}: Відображення основних даних тендера
  ...      viewer
  ...      ${USERS.users['${tender_owner}'].broker}
  ...      award_stand_still
  ...      critical
  ${award_index}=  Отримати останній індекс  awards  ${tender_owner}  ${viewer}
  :FOR  ${username}  IN  ${viewer}
  \  Отримати дані із тендера  ${username}  ${TENDER['TENDER_UAID']}  awards[${award_index}].complaintPeriod.endDate


Дочекатися закічення stand still періоду
  [Tags]   ${USERS.users['${tender_owner}'].broker}: Процес укладання угоди
  ...      viewer
  ...      ${USERS.users['${tender_owner}'].broker}
  ...      award_stand_still
  ...      critical
  ${award_index}=  Отримати останній індекс  awards  ${tender_owner}  ${viewer}
  ${standstillEnd}=  Get Variable Value  ${USERS.users['${viewer}'].tender_data.data.awards[${award_index}].complaintPeriod.endDate}
  Дочекатись дати  ${standstillEnd}

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
