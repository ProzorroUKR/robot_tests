*** Settings ***
Resource        keywords.robot
Resource        resource.robot
Suite Setup     Test Suite Setup
Suite Teardown  Test Suite Teardown
Library         Selenium2Library

*** Variables ***
@{USED_ROLES}  viewer  provider  provider1  provider2

*** Test Cases ***
Можливість знайти закупівлю по ідентифікатору
  [Tags]   ${USERS.users['${viewer}'].broker}: Пошук тендера
  ...      ${USERS.users['${viewer}'].broker}
  ...      find_tender
  Завантажити дані про тендер
  Run As  ${viewer}  Пошук тендера по ідентифікатору   ${TENDER['TENDER_UAID']}

##############################################################################################
#             AUCTION
##############################################################################################

Відображення дати початку аукціону
  [Tags]   ${USERS.users['${viewer}'].broker}: Відображення основних даних аукціону
  ...      viewer
  ...      ${USERS.users['${viewer}'].broker}
  ...      tender_view
  [Setup]  Дочекатись дати закінчення прийому пропозицій  ${viewer}  ${TENDER['TENDER_UAID']}
  Дочекатись дати початку періоду аукціону  ${viewer}  ${TENDER['TENDER_UAID']}
  Отримати дані із тендера  ${viewer}  ${TENDER['TENDER_UAID']}  auctionPeriod.startDate  ${TENDER['LOT_ID']}


Можливість дочекатись початку етапу аукціону
  [Tags]   ${USERS.users['${viewer}'].broker}: Очікування початку періоду аукціону
  ...      tender_owner
  ...      ${USERS.users['${viewer}'].broker}
  ...      tender_view
  Дочекатись дати початку періоду аукціону  ${viewer}  ${TENDER['TENDER_UAID']}


Можливість вичитати посилання на аукціон для першого учасника
  [Tags]   ${USERS.users['${provider}'].broker}: Процес аукціону
  ...      provider
  ...      ${USERS.users['${provider}'].broker}
  ...      auction_url_provider
  Можливість вичитати посилання на аукціон для ${provider}


Можливість вичитати посилання на аукціон для другого учасника
  [Tags]   ${USERS.users['${provider1}'].broker}: Процес аукціону
  ...      provider1
  ...      ${USERS.users['${provider1}'].broker}
  ...      auction_url_provider1
  Можливість вичитати посилання на аукціон для ${provider1}


Можливість вичитати посилання на аукціон для третього учасника
  [Tags]   ${USERS.users['${provider2}'].broker}: Процес аукціону
  ...      provider2
  ...      ${USERS.users['${provider2}'].broker}
  ...      auction_url_provider2
  Можливість вичитати посилання на аукціон для ${provider2}


Можливість вичитати посилання на аукціон для глядача
  [Tags]   ${USERS.users['${viewer}'].broker}: Процес аукціону
  ...      viewer
  ...      ${USERS.users['${viewer}'].broker}
  ...      auction_url_viewer
  Можливість вичитати посилання на аукціон для ${viewer}


Можливість дочекатися дати початку аукціону
  [Tags]   ${USERS.users['${viewer}'].broker}: Процес аукціону
  ...      viewer
  ...      ${USERS.users['${viewer}'].broker}
  ...      auction
  Дочекатись дати початку аукціону  ${viewer}


Можливість дочекатись першого раунду
  [Tags]   ${USERS.users['${viewer}'].broker}: Процес аукціону
  ...      viewer  provider  provider1
  ...      ${USERS.users['${viewer}'].broker}
  ...      ${USERS.users['${provider}'].broker}
  ...      ${USERS.users['${provider1}'].broker}
  ...      auction
  Дочекатись завершення паузи перед першим раундом


Можливість проведення 1 го раунду аукціону для першого учасника
  [Tags]   ${USERS.users['${provider}'].broker}: Процес аукціону
  ...      provider
  ...      ${USERS.users['${provider}'].broker}
  ...      auction
  Вибрати учасника, який може зробити ставку
  Поставити ставку в 0.69 відсотків від максимальної
  Дочекатись учасником закінчення стадії ставок
  Перевірити чи ставка була прийнята


Можливість проведення 1 го раунду аукціону для другого учасника
  [Tags]   ${USERS.users['${provider1}'].broker}: Процес аукціону
  ...      provider1
  ...      ${USERS.users['${provider1}'].broker}
  ...      auction
  Вибрати учасника, який може зробити ставку
  Поставити ставку більшу від максимальної на 1 грн
  Поставити ставку в 0.69 відсотків від максимальної
  Дочекатись учасником закінчення стадії ставок
  Перевірити чи ставка була прийнята


