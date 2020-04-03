coding: utf-8
*** Settings ***
Resource        base_keywords.robot
Resource        aboveThreshold_keywords.robot
Suite Setup     Test Suite Setup
Suite Teardown  Test Suite Teardown

*** Variables ***
${MODE}             belowThreshold
@{USED_ROLES}       tender_owner  provider  provider1  provider2  viewer  amcu_user  payment_user
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
${canellations_index}   ${0}
${ROAD_INDEX}       ${False}
${GMDN_INDEX}       ${False}
${PLAN_TENDER}      ${True}

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

##############################################################################################
#             TENDER/LOT COMPLAINT
##############################################################################################

Можливість створити чернетку скарги про виправлення умов закупівлі тендера
  [Tags]  ${USERS.users['${provider}'].broker}: Процес оскарження
  ...     provider
  ...     ${USERS.users['${provider}'].broker}
  ...     tender_complaint_draft
  ...     critical
  [Teardown]  Оновити LAST_MODIFICATION_DATE
  Можливість створити чернетку скарги


Можливість створити чернетку скарги про виправлення умов лоту
  [Tags]  ${USERS.users['${provider}'].broker}: Процес оскарження
  ...     provider
  ...     ${USERS.users['${provider}'].broker}
  ...     lot_complaint_draft
  ...     critical
  [Setup]  Дочекатись синхронізації з майданчиком  ${provider}
  [Teardown]  Оновити LAST_MODIFICATION_DATE
  Можливість створити чернетку скарги про виправлення умов ${lot_index} лоту


Відображення статусу 'draft' чернетки скарги
  [Tags]  ${USERS.users['${viewer}'].broker}: Відображення оскарження
  ...     viewer
  ...     ${USERS.users['${viewer}'].broker}
  ...     tender_complaint_view
  ...     non-critical
  [Setup]  Дочекатись синхронізації з майданчиком  ${viewer}
  Звірити відображення поля status для вимоги ${USERS.users['${provider}'].complaint_data['complaintID']} із draft для користувача ${viewer}


Відображення заголовку скарги
  [Tags]  ${USERS.users['${viewer}'].broker}: Відображення оскарження
  ...     viewer
  ...     ${USERS.users['${viewer}'].broker}
  ...     tender_complaint_view
  ...     non-critical
  Звірити відображення поля title для вимоги ${USERS.users['${provider}'].complaint_data['complaintID']} із ${USERS.users['${provider}'].complaint_data.complaint.data.title} для користувача ${viewer}


Відображення опису скарги
  [Tags]  ${USERS.users['${viewer}'].broker}: Відображення оскарження
  ...     viewer
  ...     ${USERS.users['${viewer}'].broker}
  ...     tender_complaint_view
  ...     non-critical
  [Setup]  Дочекатись синхронізації з майданчиком  ${viewer}
  Звірити відображення поля description для вимоги ${USERS.users['${provider}'].complaint_data['complaintID']} із ${USERS.users['${provider}'].complaint_data.complaint.data.description} для користувача ${viewer}


Можливість додати документ до скарги про виправлення умов закупівлі тендера
  [Tags]  ${USERS.users['${provider}'].broker}: Процес оскарження
  ...     provider
  ...     ${USERS.users['${provider}'].broker}
  ...     tender_complaint_add_doc
  ...     critical
  [Teardown]  Оновити LAST_MODIFICATION_DATE
  Додати документ до скарги


Відображення заголовку документації скарги
  [Tags]  ${USERS.users['${viewer}'].broker}: Відображення оскарження
  ...     viewer
  ...     ${USERS.users['${viewer}'].broker}
  ...     tender_complaint_add_doc
  ...     non-critical
  Звірити відображення поля title документа ${USERS.users['${provider}'].complaint_data.documents.doc_id} до скарги ${USERS.users['${provider}'].complaint_data.complaintID} з ${USERS.users['${provider}'].complaint_data.documents.doc_name} для користувача ${viewer}


