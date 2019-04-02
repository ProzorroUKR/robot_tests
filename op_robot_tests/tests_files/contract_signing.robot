*** Settings ***
Resource        base_keywords.robot
Suite Setup     Test Suite Setup
Suite Teardown  Test Suite Teardown

*** Variables ***
@{USED_ROLES}   tender_owner  viewer


*** Test Cases ***
Можливість знайти закупівлю по ідентифікатору
  [Tags]   ${USERS.users['${viewer}'].broker}: Пошук тендера
  ...      viewer  tender_owner
  ...      ${USERS.users['${viewer}'].broker}  ${USERS.users['${tender_owner}'].broker}
  ...      find_tender  level1
  ...      critical
  Завантажити дані про тендер
  :FOR  ${username}  IN  ${viewer}  ${tender_owner}
  \   Run As  ${username}  Пошук тендера по ідентифікатору  ${TENDER['TENDER_UAID']}

##############################################################################################
#             CONTRACT
##############################################################################################

Відображення закінчення періоду подачі скарг на пропозицію
  [Tags]   ${USERS.users['${tender_owner}'].broker}: Відображення основних даних тендера
  ...      tender_owner
  ...      ${USERS.users['${tender_owner}'].broker}
  ...      contract_stand_still
  ...      critical
  ${award_index}=  Отримати останній індекс  awards  ${tender_owner}  ${viewer}
  :FOR  ${username}  IN  ${viewer}  ${tender_owner}
  \  Отримати дані із тендера  ${username}  ${TENDER['TENDER_UAID']}  awards[${award_index}].complaintPeriod.endDate


Дочекатися закічення stand still періоду
  [Tags]   ${USERS.users['${tender_owner}'].broker}: Процес укладання угоди
  ...      tender_owner
  ...      ${USERS.users['${tender_owner}'].broker}
  ...      contract_stand_still
  ...      critical
  ${award_index}=  Отримати останній індекс  awards  ${tender_owner}  ${viewer}
  ${standstillEnd}=  Get Variable Value  ${USERS.users['${tender_owner}'].tender_data.data.awards[${award_index}].complaintPeriod.endDate}
  Дочекатись дати  ${standstillEnd}


Відображення вартості угоди без урахування ПДВ
  [Tags]   ${USERS.users['${viewer}'].broker}: Відображення основних даних угоди
  ...      viewer
  ...      ${USERS.users['${viewer}'].broker}
  ...      contract_view
  ...      non-critical
  [Setup]  Дочекатись синхронізації з майданчиком  ${viewer}
  ${award_index}=  Отримати останній індекс  awards  ${tender_owner}  ${viewer}
  ${award}=  Get From List  ${USERS.users['${viewer}'].tender_data.data.awards}  ${award_index}
  ${award_amount}=  Get From Dictionary  ${award.value}  amount
  ${contract_index}=  Отримати останній індекс  contracts  ${tender_owner}  ${viewer}
  ${amount_net_field}=  Set Variable  contracts[${contract_index}].value.amountNet
  Звірити відображення поля ${amount_net_field} тендера із ${award_amount} для користувача ${viewer}


Відображення вартості угоди
  [Tags]   ${USERS.users['${viewer}'].broker}: Відображення основних даних угоди
  ...      viewer
  ...      ${USERS.users['${viewer}'].broker}
  ...      contract_view
  ...      non-critical
  [Setup]  Дочекатись синхронізації з майданчиком  ${viewer}
  ${contract_index}=  Отримати останній індекс  contracts  ${tender_owner}  ${viewer}
  ${amount_field}=  Set Variable  contracts[${contract_index}].value.amount
  Отримати дані із поля ${amount_field} тендера для користувача ${viewer}