Можливість дочекатись другого раунду
  [Tags]   ${USERS.users['${viewer}'].broker}: Процес аукціону
  ...      viewer  provider  provider1
  ...      ${USERS.users['${viewer}'].broker}
  ...      ${USERS.users['${provider}'].broker}
  ...      ${USERS.users['${provider1}'].broker}
  ...      auction
  Дочекатись завершення паузи перед 2 раундом


Можливість проведення 2 го раунду аукціону для першого учасника
  [Tags]   ${USERS.users['${provider}'].broker}: Процес аукціону
  ...      provider
  ...      ${USERS.users['${provider}'].broker}
  ...      auction
  Вибрати учасника, який може зробити ставку
  Поставити малу ставку в 1 грн
  Відмінитити ставку
  Поставити максимально можливу ставку
  Дочекатись учасником закінчення стадії ставок
  Перевірити чи ставка була прийнята


Можливість проведення 2 го раунду аукціону для другого учасника
  [Tags]   ${USERS.users['${provider1}'].broker}: Процес аукціону
  ...      provider1
  ...      ${USERS.users['${provider1}'].broker}
  ...      auction
  Дочекатись учасником закінчення стадії ставок
  Вибрати учасника, який може зробити ставку
  Поставити максимально можливу ставку
  Дочекатись учасником закінчення стадії ставок
  Перевірити чи ставка була прийнята


Можливість дочекатись третього раунду
  [Tags]   ${USERS.users['${viewer}'].broker}: Процес аукціону
  ...      viewer  provider  provider1
  ...      ${USERS.users['${viewer}'].broker}
  ...      ${USERS.users['${provider}'].broker}
  ...      ${USERS.users['${provider1}'].broker}
  ...      auction
  Дочекатись завершення паузи перед 3 раундом


Можливість проведення 3 го раунду аукціону для першого учасника
  [Tags]   ${USERS.users['${provider}'].broker}: Процес аукціону
  ...      provider
  ...      ${USERS.users['${provider}'].broker}
  ...      auction
  Вибрати учасника, який може зробити ставку
  Поставити нульову ставку
  Поставити максимально можливу ставку
  Дочекатись учасником закінчення стадії ставок
  Перевірити чи ставка була прийнята


Можливість проведення 3 го раунду аукціону для другого учасника
  [Tags]   ${USERS.users['${provider1}'].broker}: Процес аукціону
  ...      provider1
  ...      ${USERS.users['${provider1}'].broker}
  ...      auction
  Вибрати учасника, який може зробити ставку
  Поставити малу ставку в 1 грн
  Змінити ставку на максимальну
  Дочекатись учасником закінчення стадії ставок
  Перевірити чи ставка була прийнята


Можливість дочекатися завершення аукціону
  [Tags]   ${USERS.users['${viewer}'].broker}: Процес аукціону
  ...      viewer  provider  provider1
  ...      ${USERS.users['${viewer}'].broker}
  ...      ${USERS.users['${provider}'].broker}
  ...      ${USERS.users['${provider1}'].broker}
  ...      auction
  [Teardown]  Оновити LAST_MODIFICATION_DATE
  Дочекатись дати закінчення аукціону


Відображення дати завершення аукціону
  [Tags]   ${USERS.users['${viewer}'].broker}: Відображення основних даних аукціону
  ...      viewer
  ...      ${USERS.users['${viewer}'].broker}
  ...      tender_view
  [Setup]  Дочекатись синхронізації з майданчиком  ${viewer}
  Отримати дані із тендера  ${viewer}  ${TENDER['TENDER_UAID']}  auctionPeriod.endDate  ${TENDER['LOT_ID']}


*** Keywords ***
Дочекатись дати початку аукціону
  [Arguments]  ${username}
  # Can't use that dirty hack here since we don't know
  # the date of auction when creating the procurement :)
  ${auctionStart}=  Отримати дані із тендера   ${username}  ${TENDER['TENDER_UAID']}   auctionPeriod.startDate  ${TENDER['LOT_ID']}
  Дочекатись дати  ${auctionStart}
  Оновити LAST_MODIFICATION_DATE
  Дочекатись синхронізації з майданчиком  ${username}