Можливість подати скаргу про виправлення умов закупівлі
  [Tags]  ${USERS.users['${provider}'].broker}: Процес оскарження
  ...     provider
  ...     ${USERS.users['${provider}'].broker}
  ...     tender_complaint_pending
  ...     critical
  [Teardown]  Оновити LAST_MODIFICATION_DATE
  Можливість подати скаргу


Відображення статусу 'pending' скарги
  [Tags]  ${USERS.users['${viewer}'].broker}: Відображення оскарження
  ...     viewer
  ...     ${USERS.users['${viewer}'].broker}
  ...     tender_complaint_pending
  ...     non-critical
  [Setup]  Дочекатись синхронізації з майданчиком  ${viewer}
  Звірити відображення поля status для вимоги ${USERS.users['${provider}'].complaint_data['complaintID']} із pending для користувача ${viewer}


Можливість прийняти скаргу до розгляду
  [Tags]   ${USERS.users['${amcu_user}'].broker}: Скарга прийнята до розгляду
  ...      amcu_user
  ...      ${USERS.users['${amcu_user}'].broker}
  ...      accept_tender_complaint
  ...      critical
  [Teardown]  Оновити LAST_MODIFICATION_DATE
  Прийняти скаргу до розгляду


Відображення статусу 'accepted' скарги
  [Tags]  ${USERS.users['${viewer}'].broker}: Відображення оскарження
  ...     viewer
  ...     ${USERS.users['${viewer}'].broker}
  ...     accept_tender_complaint
  ...     non-critical
  [Setup]  Дочекатись синхронізації з майданчиком  ${viewer}
  Звірити відображення поля status для вимоги ${USERS.users['${provider}'].complaint_data['complaintID']} із accepted для користувача ${viewer}


Можливість задовільнити скаргу
  [Tags]   ${USERS.users['${amcu_user}'].broker}: Скарга задоволена
  ...      amcu_user
  ...      ${USERS.users['${amcu_user}'].broker}
  ...      satisfy_tender_complaint
  ...      critical
  [Teardown]  Оновити LAST_MODIFICATION_DATE
  Задовільнити скаргу


Відображення статусу 'satisfied' скарги
  [Tags]  ${USERS.users['${viewer}'].broker}: Відображення оскарження
  ...     viewer
  ...     ${USERS.users['${viewer}'].broker}
  ...     satisfy_tender_complaint
  ...     non-critical
  [Setup]  Дочекатись синхронізації з майданчиком  ${viewer}
  Звірити відображення поля status для вимоги ${USERS.users['${provider}'].complaint_data['complaintID']} із satisfied для користувача ${viewer}


Можливість відхилити скаргу
  [Tags]   ${USERS.users['${amcu_user}'].broker}: Скарга відхилена
  ...      amcu_user
  ...      ${USERS.users['${amcu_user}'].broker}
  ...      decline_tender_complaint
  ...      critical
  [Teardown]  Оновити LAST_MODIFICATION_DATE
  Відхилити скаргу


Відображення статусу 'declined' скарги
  [Tags]  ${USERS.users['${viewer}'].broker}: Відображення оскарження
  ...     viewer
  ...     ${USERS.users['${viewer}'].broker}
  ...     decline_tender_complaint
  ...     non-critical
  [Setup]  Дочекатись синхронізації з майданчиком  ${viewer}
  Звірити відображення поля status для вимоги ${USERS.users['${provider}'].complaint_data['complaintID']} із declined для користувача ${viewer}


Можливість зупинити розгляд скарги
  [Tags]   ${USERS.users['${amcu_user}'].broker}: Скарга зупинена
  ...      amcu_user
  ...      ${USERS.users['${amcu_user}'].broker}
  ...      stop_tender_complaint
  ...      critical
  [Teardown]  Оновити LAST_MODIFICATION_DATE
  Зупинити розгляд скарги


