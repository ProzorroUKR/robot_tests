coding: utf-8
*** Settings ***
Documentation    Suite description
Resource        base_keywords.robot
Resource        aboveThreshold_keywords.robot
Suite Setup     Test Suite Setup
Suite Teardown  Test Suite Teardown

*** Variables ***
${MODE}             belowThreshold
@{USED_ROLES}       tender_owner  provider  provider1  provider2  viewer  amcu_user
${MOZ_INTEGRATION}  ${False}
${VAT_INCLUDED}     ${True}

${NUMBER_OF_ITEMS}  ${1}
${NUMBER_OF_LOTS}   ${1}
${NUMBER_OF_MILESTONES}  ${1}
${TENDER_MEAT}      ${0}
${ITEM_MEAT}        ${0}
${LOT_MEAT}         ${0}
${lot_index}        ${0}
${award_index}      ${0}
${qualification_index}  ${0}
${cancellations_index}  ${0}
${ROAD_INDEX}           ${False}
${GMDN_INDEX}           ${False}
${PLAN_TENDER}          ${True}
${ARTICLE_17}           ${False}
${CRITERIA_GUARANTEE}   ${False}
${CRITERIA_LOT}         ${False}
${CRITERIA_LLC}         ${False}

*** Test Cases ***

##############################################################################################
#             CREATE AND FIND TENDER LOT VIEW
##############################################################################################

Можливість оголосити однопредметний тендер
  [Tags]  ${USERS.users['${tender_owner}'].broker}: Оголошення тендера
  ...     tender_owner
  ...     ${USERS.users['${tender_owner}'].broker}
  ...     create_tender
  ...     critical
  [Teardown]  Оновити LAST_MODIFICATION_DATE
  Можливість оголосити тендер


Можливість знайти однопредметний тендер по ідентифікатору
  [Tags]  ${USERS.users['${viewer}'].broker}: Пошук тендера
  ...     viewer
  ...     ${USERS.users['${viewer}'].broker}
  ...     find_tender
  ...     critical
  [Setup]  Дочекатись синхронізації з майданчиком  ${viewer}
  Можливість знайти тендер по ідентифікатору для усіх користувачів


Відображення заголовку лотів
  [Tags]  ${USERS.users['${viewer}'].broker}: Відображення лоту тендера
  ...     viewer  tender_owner  provider  provider1
  ...     ${USERS.users['${viewer}'].broker}  ${USERS.users['${tender_owner}'].broker}
  ...     ${USERS.users['${provider}'].broker}  ${USERS.users['${provider1}'].broker}
  ...     tender_view
  ...     critical
  Звірити відображення поля title усіх лотів для усіх користувачів


##############################################################################################
#             BIDDING
##############################################################################################

Можливість подати пропозицію першим учасником
  [Tags]  ${USERS.users['${provider}'].broker}: Подання пропозиції
  ...     provider
  ...     ${USERS.users['${provider}'].broker}
  ...     make_bid_by_provider
  ...     critical
  [Setup]  Дочекатись дати початку прийому пропозицій  ${provider}  ${TENDER['TENDER_UAID']}
  [Teardown]  Оновити LAST_MODIFICATION_DATE
  Можливість подати цінову пропозицію користувачем ${provider}


Можливість подати пропозицію першим учасником
  [Tags]   ${USERS.users['${provider}'].broker}: Подання пропозиції
  ...      provider
  ...      ${USERS.users['${provider}'].broker}
  ...      make_bid_with_criteria_by_provider  level1
  ...      critical
  [Setup]  Дочекатись дати початку прийому пропозицій  ${provider}  ${TENDER['TENDER_UAID']}
  [Teardown]  Оновити LAST_MODIFICATION_DATE
  Можливість подати цінову пропозицію в статусі draft користувачем ${provider}
  Можливість завантажити документ в пропозицію користувачем ${provider}
  Можливість додати до пропозиції відповідь на критерії користувачем ${provider}
  Можливість активувати пропозицію користувачем ${provider}


Можливість подати пропозицію другим учасником
  [Tags]  ${USERS.users['${provider1}'].broker}: Подання пропозиції
  ...     provider1
  ...     ${USERS.users['${provider1}'].broker}
  ...     make_bid_by_provider1
  ...     critical
  [Setup]  Дочекатись дати початку прийому пропозицій  ${provider1}  ${TENDER['TENDER_UAID']}
  [Teardown]  Оновити LAST_MODIFICATION_DATE
  Можливість подати цінову пропозицію користувачем ${provider1}


Можливість подати пропозицію другим учасником
  [Tags]   ${USERS.users['${provider1}'].broker}: Подання пропозиції
  ...      provider1
  ...      ${USERS.users['${provider1}'].broker}
  ...      make_bid_with_criteria_by_provider1  level1
  ...      critical
  [Setup]  Дочекатись дати початку прийому пропозицій  ${provider1}  ${TENDER['TENDER_UAID']}
  [Teardown]  Оновити LAST_MODIFICATION_DATE
  Можливість подати цінову пропозицію в статусі draft користувачем ${provider1}
  Можливість завантажити документ в пропозицію користувачем ${provider1}
  Можливість додати до пропозиції відповідь на критерії користувачем ${provider1}
  Можливість активувати пропозицію користувачем ${provider1}


Можливість подати пропозицію третім учасником
  [Tags]   ${USERS.users['${provider1}'].broker}: Подання пропозиції
  ...      provider2
  ...      ${USERS.users['${provider1}'].broker}
  ...      make_bid_by_provider2  level1
  ...      critical
  [Setup]  Дочекатись дати початку прийому пропозицій  ${provider2}  ${TENDER['TENDER_UAID']}
  [Teardown]  Оновити LAST_MODIFICATION_DATE
  Можливість подати цінову пропозицію користувачем ${provider2}


Можливість подати пропозицію третім учасником
  [Tags]   ${USERS.users['${provider1}'].broker}: Подання пропозиції
  ...      provider2
  ...      ${USERS.users['${provider1}'].broker}
  ...      make_bid_with_criteria_by_provider2  level1
  ...      critical
  [Setup]  Дочекатись дати початку прийому пропозицій  ${provider2}  ${TENDER['TENDER_UAID']}
  [Teardown]  Оновити LAST_MODIFICATION_DATE
  Можливість подати цінову пропозицію в статусі draft користувачем ${provider2}
  Можливість завантажити документ в пропозицію користувачем ${provider2}
  Можливість додати до пропозиції відповідь на критерії користувачем ${provider2}
  Можливість активувати пропозицію користувачем ${provider2}