Дочекатись завершення періоду очікування перед початком аукціону
  Відкрити сторінку аукціону для ${viewer}
  Wait Until Keyword Succeeds  10 times  60 s  Page should not contain  до початку аукціону


Можливість вичитати посилання на аукціон для ${username}
  ${url}=  Run Keyword If  '${username}' == '${viewer}'  Run As  ${viewer}  Отримати посилання на аукціон для глядача  ${TENDER['TENDER_UAID']}  ${TENDER['LOT_ID']}
  ...      ELSE  Run As  ${username}  Отримати посилання на аукціон для учасника  ${TENDER['TENDER_UAID']}  ${TENDER['LOT_ID']}
  Should Be True  '${url}'
  ${status}=  Run Keyword And Return Status  Should Match Regexp  ${url}  ${AUCTION_REGEXP}
  Run Keyword If  ${status} == ${False}  Should Match Regexp  ${url}  ${OLD_SANDBOX_AUCTION_REGEXP}
  Log  URL: ${url}
  [Return]  ${url}


Відкрити сторінку аукціону для ${username}
  ${url}=  Можливість вичитати посилання на аукціон для ${username}
  Open browser  ${url}  ${USERS.users['${username}'].browser}  ${username}
  Set Window Position  @{USERS['${username}']['position']}
  Set Window Size      @{USERS['${username}']['size']}
  Run Keyword Unless  '${username}' == '${viewer}'
  ...      Click Element                  xpath=//button[contains(@class, 'btn btn-success')]


Дочекатись завершення паузи перед першим раундом
  Відкрити сторінку аукціону для ${viewer}
  Дочекатись паузи перед першим раундом глядачем
  Дочекатись завершення паузи перед першим раундом для користувачів


Дочекатись завершення паузи перед першим раундом (скорочене очікування)
  Відкрити сторінку аукціону для ${viewer}
  Дочекатись завершення паузи перед першим раундом для користувачів


Дочекатись дати закінчення аукціону
  Переключитись на учасника  ${viewer}
  ${status}  ${_}=  Run Keyword And Ignore Error  Wait Until Keyword Succeeds  61 times  30 s  Page should contain  Аукціон завершився
  Run Keyword If  '${status}' == 'FAIL'
  ...      Run Keywords
  ...      Отримати дані із тендера  ${username}  ${TENDER['TENDER_UAID']}  auctionPeriod.startDate  ${TENDER['LOT_ID']}
  ...      AND
  ...      Дочекатись дати початку аукціону  ${username}
  ...      AND
  ...      Дочекатись дати закінчення аукціону для ${username}
  ...      ELSE
  ...      Run Keywords
  ...      Wait Until Keyword Succeeds  15 times  30 s  Page should not contain  Очікуємо на розкриття імен учасників
  ...      AND
  ...      Run Keyword And Ignore Error  Переключитись на учасника  ${provider}
  ...      AND
  ...      Run Keyword And Ignore Error  Page should contain  Аукціон завершився
  ...      AND
  ...      Run Keyword And Ignore Error  Переключитись на учасника  ${provider1}
  ...      AND
  ...      Run Keyword And Ignore Error  Page should contain  Аукціон завершився
  ...      AND
  ...      Run Keyword And Ignore Error  Переключитись на учасника  ${provider2}
  ...      AND
  ...      Run Keyword And Ignore Error  Page should contain  Аукціон завершився
  ...      AND
  ...      Close browser


Дочекатись закінчення аукціону (скорочене очікування)
  Переключитись на учасника  ${viewer}
  Wait Until Keyword Succeeds  61 times  30 s  Page should contain  Аукціон завершився
  Close browser


Дочекатись паузи перед першим раундом глядачем
  ${status}  ${_}=  Run Keyword And Ignore Error  Page should contain  Очікування
  Run Keyword If  '${status}' == 'PASS'
  ...      Run Keywords
  ...      Дочекатись дати початку аукціону  ${viewer}
  ...      AND
  ...      Wait Until Keyword Succeeds  15 times  10 s  Page should contain  до початку раунду