Можливість змінити ознаку контракту на без ПДВ
  [Tags]   ${USERS.users['${tender_owner}'].broker}: Редагування угоди
  ...      tender_owner
  ...      ${USERS.users['${tender_owner}'].broker}
  ...      modify_contract_vat_to_false
  ...      critical
  [Setup]  Дочекатись синхронізації з майданчиком  ${tender_owner}
  [Teardown]  Оновити LAST_MODIFICATION_DATE
  ${contract_index}=  Отримати останній індекс  contracts  ${tender_owner}  ${viewer}
  Set to dictionary  ${USERS.users['${tender_owner}']}  valueAddedTaxIncluded=${False}
  Run As  ${tender_owner}  Змінити ознаку ПДВ  ${TENDER['TENDER_UAID']}  ${contract_index}  ${False}


Можливість змінити ознаку контракту на з ПДВ
  [Tags]   ${USERS.users['${tender_owner}'].broker}: Редагування угоди
  ...      tender_owner
  ...      ${USERS.users['${tender_owner}'].broker}
  ...      modify_contract_vat_to_true
  ...      critical
  [Setup]  Дочекатись синхронізації з майданчиком  ${tender_owner}
  [Teardown]  Оновити LAST_MODIFICATION_DATE
  ${contract_index}=  Отримати останній індекс  contracts  ${tender_owner}  ${viewer}
  ${award}=  Отримати останній элемент  awards  ${tender_owner}  ${viewer}
  ${contract}=  Отримати останній элемент  contracts  ${tender_owner}  ${viewer}
  ${amount_net}=  create_fake_amount_net  ${award.value.amount}  ${award.value.valueAddedTaxIncluded}  ${contract.value.valueAddedTaxIncluded}
  Set to dictionary  ${USERS.users['${tender_owner}']}  valueAddedTaxIncluded=${True}
  Set to dictionary  ${USERS.users['${tender_owner}']}  amountNet=${amount_net}
  Run As  ${tender_owner}  Змінити ознаку ПДВ на True  ${TENDER['TENDER_UAID']}  ${contract_index}  ${True}  ${amount_net}


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


Можливість змінити значення вартості угоду з/без ПДВ
  [Tags]   ${USERS.users['${tender_owner}'].broker}: Редагування угоди
  ...      tender_owner
  ...      ${USERS.users['${tender_owner}'].broker}
  ...      modify_contract_amount_and_amountNet
  ...      critical
  [Setup]  Дочекатись синхронізації з майданчиком  ${tender_owner}
  [Teardown]  Оновити LAST_MODIFICATION_DATE
  ${award}=  Отримати останній элемент  awards  ${tender_owner}  ${viewer}
  ${contract}=  Отримати останній элемент  contracts  ${tender_owner}  ${viewer}
  ${amount_both_fields}=  create_fake_amount  ${award.value.amount}  ${award.value.valueAddedTaxIncluded}  ${contract.value.valueAddedTaxIncluded}
  ${contract_index}=  Отримати останній індекс  contracts  ${tender_owner}  ${viewer}
  Set to dictionary  ${USERS.users['${tender_owner}']}  amount_both_fields=${amount_both_fields}
  Run As  ${tender_owner}  Редагувати обидва поля вартості угоди
  ...      ${TENDER['TENDER_UAID']}
  ...      ${contract_index}
  ...      value.amount
  ...      value.amountNet
  ...      ${amount_both_fields}


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


Відображення одночасно відредагованої вартості угоди з/без ПДВ
  [Tags]   ${USERS.users['${viewer}'].broker}: Відображення основних даних угоди
  ...      viewer
  ...      ${USERS.users['${viewer}'].broker}  ${USERS.users['${tender_owner}'].broker}.
  ...      contract_view_new_amount_and_amountNet
  ...      non-critical
  [Setup]  Дочекатись синхронізації з майданчиком  ${viewer}
  ${amount_both_fields}=  Get Variable Value  ${USERS.users['${tender_owner}'].amount_both_fields}
  ${contract_index}=  Отримати останній індекс  contracts  ${tender_owner}  ${viewer}
  ${amount_net_field}=  Set Variable  contracts[${contract_index}].value.amountNet
  ${amount_field}=  Set Variable  contracts[${contract_index}].value.amount
  Звірити відображення поля ${amount_net_field} тендера із ${amount_both_fields} для користувача ${viewer}
  Звірити відображення поля ${amount_field} тендера із ${amount_both_fields} для користувача ${viewer}