Можливість подати пропозицію першим учасником на першому етапі
  [Tags]   ${USERS.users['${provider}'].broker}: Подання пропозиції
  ...      provider
  ...      ${USERS.users['${provider}'].broker}
  ...      make_bid_with_criteria_by_provider_first_stage  level1
  ...      critical
  [Setup]  Дочекатись дати початку прийому пропозицій  ${provider}  ${TENDER['TENDER_UAID']}
  [Teardown]  Оновити LAST_MODIFICATION_DATE
  Можливість подати цінову пропозицію в статусі draft на першому етапі користувачем ${provider}
  Можливість завантажити документ в пропозицію користувачем ${provider}
  Можливість додати до пропозиції відповідь на критерії користувачем ${provider}
  Можливість активувати пропозицію користувачем ${provider}


Можливість подати пропозицію другим учасником на першому етапі
  [Tags]   ${USERS.users['${provider1}'].broker}: Подання пропозиції
  ...      provider
  ...      ${USERS.users['${provider1}'].broker}
  ...      make_bid_with_criteria_by_provider1_first_stage  level1
  ...      critical
  [Setup]  Дочекатись дати початку прийому пропозицій  ${provider1}  ${TENDER['TENDER_UAID']}
  [Teardown]  Оновити LAST_MODIFICATION_DATE
  Можливість подати цінову пропозицію в статусі draft на першому етапі користувачем ${provider1}
  Можливість завантажити документ в пропозицію користувачем ${provider1}
  Можливість додати до пропозиції відповідь на критерії користувачем ${provider1}
  Можливість активувати пропозицію користувачем ${provider1}


Можливість подати пропозицію третім учасником на першому етапі
  [Tags]   ${USERS.users['${provider2}'].broker}: Подання пропозиції
  ...      provider
  ...      ${USERS.users['${provider2}'].broker}
  ...      make_bid_with_criteria_by_provider2_first_stage  level1
  ...      critical
  [Setup]  Дочекатись дати початку прийому пропозицій  ${provider2}  ${TENDER['TENDER_UAID']}
  [Teardown]  Оновити LAST_MODIFICATION_DATE
  Можливість подати цінову пропозицію в статусі draft на першому етапі користувачем ${provider2}
  Можливість завантажити документ в пропозицію користувачем ${provider2}
  Можливість додати до пропозиції відповідь на критерії користувачем ${provider2}
  Можливість активувати пропозицію користувачем ${provider2}

##############################################################################################
#             TENDER CLAIM
##############################################################################################

Можливість створити чернетку вимоги про виправлення умов закупівлі
  [Tags]  ${USERS.users['${provider}'].broker}: Процес оскарження
  ...     provider
  ...     ${USERS.users['${provider}'].broker}
  ...     tender_claim_draft
  ...     critical
  [Teardown]  Оновити LAST_MODIFICATION_DATE
  Можливість створити чернетку вимоги користувачем ${provider}


Відображення статусу 'draft' чернетки вимоги
  [Tags]  ${USERS.users['${viewer}'].broker}: Відображення оскарження
  ...     viewer
  ...     ${USERS.users['${viewer}'].broker}
  ...     tender_claim_draft
  ...     non-critical
  [Setup]  Дочекатись синхронізації з майданчиком  ${viewer}
  ${complaintID}=  Get Variable Value  ${USERS.users['${provider}'].claim_data['complaintID']}
  Log  ${complaintID}
  Звірити відображення поля status для вимоги ${complaintID} із draft для користувача ${viewer}

##############################################################################################
#             SUBMIT TENDER CLAIM
##############################################################################################

Можливість подати вимоги про виправлення умов закупівлі
  [Tags]  ${USERS.users['${provider}'].broker}: Процес оскарження
  ...     provider
  ...     ${USERS.users['${provider}'].broker}
  ...     submit_tender_claim
  ...     critical
  [Teardown]  Оновити LAST_MODIFICATION_DATE
  Можливість подати вимогу користувачем ${provider}


Відображення статусу 'claim' вимоги про виправлення умов закупівлі
  [Tags]  ${USERS.users['${viewer}'].broker}: Відображення оскарження
  ...     viewer
  ...     ${USERS.users['${viewer}'].broker}
  ...     submit_tender_claim
  ...     non-critical
  [Setup]  Дочекатись синхронізації з майданчиком  ${viewer}
  ${complaintID}=  Get Variable Value  ${USERS.users['${provider}'].claim_data['complaintID']}
  Log  ${complaintID}
  Звірити відображення поля status для вимоги ${complaintID} із claim для користувача ${viewer}

##############################################################################################
#             ANSWER TENDER CLAIM
##############################################################################################

Можливість відповісти на вимогу про виправлення умов закупівлі
  [Tags]  ${USERS.users['${tender_owner}'].broker}: Процес оскарження
  ...     tender_owner
  ...     ${USERS.users['${tender_owner}'].broker}
  ...     answer_tender_claim
  ...     critical
  [Setup]  Дочекатись синхронізації з майданчиком  ${tender_owner}
  [Teardown]  Оновити LAST_MODIFICATION_DATE
  ${complaintID}=  Get Variable Value  ${USERS.users['${provider}'].claim_data['complaintID']}
  Log  ${complaintID}
  Можливість відповісти resolved на вимогу ${complaintID} користувачем ${tender_owner}


Відображення статусу 'answered' вимоги про виправлення умов закупівлі
  [Tags]  ${USERS.users['${viewer}'].broker}: Відображення оскарження
  ...     viewer
  ...     ${USERS.users['${viewer}'].broker}
  ...     answer_tender_claim
  ...     non-critical
  [Setup]  Дочекатись синхронізації з майданчиком  ${viewer}
  ${complaintID}=  Get Variable Value  ${USERS.users['${provider}'].claim_data['complaintID']}
  Log  ${complaintID}
  Звірити відображення поля status для вимоги ${complaintID} із answered для користувача ${viewer}