Дочекатись завершення паузи перед ${round_number} раундом
  Переключитись на учасника  ${viewer}
  Wait Until Keyword Succeeds  30 times  5s  Page should contain  → ${round_number}
  ${date}=  Get Current Date
  FOR    ${username}    IN    ${provider}  ${provider1}  ${provider2}
     ${status}  ${_}=  Run Keyword And Ignore Error  Переключитись на учасника   ${username}
     Run Keyword If  '${status}' == 'PASS'   Page should contain  → ${round_number}
  END
  #Переключитись на учасника  ${provider}
  #Page should contain  → ${round_number}
  #Переключитись на учасника  ${provider1}
  #Page should contain  → ${round_number}
  Переключитись на учасника  ${viewer}
  Wait Until Keyword Succeeds  30 times  5 s  Page should not contain  → ${round_number}
  ${new_date}=  Get Current Date
  FOR    ${username}    IN    ${provider}  ${provider1}  ${provider2}
     ${status}  ${_}=  Run Keyword And Ignore Error  Переключитись на учасника   ${username}
     Run Keyword If  '${status}' == 'PASS'   Page should not contain  → ${round_number}
  END
  #Переключитись на учасника  ${provider}
  #Page should not contain  → ${round_number}
  #Переключитись на учасника  ${provider1}
  #Page should not contain  → ${round_number}
  ${time}=  Subtract Date From Date  ${new_date}  ${date}
  Should Be True  ${time} < 140 and ${time} > 100


Дочекатись завершення паузи перед першим раундом для користувачів
  Wait Until Keyword Succeeds  30 times  5s  Page should contain  → 1
  ${date}=  Get Current Date
  Run Keyword And Ignore Error  Відкрити сторінку аукціону для ${provider}
  Run Keyword And Ignore Error  Відкрити сторінку аукціону для ${provider1}
  Run Keyword And Ignore Error  Відкрити сторінку аукціону для ${provider2}
  Переключитись на учасника  ${viewer}
  Wait Until Keyword Succeeds  62 times  5 s  Page should not contain  → 1
  ${new_date}=  Get Current Date
  ${time}=  Subtract Date From Date  ${new_date}  ${date}
  Should Be True  ${time} < 310 and ${time} > 250
  FOR    ${username}    IN    ${provider}  ${provider1}  ${provider2}
     ${status}  ${_}=  Run Keyword And Ignore Error  Переключитись на учасника   ${username}
     Run Keyword If  '${status}' == 'PASS'   Page should not contain  → 1
  END
  #Переключитись на учасника  ${provider}
  #Page should not contain  → 1
  #Переключитись на учасника  ${provider1}
  #Page should not contain  → 1


Дочекатись закінчення стадії ставок глядачем
  Wait Until Keyword Succeeds  30 times  5s  Page should contain  до закінчення раунду
  ${date}=  Get Current Date
  Wait Until Keyword Succeeds  50 times  5 s  Page should not contain  до закінчення раунду
  ${new_date}=  Get Current Date
  ${time}=  Subtract Date From Date  ${new_date}  ${date}
  Should Be True  ${time} < 250 and ${time} > 210


Дочекатись учасником закінчення стадії ставок
  Wait Until Keyword Succeeds  12 times  10 s  Page should not contain  до закінчення вашої черги


Дочекатись оголошення результатів глядачем
  Wait Until Keyword Succeeds  30 times  5s  Page should contain  до оголошення результатів
  ${date}=  Get Current Date
  Wait Until Keyword Succeeds  50 times  5 s  Page should not contain  до оголошення результатів
  ${new_date}=  Get Current Date
  ${time}=  Subtract Date From Date  ${new_date}  ${date}
  Should Be True  ${time} < 250 and ${time} > 210


Переключитись на учасника
  [Arguments]  ${username}
  Switch Browser  ${username}
  ${CURRENT_USER}=  Set Variable  ${username}
  Set Global Variable  ${CURRENT_USER}


Поставити максимально можливу ставку
  Run Keyword If  ${TENDER_MEAT} == ${True}  Wait Until Page Contains Element  xpath=//div[@class='col-md-5 col-sm-5 full-price-group']//span[@class='ng-binding']
  ...        ELSE  Wait Until Page Contains Element  id=max_bid_amount_price
  ${last_amount}=  Run Keyword If  ${TENDER_MEAT} == ${True}  Get Text  xpath=//div[@class='col-md-5 col-sm-5 full-price-group']//span[@class='ng-binding']
  ...        ELSE  Get Text  id=max_bid_amount_price
  ${last_amount}=  convert_amount_string_to_float  ${last_amount}
  ${value}=  Convert To Number  0.01
  ${last_amount}=  subtraction  ${last_amount}  ${value}
  Поставити ставку   ${last_amount}   Заявку прийнято