Відображення статусу 'stopped' скарги
  [Tags]  ${USERS.users['${viewer}'].broker}: Відображення оскарження
  ...     viewer
  ...     ${USERS.users['${viewer}'].broker}
  ...     stop_tender_complaint
  ...     non-critical
  [Setup]  Дочекатись синхронізації з майданчиком  ${viewer}
  Звірити відображення поля status для вимоги ${USERS.users['${provider}'].complaint_data['complaintID']} із stopped для користувача ${viewer}


Можливість залишити скаргу без розгляду
  [Tags]   ${USERS.users['${amcu_user}'].broker}: Скарга без розгляду
  ...      amcu_user
  ...      ${USERS.users['${amcu_user}'].broker}
  ...      invalid_tender_complaint
  ...      critical
  [Teardown]  Оновити LAST_MODIFICATION_DATE
  Залишити скаргу без розгляду


Відображення статусу 'invalid' скарги
  [Tags]  ${USERS.users['${viewer}'].broker}: Відображення оскарження
  ...     viewer
  ...     ${USERS.users['${viewer}'].broker}
  ...     invalid_tender_complaint
  ...     non-critical
  [Setup]  Дочекатись синхронізації з майданчиком  ${viewer}
  Звірити відображення поля status для вимоги ${USERS.users['${provider}'].complaint_data['complaintID']} із invalid для користувача ${viewer}


Можливість позначити скаргу як помилково створену
  [Tags]   ${USERS.users['${provider}'].broker}: Скарга створена помилково
  ...      provider
  ...      ${USERS.users['${provider}'].broker}
  ...      mistaken_tender_complaint
  ...      critical
  [Teardown]  Оновити LAST_MODIFICATION_DATE
  Помилково створена скарга


Відображення статусу 'mistaken' скарги
  [Tags]  ${USERS.users['${viewer}'].broker}: Відображення оскарження
  ...     viewer
  ...     ${USERS.users['${viewer}'].broker}
  ...     mistaken_tender_complaint
  ...     non-critical
  [Setup]  Дочекатись синхронізації з майданчиком  ${viewer}
  Звірити відображення поля status для вимоги ${USERS.users['${provider}'].complaint_data['complaintID']} із mistaken для користувача ${viewer}


Можливість виконати рішення АМКУ Замовником
  [Tags]   ${USERS.users['${tender_owner}'].broker}: Замовник виконує рішення АМКУ
  ...      tender_owner
  ...      ${USERS.users['${tender_owner}'].broker}
  ...      resolved_tender_complaint
  ...      critical
  [Teardown]  Оновити LAST_MODIFICATION_DATE
  Виконати рішення АМКУ


Відображення статусу 'resolved' скарги
  [Tags]  ${USERS.users['${viewer}'].broker}: Відображення оскарження
  ...     viewer
  ...     ${USERS.users['${viewer}'].broker}
  ...     resolved_tender_complaint
  ...     non-critical
  [Setup]  Дочекатись синхронізації з майданчиком  ${viewer}
  Звірити відображення поля status для вимоги ${USERS.users['${provider}'].complaint_data['complaintID']} із resolved для користувача ${viewer}

##############################################################################################
#             QUALIFICATION COMPLAINT
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
  Можливість підтвердити -1 пропозицію кваліфікації


Можливість затвердити остаточне рішення кваліфікації
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


Можливість створити чернетку скарги про виправлення кваліфікації учасника
  [Tags]  ${USERS.users['${provider}'].broker}: Процес оскарження пре-кваліфікації учасника
  ...     provider
  ...     ${USERS.users['${provider}'].broker}
  ...     pre-qualification_complaint_draft
  ...     critical
  [Setup]  Дочекатись синхронізації з майданчиком  ${provider}
  [Teardown]  Оновити LAST_MODIFICATION_DATE
  Можливість створити чернетку скарги про виправлення кваліфікації ${qualification_index} учасника