##############################################################################################
#             RESOLVED TENDER CLAIM
##############################################################################################

Можливість підтвердити задоволення вимоги про виправлення умов закупівлі
  [Tags]  ${USERS.users['${provider}'].broker}: Процес оскарження
  ...     provider
  ...     ${USERS.users['${provider}'].broker}
  ...     resolved_tender_claim
  ...     critical
  [Setup]  Дочекатись синхронізації з майданчиком  ${provider}
  [Teardown]  Оновити LAST_MODIFICATION_DATE
  ${complaintID}=  Get Variable Value  ${USERS.users['${provider}'].claim_data['complaintID']}
  Log  ${complaintID}
  Можливість підтвердити задоволення вимоги ${complaintID} про виправлення умов закупівлі користувачем ${provider}


Відображення статусу 'resolved' вимоги про виправлення умов закупівлі
  [Tags]  ${USERS.users['${viewer}'].broker}: Відображення оскарження
  ...     viewer
  ...     ${USERS.users['${viewer}'].broker}
  ...     resolved_tender_claim
  ...     non-critical
  [Setup]  Дочекатись синхронізації з майданчиком  ${viewer}
  ${complaintID}=  Get Variable Value  ${USERS.users['${provider}'].claim_data['complaintID']}
  Log  ${complaintID}
  Звірити відображення поля status для вимоги ${complaintID} із resolved для користувача ${viewer}

##############################################################################################
#             CANCEL TENDER CLAIM
##############################################################################################

Можливість скасувати вимогу про виправлення умов закупівлі
  [Tags]  ${USERS.users['${provider}'].broker}: Процес оскарження
  ...     provider
  ...     ${USERS.users['${provider}'].broker}
  ...     cancel_tender_claim
  ...     critical
  [Teardown]  Оновити LAST_MODIFICATION_DATE
  ${complaintID}=  Get Variable Value  ${USERS.users['${provider}'].claim_data['complaintID']}
  Log  ${complaintID}
  Можливість скасувати вимогу ${complaintID} користувачем ${provider}


Відображення статусу 'cancelled' чернетки вимоги про виправлення умов закупівлі
  [Tags]  ${USERS.users['${viewer}'].broker}: Відображення оскарження
  ...     viewer
  ...     ${USERS.users['${viewer}'].broker}
  ...     cancel_tender_claim
  ...     non-critical
  [Setup]  Дочекатись синхронізації з майданчиком  ${viewer}
  ${complaintID}=  Get Variable Value  ${USERS.users['${provider}'].claim_data['complaintID']}
  Log  ${complaintID}
  Звірити відображення поля status для вимоги ${complaintID} із cancelled для користувача ${viewer}


Відображення причини скасування чернетки вимоги про виправлення умов закупівлі
  [Tags]  ${USERS.users['${viewer}'].broker}: Відображення оскарження
  ...     viewer
  ...     ${USERS.users['${viewer}'].broker}
  ...     cancel_tender_claim
  ...     non-critical
  ${complaintID}=  Get Variable Value  ${USERS.users['${provider}'].claim_data['complaintID']}
  Log  ${complaintID}
  ${cancellationReason}=  Get Variable Value  ${USERS.users['${provider}'].claim_data.cancellation.data.cancellationReason}
  Log  ${cancellationReason}
  Звірити відображення поля cancellationReason для вимоги ${complaintID} із ${cancellationReason} для користувача ${viewer}

##############################################################################################
#             LOT CLAIM
##############################################################################################

Можливість створити чернетку вимоги про виправлення умов лоту
  [Tags]  ${USERS.users['${provider}'].broker}: Процес оскарження
  ...     provider
  ...     ${USERS.users['${provider}'].broker}
  ...     lot_claim_draft
  ...     critical
  [Setup]  Дочекатись синхронізації з майданчиком  ${provider}
  [Teardown]  Оновити LAST_MODIFICATION_DATE
  Можливість створити чернетку вимоги про виправлення умов ${lot_index} лоту користувачем ${provider}


Відображення статусу 'draft' чернетки вимоги про виправлення умов лоту
  [Tags]  ${USERS.users['${viewer}'].broker}: Відображення оскарження
  ...     viewer
  ...     ${USERS.users['${viewer}'].broker}
  ...     lot_claim_draft
  ...     non-critical
  [Setup]  Дочекатись синхронізації з майданчиком  ${viewer}
  ${complaintID}=  Get Variable Value  ${USERS.users['${provider}'].claim_data['complaintID']}
  Log  ${complaintID}
  Звірити відображення поля status для вимоги ${complaintID} із draft для користувача ${viewer}

##############################################################################################
#             SUBMIT LOT CLAIM
##############################################################################################

Можливість подати вимоги про виправлення умов лоту
  [Tags]  ${USERS.users['${provider}'].broker}: Процес оскарження
  ...     provider
  ...     ${USERS.users['${provider}'].broker}
  ...     submit_lot_claim
  ...     critical
  [Teardown]  Оновити LAST_MODIFICATION_DATE
  Можливість подати вимогу користувачем ${provider}


Відображення статусу 'claim' вимоги про виправлення умов лоту
  [Tags]  ${USERS.users['${viewer}'].broker}: Відображення оскарження
  ...     viewer
  ...     ${USERS.users['${viewer}'].broker}
  ...     submit_lot_claim
  ...     non-critical
  [Setup]  Дочекатись синхронізації з майданчиком  ${viewer}
  ${complaintID}=  Get Variable Value  ${USERS.users['${provider}'].claim_data['complaintID']}
  Log  ${complaintID}
  Звірити відображення поля status для вимоги ${complaintID} із claim для користувача ${viewer}

##############################################################################################
#             ANSWER LOT CLAIM
##############################################################################################

Можливість відповісти на вимогу про виправлення умов лоту
  [Tags]  ${USERS.users['${tender_owner}'].broker}: Процес оскарження
  ...     tender_owner
  ...     ${USERS.users['${tender_owner}'].broker}
  ...     answer_lot_claim
  ...     critical
  [Setup]  Дочекатись синхронізації з майданчиком  ${tender_owner}
  [Teardown]  Оновити LAST_MODIFICATION_DATE
  ${complaintID}=  Get Variable Value  ${USERS.users['${provider}'].claim_data['complaintID']}
  Log  ${complaintID}
  Можливість відповісти resolved на вимогу ${complaintID} користувачем ${tender_owner}