Неможливість вказати ціну договору без ПДВ більше ніж результат проведення аукціону
# contract:value:amountNet should be <= award.value.amount if valueAddedTaxIncluded=false
# lots:value:valueAddedTaxIncluded:false - contract:value:valueAddedTaxIncluded:true
# lots:value:valueAddedTaxIncluded:true - contract:value:valueAddedTaxIncluded:false
# lots:value:valueAddedTaxIncluded:false - contract:value:valueAddedTaxIncluded:false
  [Tags]   ${USERS.users['${tender_owner}'].broker}: Редагування угоди
  ...      tender_owner
  ...      ${USERS.users['${tender_owner}'].broker}
  ...      modify_contract_invalid_amountNet
  ...      critical
  [Setup]  Дочекатись синхронізації з майданчиком  ${tender_owner}
  ${award}=  Отримати останній элемент  awards  ${tender_owner}  ${viewer}
  ${contract}=  Отримати останній элемент  contracts  ${tender_owner}  ${viewer}
  ${contract_index}=  Отримати останній індекс  contracts  ${tender_owner}  ${viewer}
  ${amount_net}=  Evaluate  ${award.value.amount} * 2
  ${value}=  Require Failure  ${tender_owner}  Редагувати угоду
  ...      ${TENDER['TENDER_UAID']}
  ...      ${contract_index}
  ...      value.amountNet
  ...      ${amount_net}
  Run Keyword IF  '${award.value.valueAddedTaxIncluded}' == '${False}' and '${contract.value.valueAddedTaxIncluded}' == '${True}'
  ...      Should Contain  ${value}  AmountNet should be less or equal to awarded amount
  Run Keyword IF  '${award.value.valueAddedTaxIncluded}' == '${True}' and '${contract.value.valueAddedTaxIncluded}' == '${False}'
  ...      Should Contain  ${value}  Amount and amountNet should be equal
  Run Keyword IF  '${award.value.valueAddedTaxIncluded}' == '${False}' and '${contract.value.valueAddedTaxIncluded}' == '${False}'
  ...      Should Contain  ${value}  Amount and amountNet should be equal


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
  #Run Keyword IF  '${award.value.valueAddedTaxIncluded}' == '${True}' and '${contract.value.valueAddedTaxIncluded}' == '${True}'
  #...      Should Contain  ${value}  Amount should be less or equal to awarded amount
  Run Keyword IF  '${award.value.valueAddedTaxIncluded}' == '${True}' and '${contract.value.valueAddedTaxIncluded}' == '${False}'
  ...      Should Contain  ${value}  Amount should be less or equal to awarded amount
  Run Keyword IF  '${award.value.valueAddedTaxIncluded}' == '${False}' and '${contract.value.valueAddedTaxIncluded}' == '${False}'
  ...      Should Contain  ${value}  Amount should be less or equal to awarded amount


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


Неможливість збільшити ціну договору з ПДВ на суму більшу за 20% від ціни договору без ПДВ (закупівля без ПДВ)
# contract:value:amount can be >= contract:value:amountNet  but no more than on 20% of contract:value:amountNet value if valueAddedTaxIncluded=false
# lots:value:valueAddedTaxIncluded:false - contract:value:valueAddedTaxIncluded:true
  [Tags]   ${USERS.users['${tender_owner}'].broker}: Редагування угоди
  ...      tender_owner
  ...      ${USERS.users['${tender_owner}'].broker}
  ...      modify_contract_invalid_amount_tender_vat_false
  ...      critical
  [Setup]  Дочекатись синхронізації з майданчиком  ${tender_owner}
  ${award}=  Отримати останній элемент  awards  ${tender_owner}  ${viewer}
  ${contract_index}=  Отримати останній індекс  contracts  ${tender_owner}  ${viewer}
  ${amount}=  Evaluate  ${award.value.amount} * 2
  ${value}=  Require Failure  ${tender_owner}  Редагувати угоду
  ...      ${TENDER['TENDER_UAID']}
  ...      ${contract_index}
  ...      value.amount
  ...      ${amount}
  Should Contain  ${value}  Amount should be greater than amountNet and differ by no more than 20.0%"


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