Можливість додати документ до скарги про виправлення кваліфікації учасника
  [Tags]  ${USERS.users['${provider}'].broker}: Процес оскарження пре-кваліфікації учасника
  ...     provider
  ...     ${USERS.users['${provider}'].broker}
  ...     pre-qualification_complaint_add_doc
  ...     critical
  [Teardown]  Оновити LAST_MODIFICATION_DATE
  Додати документ до скарги ${qualification_index} учасника в qualifications


Можливість подати скаргу про виправлення визначення кваліфікації учасника
  [Tags]  ${USERS.users['${provider}'].broker}: Процес оскарження пре-кваліфікації учасника
  ...     provider
  ...     ${USERS.users['${provider}'].broker}
  ...     pre-qualification_complaint_pending
  ...     critical
  [Teardown]  Оновити LAST_MODIFICATION_DATE
  Можливість подати скаргу на визначення пре-кваліфікації ${qualification_index} учасника


Можливість позначити скаргу на визначення пре-кваліфікації учасника як помилково створену
  [Tags]   ${USERS.users['${provider}'].broker}: Скарга пре-кваліфікації учасника створена помилково
  ...      provider
  ...      ${USERS.users['${provider}'].broker}
  ...      mistaken_pre-qualification_complaint
  ...      critical
  [Teardown]  Оновити LAST_MODIFICATION_DATE
  Помилково створена скарга на визначення пре-кваліфікації ${qualification_index} учасника


Можливість залишити скаргу на визначення пре-кваліфікації учасника ,tp
  [Tags]   ${USERS.users['${amcu_user}'].broker}: Скарга пре-кваліфікації учасника без розгляду
  ...      amcu_user
  ...      ${USERS.users['${amcu_user}'].broker}
  ...      invalid_pre-qualification_complaint
  ...      critical
  [Teardown]  Оновити LAST_MODIFICATION_DATE
  Залишити скаргу на визначення пре-кваліфікації ${qualification_index} учасника без розгляду


Можливість прийняти скаргу на визначення пре-кваліфікації учасника
  [Tags]   ${USERS.users['${amcu_user}'].broker}: Скарга прийнята до розгляду
  ...      amcu_user
  ...      ${USERS.users['${amcu_user}'].broker}
  ...      accept_pre-qualification_complaint
  ...      critical
  [Teardown]  Оновити LAST_MODIFICATION_DATE
  Прийняти скаргу на визначення пре-кваліфікації ${qualification_index} учасника до розгляду


Можливість задовільнити скаргу на визначення пре-кваліфікації учасника
  [Tags]   ${USERS.users['${amcu_user}'].broker}: Скарга пре-кваліфікації учасника задоволена
  ...      amcu_user
  ...      ${USERS.users['${amcu_user}'].broker}
  ...      satisfy_pre-qualification_complaint
  ...      critical
  [Teardown]  Оновити LAST_MODIFICATION_DATE
  Задовільнити скаргу на визначення пре-кваліфікації ${qualification_index} учасника


Можливість виконати рішення АМКУ Замовником
  [Tags]   ${USERS.users['${tender_owner}'].broker}: Замовник виконує рішення АМКУ по скарзі пре-кваліфікації учасника
  ...      tender_owner
  ...      ${USERS.users['${tender_owner}'].broker}
  ...      resolved_pre-qualification_complaint
  ...      critical
  [Teardown]  Оновити LAST_MODIFICATION_DATE
  Виконати рішення АМКУ по скарзі на визначення пре-кваліфікації ${qualification_index} учасника


Можливість відхилити скаргу на визначення пре-кваліфікації учасника
  [Tags]   ${USERS.users['${amcu_user}'].broker}: Скарга пре-кваліфікації учасника відхилена
  ...      amcu_user
  ...      ${USERS.users['${amcu_user}'].broker}
  ...      decline_pre-qualification_complaint
  ...      critical
  [Teardown]  Оновити LAST_MODIFICATION_DATE
  Відхилити скаргу на визначення пре-кваліфікації ${qualification_index} учасника