Відображення статусу 'answered' вимоги про виправлення умов лоту
  [Tags]  ${USERS.users['${viewer}'].broker}: Відображення оскарження
  ...     viewer
  ...     ${USERS.users['${viewer}'].broker}
  ...     answer_lot_claim
  ...     non-critical
  [Setup]  Дочекатись синхронізації з майданчиком  ${viewer}
  ${complaintID}=  Get Variable Value  ${USERS.users['${provider}'].claim_data['complaintID']}
  Log  ${complaintID}
  Звірити відображення поля status для вимоги ${complaintID} із answered для користувача ${viewer}

##############################################################################################
#             RESOLVED LOT CLAIM
##############################################################################################

Можливість підтвердити задоволення вимоги про виправлення умов лоту
  [Tags]  ${USERS.users['${provider}'].broker}: Процес оскарження
  ...     provider
  ...     ${USERS.users['${provider}'].broker}
  ...     resolved_lot_claim
  ...     critical
  [Setup]  Дочекатись синхронізації з майданчиком  ${provider}
  [Teardown]  Оновити LAST_MODIFICATION_DATE
  ${complaintID}=  Get Variable Value  ${USERS.users['${provider}'].claim_data['complaintID']}
  Log  ${complaintID}
  Можливість підтвердити задоволення вимоги ${complaintID} про виправлення умов закупівлі користувачем ${provider}



Відображення статусу 'resolved' вимоги
  [Tags]  ${USERS.users['${viewer}'].broker}: Відображення оскарження
  ...     viewer
  ...     ${USERS.users['${viewer}'].broker}
  ...     resolved_lot_claim
  ...     non-critical
  [Setup]  Дочекатись синхронізації з майданчиком  ${viewer}
  ${complaintID}=  Get Variable Value  ${USERS.users['${provider}'].claim_data['complaintID']}
  Log  ${complaintID}
  Звірити відображення поля status для вимоги ${complaintID} із resolved для користувача ${viewer}

##############################################################################################
#             CANCEL LOT CLAIM
##############################################################################################

Можливість скасувати вимогу про виправлення умов лоту
  [Tags]  ${USERS.users['${provider}'].broker}: Процес оскарження
  ...     provider
  ...     ${USERS.users['${provider}'].broker}
  ...     cancel_lot_claim
  ...     critical
  [Teardown]  Оновити LAST_MODIFICATION_DATE
  ${complaintID}=  Get Variable Value  ${USERS.users['${provider}'].claim_data['complaintID']}
  Log  ${complaintID}
  Можливість скасувати вимогу ${complaintID} користувачем ${provider}


Відображення статусу 'cancelled' чернетки вимоги про виправлення умов лоту
  [Tags]  ${USERS.users['${viewer}'].broker}: Відображення оскарження
  ...     viewer
  ...     ${USERS.users['${viewer}'].broker}
  ...     cancel_lot_claim
  ...     non-critical
  [Setup]  Дочекатись синхронізації з майданчиком  ${viewer}
  ${complaintID}=  Get Variable Value  ${USERS.users['${provider}'].claim_data['complaintID']}
  Log  ${complaintID}
  Звірити відображення поля status для вимоги ${complaintID} із cancelled для користувача ${viewer}


Відображення причини скасування чернетки вимоги про виправлення умов лоту
  [Tags]  ${USERS.users['${viewer}'].broker}: Відображення оскарження
  ...     viewer
  ...     ${USERS.users['${viewer}'].broker}
  ...     cancel_lot_claim
  ...     non-critical
  ${complaintID}=  Get Variable Value  ${USERS.users['${provider}'].claim_data['complaintID']}
  Log  ${complaintID}
  ${cancellationReason}=  Get Variable Value  ${USERS.users['${provider}'].claim_data.cancellation.data.cancellationReason}
  Log  ${cancellationReason}
  Звірити відображення поля cancellationReason для вимоги ${complaintID} із ${cancellationReason} для користувача ${viewer}

##############################################################################################
#             PRE-QUALIFICATION
##############################################################################################

Можливість підтвердити першу пропозицію кваліфікації
  [Tags]   ${USERS.users['${tender_owner}'].broker}: Пре-Кваліфікація
  ...      tender_owner
  ...      ${USERS.users['${tender_owner}'].broker}
  ...      pre-qualification_approve_first_bid  level1
  ...      critical
  [Setup]  Дочекатись дати початку періоду прекваліфікації  ${tender_owner}  ${TENDER['TENDER_UAID']}
  [Teardown]  Оновити LAST_MODIFICATION_DATE
  Можливість підтвердити 0 пропозицію кваліфікації


Можливість підтвердити другу пропозицію кваліфікації
  [Tags]   ${USERS.users['${tender_owner}'].broker}: Пре-Кваліфікація
  ...      tender_owner
  ...      ${USERS.users['${tender_owner}'].broker}
  ...      pre-qualification_approve_second_bid  level1
  ...      critical
  [Teardown]  Оновити LAST_MODIFICATION_DATE
  Можливість підтвердити 1 пропозицію кваліфікації


Можливість підтвердити третю пропозицію кваліфікації
  [Tags]   ${USERS.users['${tender_owner}'].broker}: Процес пре-кваліфікації
  ...      tender_owner
  ...      ${USERS.users['${tender_owner}'].broker}
  ...      pre-qualification_approve_third_bid  level1
  ...      critical
  [Teardown]  Оновити LAST_MODIFICATION_DATE
  Можливість підтвердити 2 пропозицію кваліфікації


Можливість затвердити остаточне рішення пре-кваліфікації
  [Tags]   ${USERS.users['${tender_owner}'].broker}: Пре-Кваліфікація
  ...      tender_owner
  ...      ${USERS.users['${tender_owner}'].broker}
  ...      pre-qualification_approve_qualifications  level1
  ...      critical
  [Setup]  Дочекатись синхронізації з майданчиком  ${tender_owner}
  [Teardown]  Оновити LAST_MODIFICATION_DATE
  Можливість затвердити остаточне рішення кваліфікації