Поставити ставку в ${percent} відсотків від максимальної
  Run Keyword If  ${TENDER_MEAT} == ${True}  Wait Until Page Contains Element  xpath=//div[@class='col-md-5 col-sm-5 full-price-group']//span[@class='ng-binding']
  ...        ELSE  Wait Until Page Contains Element  id=max_bid_amount_price
  ${max_amount}=  Run Keyword If  ${TENDER_MEAT} == ${True}  Get Text  xpath=//div[@class='col-md-5 col-sm-5 full-price-group']//span[@class='ng-binding']
  ...        ELSE  Get Text  id=max_bid_amount_price
  ${max_amount}=  convert_amount_string_to_float  ${max_amount}
  ${max_amount}=  Convert To Number  ${max_amount}  2
  ${percent}=  convert_amount_string_to_float  ${percent}
  ${last_amount}=  Evaluate  ${max_amount}*${percent}
  ${last_amount}=  Convert To Number  ${last_amount}  2
  Поставити ставку   ${last_amount}  Ви збираєтеся значно понизити свою ставку на
  Поставити ставку   ${last_amount}  Заявку прийнято


Поставити ставку більшу від максимальної на ${extra_amount} грн
  Run Keyword If  ${TENDER_MEAT} == ${True}  Wait Until Page Contains Element  xpath=//div[@class='col-md-5 col-sm-5 full-price-group']//span[@class='ng-binding']
  ...        ELSE  Wait Until Page Contains Element  id=max_bid_amount_price
  ${last_amount}=  Run Keyword If  ${TENDER_MEAT} == ${True}  Get Text  xpath=//div[@class='col-md-5 col-sm-5 full-price-group']//span[@class='ng-binding']
  ...        ELSE  Get Text  id=max_bid_amount_price
  ${last_amount}=  convert_amount_string_to_float  ${last_amount}
  ${extra_amount}=  convert_amount_string_to_float  ${extra_amount}
  ${last_amount}=  Evaluate  ${last_amount}+${extra_amount}
  Поставити ставку  ${last_amount}  Надто висока заявка


Поставити ставку
  [Arguments]  ${amount}  ${msg}
  ${amount}=  Convert To String  ${amount}
  Set To Dictionary  ${USERS['${CURRENT_USER}']}  last_amount=${amount}
  Click Element  id=clear-bid-button
  Wait Until Page Does Not Contain Element  xpath=//alert[contains(@class, 'bids-form')]  7s
  Input Text     id=bid-amount-input  ${amount}
  Click Element  id=place-bid-button
  Wait Until Page Contains  ${msg}  30s


Відмінитити ставку
  Click Element             id=cancel-bid-button
  Wait Until Page Contains  Заявку відмінено  10s


Змінити ставку на максимальну
  Click Element  id=edit-bid-button
  Click Element  id=clear-bid-button
  Поставити максимально можливу ставку


Вибрати учасника, який може зробити ставку
  FOR    ${username}    IN    ${provider}  ${provider1}  ${provider2}
     Run Keyword And Ignore Error  Переключитись на учасника   ${username}
     ${status}  ${_}=  Run Keyword And Ignore Error  Page Should Contain  до закінчення вашої черги
     Run Keyword If  '${status}' == 'PASS'    Exit For Loop
  END


Поставити малу ставку в ${last_amount} грн
  Run Keyword If  ${TENDER_MEAT} == ${True}  Wait Until Page Contains Element  xpath=//div[@class='col-md-5 col-sm-5 full-price-group']//span[@class='ng-binding']
  ...        ELSE  Wait Until Page Contains Element  id=max_bid_amount_price
  Поставити ставку  ${last_amount}  Ви збираєтеся значно понизити свою ставку на
  Поставити ставку  ${last_amount}  Заявку прийнято


Поставити нульову ставку
  Run Keyword If  ${TENDER_MEAT} == ${True}  Wait Until Page Contains Element  xpath=//div[@class='col-md-5 col-sm-5 full-price-group']//span[@class='ng-binding']
  ...        ELSE  Wait Until Page Contains Element  id=max_bid_amount_price
  Поставити ставку  0  Ви збираєтеся значно понизити свою ставку на


Перевірити чи ставка була прийнята
  ${last_amount}=  convert_amount  ${USERS['${CURRENT_USER}']['last_amount']}
  Page Should Contain  ${last_amount}