Можливість зупинити розгляд скарги на визначення пре-кваліфікації учасника
  [Tags]   ${USERS.users['${amcu_user}'].broker}: Скарга пре-кваліфікації учасника зупинена
  ...      amcu_user
  ...      ${USERS.users['${amcu_user}'].broker}
  ...      stop_pre-qualification_complaint
  ...      critical
  [Teardown]  Оновити LAST_MODIFICATION_DATE
  Зупинити скаргу на визначення пре-кваліфікації ${qualification_index} учасника

##############################################################################################
#             AWARD COMPLAINT
##############################################################################################

Можливість дочекатись дати початку періоду кваліфікації
  [Tags]  ${USERS.users['${provider}'].broker}: Подання кваліфікації
  ...     provider
  ...     ${USERS.users['${provider}'].broker}
  ...     awardPeriod_startDate
  ...     critical
  [Teardown]  Оновити LAST_MODIFICATION_DATE
  Дочекатись дати початку періоду кваліфікації  ${provider}  ${TENDER['TENDER_UAID']}


Можливість підтвердити учасника
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


Можливість створити чернетку скарги про виправлення визначення переможця
  [Tags]  ${USERS.users['${provider}'].broker}: Процес оскарження визначення переможця
  ...     provider
  ...     ${USERS.users['${provider}'].broker}
  ...     award_complaint_draft
  ...     critical
  [Setup]  Дочекатись синхронізації з майданчиком  ${provider}
  [Teardown]  Оновити LAST_MODIFICATION_DATE
  Можливість створити чернетку скарги про виправлення визначення ${award_index} переможця


Можливість додати документ до скарги про виправлення визначення переможця
  [Tags]  ${USERS.users['${provider}'].broker}: Процес оскарження визначення переможця
  ...     provider
  ...     ${USERS.users['${provider}'].broker}
  ...     award_complaint_add_doc
  ...     critical
  [Teardown]  Оновити LAST_MODIFICATION_DATE
  Додати документ до скарги ${award_index} учасника в awards


Можливість подати скаргу про виправлення визначення переможця
  [Tags]  ${USERS.users['${provider}'].broker}: Процес оскарження визначення переможця
  ...     provider
  ...     ${USERS.users['${provider}'].broker}
  ...     award_complaint_pending
  ...     critical
  [Teardown]  Оновити LAST_MODIFICATION_DATE
  Можливість подати скаргу на визначення ${award_index} переможця


Можливість позначити скаргу на визначення переможця як помилково створену
  [Tags]   ${USERS.users['${provider}'].broker}: Скарга визначення переможця створена помилково
  ...      provider
  ...      ${USERS.users['${provider}'].broker}
  ...      mistaken_award_complaint
  ...      critical
  [Teardown]  Оновити LAST_MODIFICATION_DATE
  Помилково створена скарга на визначення ${award_index} переможця


Можливість залишити скаргу на визначення переможця без розгляду
  [Tags]   ${USERS.users['${amcu_user}'].broker}: Скарга на визначення переможця без розгляду
  ...      amcu_user
  ...      ${USERS.users['${amcu_user}'].broker}
  ...      invalid_award_complaint
  ...      critical
  [Teardown]  Оновити LAST_MODIFICATION_DATE
  Залишити скаргу на визначення ${award_index} переможця без розгляду


Можливість прийняти скаргу на визначення переможця до розгляду
  [Tags]   ${USERS.users['${amcu_user}'].broker}: Скарга прийнята до розгляду
  ...      amcu_user
  ...      ${USERS.users['${amcu_user}'].broker}
  ...      accept_award_complaint
  ...      critical
  [Teardown]  Оновити LAST_MODIFICATION_DATE
  Прийняти скаргу на визначення ${award_index} переможця до розгляду