Відображення статусу блокування перед початком аукціону
  [Tags]   ${USERS.users['${tender_owner}'].broker}: Пре-Кваліфікація
  ...      tender_owner
  ...      ${USERS.users['${tender_owner}'].broker}
  ...      pre-qualification_view
  ...      non-critical
  [Setup]  Дочекатись синхронізації з майданчиком  ${tender_owner}
  Звірити статус тендера  ${tender_owner}  ${TENDER['TENDER_UAID']}  active.pre-qualification.stand-still

##############################################################################################
#             QUALIFICATION CLAIM
##############################################################################################

Можливість створити вимогу про виправлення кваліфікації учасника
  [Tags]  ${USERS.users['${provider}'].broker}: Процес оскарження
  ...     provider
  ...     ${USERS.users['${provider}'].broker}
  ...     qualification_claim_draft
  ...     critical
  [Setup]  Дочекатись синхронізації з майданчиком  ${provider}
  [Teardown]  Оновити LAST_MODIFICATION_DATE
  ${qualification_index}=  Convert To Integer  ${qualification_index}
  Можливість створити чернетку вимоги про виправлення кваліфікації ${qualification_index} учасника користувачем ${provider}


Відображення статусу 'draft' чернетки вимоги про виправлення кваліфікації учасника
  [Tags]  ${USERS.users['${viewer}'].broker}: Відображення оскарження
  ...     viewer
  ...     ${USERS.users['${viewer}'].broker}
  ...     qualification_claim_draft
  ...     non-critical
  [Setup]  Дочекатись синхронізації з майданчиком  ${viewer}
  ${complaintID}=  Get Variable Value  ${USERS.users['${provider}'].claim_data['complaintID']}
  Log  ${complaintID}
  Звірити відображення поля status вимоги ${complaintID} ${qualification_index} із draft об'єкта qualifications для користувача ${viewer}

##############################################################################################
#             SUBMIT QUALIFICATION CLAIM
##############################################################################################

Можливість подати вимоги про виправлення кваліфікації учасника
  [Tags]  ${USERS.users['${provider}'].broker}: Процес оскарження
  ...     provider
  ...     ${USERS.users['${provider}'].broker}
  ...     submit_qualification_claim
  ...     critical
  [Teardown]  Оновити LAST_MODIFICATION_DATE
  Можливість подати вимогу на пре-кваліфікацію ${qualification_index} користувачем ${provider}


Відображення статусу 'claim' вимоги про виправлення кваліфікації учасника
  [Tags]  ${USERS.users['${viewer}'].broker}: Відображення оскарження
  ...     viewer
  ...     ${USERS.users['${viewer}'].broker}
  ...     submit_qualification_claim
  ...     non-critical
  [Setup]  Дочекатись синхронізації з майданчиком  ${viewer}
  ${complaintID}=  Get Variable Value  ${USERS.users['${provider}'].claim_data['complaintID']}
  Log  ${complaintID}
  Звірити відображення поля status вимоги ${complaintID} ${qualification_index} із claim об'єкта qualifications для користувача ${viewer}

##############################################################################################
#             ANSWER QUALIFICATION CLAIM
##############################################################################################

Можливість відповісти на вимогу про виправлення кваліфікації учасника
  [Tags]  ${USERS.users['${tender_owner}'].broker}: Процес оскарження
  ...     tender_owner
  ...     ${USERS.users['${tender_owner}'].broker}
  ...     answer_qualification_claim
  ...     critical
  [Setup]  Дочекатись синхронізації з майданчиком  ${tender_owner}
  [Teardown]  Оновити LAST_MODIFICATION_DATE
  ${complaintID}=  Get Variable Value  ${USERS.users['${provider}'].qualification_claim_data['complaintID']}
  Log  ${complaintID}
  Можливість відповісти resolved на кваліфікацію ${qualification_index} учасника


Відображення статусу 'answered' вимоги про виправлення кваліфікації учасника
  [Tags]  ${USERS.users['${viewer}'].broker}: Відображення оскарження
  ...     viewer
  ...     ${USERS.users['${viewer}'].broker}
  ...     answer_qualification_claim
  ...     non-critical
  [Setup]  Дочекатись синхронізації з майданчиком  ${viewer}
  ${complaintID}=  Get Variable Value  ${USERS.users['${provider}'].claim_data['complaintID']}
  Log  ${complaintID}
  Звірити відображення поля status вимоги ${complaintID} ${qualification_index} із answered об'єкта qualifications для користувача ${viewer}

##############################################################################################
#             RESOLVED QUALIFICATION CLAIM
##############################################################################################

Можливість підтвердити задоволення вимоги про виправлення кваліфікації учасника
  [Tags]  ${USERS.users['${provider}'].broker}: Процес оскарження
  ...     provider
  ...     ${USERS.users['${provider}'].broker}
  ...     resolved_qualification_claim
  ...     critical
  [Setup]  Дочекатись синхронізації з майданчиком  ${provider}
  [Teardown]  Оновити LAST_MODIFICATION_DATE
  Можливість підтвердити задоволення вимоги про виправлення кваліфікації ${qualification_index} учасника


Відображення статусу 'resolved' вимоги про виправлення кваліфікації учасника
  [Tags]  ${USERS.users['${viewer}'].broker}: Відображення оскарження
  ...     viewer
  ...     ${USERS.users['${viewer}'].broker}
  ...     resolved_qualification_claim
  ...     non-critical
  [Setup]  Дочекатись синхронізації з майданчиком  ${viewer}
  ${complaintID}=  Get Variable Value  ${USERS.users['${provider}'].claim_data['complaintID']}
  Log  ${complaintID}
  Звірити відображення поля status вимоги ${complaintID} ${qualification_index} із resolved об'єкта qualifications для користувача ${viewer}

##############################################################################################
#             CANCEL QUALIFICATION CLAIM
##############################################################################################

Можливість скасувати вимогу про виправлення кваліфікації учасника
  [Tags]  ${USERS.users['${provider}'].broker}: Процес оскарження
  ...     provider
  ...     ${USERS.users['${provider}'].broker}
  ...     cancel_qualification_claim
  ...     critical
  [Teardown]  Оновити LAST_MODIFICATION_DATE
  ${complaintID}=  Get Variable Value  ${USERS.users['${provider}'].claim_data['complaintID']}
  Log  ${complaintID}
  Можливість скасувати ${complaintID} вимогу про виправлення кваліфікації ${qualification_index} користувачем ${provider}