Відображення дати підписання угоди
  [Tags]   ${USERS.users['${viewer}'].broker}: Відображення основних даних угоди
  ...      viewer
  ...      ${USERS.users['${viewer}'].broker}
  ...      contract_view
  ...      non-critical
  [Setup]  Дочекатись синхронізації з майданчиком  ${viewer}
  ${contract_index}=  Отримати останній індекс  contracts  ${tender_owner}  ${viewer}
  Звірити відображення дати contracts[${contract_index}].dateSigned контракту із ${USERS.users['${tender_owner}'].dateSigned} для користувача ${viewer}


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


Відображення дати початку дії угоди
  [Tags]   ${USERS.users['${viewer}'].broker}: Відображення основних даних угоди
  ...      viewer
  ...      ${USERS.users['${viewer}'].broker}
  ...      contract_view
  ...      non-critical
  [Setup]  Дочекатись синхронізації з майданчиком  ${viewer}
  ${contract_index}=  Отримати останній індекс  contracts  ${tender_owner}  ${viewer}
  Звірити відображення дати contracts[${contract_index}].period.startDate контракту із ${USERS.users['${tender_owner}'].contract_startDate} для користувача ${viewer}


Відображення дати завершення дії угоди
  [Tags]   ${USERS.users['${viewer}'].broker}: Відображення основних даних угоди
  ...      viewer
  ...      ${USERS.users['${viewer}'].broker}
  ...      contract_view
  ...      non-critical
  [Setup]  Дочекатись синхронізації з майданчиком  ${viewer}
  ${contract_index}=  Отримати останній індекс  contracts  ${tender_owner}  ${viewer}
  Звірити відображення дати contracts[${contract_index}].period.endDate контракту із ${USERS.users['${tender_owner}'].contract_endDate} для користувача ${viewer}


Можливість завантажити документацію в угоду
  [Tags]   ${USERS.users['${tender_owner}'].broker}: Завантаження документації в угоду
  ...      tender_owner
  ...      ${USERS.users['${tender_owner}'].broker}
  ...      add_doc_to_contract
  [Setup]  Дочекатись синхронізації з майданчиком  ${tender_owner}
  [Teardown]  Оновити LAST_MODIFICATION_DATE
  ${contract_index}=  Отримати останній індекс  contracts  ${tender_owner}  ${viewer}
  Можливість завантажити документ в ${contract_index} угоду користувачем ${tender_owner}


Відображення заголовку документа
  [Tags]   ${USERS.users['${viewer}'].broker}: Відображення документації
  ...      viewer
  ...      ${USERS.users['${viewer}'].broker}
  ...      add_doc_to_contract
  [Setup]  Дочекатись синхронізації з майданчиком  ${viewer}
  Звірити відображення поля title документа ${USERS.users['${tender_owner}']['contract_doc']['id']} із ${USERS.users['${tender_owner}']['contract_doc']['name']} для користувача ${viewer}


Відображення вмісту документа
  [Tags]   ${USERS.users['${viewer}'].broker}: Відображення документації
  ...      viewer
  ...      ${USERS.users['${viewer}'].broker}
  ...      add_doc_to_contract
  Звірити відображення вмісту документа ${USERS.users['${tender_owner}']['contract_doc']['id']} із ${USERS.users['${tender_owner}']['contract_doc']['content']} для користувача ${viewer}


Відображення прив'язки документа до тендера
  [Tags]   ${USERS.users['${viewer}'].broker}: Відображення документації
  ...      viewer
  ...      ${USERS.users['${viewer}'].broker}
  ...      contract_doc_documentOf
  Звірити відображення поля documentOf документа ${USERS.users['${tender_owner}']['contract_doc']['id']} із tender для користувача ${viewer}


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