Можливість задовільнити скаргу на визначення переможця
  [Tags]   ${USERS.users['${amcu_user}'].broker}: Скарга на визначення переможця задоволена
  ...      amcu_user
  ...      ${USERS.users['${amcu_user}'].broker}
  ...      satisfy_award_complaint
  ...      critical
  [Teardown]  Оновити LAST_MODIFICATION_DATE
  Задовільнити скаргу на визначення ${award_index} переможця


Можливість виконати рішення АМКУ Замовником
  [Tags]   ${USERS.users['${tender_owner}'].broker}: Замовник виконує рішення АМКУ по скарзі на визначення переможця
  ...      tender_owner
  ...      ${USERS.users['${tender_owner}'].broker}
  ...      resolved_award_complaint
  ...      critical
  [Teardown]  Оновити LAST_MODIFICATION_DATE
  Виконати рішення АМКУ по скарзі на визначення ${award_index} переможця


Можливість відхилити скаргу на визначення переможця
  [Tags]   ${USERS.users['${amcu_user}'].broker}: Скарга на визначення переможця відхилена
  ...      amcu_user
  ...      ${USERS.users['${amcu_user}'].broker}
  ...      decline_award_complaint
  ...      critical
  [Teardown]  Оновити LAST_MODIFICATION_DATE
  Відхилити скаргу на визначення ${award_index} переможця


Можливість зупинити розгляд скарги на визначення переможця
  [Tags]   ${USERS.users['${amcu_user}'].broker}: Скарга на визначення переможця зупинена
  ...      amcu_user
  ...      ${USERS.users['${amcu_user}'].broker}
  ...      stop_award_complaint
  ...      critical
  [Teardown]  Оновити LAST_MODIFICATION_DATE
  Зупинити скаргу на визначення ${award_index} переможця

##############################################################################################
#             CANCELLATION COMPLAINT
##############################################################################################

Можливість скасувати лот
  [Tags]  ${USERS.users['${tender_owner}'].broker}: Скасування лота
  ...  tender_owner
  ...  ${USERS.users['${tender_owner}'].broker}
  ...  lot_cancellation
  [Teardown]  Оновити LAST_MODIFICATION_DATE
  Можливість скасувати 0 лот


Відображення активного статусу скасування лота
  [Tags]  ${USERS.users['${viewer}'].broker}: Відображення скасування лота
  ...  viewer
  ...  ${USERS.users['${viewer}'].broker}
  ...  lot_cancellation
  [Setup]  Дочекатись синхронізації з майданчиком  ${viewer}
  ${cancellation_index}=  Отримати останній індекс  cancellations  ${tender_owner}  ${viewer}
  Звірити поле тендера із значенням  ${viewer}  ${TENDER['TENDER_UAID']}
  ...      active
  ...      cancellations[${cancellation_index}].status


Можливість створити чернетку скарги на скасування лота
  [Tags]  ${USERS.users['${provider}'].broker}: Процес оскарження визначення переможця
  ...     provider
  ...     ${USERS.users['${provider}'].broker}
  ...     lot_cancellation_complaint_draft
  ...     critical
  [Setup]  Дочекатись синхронізації з майданчиком  ${provider}
  [Teardown]  Оновити LAST_MODIFICATION_DATE
  Можливість створити чернетку скарги на скасування ${canellations_index} лота

*** Keywords ***

Можливість скасувати ${index} лот
  ${cancellation_data}=  Підготувати дані про скасування
  ${lot_id}=  get_id_from_object  ${USERS.users['${tender_owner}'].initial_data.data.lots[${index}]}
  Run As  ${tender_owner}
  ...      Скасувати лот
  ...      ${TENDER['TENDER_UAID']}
  ...      ${lot_id}
  ...      ${cancellation_data['cancellation_reason']}
  ...      ${cancellation_data['document']['doc_path']}
  ...      ${cancellation_data['description']}
  Set To Dictionary  ${USERS.users['${tender_owner}']}  lot_cancellation_data=${cancellation_data}