Відображення статусу 'cancelled' чернетки вимоги про виправлення кваліфікації учасника
  [Tags]  ${USERS.users['${viewer}'].broker}: Відображення оскарження
  ..      viewer
  ...     ${USERS.users['${viewer}'].broker}
  ...     cancel_qualification_claim
  ...     non-critical
  [Setup]  Дочекатись синхронізації з майданчиком  ${viewer}
  ${complaintID}=  Get Variable Value  ${USERS.users['${provider}'].claim_data['complaintID']}
  Log  ${complaintID}
  Звірити відображення поля status вимоги ${complaintID} ${qualification_index} із cancelled об'єкта qualifications для користувача ${viewer}


Відображення причини скасування чернетки вимоги про виправлення кваліфікації учасника
  [Tags]  ${USERS.users['${viewer}'].broker}: Відображення оскарження
  ...     viewer
  ...     ${USERS.users['${viewer}'].broker}
  ...     cancel_qualification_claim
  ...     non-critical
  [Setup]  Дочекатись синхронізації з майданчиком  ${viewer}
  ${complaintID}=  Get Variable Value  ${USERS.users['${provider}'].claim_data['complaintID']}
  Log  ${complaintID}
  ${cancellationReason}=  Get Variable Value  ${USERS.users['${provider}'].claim_data.cancellation.data.cancellationReason}
  Log  ${cancellationReason}
  Звірити відображення поля cancellationReason вимоги ${complaintID} ${qualification_index} із ${cancellationReason} об'єкта qualifications для користувача ${viewer}

##############################################################################################
#             STAGE 2
##############################################################################################

Можливість дочекатися початку періоду очікування
  [Tags]   ${USERS.users['${tender_owner}'].broker}: Процес очікування оскаржень на пре-кваліфікації
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

##############################################################################################
#             BID STAGE 2
##############################################################################################

Можливість подати пропозицію першим учасником на другому етапі
  [Tags]   ${USERS.users['${provider}'].broker}: Подання пропозиції
  ...      provider
  ...      ${USERS.users['${provider}'].broker}
  ...      make_bid_with_criteria_by_provider_second_stage
  ...      critical
  [Setup]  Дочекатись дати початку прийому пропозицій  ${provider}  ${TENDER['TENDER_UAID']}
  [Teardown]  Оновити LAST_MODIFICATION_DATE
  Можливість подати цінову пропозицію на другий етап конкурентного діалогу користувачем  ${provider}
  Можливість завантажити документ в пропозицію користувачем ${provider}
  Можливість додати до пропозиції відповідь на критерії користувачем ${provider}
  Можливість активувати пропозицію користувачем ${provider}


Можливість подати пропозицію другим учасником на другому етапі
  [Tags]   ${USERS.users['${provider1}'].broker}: Подання пропозиції на другий етап
  ...      provider1
  ...      ${USERS.users['${provider1}'].broker}
  ...      make_bid_with_criteria_by_provider1_second_stage
  ...      critical
  [Teardown]  Оновити LAST_MODIFICATION_DATE
  Можливість подати цінову пропозицію на другий етап конкурентного діалогу користувачем  ${provider1}
  Можливість завантажити документ в пропозицію користувачем ${provider1}
  Можливість додати до пропозиції відповідь на критерії користувачем ${provider1}
  Можливість активувати пропозицію користувачем ${provider1}

##############################################################################################
#             PRE-QUALIFICATION 2 STAGE
##############################################################################################

Можливість підтвердити першу пропозицію кваліфікації на другому етапі
  [Tags]   ${USERS.users['${tender_owner}'].broker}: Кваліфікація на другому етапі
  ...      tender_owner
  ...      ${USERS.users['${tender_owner}'].broker}
  ...      pre-qualification_approve_first_bid_second_stage
  [Setup]  Дочекатись дати початку періоду прекваліфікації  ${tender_owner}  ${TENDER['TENDER_UAID']}
  [Teardown]  Оновити LAST_MODIFICATION_DATE
  Можливість підтвердити 0 пропозицію кваліфікації

Можливість підтвердити другу пропозицію кваліфікації на другому етапі
  [Tags]   ${USERS.users['${tender_owner}'].broker}: Кваліфікація на другому етапі
  ...      tender_owner
  ...      ${USERS.users['${tender_owner}'].broker}
  ...      pre-qualification_approve_second_bid_second_stage
  [Teardown]  Оновити LAST_MODIFICATION_DATE
  Можливість підтвердити 1 пропозицію кваліфікації


Можливість підтвердити третю пропозицію кваліфікації на другому етапі
  [Tags]   ${USERS.users['${tender_owner}'].broker}: Кваліфікація на другому етапі
  ...      tender_owner
  ...      ${USERS.users['${tender_owner}'].broker}
  ...      pre-qualification_approve_third_bid_second_stage
  [Teardown]  Оновити LAST_MODIFICATION_DATE
  Можливість підтвердити 2 пропозицію кваліфікації


Можливість затвердити остаточне рішення кваліфікації на другому етапі
  [Tags]   ${USERS.users['${tender_owner}'].broker}: Кваліфікація на другому етапі
  ...      tender_owner
  ...      ${USERS.users['${tender_owner}'].broker}
  ...      pre-qualification_approve_qualifications_second_stage
  [Setup]  Дочекатись синхронізації з майданчиком  ${tender_owner}
  [Teardown]  Оновити LAST_MODIFICATION_DATE
  Можливість затвердити остаточне рішення кваліфікації

##############################################################################################
#             AWARD
##############################################################################################

Можливість дочекатись дати початку періоду кваліфікації
  [Tags]  ${USERS.users['${provider}'].broker}: Подання кваліфікації
  ...     provider
  ...     ${USERS.users['${provider}'].broker}
  ...     awardPeriod_startDate
  ...     critical
  [Teardown]  Оновити LAST_MODIFICATION_DATE
  Дочекатись дати початку періоду кваліфікації  ${provider}  ${TENDER['TENDER_UAID']}