Неможливість підтвердити постачальника після закінчення періоду кваліфікації
  [Tags]  ${USERS.users['${tender_owner}'].broker}: Процес кваліфікації
  ...  tender_owner
  ...  ${USERS.users['${tender_owner}'].broker}
  ...  awarding_approve_first_award
  ...  critical
  [Setup]  Дочекатись дати закінчення періоду кваліфікації  ${tender_owner}  ${TENDER['TENDER_UAID']}
  Run keyword and expect error  *  Run As  ${tender_owner}  Підтвердити постачальника  ${TENDER['TENDER_UAID']}  0


Можливість встановити ціну за одиницю для першого контракту
  [Tags]   ${USERS.users['${tender_owner}'].broker}: Редагування угоди
  ...      tender_owner
  ...      ${USERS.users['${tender_owner}'].broker}
  ...      modify_agreement
  ...      critical
  [Setup]  Дочекатись синхронізації з майданчиком  ${tender_owner}
  [Teardown]  Оновити LAST_MODIFICATION_DATE
  ${contract_data}=  Розрахувати ціну для 0 контракту
  Run As  ${tender_owner}  Встановити ціну за одиницю для контракту  ${TENDER['TENDER_UAID']}  ${contract_data}


Можливість встановити ціну за одиницю для другого контракту
  [Tags]   ${USERS.users['${tender_owner}'].broker}: Редагування угоди
  ...      tender_owner
  ...      ${USERS.users['${tender_owner}'].broker}
  ...      modify_agreement
  ...      critical
  [Setup]  Дочекатись синхронізації з майданчиком  ${tender_owner}
  [Teardown]  Оновити LAST_MODIFICATION_DATE
  ${contract_data}=  Розрахувати ціну для 1 контракту
  Run As  ${tender_owner}  Встановити ціну за одиницю для контракту  ${TENDER['TENDER_UAID']}  ${contract_data}


Можливість встановити ціну за одиницю для третього контракту
  [Tags]   ${USERS.users['${tender_owner}'].broker}: Редагування угоди
  ...      tender_owner
  ...      ${USERS.users['${tender_owner}'].broker}
  ...      modify_agreement
  ...      critical
  [Setup]  Дочекатись синхронізації з майданчиком  ${tender_owner}
  [Teardown]  Оновити LAST_MODIFICATION_DATE
  ${contract_data}=  Розрахувати ціну для 2 контракту
  Run As  ${tender_owner}  Встановити ціну за одиницю для контракту  ${TENDER['TENDER_UAID']}  ${contract_data}


Можливість зареєструвати угоду
  [Tags]   ${USERS.users['${tender_owner}'].broker}: Редагування угоди
  ...      tender_owner
  ...      ${USERS.users['${tender_owner}'].broker}
  ...      modify_agreement
  ...      critical
  [Setup]  Дочекатись можливості зареєструвати угоди  ${tender_owner}
  [Teardown]  Оновити LAST_MODIFICATION_DATE
  ${days}=  create_fake_number  366  1460
  ${period}=  create_fake_period  days=${days}
  Run As  ${tender_owner}  Зареєструвати угоду  ${TENDER['TENDER_UAID']}  ${period}


Відображення статусу зареєстрованої угоди
  [Tags]   ${USERS.users['${viewer}'].broker}: Відображення основних даних угоди
  ...      viewer
  ...      ${USERS.users['${viewer}'].broker}
  ...      agreement_registration
  ...      critical
  [Setup]  Дочекатись синхронізації з майданчиком  ${viewer}
  Звірити відображення поля agreements[0].status тендера із active для користувача ${viewer}


Відображення статусу успішного завершення тендера
  [Tags]   ${USERS.users['${viewer}'].broker}: Відображення основних даних угоди
  ...      viewer
  ...      ${USERS.users['${viewer}'].broker}
  ...      agreement_registration
  ...      critical
  [Setup]  Дочекатись синхронізації з майданчиком  ${viewer}
  Звірити відображення поля status тендера із complete для користувача ${viewer}