Можливість підтвердити першого учасника
  [Tags]  ${USERS.users['${tender_owner}'].broker}: Процес кваліфікації
  ...     tender_owner
  ...     ${USERS.users['${tender_owner}'].broker}
  ...     qualification_approve_first_award
  ...     critical
  [Setup]  Дочекатись синхронізації з майданчиком  ${tender_owner}
  [Teardown]  Оновити LAST_MODIFICATION_DATE
  ${file_path}  ${file_name}  ${file_content}=   create_fake_doc
  Run As  ${tender_owner}  Завантажити документ рішення кваліфікаційної комісії  ${file_path}  ${TENDER['TENDER_UAID']}  0
  Run As  ${tender_owner}  Підтвердити постачальника  ${TENDER['TENDER_UAID']}  0
  Remove File  ${file_path}


Можливість підтвердити другого постачальника
  [Tags]  ${USERS.users['${tender_owner}'].broker}: Процес кваліфікації
  ...  tender_owner
  ...  ${USERS.users['${tender_owner}'].broker}
  ...  qualification_approve_second_award
  ...  critical
  Run As  ${tender_owner}  Підтвердити постачальника  ${TENDER['TENDER_UAID']}  1


Можливість підтвердити третього постачальника
  [Tags]  ${USERS.users['${tender_owner}'].broker}: Процес кваліфікації
  ...  tender_owner
  ...  ${USERS.users['${tender_owner}'].broker}
  ...  qualification_approve_third_award
  ...  critical
  [Setup]  Дочекатись синхронізації з майданчиком  ${tender_owner}
  [Teardown]  Оновити LAST_MODIFICATION_DATE
  Run As  ${tender_owner}  Підтвердити постачальника  ${TENDER['TENDER_UAID']}  2


Можливість затвердити остаточне рішення кваліфікації
  [Tags]   ${USERS.users['${tender_owner}'].broker}: Кваліфікація
  ...      tender_owner
  ...      ${USERS.users['${tender_owner}'].broker}
  ...      qualification_approve_qualifications
  ...      critical
  [Setup]  Дочекатись синхронізації з майданчиком  ${tender_owner}
  [Teardown]  Оновити LAST_MODIFICATION_DATE
  Run As  ${tender_owner}  Затвердити постачальників  ${TENDER['TENDER_UAID']}


Можливість вперше скасувати рішення кваліфікації учасника
  [Tags]  ${USERS.users['${tender_owner}'].broker}: Процес кваліфікації
  ...  tender_owner
  ...  ${USERS.users['${tender_owner}'].broker}
  ...  qualification_cancel_first_time
  ...  critical
  Run As  ${tender_owner}  Скасування рішення кваліфікаційної комісії  ${TENDER['TENDER_UAID']}  ${first_cancel_index}


Можливість вперше відхилити постачальника
  [Tags]  ${USERS.users['${tender_owner}'].broker}: Процес кваліфікації
  ...  tender_owner
  ...  ${USERS.users['${tender_owner}'].broker}
  ...  qualification_reject_first_time
  ...  critical
  Run As  ${tender_owner}  Дискваліфікувати постачальника  ${TENDER['TENDER_UAID']}  ${first_reject_index}


Можливість підтвердити другого постачальника
  [Tags]  ${USERS.users['${tender_owner}'].broker}: Процес кваліфікації
  ...  tender_owner
  ...  ${USERS.users['${tender_owner}'].broker}
  ...  qualification_approve_second_participant
  ...  critical
  Run As  ${tender_owner}  Підтвердити постачальника  ${TENDER['TENDER_UAID']}  ${second_approve_index}


Можливість вдруге скасувати рішення кваліфікації
  [Tags]  ${USERS.users['${tender_owner}'].broker}: Процес кваліфікації
  ...  tender_owner
  ...  ${USERS.users['${tender_owner}'].broker}
  ...  qualification_cancel_second_time
  ...  critical
  Run As  ${tender_owner}  Скасування рішення кваліфікаційної комісії  ${TENDER['TENDER_UAID']}  ${second_cancel_index}


Можливість вдруге відхилити постачальника
  [Tags]  ${USERS.users['${tender_owner}'].broker}: Процес кваліфікації
  ...  tender_owner
  ...  ${USERS.users['${tender_owner}'].broker}
  ...  qualification_reject_second_time
  ...  critical
  Run As  ${tender_owner}  Дискваліфікувати постачальника  ${TENDER['TENDER_UAID']}  ${second_reject_index}


Можливість підтвердити третього постачальника
  [Tags]  ${USERS.users['${tender_owner}'].broker}: Процес кваліфікації
  ...  tender_owner
  ...  ${USERS.users['${tender_owner}'].broker}
  ...  qualification_approve_third_participant
  ...  critical
  Run As  ${tender_owner}  Підтвердити постачальника  ${TENDER['TENDER_UAID']}  ${third_approve_index}


Можливість втретє скасувати рішення кваліфікації
  [Tags]  ${USERS.users['${tender_owner}'].broker}: Процес кваліфікації
  ...  tender_owner
  ...  ${USERS.users['${tender_owner}'].broker}
  ...  qualification_cancel_third_time
  ...  critical
  Run As  ${tender_owner}  Скасування рішення кваліфікаційної комісії  ${TENDER['TENDER_UAID']}  ${third_cancel_index}


Можливість втретє відхилити постачальника
  [Tags]  ${USERS.users['${tender_owner}'].broker}: Процес кваліфікації
  ...  tender_owner
  ...  ${USERS.users['${tender_owner}'].broker}
  ...  qualification_reject_third_time
  ...  critical
  Run As  ${tender_owner}  Дискваліфікувати постачальника  ${TENDER['TENDER_UAID']}  ${third_reject_index}

##############################################################################################
#             AWARD CLAIM
##############################################################################################

Можливість створити вимогу про виправлення визначення переможця
  [Tags]  ${USERS.users['${provider}'].broker}: Процес оскарження
  ...     provider
  ...     ${USERS.users['${provider}'].broker}
  ...     award_claim_draft
  ...     critical
  [Setup]  Дочекатись синхронізації з майданчиком  ${provider}
  [Teardown]  Оновити LAST_MODIFICATION_DATE
  ${award_index}=  Convert To Integer  ${award_index}
  Можливість створити чернетку вимоги про виправлення визначення ${award_index} переможця користувачем ${provider}


Відображення статусу 'draft' чернетки вимоги виправлення визначення переможця
  [Tags]  ${USERS.users['${viewer}'].broker}: Відображення оскарження
  ...     viewer
  ...     ${USERS.users['${viewer}'].broker}
  ...     award_claim_draft
  ...     non-critical
  [Setup]  Дочекатись синхронізації з майданчиком  ${viewer}
  ${complaintID}=  Get Variable Value  ${USERS.users['${provider}'].claim_data['complaintID']}
  Log  ${complaintID}
  Звірити відображення поля status вимоги ${complaintID} ${award_index} із draft об'єкта awards для користувача ${viewer}

##############################################################################################
#             SUBMIT AWARD CLAIM
##############################################################################################

Можливість подати вимоги про виправлення визначення переможця
  [Tags]  ${USERS.users['${provider}'].broker}: Процес оскарження
  ...     provider
  ...     ${USERS.users['${provider}'].broker}
  ...     submit_award_claim
  ...     critical
  [Teardown]  Оновити LAST_MODIFICATION_DATE
  Можливість подати вимогу на кваліфікацію ${award_index} користувачем ${provider}


Відображення статусу 'claim' вимоги про виправлення визначення переможця
  [Tags]  ${USERS.users['${viewer}'].broker}: Відображення оскарження
  ...     viewer
  ...     ${USERS.users['${viewer}'].broker}
  ...     submit_award_claim
  ...     non-critical
  [Setup]  Дочекатись синхронізації з майданчиком  ${viewer}
  ${complaintID}=  Get Variable Value  ${USERS.users['${provider}'].claim_data['complaintID']}
  Log  ${complaintID}
  Звірити відображення поля status вимоги ${complaintID} ${award_index} із claim об'єкта awards для користувача ${viewer}

##############################################################################################
#             ANSWER AWARD CLAIM
##############################################################################################

Можливість відповісти на вимогу про виправлення визначення переможця
  [Tags]  ${USERS.users['${tender_owner}'].broker}: Процес оскарження
  ...     tender_owner
  ...     ${USERS.users['${tender_owner}'].broker}
  ...     answer_award_claim
  ...     critical
  [Setup]  Дочекатись синхронізації з майданчиком  ${tender_owner}
  [Teardown]  Оновити LAST_MODIFICATION_DATE
  Можливість відповісти resolved на вимогу про виправлення визначення ${award_index} переможця


Відображення статусу 'answered' вимоги про виправлення визначення переможця
  [Tags]  ${USERS.users['${viewer}'].broker}: Відображення оскарження
  ...     viewer
  ...     ${USERS.users['${viewer}'].broker}
  ...     answer_award_claim
  ...     non-critical
  [Setup]  Дочекатись синхронізації з майданчиком  ${viewer}
  ${complaintID}=  Get Variable Value  ${USERS.users['${provider}'].claim_data['complaintID']}
  Log  ${complaintID}
  Звірити відображення поля status вимоги ${complaintID} ${award_index} із answered об'єкта awards для користувача ${provider}

##############################################################################################
#             RESOLVED AWARD CLAIM
##############################################################################################

Можливість підтвердити задоволення вимоги про виправлення визначення переможця
  [Tags]  ${USERS.users['${provider}'].broker}: Процес оскарження
  ...     provider
  ...     ${USERS.users['${provider}'].broker}
  ...     resolved_award_claim
  ...     critical
  [Setup]  Дочекатись синхронізації з майданчиком  ${provider}
  [Teardown]  Оновити LAST_MODIFICATION_DATE
  Можливість підтвердити задоволення вимоги про виправлення визначення ${award_index} переможця


Відображення статусу 'resolved' вимоги про виправлення умов закупівлі
  [Tags]  ${USERS.users['${viewer}'].broker}: Відображення оскарження
  ...     viewer
  ...     ${USERS.users['${viewer}'].broker}
  ...     resolved_award_claim
  ...     non-critical
  [Setup]  Дочекатись синхронізації з майданчиком  ${viewer}
  ${complaintID}=  Get Variable Value  ${USERS.users['${provider}'].claim_data['complaintID']}
  Log  ${complaintID}
  Звірити відображення поля status вимоги ${complaintID} ${award_index} із resolved об'єкта awards для користувача ${viewer}

##############################################################################################
#             CANCEL AWARD CLAIM
##############################################################################################

Можливість скасувати вимогу про виправлення визначення переможця
  [Tags]  ${USERS.users['${provider}'].broker}: Процес оскарження
  ...     provider
  ...     ${USERS.users['${provider}'].broker}
  ...     cancel_award_claim
  ...     critical
  [Teardown]  Оновити LAST_MODIFICATION_DATE
  ${complaintID}=  Get Variable Value  ${USERS.users['${provider}'].claim_data['complaintID']}
  Log  ${complaintID}
  Можливість скасувати ${complaintID} вимогу про виправлення визначення переможця ${award_index} користувачем ${provider}


Відображення статусу 'cancelled' чернетки вимоги про виправлення визначення переможця
  [Tags]  ${USERS.users['${viewer}'].broker}: Відображення оскарження
  ...     viewer
  ...     ${USERS.users['${viewer}'].broker}
  ...     cancel_award_claim
  ...     non-critical
  [Setup]  Дочекатись синхронізації з майданчиком  ${viewer}
  ${complaintID}=  Get Variable Value  ${USERS.users['${provider}'].claim_data['complaintID']}
  Log  ${complaintID}
  Звірити відображення поля status вимоги ${complaintID} ${award_index} із cancelled об'єкта awards для користувача ${viewer}


Відображення причини скасування чернетки вимоги про виправлення визначення переможця
  [Tags]  ${USERS.users['${viewer}'].broker}: Відображення оскарження
  ...     viewer
  ...     ${USERS.users['${viewer}'].broker}
  ...     cancel_award_claim
  ...     non-critical
  ${complaintID}=  Get Variable Value  ${USERS.users['${provider}'].claim_data['complaintID']}
  Log  ${complaintID}
  ${cancellationReason}=  Get Variable Value  ${USERS.users['${provider}'].claim_data.cancellation.data.cancellationReason}
  Log  ${cancellationReason}
  Звірити відображення поля cancellationReason вимоги ${complaintID} ${award_index} із ${cancellationReason} об'єкта awards для користувача ${viewer}