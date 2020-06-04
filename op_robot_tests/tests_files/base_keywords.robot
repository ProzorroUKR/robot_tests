coding: utf-8
*** Settings ***
Library            op_robot_tests.tests_files.service_keywords
Library            Collections
Resource           keywords.robot
Resource           resource.robot

*** Variables ***
${ERROR_MESSAGE}=  Calling method 'get_tender' failed: ResourceGone: {"status": "error", "errors": [{"location": "url", "name": "tender_id", "description": "Archived"}]}

${ERROR_PLAN_MESSAGE}=  Calling method 'get_plan' failed: ResourceGone: {"status": "error", "errors": [{"location": "url", "name": "plan_id", "description": "Archived"}]}

*** Keywords ***
Можливість оголосити тендер
  ${file_path}=  Get Variable Value  ${ARTIFACT_FILE}  artifact_plan.yaml
  ${ARTIFACT}=  load_data_from  ${file_path}
  Log  ${ARTIFACT.tender_uaid}
  ${NUMBER_OF_LOTS}=  Convert To Integer  ${NUMBER_OF_LOTS}
  ${NUMBER_OF_ITEMS}=  Convert To Integer  ${NUMBER_OF_ITEMS}
  ${NUMBER_OF_MILESTONES}=  Convert To Integer  ${NUMBER_OF_MILESTONES}
  ${tender_parameters}=  Create Dictionary
  ...      mode=${MODE}
  ...      number_of_items=${NUMBER_OF_ITEMS}
  ...      number_of_lots=${NUMBER_OF_LOTS}
  ...      number_of_milestones=${NUMBER_OF_MILESTONES}
  ...      tender_meat=${${TENDER_MEAT}}
  ...      lot_meat=${${LOT_MEAT}}
  ...      item_meat=${${ITEM_MEAT}}
  ...      api_host_url=${API_HOST_URL}
  ...      moz_integration=${${MOZ_INTEGRATION}}
  ...      vat_included=${${VAT_INCLUDED}}
  ...      road_index=${${ROAD_INDEX}}
  ...      gmdn_index=${${GMDN_INDEX}}
  ...      plan_tender=${${PLAN_TENDER}}
  ...      profile=${${PROFILE}}
  ${DIALOGUE_TYPE}=  Get Variable Value  ${DIALOGUE_TYPE}
  ${FUNDING_KIND}=  Get Variable Value  ${FUNDING_KIND}
  Run keyword if  '${DIALOGUE_TYPE}' != '${None}'  Set to dictionary  ${tender_parameters}  dialogue_type=${DIALOGUE_TYPE}
  Run keyword if  '${FUNDING_KIND}' != '${None}'  Set to dictionary  ${tender_parameters}  fundingKind=${FUNDING_KIND}
  :FOR  ${username}  IN  ${viewer}  ${tender_owner}
  \  ${status}=   Run Keyword And Return Status  List Should Contain Value  ${USERS.users['${username}']}  plan_client
  \  Run Keyword If  ${status}   Exit For Loop
  ${plan_data}=  знайти план за ідентифікатором  ${ARTIFACT.tender_uaid}  ${username}
  Log  ${plan_data}
  ${tender_data}=  Підготувати дані для створення тендера  ${tender_parameters}  ${plan_data}
  ${adapted_data}=  Адаптувати дані для оголошення тендера  ${tender_data}
  ${TENDER_UAID}=  Run As  ${tender_owner}  Створити тендер  ${adapted_data}  ${ARTIFACT.tender_uaid}
  Set To Dictionary  ${USERS.users['${tender_owner}']}  initial_data=${adapted_data}
  Set To Dictionary  ${TENDER}  TENDER_UAID=${TENDER_UAID}


Можливість оголосити тендер другого етапу
  ${NUMBER_OF_LOTS}=  Convert To Integer  ${NUMBER_OF_LOTS}
  ${NUMBER_OF_ITEMS}=  Convert To Integer  ${NUMBER_OF_ITEMS}
  ${tender_parameters}=  Create Dictionary
  ...      mode=${MODE}
  ...      number_of_items=${NUMBER_OF_ITEMS}
  ...      number_of_lots=${NUMBER_OF_LOTS}
  ...      tender_meat=${${TENDER_MEAT}}
  ...      lot_meat=${${LOT_MEAT}}
  ...      item_meat=${${ITEM_MEAT}}
  ...      api_host_url=${API_HOST_URL}
  ...      moz_integration=${${MOZ_INTEGRATION}}
  ...      road_index=${${ROAD_INDEX}}
  ...      gmdn_index=${${GMDN_INDEX}}
  ${submissionMethodDetails}=  Get Variable Value  ${submissionMethodDetails}
  ${period_intervals}=  compute_intrs  ${BROKERS}  ${used_brokers}
  ${first_stage}=  Run As  ${provider2}  Пошук тендера по ідентифікатору  ${TENDER['TENDER_UAID']}
  ${tender_data}=  test_tender_data_selection  ${period_intervals}  ${tender_parameters}  ${submissionMethodDetails}  tender_data=${first_stage}
  ${adapted_data}=  Адаптувати дані для оголошення тендера  ${tender_data}
  ${TENDER_UAID}=  Run As  ${tender_owner}  Створити тендер другого етапу  ${adapted_data}
  Set To Dictionary  ${USERS.users['${tender_owner}']}  initial_data=${adapted_data}
  Set To Dictionary  ${TENDER}  TENDER_UAID=${TENDER_UAID}
  Дочекатись дати початку періоду уточнення  ${tender_owner}  ${TENDER_UAID}


Можливість оголосити тендер з використанням валідації для MNN
  ${file_path}=  Get Variable Value  ${ARTIFACT_FILE}  artifact_plan.yaml
  ${ARTIFACT}=  load_data_from  ${file_path}
  Log  ${ARTIFACT.tender_uaid}
  [Arguments]  ${data_version}
  ${NUMBER_OF_LOTS}=  Convert To Integer  ${NUMBER_OF_LOTS}
  ${NUMBER_OF_ITEMS}=  Convert To Integer  ${NUMBER_OF_ITEMS}
  ${NUMBER_OF_MILESTONES}=  Convert To Integer  ${NUMBER_OF_MILESTONES}
  ${tender_parameters}=  Create Dictionary
  ...      mode=${MODE}
  ...      number_of_items=${NUMBER_OF_ITEMS}
  ...      number_of_lots=${NUMBER_OF_LOTS}
  ...      number_of_milestones=${NUMBER_OF_MILESTONES}
  ...      tender_meat=${${TENDER_MEAT}}
  ...      lot_meat=${${LOT_MEAT}}
  ...      item_meat=${${ITEM_MEAT}}
  ...      api_host_url=${API_HOST_URL}
  ...      moz_integration=${${MOZ_INTEGRATION}}
  ...      road_index=${${ROAD_INDEX}}
  ...      gmdn_index=${${GMDN_INDEX}}
  ...      plan_tender=${${PLAN_TENDER}}
  ${DIALOGUE_TYPE}=  Get Variable Value  ${DIALOGUE_TYPE}
  ${FUNDING_KIND}=  Get Variable Value  ${FUNDING_KIND}
  Run keyword if  '${DIALOGUE_TYPE}' != '${None}'  Set to dictionary  ${tender_parameters}  dialogue_type=${DIALOGUE_TYPE}
  Run keyword if  '${FUNDING_KIND}' != '${None}'  Set to dictionary  ${tender_parameters}  fundingKind=${FUNDING_KIND}
  ${plan_data}=  Run as  ${tender_owner}  Пошук плану по ідентифікатору  ${ARTIFACT.tender_uaid}
  Log  ${plan_data}
  ${tender_data}=  Підготувати дані для створення тендера  ${tender_parameters}  ${plan_data}
  ${adapted_data}=  Адаптувати дані для оголошення тендера  ${tender_data}
  ${adapted_data_mnn}=  edit_tender_data_for_mnn  ${adapted_data}  ${MODE}  ${data_version}
  Log  ${adapted_data_mnn}
  ${TENDER_UAID}=  Run As  ${tender_owner}  Створити тендер  ${adapted_data_mnn}  ${ARTIFACT.tender_uaid}
  Set To Dictionary  ${USERS.users['${tender_owner}']}  initial_data=${adapted_data_mnn}
  Set To Dictionary  ${TENDER}  TENDER_UAID=${TENDER_UAID}


Можливість оголосити тендер з використанням валідації Індекс автомобільних доріг
  [Arguments]  ${data_version}
  ${file_path}=  Get Variable Value  ${ARTIFACT_FILE}  artifact_plan.yaml
  ${ARTIFACT}=  load_data_from  ${file_path}
  Log  ${ARTIFACT.tender_uaid}
  ${NUMBER_OF_LOTS}=  Convert To Integer  ${NUMBER_OF_LOTS}
  ${NUMBER_OF_ITEMS}=  Convert To Integer  ${NUMBER_OF_ITEMS}
  ${NUMBER_OF_MILESTONES}=  Convert To Integer  ${NUMBER_OF_MILESTONES}
  ${tender_parameters}=  Create Dictionary
  ...      mode=${MODE}
  ...      number_of_items=${NUMBER_OF_ITEMS}
  ...      number_of_lots=${NUMBER_OF_LOTS}
  ...      number_of_milestones=${NUMBER_OF_MILESTONES}
  ...      tender_meat=${${TENDER_MEAT}}
  ...      lot_meat=${${LOT_MEAT}}
  ...      item_meat=${${ITEM_MEAT}}
  ...      api_host_url=${API_HOST_URL}
  ...      moz_integration=${${MOZ_INTEGRATION}}
  ...      road_index=${${ROAD_INDEX}}
  ...      gmdn_index=${${GMDN_INDEX}}
  ...      plan_tender=${${PLAN_TENDER}}
  ${DIALOGUE_TYPE}=  Get Variable Value  ${DIALOGUE_TYPE}
  ${FUNDING_KIND}=  Get Variable Value  ${FUNDING_KIND}
  Run keyword if  '${DIALOGUE_TYPE}' != '${None}'  Set to dictionary  ${tender_parameters}  dialogue_type=${DIALOGUE_TYPE}
  Run keyword if  '${FUNDING_KIND}' != '${None}'  Set to dictionary  ${tender_parameters}  fundingKind=${FUNDING_KIND}
  ${plan_data}=  Run as  ${tender_owner}  Пошук плану по ідентифікатору  ${ARTIFACT.tender_uaid}
  Log  ${plan_data}
  ${tender_data}=  Підготувати дані для створення тендера  ${tender_parameters}  ${plan_data}
  ${adapted_data}=  Адаптувати дані для оголошення тендера  ${tender_data}
  ${adapted_data_cost}=  edit_tender_data_for_cost  ${adapted_data}  ${MODE}  ${data_version}
  Log  ${adapted_data_cost}
  ${TENDER_UAID}=  Run As  ${tender_owner}  Створити тендер  ${adapted_data_cost}  ${ARTIFACT.tender_uaid}
  Set To Dictionary  ${USERS.users['${tender_owner}']}  initial_data=${adapted_data_cost}
  Set To Dictionary  ${TENDER}  TENDER_UAID=${TENDER_UAID}


Можливість оголосити тендер з використанням валідації класифікатор медичних виробів
  [Arguments]  ${data_version}
  ${file_path}=  Get Variable Value  ${ARTIFACT_FILE}  artifact_plan.yaml
  ${ARTIFACT}=  load_data_from  ${file_path}
  Log  ${ARTIFACT.tender_uaid}
  ${NUMBER_OF_LOTS}=  Convert To Integer  ${NUMBER_OF_LOTS}
  ${NUMBER_OF_ITEMS}=  Convert To Integer  ${NUMBER_OF_ITEMS}
  ${NUMBER_OF_MILESTONES}=  Convert To Integer  ${NUMBER_OF_MILESTONES}
  ${tender_parameters}=  Create Dictionary
  ...      mode=${MODE}
  ...      number_of_items=${NUMBER_OF_ITEMS}
  ...      number_of_lots=${NUMBER_OF_LOTS}
  ...      number_of_milestones=${NUMBER_OF_MILESTONES}
  ...      tender_meat=${${TENDER_MEAT}}
  ...      lot_meat=${${LOT_MEAT}}
  ...      item_meat=${${ITEM_MEAT}}
  ...      api_host_url=${API_HOST_URL}
  ...      moz_integration=${${MOZ_INTEGRATION}}
  ...      road_index=${${ROAD_INDEX}}
  ...      gmdn_index=${${GMDN_INDEX}}
  ...      plan_tender=${${PLAN_TENDER}}
  ${DIALOGUE_TYPE}=  Get Variable Value  ${DIALOGUE_TYPE}
  ${FUNDING_KIND}=  Get Variable Value  ${FUNDING_KIND}
  Run keyword if  '${DIALOGUE_TYPE}' != '${None}'  Set to dictionary  ${tender_parameters}  dialogue_type=${DIALOGUE_TYPE}
  Run keyword if  '${FUNDING_KIND}' != '${None}'  Set to dictionary  ${tender_parameters}  fundingKind=${FUNDING_KIND}
  ${plan_data}=  Run as  ${tender_owner}  Пошук плану по ідентифікатору  ${ARTIFACT.tender_uaid}
  Log  ${plan_data}
  ${tender_data}=  Підготувати дані для створення тендера  ${tender_parameters}  ${plan_data}
  ${adapted_data}=  Адаптувати дані для оголошення тендера  ${tender_data}
  ${adapted_data_gmdn}=  edit_tender_data_for_gmdn  ${adapted_data}  ${MODE}  ${data_version}
  Log  ${adapted_data_gmdn}
  ${TENDER_UAID}=  Run As  ${tender_owner}  Створити тендер  ${adapted_data_gmdn}  ${ARTIFACT.tender_uaid}
  Set To Dictionary  ${USERS.users['${tender_owner}']}  initial_data=${adapted_data_gmdn}
  Set To Dictionary  ${TENDER}  TENDER_UAID=${TENDER_UAID}


Можливість оголосити тендер з використанням валідації план-тендер
  [Arguments]  ${data_version}
  ${file_path}=  Get Variable Value  ${ARTIFACT_FILE}  artifact_plan.yaml
  ${ARTIFACT}=  load_data_from  ${file_path}
  Log  ${ARTIFACT.tender_uaid}
  ${NUMBER_OF_LOTS}=  Convert To Integer  ${NUMBER_OF_LOTS}
  ${NUMBER_OF_ITEMS}=  Convert To Integer  ${NUMBER_OF_ITEMS}
  ${NUMBER_OF_MILESTONES}=  Convert To Integer  ${NUMBER_OF_MILESTONES}
  ${tender_parameters}=  Create Dictionary
  ...      mode=${MODE}
  ...      number_of_items=${NUMBER_OF_ITEMS}
  ...      number_of_lots=${NUMBER_OF_LOTS}
  ...      number_of_milestones=${NUMBER_OF_MILESTONES}
  ...      tender_meat=${${TENDER_MEAT}}
  ...      lot_meat=${${LOT_MEAT}}
  ...      item_meat=${${ITEM_MEAT}}
  ...      api_host_url=${API_HOST_URL}
  ...      moz_integration=${${MOZ_INTEGRATION}}
  ...      road_index=${${ROAD_INDEX}}
  ...      gmdn_index=${${GMDN_INDEX}}
  ...      plan_tender=${${PLAN_TENDER}}
  ${DIALOGUE_TYPE}=  Get Variable Value  ${DIALOGUE_TYPE}
  ${FUNDING_KIND}=  Get Variable Value  ${FUNDING_KIND}
  Run keyword if  '${DIALOGUE_TYPE}' != '${None}'  Set to dictionary  ${tender_parameters}  dialogue_type=${DIALOGUE_TYPE}
  Run keyword if  '${FUNDING_KIND}' != '${None}'  Set to dictionary  ${tender_parameters}  fundingKind=${FUNDING_KIND}
  ${plan_data}=  Run as  ${tender_owner}  Пошук плану по ідентифікатору  ${ARTIFACT.tender_uaid}
  Log  ${plan_data}
  ${tender_data}=  Підготувати дані для створення тендера  ${tender_parameters}  ${plan_data}
  ${adapted_data}=  Адаптувати дані для оголошення тендера  ${tender_data}
  ${adapted_data_plan_tender}=  edit_tender_data_for_plan_tender  ${adapted_data}  ${MODE}  ${data_version}
  Log  ${adapted_data_plan_tender}
  ${TENDER_UAID}=  Run As  ${tender_owner}  Створити тендер  ${adapted_data_plan_tender}  ${ARTIFACT.tender_uaid}
  Set To Dictionary  ${USERS.users['${tender_owner}']}  initial_data=${adapted_data_plan_tender}
  Set To Dictionary  ${TENDER}  TENDER_UAID=${TENDER_UAID}


Можливість створити об'єкт моніторингу
  ${period_intervals}=  compute_intrs  ${BROKERS}  ${used_brokers}
  ${accelerator}=  Get Variable Value  ${accelerator}
  ${accelerator}=  Set Variable If  '${accelerator}' != '${None}'  ${accelerator}  ${period_intervals.default.accelerator}
  ${monitoring_data}=  test_monitoring_data  ${USERS.users['${dasu_user}'].tender_data.data.id}  ${accelerator}
  Log  ${monitoring_data}
  ${MNITORING_UAID}=  Run As  ${dasu_user}  Створити об'єкт моніторингу  ${monitoring_data}
  ${MONITORING}=  Create Dictionary
  Set Global Variable  ${MONITORING}
  Set To Dictionary  ${USERS.users['${dasu_user}']}  initial_data=${monitoring_data}
  Set To Dictionary  ${MONITORING}  MONITORING_UAID=${MNITORING_UAID}


Можливість перевірити завантаження документів через Document Service
  :FOR  ${username}  IN  ${viewer}  ${tender_owner}
  \  ${status}=   Run Keyword And Return Status  List Should Contain Value  ${USERS.users['${username}'].tender_data.data}  documents
  \  Run Keyword If  ${status}   Exit For Loop
  ${documents}=  Get From Dictionary  ${USERS.users['${username}'].tender_data.data}  documents
  ${doc_number}=  Get Length  ${documents}
  :FOR  ${doc_index}  IN RANGE  ${doc_number}
  \  ${document_url}=  Get From Dictionary  ${USERS.users['${username}'].tender_data.data.documents[${doc_index}]}  url
  \  Should Match Regexp   ${document_url}   ${DS_REGEXP}   msg=Not a Document Service Upload


Можливість створити план закупівлі
  ${NUMBER_OF_ITEMS}=  Convert To Integer  ${NUMBER_OF_ITEMS}
  ${NUMBER_OF_BREAKDOWN}=  Convert To Integer  ${NUMBER_OF_BREAKDOWN}
  ${tender_parameters}=  Create Dictionary
  ...      mode=${MODE}
  ...      number_of_items=${NUMBER_OF_ITEMS}
  ...      tender_meat=${${TENDER_MEAT}}
  ...      item_meat=${${ITEM_MEAT}}
  ...      moz_integration=${${MOZ_INTEGRATION}}
  ...      road_index=${${ROAD_INDEX}}
  ...      gmdn_index=${${GMDN_INDEX}}
  ...      number_of_breakdown=${NUMBER_OF_BREAKDOWN}
  ${DIALOGUE_TYPE}=  Get Variable Value  ${DIALOGUE_TYPE}
  Run keyword if  '${DIALOGUE_TYPE}' != '${None}'  Set to dictionary  ${tender_parameters}  dialogue_type=${DIALOGUE_TYPE}
  ${tender_data}=  Підготувати дані для створення плану  ${tender_parameters}
  ${adapted_data}=  Адаптувати дані для оголошення тендера  ${tender_data}
  ${TENDER_UAID}=  Run As  ${tender_owner}  Створити план  ${adapted_data}
  Set To Dictionary  ${USERS.users['${tender_owner}']}  initial_data=${adapted_data}
  Set To Dictionary  ${TENDER}  TENDER_UAID=${TENDER_UAID}


Можливість створити план закупівлі з використанням валідації для buyers
  [Arguments]  ${data_version}
  ${NUMBER_OF_ITEMS}=  Convert To Integer  ${NUMBER_OF_ITEMS}
  ${tender_parameters}=  Create Dictionary
  ...      mode=${MODE}
  ...      number_of_items=${NUMBER_OF_ITEMS}
  ...      tender_meat=${${TENDER_MEAT}}
  ...      item_meat=${${ITEM_MEAT}}
  ...      moz_integration=${${MOZ_INTEGRATION}}
  ${DIALOGUE_TYPE}=  Get Variable Value  ${DIALOGUE_TYPE}
  Run keyword if  '${DIALOGUE_TYPE}' != '${None}'  Set to dictionary  ${tender_parameters}  dialogue_type=${DIALOGUE_TYPE}
  ${tender_data}=  Підготувати дані для створення плану  ${tender_parameters}
  ${adapted_data}=  Адаптувати дані для оголошення тендера  ${tender_data}
  ${adapted_data_buyers}=  edit_plan_buyers  ${adapted_data}  ${data_version}
  Log  ${adapted_data_buyers}
  ${TENDER_UAID}=  Run As  ${tender_owner}  Створити план  ${adapted_data_buyers}
  Set To Dictionary  ${USERS.users['${tender_owner}']}  initial_data=${adapted_data_buyers}
  Set To Dictionary  ${TENDER}  TENDER_UAID=${TENDER_UAID}


Можливість знайти тендер по ідентифікатору для усіх користувачів
  :FOR  ${username}  IN  ${tender_owner}  ${provider}  ${provider1}  ${provider2}  ${viewer}
  \  Можливість знайти тендер по ідентифікатору для користувача ${username}


Можливість знайти тендер по ідентифікатору для користувача ${username}
  Дочекатись синхронізації з майданчиком  ${username}
  Run As  ${username}  Пошук тендера по ідентифікатору  ${TENDER['TENDER_UAID']}


Можливість прочитати тендери для користувача ${username}
  ${tenders_feed}=  Run As  ${username}  Отримати список тендерів
  ${tenders_len}=  Get Length  ${tenders_feed}
  ${number}=  Evaluate  min(${FEED_ITEMS_NUMBER}, ${tenders_len})
  ${sample}=  Evaluate  random.sample(range(0, ${tenders_len}), ${number})  random
  Log To Console  ${number}/${tenders_len}
  :FOR  ${index}  IN  @{sample}
  \  ${tenders_feed_item}=  Get From List  ${tenders_feed}  ${index}
  \  ${internalid}=  Get From Dictionary  ${tenders_feed_item}  id
  \  ${date_modified}=  Get From Dictionary  ${tenders_feed_item}  dateModified
  \  Log To Console  - Читання тендеру з id ${internalid} та датою модифікації ${date_modified}
  \  ${status}=  Run Keyword And Return Status  Отримати тендер по внутрішньому ідентифікатору  ${username}  ${internalid}
  \  Run Keyword If  ${status} == ${False}
  \  ...  Run Keyword And Expect Error  ${ERROR_MESSAGE}  Отримати тендер по внутрішньому ідентифікатору  ${username}  ${internalid}
  \  Run Keyword If  ${status} == ${True}
  \  ...  Run As  ${username}  Отримати тендер по внутрішньому ідентифікатору  ${internalid}


Можливість знайти план по ідентифікатору
  :FOR  ${username}  IN  ${tender_owner}  ${viewer}
  \  Можливість знайти план по ідентифікатору для користувача ${username}


Можливість прочитати плани для користувача ${username}
  ${plans_feed}=  Run As  ${username}  Отримати список планів
  ${plans_len}=  Get Length  ${plans_feed}
  ${number}=  Evaluate  min(${FEED_ITEMS_NUMBER}, ${plans_len})
  ${sample}=  Evaluate  random.sample(range(0, ${plans_len}), ${number})  random
  Log To Console  ${number}/${plans_len}
  :FOR  ${index}  IN  @{sample}
  \  ${plans_feed_item}=  Get From List  ${plans_feed}  ${index}
  \  ${internalid}=  Get From Dictionary  ${plans_feed_item}  id
  \  ${date_modified}=  Get From Dictionary  ${plans_feed_item}  dateModified
  \  Log To Console  - Читання плану з id ${internalid} та датою модифікації ${date_modified}
  \  ${status}=  Run Keyword And Return Status  Отримати план по внутрішньому ідентифікатору  ${username}  ${internalid}
  \  Run Keyword If  ${status} == ${False}
  \  ...  Run Keyword And Expect Error  ${ERROR_PLAN_MESSAGE}  Отримати план по внутрішньому ідентифікатору  ${username}  ${internalid}
  \  Run Keyword If  ${status} == ${True}
  \  ...  Run As  ${username}  Отримати план по внутрішньому ідентифікатору  ${internalid}


Можливість прочитати договори для користувача ${username}
  ${contracts_feed}=  Run As  ${username}  Отримати список договорів
  ${contracts_len}=  Get Length  ${contracts_feed}
  ${number}=  Evaluate  min(${FEED_ITEMS_NUMBER}, ${contracts_len})
  ${sample}=  Evaluate  random.sample(range(0, ${contracts_len}), ${number})  random
  Log To Console  ${number}/${contracts_len}
  :FOR  ${index}  IN  @{sample}
  \  ${contracts_feed_item}=  Get From List  ${contracts_feed}  ${index}
  \  ${internalid}=  Get From Dictionary  ${contracts_feed_item}  id
  \  ${date_modified}=  Get From Dictionary  ${contracts_feed_item}  dateModified
  \  Log To Console  - Читання договору з id ${internalid} та датою модифікації ${date_modified}
  \  Run As  ${username}  Отримати договір по внутрішньому ідентифікатору  ${internalid}


Можливість знайти об'єкт моніторингу по ідентифікатору
  :FOR  ${username}  IN  ${viewer}  ${dasu_user}
  \  Можливість знайти об'єкт моніторингу по ідентифікатору для користувача ${username}


Можливість знайти план по ідентифікатору для користувача ${username}
  Дочекатись синхронізації з майданчиком  ${username}
  Run as  ${username}  Пошук плану по ідентифікатору  ${TENDER['TENDER_UAID']}


Можливість знайти об'єкт моніторингу по ідентифікатору для користувача ${username}
  Дочекатись синхронізації з ДАСУ  ${username}
  Run as  ${username}  Пошук об'єкта моніторингу по ідентифікатору  ${MONITORING['MONITORING_UAID']}


Можливість оприлюднити рішення про початок моніторингу
  ${file_path}  ${file_name}  ${file_content}=  create_fake_doc
  ${monitoring_data}=  test_status_data  active
  ${date}=  create_fake_date
  ${description}=  create_fake_sentence
  ${decision}=  Create Dictionary
  ...      date=${date}
  ...      description=${description}
  Set To Dictionary  ${monitoring_data.data}  decision=${decision}
  Run As  ${dasu_user}  Оприлюднити рішення про початок моніторингу  ${MONITORING['MONITORING_UAID']}  ${file_path}  ${monitoring_data}


Можливість змінити поле ${field_name} тендера на ${field_value}
  Run As  ${tender_owner}  Внести зміни в тендер  ${TENDER['TENDER_UAID']}  ${field_name}  ${field_value}


Перевірити неможливість зміни поля ${field_name} тендера на значення ${field_value} для користувача ${username}
  Require Failure  ${username}  Внести зміни в тендер  ${TENDER['TENDER_UAID']}  ${field_name}  ${field_value}


Можливість змінити поле ${field_name} плану на ${field_value}
  Run As  ${tender_owner}  Внести зміни в план  ${TENDER['TENDER_UAID']}  ${field_name}  ${field_value}


Можливість додати учасника процесу моніторингу
  ${party_data}=  test_party
  ${party}=  Create Dictionary  data=${party_data}
  Run As  ${dasu_user}  Додати учасника процесу моніторингу  ${MONITORING['MONITORING_UAID']}  ${party}


Можливість запитати в замовника пояснення
  ${post_data}=  test_dialogue
  Set To Dictionary  ${post_data.data}  relatedParty=${USERS.users['${dasu_user}'].monitoring_data.data.parties[0].id}
  Run As  ${dasu_user}  Запитати в замовника пояснення  ${MONITORING['MONITORING_UAID']}  ${post_data}


Можливість надати пояснення замовником
  ${post_data}=  test_dialogue
  Set To Dictionary  ${post_data.data}  relatedPost=${USERS.users['${dasu_user}'].monitoring_data.data.posts[0].id}
  Run As  ${tender_owner}  Надати пояснення замовником  ${MONITORING['MONITORING_UAID']}  ${post_data}


Можливість надати відповідь користувачем ДАСУ
  ${post_data}=  test_dialogue
  Set To Dictionary  ${post_data.data}  relatedPost=${USERS.users['${dasu_user}'].monitoring_data.data.posts[2].id}
  Run As  ${dasu_user}  Надати відповідь користувачем ДАСУ  ${MONITORING['MONITORING_UAID']}  ${post_data}


Можливість надати висновок про наявність порушення в тендері
  ${conclusion_data}=  test_conclusion  ${True}  ${USERS.users['${dasu_user}'].monitoring_data.data.parties[0].id}
  Run As  ${dasu_user}  Надати висновок про наявність/відсутність порушення в тендері  ${MONITORING['MONITORING_UAID']}  ${conclusion_data}


Можливість надати висновок про відсутність порушення в тендері
  ${conclusion_data}=  test_conclusion  ${False}  ${USERS.users['${dasu_user}'].monitoring_data.data.parties[0].id}
  Run As  ${dasu_user}  Надати висновок про наявність/відсутність порушення в тендері  ${MONITORING['MONITORING_UAID']}  ${conclusion_data}


Можливість змінити статус об’єкта моніторингу на ${status}
  ${conclusion_data}=  test_status_data  ${status}  ${USERS.users['${dasu_user}'].monitoring_data.data.parties[0].id}
  Run As  ${dasu_user}  Змінити статус об’єкта моніторингу  ${MONITORING['MONITORING_UAID']}  ${conclusion_data}


Можливість надати пояснення замовником з власної ініціативи
  ${party_data}=  test_dialogue
  Run As  ${tender_owner}  Надати пояснення замовником з власної ініціативи  ${MONITORING['MONITORING_UAID']}  ${party_data}


Можливість надати звіт про усунення порушення замовником
  ${description}=  create_fake_sentence
  ${resolution}=  munch_dict  data=${True}
  Set To Dictionary   ${resolution.data}  description=${description}
  ${file_path}  ${file_name}  ${file_content}=  create_fake_doc
  Run As  ${tender_owner}  Надати звіт про усунення порушення замовником  ${MONITORING['MONITORING_UAID']}  ${resolution}  ${file_path}


Можливість зазначити, що порушення було оскаржено в суді
  ${description}=  create_fake_sentence
  ${appeal}=  munch_dict  data=${True}
  Set To Dictionary   ${appeal.data}  description=${description}
  ${file_path}  ${file_name}  ${file_content}=  create_fake_doc
  Run As  ${tender_owner}  Зазначити, що порушення було оскаржено в суді  ${MONITORING['MONITORING_UAID']}  ${appeal}  ${file_path}


Можливість оприлюднути рішення про усунення порушення
  ${report_data}=  test_elimination_report
  ...      ${USERS.users['${dasu_user}'].monitoring_data.data.conclusion.violationType[0]}
  ...      ${USERS.users['${dasu_user}'].monitoring_data.data.parties[0].id}
  Run As  ${dasu_user}  Оприлюднити рішення про усунення порушення  ${MONITORING['MONITORING_UAID']}  ${report_data}


Можливість додати документацію до тендера
  ${file_path}  ${file_name}  ${file_content}=  create_fake_doc
  Run As  ${tender_owner}  Завантажити документ  ${file_path}  ${TENDER['TENDER_UAID']}
  ${doc_id}=  get_id_from_string  ${file_name}
  ${tender_document}=  Create Dictionary
  ...      doc_name=${file_name}
  ...      doc_id=${doc_id}
  ...      doc_content=${file_content}
  Set To Dictionary  ${USERS.users['${tender_owner}']}  tender_document=${tender_document}
  Remove File  ${file_path}


Можливість додати предмет закупівлі в тендер
  ${item}=  Підготувати дані для створення предмету закупівлі  ${USERS.users['${tender_owner}'].initial_data.data['items'][0]['classification']['id']}
  Run As  ${tender_owner}  Додати предмет закупівлі  ${TENDER['TENDER_UAID']}  ${item}
  ${item_id}=  get_id_from_object  ${item}
  ${item_data}=  Create Dictionary
  ...      item=${item}
  ...      item_id=${item_id}
  ${item_data}=  munch_dict  arg=${item_data}
  Set To Dictionary  ${USERS.users['${tender_owner}']}  item_data=${item_data}


Можливість додати предмет закупівлі в план
  ${item}=  Підготувати дані для створення предмету закупівлі плану  ${USERS.users['${tender_owner}'].initial_data.data['items'][0]['classification']['id']}
  Run As  ${tender_owner}  Додати предмет закупівлі в план  ${TENDER['TENDER_UAID']}  ${item}
  ${item_id}=  get_id_from_object  ${item}
  ${item_data}=  Create Dictionary
  ...      item=${item}
  ...      item_id=${item_id}
  ${item_data}=  munch_dict  arg=${item_data}
  Set To Dictionary  ${USERS.users['${tender_owner}']}  item_data=${item_data}


Можливість видалити предмет закупівлі з тендера
  Run As  ${tender_owner}  Видалити предмет закупівлі  ${TENDER['TENDER_UAID']}  ${USERS.users['${tender_owner}'].item_data.item_id}


Можливість видалити предмет закупівлі з плану
  Run As  ${tender_owner}  Видалити предмет закупівлі плану  ${TENDER['TENDER_UAID']}  ${USERS.users['${tender_owner}'].item_data.item_id}


Можливість видалити поле ${field_name} з донора ${funders_index}
  Run As  ${tender_owner}  Видалити поле з донора  ${TENDER['TENDER_UAID']}  ${funders_index}  ${field_name}


Можливість видалити донора ${funders_index}
  Run As  ${tender_owner}  Видалити донора  ${TENDER['TENDER_UAID']}  ${funders_index}


Можливість додати донора
  ${funders_data}=  create_fake_funder
  Run As  ${tender_owner}  Додати донора  ${TENDER['TENDER_UAID']}  ${funders_data}


Звірити відображення поля ${field} документа ${doc_id} із ${left} для користувача ${username}
  ${right}=  Run As  ${username}  Отримати інформацію із документа  ${TENDER['TENDER_UAID']}  ${doc_id}  ${field}
  Порівняти об'єкти  ${left}  ${right}


Звірити відображення поля ${field} тендера для усіх користувачів
  :FOR  ${username}  IN  ${viewer}  ${tender_owner}  ${provider}  ${provider1}  ${provider2}
  \  Звірити відображення поля ${field} тендера для користувача ${username}


Звірити відображення поля ${field} тендера із ${data} для користувача ${username}
  Звірити поле тендера із значенням  ${username}  ${TENDER['TENDER_UAID']}  ${data}  ${field}


Звірити відображення поля ${field} тендера для користувача ${username}
  Звірити поле тендера  ${username}  ${TENDER['TENDER_UAID']}  ${USERS.users['${tender_owner}'].initial_data}  ${field}


Звірити відображення поля ${field} об'єкта моніторингу для користувача ${username}
  Звірити поле об'єкта моніторингу  ${username}  ${MONITORING['MONITORING_UAID']}  ${USERS.users['${dasu_user}'].initial_data}  ${field}


Звірити відображення поля ${field} плану для користувача ${username}
  Звірити поле плану  ${username}  ${TENDER['TENDER_UAID']}  ${USERS.users['${tender_owner}'].initial_data}  ${field}


Можливість знайти тендер другого етапу по ідентифікатору для усіх користувачів
  :FOR  ${username}  IN  ${tender_owner}  ${provider}  ${provider1}  ${provider2}  ${viewer}
  \  Дочекатись синхронізації з майданчиком  ${username}
  \  Run As  ${username}  Пошук тендера по ідентифікатору  ${TENDER['TENDER_UAID']}  second_stage_data


Звірити відображення вмісту документа ${doc_id} із ${left} для користувача ${username}
  ${file_name}=  Run as  ${username}  Отримати документ  ${TENDER['TENDER_UAID']}  ${doc_id}
  ${right}=  Get File  ${OUTPUT_DIR}${/}${file_name}
  Порівняти об'єкти  ${left}  ${right}


Отримати інформацію про документ тендера ${doc_id} ${username}
  ${file_properties} =  Run as  ${username}  Отримати інформацію про документ  ${TENDER['TENDER_UAID']}  ${doc_id}
  Set To Dictionary  ${USERS.users['${tender_owner}'].tender_document}  file_properties=${file_properties}
  Log  ${file_properties}


Отримати інформацію про документ лотів ${doc_id} ${username}
  ${file_properties} =  Run as  ${username}  Отримати інформацію про документ  ${TENDER['TENDER_UAID']}  ${doc_id}
  Set To Dictionary  ${USERS.users['${tender_owner}'].lots_documents[0]}  file_properties=${file_properties}
  Log  ${file_properties}


Звірити інформацію про документацію ${file_properties} ${username}
  ${file_contents}=  Run as  ${username}  Отримати вміст документа  ${file_properties.url}
  ${file_hash}=  get_hash  ${file_contents}
  ${new_file_properties}=  Call Method  ${USERS.users['${viewer}'].client}  get_file_properties  ${file_properties.url}  ${file_hash}
  Порівняти об'єкти  ${new_file_properties}  ${file_properties}


Звірити відображення дати ${date} тендера для усіх користувачів
  :FOR  ${username}  IN  ${viewer}  ${tender_owner}  ${provider}  ${provider1}  ${provider2}
  \  Звірити відображення дати ${date} тендера для користувача ${username}


Звірити відображення дати ${date} тендера для користувача ${username}
  Звірити дату тендера  ${username}  ${TENDER['TENDER_UAID']}  ${USERS.users['${tender_owner}'].initial_data}  ${date}


Звірити відображення дати ${field} контракту із ${date} для користувача ${username}
  Звірити дату тендера із значенням  ${username}  ${TENDER['TENDER_UAID']}  ${date}  ${field}


Звірити відображення поля ${field} у новоствореному предметі для усіх користувачів
  :FOR  ${username}  IN  ${viewer}  ${tender_owner}  ${provider}  ${provider1}  ${provider2}
  \  Звірити відображення поля ${field} у новоствореному предметі для користувача ${username}


Звірити відображення поля ${field} у новоствореному предметі для користувача ${username}
  Дочекатись синхронізації з майданчиком  ${username}
  Звірити поле тендера із значенням  ${username}  ${TENDER['TENDER_UAID']}
  ...      ${USERS.users['${tender_owner}'].item_data.item.${field}}  ${field}
  ...      object_id=${USERS.users['${tender_owner}'].item_data.item_id}


Звірити відображення поля ${field} усіх предметів для усіх користувачів
  :FOR  ${username}  IN  ${viewer}  ${tender_owner}  ${provider}  ${provider1}  ${provider2}
  \  Звірити відображення поля ${field} усіх предметів для користувача ${username}


Звірити відображення поля ${field} усіх предметів для користувача ${username}
  :FOR  ${item_index}  IN RANGE  ${NUMBER_OF_ITEMS}
  \  Звірити відображення поля ${field} ${item_index} предмету для користувача ${username}


Звірити відображення поля ${field} усіх умов оплати для усіх користувачів
  :FOR  ${username}  IN  ${viewer}  ${tender_owner}  ${provider}  ${provider1}  ${provider2}
  \  Звірити відображення поля ${field} усіх умов оплати для користувача ${username}


Звірити відображення поля ${field} усіх умов оплати для користувача ${username}
  :FOR  ${milestone_index}  IN RANGE  ${NUMBER_OF_MILESTONES}
  \  Звірити поле тендера із значенням
  \  ...      ${username}
  \  ...      ${TENDER['TENDER_UAID']}
  \  ...      ${USERS.users['${tender_owner}'].initial_data.data['milestones'][${milestone_index}].${field}}
  \  ...      ${field}  object_type=milestones  object_index=${milestone_index}


Звірити відображення ${field} усіх предметів плану для усіх користувачів
  :FOR  ${username}  IN  ${viewer}  ${tender_owner}
  \  Звірити відображення ${field} усіх предметів плану для користувача ${username}


Звірити відображення ${field} усіх предметів плану для користувача ${username}
  :FOR  ${item_index}  IN RANGE  ${NUMBER_OF_ITEMS}
  \  ${item_id}=  get_id_from_object  ${USERS.users['${tender_owner}'].initial_data.data['items'][${item_index}]}
  \  Звірити поле плану із значенням  ${username}  ${TENDER['TENDER_UAID']}  ${USERS.users['${tender_owner}'].initial_data.data['items'][${item_index}].${field}}  ${field}  ${item_id}


Звірити відображення поля ${field} ${item_index} предмету для користувача ${username}
  ${item_id}=  get_id_from_object  ${USERS.users['${tender_owner}'].initial_data.data['items'][${item_index}]}
  Звірити поле тендера із значенням  ${username}  ${TENDER['TENDER_UAID']}  ${USERS.users['${tender_owner}'].initial_data.data['items'][${item_index}].${field}}  ${field}  ${item_id}


Звірити відображення дати ${field} усіх предметів для користувача ${username}
  :FOR  ${item_index}  IN RANGE  ${NUMBER_OF_ITEMS}
  \  Звірити відображення дати ${field} ${item_index} предмету для користувача ${username}


Звірити відображення дати ${date} ${item_index} предмету для користувача ${username}
  ${item_id}=  get_id_from_object  ${USERS.users['${tender_owner}'].initial_data.data['items'][${item_index}]}
  Звірити дату тендера із значенням  ${username}  ${TENDER['TENDER_UAID']}  ${USERS.users['${tender_owner}'].initial_data.data['items'][${item_index}].${date}}  ${date}  ${item_id}


Звірити відображення координат усіх предметів для користувача ${username}
  :FOR  ${item_index}  IN RANGE  ${NUMBER_OF_ITEMS}
  \  Звірити відображення координат ${item_index} предмету для користувача ${username}


Звірити відображення координат ${item_index} предмету для користувача ${username}
  ${item_id}=  get_id_from_object  ${USERS.users['${tender_owner}'].initial_data.data['items'][${item_index}]}
  Звірити координати доставки тендера  ${viewer}  ${TENDER['TENDER_UAID']}  ${USERS.users['${tender_owner}'].initial_data}  ${item_id}


Звірити відображення поля ${field} усіх донорів для усіх користувачів
  :FOR  ${username}  IN  ${viewer}  ${tender_owner}  ${provider}  ${provider1}  ${provider2}
  \  Звірити відображення поля ${field} усіх донорів для користувача ${username}


Звірити відображення поля ${field} усіх донорів для користувача ${username}
  :FOR  ${funders_index}  IN RANGE  ${FUNDERS}
  \  Звірити відображення поля ${field} ${funders_index} донора для користувача ${username}


Звірити відображення поля ${field} ${funders_index} донора для користувача ${username}
  Звірити поле донора  ${username}  ${TENDER['TENDER_UAID']}  ${USERS.users['${tender_owner}'].initial_data}  ${field}  ${funders_index}


Отримати дані із поля ${field} тендера для усіх користувачів
  :FOR  ${username}  IN  ${viewer}  ${provider}  ${provider1}  ${provider2}  ${tender_owner}
  \  Отримати дані із поля ${field} тендера для користувача ${username}


Отримати дані із поля ${field} тендера для користувача ${username}
  Отримати дані із тендера  ${username}  ${TENDER['TENDER_UAID']}  ${field}


Отримати дані із поля ${field} об'єкта моніторингу для усіх користувачів
  :FOR  ${username}  IN  ${viewer}  ${tender_owner}  ${dasu_user}
  \  Отримати дані із поля ${field} об'єкта моніторингу для користувача ${username}


Отримати дані із поля ${field} об'єкта моніторингу для користувача ${username}
  Отримати дані із об'єкта моніторингу  ${username}  ${MONITORING['MONITORING_UAID']}  ${field}

##############################################################################################
#             LOTS
##############################################################################################

Можливість додати документацію до ${lot_index} лоту
  ${lot_id}=  get_id_from_object  ${USERS.users['${tender_owner}'].tender_data.data.lots[${lot_index}]}
  ${file_path}  ${file_name}  ${file_content}=  create_fake_doc
  Run As  ${tender_owner}  Завантажити документ в лот  ${file_path}  ${TENDER['TENDER_UAID']}  ${lot_id}
  ${doc_id}=  get_id_from_string  ${file_name}
  ${data}=  Create Dictionary
  ...      doc_name=${file_name}
  ...      doc_id=${doc_id}
  ...      doc_content=${file_content}
  ${empty_list}=  Create List
  ${lots_documents}=  Get variable value  ${USERS.users['${tender_owner}'].lots_documents}  ${empty_list}
  Append to list  ${lots_documents}  ${data}
  Set to dictionary  ${USERS.users['${tender_owner}']}  lots_documents=${lots_documents}
  Log  ${USERS.users['${tender_owner}'].lots_documents}
  Remove File  ${file_path}


Можливість додати документацію до всіх лотів
  :FOR  ${lot_index}  IN RANGE  ${NUMBER_OF_LOTS}
  \  Можливість додати документацію до ${lot_index} лоту


Можливість додати предмет закупівлі в ${lot_index} лот
  ${lot_id}=  get_id_from_object  ${USERS.users['${tender_owner}'].tender_data.data.lots[${lot_index}]}
  ${item}=  Підготувати дані для створення предмету закупівлі  ${USERS.users['${tender_owner}'].initial_data.data['items'][0]['classification']['id']}
  Run As  ${tender_owner}  Додати предмет закупівлі в лот  ${TENDER['TENDER_UAID']}  ${lot_id}  ${item}
  ${item_id}=  get_id_from_object  ${item}
  ${item_data}=  Create Dictionary
  ...      item=${item}
  ...      item_id=${item_id}
  ${item_data}=  munch_dict  arg=${item_data}
  Set To Dictionary  ${USERS.users['${tender_owner}']}  item_data=${item_data}


Звірити відображення заголовку документації до всіх лотів для користувача ${username}
  :FOR  ${lot_index}  IN RANGE  ${NUMBER_OF_LOTS}
  \  Звірити відображення поля title документа ${USERS.users['${tender_owner}'].lots_documents[${lot_index}].doc_id} із ${USERS.users['${tender_owner}'].lots_documents[${lot_index}].doc_name} для користувача ${username}


Звірити відображення вмісту документації до всіх лотів для користувача ${username}
  :FOR  ${lot_index}  IN RANGE  ${NUMBER_OF_LOTS}
  \  ${lot_id}=  get_id_from_object  ${USERS.users['${tender_owner}'].tender_data.data.lots[${lot_index}]}
  \  Звірити відображення вмісту документа ${USERS.users['${tender_owner}'].lots_documents[${lot_index}].doc_id} до лоту ${lot_id} з ${USERS.users['${tender_owner}'].lots_documents[${lot_index}].doc_content} для користувача ${username}


Звірити відображення поля ${field} документа ${doc_id} до лоту ${lot_id} з ${left} для користувача ${username}
  ${right}=  Run As  ${username}  Отримати інформацію із документа до лоту  ${TENDER['TENDER_UAID']}  ${lot_id}  ${doc_id}  ${field}
  Порівняти об'єкти  ${left}  ${right}


Звірити відображення вмісту документа ${doc_id} до лоту ${lot_id} з ${left} для користувача ${username}
  ${file_name}=  Run as  ${username}  Отримати документ до лоту  ${TENDER['TENDER_UAID']}  ${lot_id}  ${doc_id}
  ${right}=  Get File  ${OUTPUT_DIR}${/}${file_name}
  Порівняти об'єкти  ${left}  ${right}


Можливість видалити предмет закупівлі з ${lot_index} лоту
  ${lot_id}=  get_id_from_object  ${USERS.users['${tender_owner}'].tender_data.data.lots[${lot_index}]}
  Run As  ${tender_owner}  Видалити предмет закупівлі  ${TENDER['TENDER_UAID']}  ${USERS.users['${tender_owner}'].item_data.item_id}  ${lot_id}


Можливість створення лоту із прив’язаним предметом закупівлі
  ${lot}=  Підготувати дані для створення лоту  ${USERS.users['${tender_owner}'].tender_data.data.value.amount}
  ${item}=  Підготувати дані для створення предмету закупівлі  ${USERS.users['${tender_owner}'].initial_data.data['items'][0]['classification']['id']}
  Run As  ${tender_owner}  Створити лот із предметом закупівлі  ${TENDER['TENDER_UAID']}  ${lot}  ${item}
  ${item_id}=  get_id_from_object  ${item}
  ${item_data}=  Create Dictionary
  ...      item=${item}
  ...      item_id=${item_id}
  ${item_data}=  munch_dict  arg=${item_data}
  ${lot_id}=  get_id_from_object  ${lot.data}
  ${lot_data}=  Create Dictionary
  ...      lot=${lot}
  ...      lot_id=${lot_id}
  ${lot_data}=  munch_dict  arg=${lot_data}
  Set To Dictionary  ${USERS.users['${tender_owner}']}  item_data=${item_data}  lot_data=${lot_data}


Можливість видалення ${lot_index} лоту
  ${lot_id}=  get_id_from_object  ${USERS.users['${tender_owner}'].tender_data.data.lots[${lot_index}]}
  Run As  ${tender_owner}  Видалити лот  ${TENDER['TENDER_UAID']}  ${lot_id}
  :FOR  ${username}  IN  ${viewer}  ${tender_owner}  ${provider}  ${provider1}
  \  Remove From List  ${USERS.users['${username}'].tender_data.data.lots}  ${lot_index}


Звірити відображення поля ${field} усіх лотів для усіх користувачів
  :FOR  ${username}  IN  ${viewer}  ${tender_owner}  ${provider}  ${provider1}  ${provider2}
  \  Звірити відображення поля ${field} усіх лотів для користувача ${username}


Звірити відображення поля ${field} усіх лотів другого етапу для усіх користувачів
  :FOR  ${username}  IN  ${viewer}  ${tender_owner}  ${provider}  ${provider1}  ${provider2}
  \  Звірити відображення поля ${field} усіх лотів другого етапу для користувача ${username}


Звірити відображення поля ${field} усіх лотів для користувача ${username}
  :FOR  ${lot_index}  IN RANGE  ${NUMBER_OF_LOTS}
  \  Звірити відображення поля ${field} ${lot_index} лоту для користувача ${username}


Звірити відображення поля ${field} усіх лотів другого етапу для користувача ${username}
  :FOR  ${lot_index}  IN RANGE  ${NUMBER_OF_LOTS}
  \  Звірити відображення поля ${field} ${lot_index} лоту другого етапу для користувача ${username}


Звірити відображення поля ${field} ${lot_index} лоту для користувача ${username}
  Дочекатись синхронізації з майданчиком  ${username}
  ${lot_id}=  get_id_from_object  ${USERS.users['${tender_owner}'].initial_data.data.lots[${lot_index}]}
  Звірити поле тендера із значенням  ${username}  ${TENDER['TENDER_UAID']}
  ...      ${USERS.users['${tender_owner}'].initial_data.data.lots[${lot_index}].${field}}  ${field}
  ...      object_id=${lot_id}

Звірити відображення поля ${field} ${lot_index} лоту другого етапу для користувача ${username}
  Дочекатись синхронізації з майданчиком  ${username}
  ${lot_id}=  get_id_from_object  ${USERS.users['${tender_owner}'].tender_data.data.lots[${lot_index}]}
  ${left}=  Set Variable  ${USERS.users['${tender_owner}'].tender_data.data.lots[${lot_index}].${field}}
  ${right}=  Run As  ${username}  Отримати інформацію із лоту  ${TENDER['TENDER_UAID']}  ${lot_id}  ${field}
  Порівняти об'єкти  ${left}  ${right}


Отримати дані із поля ${field} тендера другого етапу для усіх користувачів
  :FOR  ${username}  IN  ${viewer}  ${tender_owner}  ${provider}  ${provider1}
  \  Отримати дані із поля ${field} тендера другого етапу для користувача ${username}


Отримати дані із поля ${field} тендера другого етапу для користувача ${username}
  Отримати дані із тендера другого етапу  ${username}  ${TENDER['TENDER_UAID']}  ${field}


Звірити відображення поля ${field} ${lot_index} лоту з ${data} для користувача ${username}
  ${lot_id}=  get_id_from_object  ${USERS.users['${tender_owner}'].initial_data.data.lots[${lot_index}]}
  Звірити поле тендера із значенням  ${username}  ${TENDER['TENDER_UAID']}  ${data}  ${field}  ${lot_id}


Звірити відображення поля ${field} у новоствореному лоті для усіх користувачів
  :FOR  ${username}  IN  ${viewer}  ${tender_owner}  ${provider}  ${provider1}  ${provider2}
  \  Звірити відображення поля ${field} у новоствореному лоті для користувача ${username}


Звірити відображення поля ${field} у новоствореному лоті для користувача ${username}
  Дочекатись синхронізації з майданчиком  ${username}
  Звірити поле тендера із значенням  ${username}  ${TENDER['TENDER_UAID']}
  ...      ${USERS.users['${tender_owner}'].lot_data.lot.data.${field}}  ${field}
  ...      object_id=${USERS.users['${tender_owner}'].lot_data.lot_id}


Можливість змінити на ${percent} відсотки бюджет ${lot_index} лоту
  ${percent}=  Convert To Number  ${percent}
  ${divider}=  Convert To Number  0.01
  ${value}=  mult_and_round  ${USERS.users['${tender_owner}'].tender_data.data.lots[${lot_index}].value.amount}  ${percent}  ${divider}  precision=${2}
  ${step_value}=  mult_and_round  ${USERS.users['${tender_owner}'].tender_data.data.lots[${lot_index}].minimalStep.amount}  ${percent}  ${divider}  precision=${2}
  Можливість змінити поле value.amount ${lot_index} лоту на ${value}
  Можливість змінити поле minimalStep.amount ${lot_index} лоту на ${step_value}


Можливість змінити поле ${field} ${lot_index} лоту на ${value}
  ${lot_id}=  get_id_from_object  ${USERS.users['${tender_owner}'].tender_data.data.lots[${lot_index}]}
  Run As  ${tender_owner}  Змінити лот  ${TENDER['TENDER_UAID']}  ${lot_id}  ${field}  ${value}

##############################################################################################
#             FEATURES
##############################################################################################

Можливість додати неціновий показник на тендер
  ${feature}=  Підготувати дані для створення нецінового показника
  Set To Dictionary  ${feature}  featureOf=tenderer
  Run As  ${tender_owner}  Додати неціновий показник на тендер  ${TENDER['TENDER_UAID']}  ${feature}
  ${feature_id}=  get_id_from_object  ${feature}
  ${feature_data}=  Create Dictionary
  ...      feature=${feature}
  ...      feature_id=${feature_id}
  ${feature_data}=  munch_dict  arg=${feature_data}
  Set To Dictionary  ${USERS.users['${tender_owner}']}  feature_data=${feature_data}


Можливість додати неціновий показник на ${lot_index} лот
  ${feature}=  Підготувати дані для створення нецінового показника
  Set To Dictionary  ${feature}  featureOf=lot
  ${lot_id}=  get_id_from_object  ${USERS.users['${tender_owner}'].tender_data.data.lots[${lot_index}]}
  Run As  ${tender_owner}  Додати неціновий показник на лот  ${TENDER['TENDER_UAID']}  ${feature}  ${lot_id}
  ${feature_id}=  get_id_from_object  ${feature}
  ${feature_data}=  Create Dictionary
  ...      feature=${feature}
  ...      feature_id=${feature_id}
  ${feature_data}=  munch_dict  arg=${feature_data}
  Set To Dictionary  ${USERS.users['${tender_owner}']}  feature_data=${feature_data}


Можливість додати неціновий показник на ${item_index} предмет
  ${feature}=  Підготувати дані для створення нецінового показника
  Set To Dictionary  ${feature}  featureOf=item
  ${item_id}=  get_id_from_object  ${USERS.users['${tender_owner}'].tender_data.data['items'][${item_index}]}
  Run As  ${tender_owner}  Додати неціновий показник на предмет  ${TENDER['TENDER_UAID']}  ${feature}  ${item_id}
  ${feature_id}=  get_id_from_object  ${feature}
  ${feature_data}=  Create Dictionary
  ...      feature=${feature}
  ...      feature_id=${feature_id}
  ${feature_data}=  munch_dict  arg=${feature_data}
  Set To Dictionary  ${USERS.users['${tender_owner}']}  feature_data=${feature_data}


Звірити відображення поля ${field} у новоствореному неціновому показнику для усіх користувачів
  :FOR  ${username}  IN  ${viewer}  ${tender_owner}  ${provider}  ${provider1}  ${provider2}
  \  Звірити відображення поля ${field} у новоствореному неціновому показнику для користувача ${username}


Звірити відображення поля ${field} у новоствореному неціновому показнику для користувача ${username}
  Дочекатись синхронізації з майданчиком  ${username}
  Звірити поле тендера із значенням  ${username}  ${TENDER['TENDER_UAID']}
  ...      ${USERS.users['${tender_owner}'].feature_data.feature.${field}}  ${field}
  ...      object_id=${USERS.users['${tender_owner}'].feature_data.feature_id}


Звірити відображення поля ${field} усіх нецінових показників для усіх користувачів
  :FOR  ${username}  IN  ${viewer}  ${tender_owner}  ${provider}  ${provider1}  ${provider2}
  \  Звірити відображення поля ${field} усіх нецінових показників для користувача ${username}


Звірити відображення поля ${field} усіх нецінових показників для користувача ${username}
  ${number_of_features}=  Get Length  ${USERS.users['${tender_owner}'].initial_data.data.features}
  :FOR  ${feature_index}  IN RANGE  ${number_of_features}
  \  Звірити відображення поля ${field} ${feature_index} нецінового показника для користувача ${username}


Звірити відображення поля ${field} ${feature_index} нецінового показника для користувача ${username}
  Дочекатись синхронізації з майданчиком  ${username}
  ${feature_id}=  get_id_from_object  ${USERS.users['${tender_owner}'].initial_data.data.features[${feature_index}]}
  Звірити поле тендера із значенням  ${username}  ${TENDER['TENDER_UAID']}
  ...      ${USERS.users['${tender_owner}'].initial_data.data.features[${feature_index}].${field}}  ${field}
  ...      object_id=${feature_id}


Отримати дані із поля ${field_name} нецінових показників для усіх користувачів
  :FOR  ${username}  IN  ${viewer}  ${tender_owner}  ${provider}  ${provider1}
  \  Отримати дані із поля ${field_name} нецінових показників для користувача ${username}


Отримати дані із поля ${field_name} нецінових показників для користувача ${username}
  ${number_of_features}=  Get Length  ${USERS.users['${provider2}'].tender_data.data.features}
  :FOR  ${feature_index}  IN RANGE  ${number_of_features}
  \  Отримати дані із нецінового показника  ${username}  ${TENDER['TENDER_UAID']}  features[${feature_index}].${field_name}


Отримати дані із нецінового показника
  [Arguments]  ${username}  ${tender_uaid}  ${field_name}
  ${field_value}=  Run As  ${username}  Отримати інформацію із тендера  ${tender_uaid}  ${field_name}
  Set_To_Object  ${USERS.users['${username}'].tender_data.data}  ${field_name}  ${field_value}
  ${data}=  munch_dict  arg=${USERS.users['${username}'].tender_data.data}
  Set To Dictionary  ${USERS.users['${username}'].tender_data}  data=${data}
  Log  ${USERS.users['${username}'].tender_data.data}
  [return]  ${field_value}


Можливість видалити ${feature_index} неціновий показник
  ${feature_id}=  get_id_from_object  ${USERS.users['${tender_owner}'].tender_data.data['features'][${feature_index}]}
  Run As  ${tender_owner}  Видалити неціновий показник  ${TENDER['TENDER_UAID']}  ${feature_id}
  ${feature_index}=  get_object_index_by_id  ${USERS.users['${tender_owner}'].tender_data.data['features']}  ${feature_id}
  :FOR  ${username}  IN  ${viewer}  ${tender_owner}  ${provider}  ${provider1}  ${provider2}
  \  Remove From List  ${USERS.users['${username}'].tender_data.data['features']}  ${feature_index}


Звірити відображення поля ${field} зміни до договору для користувача ${username}
  Звірити поле зміни до договору  ${username}  ${CONTRACT_UAID}
  ...      ${USERS.users['${tender_owner}'].change_data}
  ...      ${field}


Звірити відображення поля ${field} договору із ${left} для користувача ${username}
  ${right}=  Run As  ${username}  Отримати інформацію із договору  ${CONTRACT_UAID}  ${field}
  Порівняти об'єкти  ${left}  ${right}


Звірити відображення поля ${field} документа ${doc_id} до договору з ${left} для користувача ${username}
  ${right}=  Run As  ${username}  Отримати інформацію із документа до договору  ${CONTRACT_UAID}  ${doc_id}  ${field}
  Порівняти об'єкти  ${left}  ${right}


Звірити відображення вмісту документа ${doc_id} до договору з ${left} для користувача ${username}
  ${file_name}=  Run As  ${username}  Отримати документ до договору  ${CONTRACT_UAID}  ${doc_id}
  ${right}=  Get File  ${OUTPUT_DIR}${/}${file_name}
  Порівняти об'єкти  ${left}  ${right}


Звірити відображення причин зміни договору
  ${rationale_types_from_broker}=  Run as  ${viewer}  Отримати інформацію із договору  ${CONTRACT_UAID}  changes[0].rationaleTypes
  ${rationale_types_from_robot}=  Get variable value  ${USERS.users['${tender_owner}'].change_data.data.rationaleTypes}
  Log  ${rationale_types_from_broker}
  Log  ${rationale_types_from_robot}
  ${result}=  compare_rationale_types  ${rationale_types_from_broker}  ${rationale_types_from_robot}
  Run keyword if  ${result} == ${False}  Fail  Rationale types are not equal


Додати документацію до зміни договору
  ${file_path}  ${file_name}  ${file_content}=  create_fake_doc
  ${doc_id}=  get_id_from_string  ${file_name}
  ${doc}=  Create Dictionary
  ...      id=${doc_id}
  ...      name=${file_name}
  ...      content=${file_content}
  Set to dictionary  ${USERS.users['${tender_owner}']}  change_doc=${doc}
  Run As  ${tender_owner}  Додати документацію до зміни в договорі  ${CONTRACT_UAID}  ${file_path}
  Remove File  ${file_path}


Додати документацію до договору
  ${file_path}  ${file_name}  ${file_content}=  create_fake_doc
  ${doc_id}=  get_id_from_string  ${file_name}
  ${doc}=  Create Dictionary
  ...      id=${doc_id}
  ...      name=${file_name}
  ...      content=${file_content}
  Set to dictionary  ${USERS.users['${tender_owner}']}  contract_doc=${doc}
  Run As  ${tender_owner}  Завантажити документацію до договору  ${CONTRACT_UAID}  ${file_path}
  Remove File  ${file_path}


Вказати дійсно оплачену суму
  ${amount}=  Get variable value  ${USERS.users['${tender_owner}'].contract_data.data.value.amount}
  ${amount_net}=  Get variable value  ${USERS.users['${tender_owner}'].contract_data.data.value.amountNet}
  ${valueAddedTaxIncluded}=  Get variable value  ${USERS.users['${tender_owner}'].contract_data.data.value.valueAddedTaxIncluded}
  ${amountPaid}=  Create Dictionary  amount=${amount}  amountNet=${amount_net}  valueAddedTaxIncluded=${valueAddedTaxIncluded}  currency=UAH
  ${data}=  Create Dictionary  amountPaid=${amountPaid}
  ${data}=  Create Dictionary  data=${data}
  Set to dictionary  ${USERS.users['${tender_owner}']}  terminating_data=${data}
  Run As  ${tender_owner}  Внести зміни в договір  ${CONTRACT_UAID}  ${data}


##############################################################################################
#             QUESTIONS
##############################################################################################

Можливість задати запитання на тендер користувачем ${username}
  ${question}=  Підготувати дані для запитання
  Run As  ${username}  Задати запитання на тендер  ${TENDER['TENDER_UAID']}  ${question}
  ${now}=  Get Current TZdate
  ${question.data.date}=  Set variable  ${now}
  ${question_id}=  get_id_from_object  ${question.data}
  ${question_data}=  Create Dictionary
  ...      question=${question}
  ...      question_id=${question_id}
  ${question_data}=  munch_dict  arg=${question_data}
  Set To Dictionary  ${USERS.users['${username}']}  tender_question_data=${question_data}


Можливість задати запитання на ${lot_index} лот користувачем ${username}
  ${lot_id}=  get_id_from_object  ${USERS.users['${tender_owner}'].tender_data.data.lots[${lot_index}]}
  ${question}=  Підготувати дані для запитання
  Run As  ${username}  Задати запитання на лот  ${TENDER['TENDER_UAID']}  ${lot_id}  ${question}
  ${now}=  Get Current TZdate
  ${question.data.date}=  Set variable  ${now}
  ${question_id}=  get_id_from_object  ${question.data}
  ${question_data}=  Create Dictionary
  ...      question=${question}
  ...      question_id=${question_id}
  ${question_data}=  munch_dict  arg=${question_data}
  Set To Dictionary  ${USERS.users['${username}']}  lots_${lot_index}_question_data=${question_data}


Можливість задати запитання на ${item_index} предмет користувачем ${username}
  ${item_id}=  get_id_from_object  ${USERS.users['${tender_owner}'].tender_data.data['items'][${item_index}]}
  ${question}=  Підготувати дані для запитання
  Run As  ${username}  Задати запитання на предмет  ${TENDER['TENDER_UAID']}  ${item_id}  ${question}
  ${now}=  Get Current TZdate
  ${question.data.date}=  Set variable  ${now}
  ${question_id}=  get_id_from_object  ${question.data}
  ${question_data}=  Create Dictionary
  ...      question=${question}
  ...      question_id=${question_id}
  ${question_data}=  munch_dict  arg=${question_data}
  Set To Dictionary  ${USERS.users['${username}']}  items_${item_index}_question_data=${question_data}


Можливість відповісти на запитання на тендер
  ${answer}=  Підготувати дані для відповіді на запитання
  Run As  ${tender_owner}
  ...      Відповісти на запитання  ${TENDER['TENDER_UAID']}
  ...      ${answer}
  ...      ${USERS.users['${provider}'].tender_question_data.question_id}
  Set To Dictionary  ${USERS.users['${provider}'].tender_question_data.question.data}  answer=${answer.data.answer}


Можливість відповісти на запитання на ${item_index} предмет
  ${answer}=  Підготувати дані для відповіді на запитання
  Run As  ${tender_owner}
  ...      Відповісти на запитання  ${TENDER['TENDER_UAID']}
  ...      ${answer}
  ...      ${USERS.users['${provider}'].items_${item_index}_question_data.question_id}
  Set To Dictionary  ${USERS.users['${provider}'].items_${item_index}_question_data.question.data}  answer=${answer.data.answer}


Можливість відповісти на запитання на ${lot_index} лот
  ${answer}=  Підготувати дані для відповіді на запитання
  Run As  ${tender_owner}
  ...      Відповісти на запитання  ${TENDER['TENDER_UAID']}
  ...      ${answer}
  ...      ${USERS.users['${provider}'].lots_${lot_index}_question_data.question_id}
  Set To Dictionary  ${USERS.users['${provider}'].lots_${lot_index}_question_data.question.data}  answer=${answer.data.answer}


Звірити відображення поля ${field} запитання на тендер для усіх користувачів
  :FOR  ${username}  IN  ${viewer}  ${tender_owner}  ${provider}  ${provider1}  ${provider2}
  \  Звірити відображення поля ${field} запитання на тендер для користувача ${username}


Звірити відображення поля ${field} запитання на тендер для користувача ${username}
  Звірити поле тендера із значенням  ${username}  ${TENDER['TENDER_UAID']}  ${USERS.users['${provider}'].tender_question_data.question.data.${field}}  ${field}  ${USERS.users['${provider}'].tender_question_data.question_id}


Звірити відображення поля ${field} запитання на ${item_index} предмет для усіх користувачів
  :FOR  ${username}  IN  ${viewer}  ${tender_owner}  ${provider}  ${provider1}  ${provider2}
  \  Звірити відображення поля ${field} запитання на ${item_index} предмет для користувача ${username}


Звірити відображення поля ${field} запитання на ${item_index} предмет для користувача ${username}
  Звірити поле тендера із значенням  ${username}  ${TENDER['TENDER_UAID']}  ${USERS.users['${provider}'].items_${item_index}_question_data.question.data.${field}}  ${field}  ${USERS.users['${provider}'].items_${item_index}_question_data.question_id}


Звірити відображення поля ${field} запитання на ${lot_index} лот для усіх користувачів
  :FOR  ${username}  IN  ${viewer}  ${tender_owner}  ${provider}  ${provider1}  ${provider2}
  \  Звірити відображення поля ${field} запитання на ${lot_index} лот для користувача ${username}


Звірити відображення поля ${field} запитання на ${lot_index} лот для користувача ${username}
  Звірити поле тендера із значенням  ${username}  ${TENDER['TENDER_UAID']}  ${USERS.users['${provider}'].lots_${lot_index}_question_data.question.data.${field}}  ${field}  ${USERS.users['${provider}'].lots_${lot_index}_question_data.question_id}

##############################################################################################
#             COMPLAINTS
##############################################################################################

Можливість створити чернетку скарги
  ${complaint}=  Підготувати дані для подання скарги
  ${complaintID}=  Run As  ${provider}
  ...      Створити чернетку скарги про виправлення умов закупівлі
  ...      ${TENDER['TENDER_UAID']}
  ...      ${complaint}
  Set To Dictionary  ${USERS.users['${provider}']}  complaint_data  ${complaintID}
  Log  ${USERS.users['${provider}'].complaint_data}


Можливість створити чернетку скарги про виправлення умов ${lot_index} лоту
  ${complaint}=  Підготувати дані для подання скарги
  ${lot_id}=  get_id_from_object  ${USERS.users['${provider}'].tender_data.data.lots[${lot_index}]}
  ${complaintID}=  Run As  ${provider}
  ...      Створити чернетку скарги про виправлення умов лоту
  ...      ${TENDER['TENDER_UAID']}
  ...      ${complaint}
  ...      ${lot_id}
  Set To Dictionary  ${USERS.users['${provider}']}  complaint_data  ${complaintID}
  Log  ${USERS.users['${provider}'].complaint_data}


Додати документ до скарги
  ${file_path}  ${file_name}  ${file_content}=  create_fake_doc
  Run As  ${provider}
  ...      Завантажити документацію до вимоги
  ...      ${TENDER['TENDER_UAID']}
  ...      ${USERS.users['${provider}']['complaint_data']['complaintID']}
  ...      ${file_path}
  ${doc_id}=  get_id_from_string  ${file_name}
  ${complaint_doc}=  Create Dictionary
  ...      doc_name=${file_name}
  ...      doc_id=${doc_id}
  ...      doc_content=${file_content}
  ${claim_doc}=  munch_dict  arg=${complaint_doc}
  Set To Dictionary  ${USERS.users['${provider}'].complaint_data}  documents  ${complaint_doc}
  Remove File  ${file_path}
  Log  ${USERS.users['${provider}'].complaint_data}


Можливість створити чернетку скарги про виправлення кваліфікації ${qualification_index} учасника
  ${complaint}=  Підготувати дані для подання скарги
  ${complaintID}=  Run As  ${provider}
  ...      Створити чернетку вимоги/скарги про виправлення кваліфікації учасника
  ...      ${TENDER['TENDER_UAID']}
  ...      ${complaint}
  ...      ${qualification_index}
  Set To Dictionary  ${USERS.users['${provider}']}  complaint_data  ${complaintID}
  Log  ${USERS.users['${provider}'].complaint_data}


Можливість створити чернетку скарги про виправлення визначення ${award_index} переможця
  ${complaint}=  Підготувати дані для подання скарги
  ${complaintID}=  Run As  ${provider}
  ...      Створити чернетку вимоги/скарги про виправлення визначення переможця
  ...      ${TENDER['TENDER_UAID']}
  ...      ${complaint}
  ...      ${award_index}
  Set To Dictionary  ${USERS.users['${provider}']}  complaint_data  ${complaintID}
  Log  ${USERS.users['${provider}'].complaint_data}


Можливість створити чернетку скарги на скасування ${canсellations_index}
  ${complaint}=  Підготувати дані для подання скарги
  ${complaintID}=  Run As  ${provider}
  ...      Створити чернетку вимоги/скарги на скасування
  ...      ${TENDER['TENDER_UAID']}
  ...      ${complaint}
  ...      ${canсellations_index}
  Set To Dictionary  ${USERS.users['${provider}']}  complaint_data  ${complaintID}
  Log  ${USERS.users['${provider}'].complaint_data}


Звірити відображення поля ${field} скарги ${object_index} із ${data} об'єкта ${object} для користувача ${username}
  Wait until keyword succeeds
  ...      5 min
  ...      60 sec
  ...      Звірити поле скарги із значенням
  ...      ${username}
  ...      ${TENDER['TENDER_UAID']}
  ...      ${data}
  ...      ${field}
  ...      ${USERS.users['${provider}'].complaint_data['complaintID']}
  ...      ${object_index}
  ...      ${object}


Звірити відображення поля ${field} скарги із ${data} для користувача ${username}
  Wait until keyword succeeds
  ...      5 min
  ...      60 sec
  ...      Звірити поле скарги із значенням
  ...      ${username}
  ...      ${TENDER['TENDER_UAID']}
  ...      ${data}
  ...      ${field}
  ...      ${USERS.users['${provider}'].complaint_data['complaintID']}


Додати документ до скарги ${object_index} учасника в ${object}
  ${file_path}  ${file_name}  ${file_content}=  create_fake_doc
  Run As  ${provider}
  ...      Завантажити документ до скарги в окремий об'єкт
  ...      ${TENDER['TENDER_UAID']}
  ...      ${USERS.users['${provider}']['complaint_data']['complaintID']}
  ...      ${object_index}
  ...      ${file_path}
  ...      ${object}
  ${doc_id}=  get_id_from_string  ${file_name}
  ${complaint_doc}=  Create Dictionary
  ...      doc_name=${file_name}
  ...      doc_id=${doc_id}
  ...      doc_content=${file_content}
  ${claim_doc}=  munch_dict  arg=${complaint_doc}
  Set To Dictionary  ${USERS.users['${provider}'].complaint_data}  documents  ${complaint_doc}
  Remove File  ${file_path}
  Log  ${USERS.users['${provider}'].complaint_data}


Можливість подати скаргу
  Log  ${USERS.users['${provider}'].complaint_access_token}
  ${complaint_token}=  set variable  ${USERS.users['${provider}'].complaint_access_token}
  Log  ${USERS.users['${provider}']['complaint_data']['value']['amount']}
  ${complaint_value}=  set variable  ${USERS.users['${provider}']['complaint_data']['value']['amount']}
  Log  ${USERS.users['${provider}']['complaint_data']['complaintID']}
  ${complaint_uaid}=  set variable  ${USERS.users['${provider}']['complaint_data']['complaintID']}
  ${payment_data}=  Підготувати дані для оплати скарги  ${complaint_token}  ${complaint_value}  ${complaint_uaid}
  Run As  ${provider}
  ...      Виконати оплату скарги
  ...      ${payment_data}


Прийняти скаргу до розгляду
  ${confirmation_data}=  Підготувати дані для прийняття скарги до розгляду
  Run As  ${amcu_user}
  ...      Змінити статус скарги
  ...      ${TENDER['TENDER_UAID']}
  ...      ${USERS.users['${provider}']['complaint_data']['complaintID']}
  ...      ${confirmation_data}


Прийняти скаргу на визначення пре-кваліфікації ${qualification_index} учасника до розгляду
  ${confirmation_data}=  Підготувати дані для прийняття скарги до розгляду
  Run As  ${amcu_user}
  ...      Змінити статус скарги на визначення пре-кваліфікації учасника
  ...      ${TENDER['TENDER_UAID']}
  ...      ${USERS.users['${provider}']['complaint_data']['complaintID']}
  ...      ${qualification_index}
  ...      ${confirmation_data}


Прийняти скаргу на визначення ${award_index} переможця до розгляду
  ${confirmation_data}=  Підготувати дані для прийняття скарги до розгляду
  Run As  ${amcu_user}
  ...      Змінити статус скарги на визначення переможця
  ...      ${TENDER['TENDER_UAID']}
  ...      ${USERS.users['${provider}']['complaint_data']['complaintID']}
  ...      ${award_index}
  ...      ${confirmation_data}


Прийняти скаргу на скасування ${canсellations_index} до розгляду
  ${confirmation_data}=  Підготувати дані для прийняття скарги до розгляду
  Run As  ${amcu_user}
  ...      Змінити статус скарги на скасування
  ...      ${TENDER['TENDER_UAID']}
  ...      ${USERS.users['${provider}']['complaint_data']['complaintID']}
  ...      ${canсellations_index}
  ...      ${confirmation_data}


Задовільнити скаргу
  ${data}=  Create Dictionary  status=satisfied
  ${confirmation_data}=  Create Dictionary  data=${data}
  Run As  ${amcu_user}
  ...      Змінити статус скарги
  ...      ${TENDER['TENDER_UAID']}
  ...      ${USERS.users['${provider}']['complaint_data']['complaintID']}
  ...      ${confirmation_data}


Задовільнити скаргу на визначення пре-кваліфікації ${qualification_index} учасника
  ${data}=  Create Dictionary  status=satisfied
  ${confirmation_data}=  Create Dictionary  data=${data}
  Run As  ${amcu_user}
  ...      Змінити статус скарги на визначення пре-кваліфікації учасника
  ...      ${TENDER['TENDER_UAID']}
  ...      ${USERS.users['${provider}']['complaint_data']['complaintID']}
  ...      ${qualification_index}
  ...      ${confirmation_data}


Задовільнити скаргу на визначення ${award_index} переможця
  ${data}=  Create Dictionary  status=satisfied
  ${confirmation_data}=  Create Dictionary  data=${data}
  Run As  ${amcu_user}
  ...      Змінити статус скарги на визначення переможця
  ...      ${TENDER['TENDER_UAID']}
  ...      ${USERS.users['${provider}']['complaint_data']['complaintID']}
  ...      ${award_index}
  ...      ${confirmation_data}


Задовільнити скаргу на скасування ${canсellations_index}
  ${data}=  Create Dictionary  status=satisfied
  ${confirmation_data}=  Create Dictionary  data=${data}
  Run As  ${amcu_user}
  ...      Змінити статус скарги на скасування
  ...      ${TENDER['TENDER_UAID']}
  ...      ${USERS.users['${provider}']['complaint_data']['complaintID']}
  ...      ${canсellations_index}
  ...      ${confirmation_data}


Відхилити скаргу
  ${data}=  Create Dictionary  status=declined
  ${confirmation_data}=  Create Dictionary  data=${data}
  Run As  ${amcu_user}
  ...      Змінити статус скарги
  ...      ${TENDER['TENDER_UAID']}
  ...      ${USERS.users['${provider}']['complaint_data']['complaintID']}
  ...      ${confirmation_data}


Відхилити скаргу на визначення пре-кваліфікації ${qualification_index} учасника
  ${data}=  Create Dictionary  status=declined
  ${confirmation_data}=  Create Dictionary  data=${data}
  Run As  ${amcu_user}
  ...      Змінити статус скарги на визначення пре-кваліфікації учасника
  ...      ${TENDER['TENDER_UAID']}
  ...      ${USERS.users['${provider}']['complaint_data']['complaintID']}
  ...      ${qualification_index}
  ...      ${confirmation_data}


Відхилити скаргу на визначення ${award_index} переможця
  ${data}=  Create Dictionary  status=declined
  ${confirmation_data}=  Create Dictionary  data=${data}
  Run As  ${amcu_user}
  ...      Змінити статус скарги на визначення переможця
  ...      ${TENDER['TENDER_UAID']}
  ...      ${USERS.users['${provider}']['complaint_data']['complaintID']}
  ...      ${award_index}
  ...      ${confirmation_data}


Відхилити скаргу на скасування ${canсellations_index}
  ${data}=  Create Dictionary  status=declined
  ${confirmation_data}=  Create Dictionary  data=${data}
  Run As  ${amcu_user}
  ...      Змінити статус скарги на скасування
  ...      ${TENDER['TENDER_UAID']}
  ...      ${USERS.users['${provider}']['complaint_data']['complaintID']}
  ...      ${canсellations_index}
  ...      ${confirmation_data}


Зупинити розгляд скарги
  ${confirmation_data}=  Підготувати дані для відхилення скарги
  Set To Dictionary  ${confirmation_data.data}  status=stopped
  Run As  ${amcu_user}
  ...      Змінити статус скарги
  ...      ${TENDER['TENDER_UAID']}
  ...      ${USERS.users['${provider}']['complaint_data']['complaintID']}
  ...      ${confirmation_data}


Зупинити скаргу на визначення пре-кваліфікації ${qualification_index} учасника
  ${confirmation_data}=  Підготувати дані для відхилення скарги
  Set To Dictionary  ${confirmation_data.data}  status=stopped
  Run As  ${amcu_user}
  ...      Змінити статус скарги на визначення пре-кваліфікації учасника
  ...      ${TENDER['TENDER_UAID']}
  ...      ${USERS.users['${provider}']['complaint_data']['complaintID']}
  ...      ${qualification_index}
  ...      ${confirmation_data}


Зупинити скаргу на визначення ${award_index} переможця
  ${confirmation_data}=  Підготувати дані для відхилення скарги
  Set To Dictionary  ${confirmation_data.data}  status=stopped
  Run As  ${amcu_user}
  ...      Змінити статус скарги на визначення переможця
  ...      ${TENDER['TENDER_UAID']}
  ...      ${USERS.users['${provider}']['complaint_data']['complaintID']}
  ...      ${award_index}
  ...      ${confirmation_data}


Зупинити скаргу на скасування ${cancellations_index}
  ${confirmation_data}=  Підготувати дані для відхилення скарги
  Set To Dictionary  ${confirmation_data.data}  status=stopped
  Run As  ${amcu_user}
  ...      Змінити статус скарги на скасування
  ...      ${TENDER['TENDER_UAID']}
  ...      ${USERS.users['${provider}']['complaint_data']['complaintID']}
  ...      ${cancellations_index}
  ...      ${confirmation_data}


Залишити скаргу без розгляду
  ${confirmation_data}=  Підготувати дані для відхилення скарги
  Set To Dictionary  ${confirmation_data.data}  status=invalid
  Run As  ${amcu_user}
  ...      Змінити статус скарги
  ...      ${TENDER['TENDER_UAID']}
  ...      ${USERS.users['${provider}']['complaint_data']['complaintID']}
  ...      ${confirmation_data}


Залишити скаргу на визначення пре-кваліфікації ${qualification_index} учасника без розгляду
  ${confirmation_data}=  Підготувати дані для відхилення скарги
  Set To Dictionary  ${confirmation_data.data}  status=invalid
  Run As  ${amcu_user}
  ...      Змінити статус скарги на визначення пре-кваліфікації учасника
  ...      ${TENDER['TENDER_UAID']}
  ...      ${USERS.users['${provider}']['complaint_data']['complaintID']}
  ...      ${qualification_index}
  ...      ${confirmation_data}


Залишити скаргу на визначення ${award_index} переможця без розгляду
  ${confirmation_data}=  Підготувати дані для відхилення скарги
  Set To Dictionary  ${confirmation_data.data}  status=invalid
  Run As  ${amcu_user}
  ...      Змінити статус скарги на визначення переможця
  ...      ${TENDER['TENDER_UAID']}
  ...      ${USERS.users['${provider}']['complaint_data']['complaintID']}
  ...      ${award_index}
  ...      ${confirmation_data}


Залишити скаргу на скасування ${cancellations_index} без розгляду
  ${confirmation_data}=  Підготувати дані для відхилення скарги
  Set To Dictionary  ${confirmation_data.data}  status=invalid
  Run As  ${amcu_user}
  ...      Змінити статус скарги на скасування
  ...      ${TENDER['TENDER_UAID']}
  ...      ${USERS.users['${provider}']['complaint_data']['complaintID']}
  ...      ${cancellations_index}
  ...      ${confirmation_data}


Помилково створена скарга
  ${data}=  Create Dictionary  status=mistaken
  ${confirmation_data}=  Create Dictionary  data=${data}
  Run As  ${provider}
  ...      Змінити статус скарги
  ...      ${TENDER['TENDER_UAID']}
  ...      ${USERS.users['${provider}']['complaint_data']['complaintID']}
  ...      ${confirmation_data}


Помилково створена скарга на визначення пре-кваліфікації ${qualification_index} учасника
  ${data}=  Create Dictionary  status=mistaken
  ${confirmation_data}=  Create Dictionary  data=${data}
  Run As  ${provider}
  ...      Змінити статус скарги на визначення пре-кваліфікації учасника
  ...      ${TENDER['TENDER_UAID']}
  ...      ${USERS.users['${provider}']['complaint_data']['complaintID']}
  ...      ${qualification_index}
  ...      ${confirmation_data}


Помилково створена скарга на визначення ${award_index} переможця
  ${data}=  Create Dictionary  status=mistaken
  ${confirmation_data}=  Create Dictionary  data=${data}
  Run As  ${provider}
  ...      Змінити статус скарги на визначення переможця
  ...      ${TENDER['TENDER_UAID']}
  ...      ${USERS.users['${provider}']['complaint_data']['complaintID']}
  ...      ${award_index}
  ...      ${confirmation_data}


Помилково створена скарга скасування ${canсellations_index}
  ${data}=  Create Dictionary  status=mistaken
  ${confirmation_data}=  Create Dictionary  data=${data}
  Run As  ${provider}
  ...      Змінити статус скарги на скасування
  ...      ${TENDER['TENDER_UAID']}
  ...      ${USERS.users['${provider}']['complaint_data']['complaintID']}
  ...      ${award_index}
  ...      ${confirmation_data}


Виконати рішення АМКУ
  ${tendererAction}=  create_fake_sentence
  ${data}=  Create Dictionary
  ...      status=resolved
  ...      tendererAction=${tendererAction}
  ${confirmation_data}=  Create Dictionary  data=${data}
  Run As  ${tender_owner}
  ...      Змінити статус скарги
  ...      ${TENDER['TENDER_UAID']}
  ...      ${USERS.users['${provider}']['complaint_data']['complaintID']}
  ...      ${confirmation_data}


Виконати рішення АМКУ по скарзі на визначення пре-кваліфікації ${qualification_index} учасника
  ${tendererAction}=  create_fake_sentence
  ${data}=  Create Dictionary
  ...      status=resolved
  ...      tendererAction=${tendererAction}
  ${confirmation_data}=  Create Dictionary  data=${data}
  Run As  ${tender_owner}
  ...      Змінити статус скарги на визначення пре-кваліфікації учасника
  ...      ${TENDER['TENDER_UAID']}
  ...      ${USERS.users['${provider}']['complaint_data']['complaintID']}
  ...      ${qualification_index}
  ...      ${confirmation_data}


Виконати рішення АМКУ по скарзі на визначення ${award_index} переможця
  ${tendererAction}=  create_fake_sentence
  ${data}=  Create Dictionary
  ...      status=resolved
  ...      tendererAction=${tendererAction}
  ${confirmation_data}=  Create Dictionary  data=${data}
  Run As  ${tender_owner}
  ...      Змінити статус скарги на визначення переможця
  ...      ${TENDER['TENDER_UAID']}
  ...      ${USERS.users['${provider}']['complaint_data']['complaintID']}
  ...      ${award_index}
  ...      ${confirmation_data}


Виконати рішення АМКУ по скарзі на скасування ${canсellations_index}
  ${tendererAction}=  create_fake_sentence
  ${data}=  Create Dictionary
  ...      status=resolved
  ...      tendererAction=${tendererAction}
  ${confirmation_data}=  Create Dictionary  data=${data}
  Run As  ${tender_owner}
  ...      Змінити статус скарги на скасування
  ...      ${TENDER['TENDER_UAID']}
  ...      ${USERS.users['${provider}']['complaint_data']['complaintID']}
  ...      ${canсellations_index}
  ...      ${confirmation_data}

##############################################################################################
#             CLAIMS
##############################################################################################

Можливість створити чернетку вимоги
  ${claim}=  Підготувати дані для подання вимоги
  ${claimID}=  Run As  ${provider}
  ...      Створити чернетку вимоги про виправлення умов закупівлі
  ...      ${TENDER['TENDER_UAID']}
  ...      ${claim}
  ${claim_data}=  Create Dictionary
  ...      claim=${claim}
  ...      complaintID=${claimID}
  ${claim_data}=  munch_dict  arg=${claim_data}
  Set To Dictionary  ${USERS.users['${provider}']}  claim_data  ${claim_data}
  Log  ${USERS.users['${provider}'].claim_data}


Можливість створити чернетку вимоги про виправлення умов ${lot_index} лоту
  ${claim}=  Підготувати дані для подання вимоги
  ${lot_id}=  get_id_from_object  ${USERS.users['${provider}'].tender_data.data.lots[${lot_index}]}
  ${complaintID}=  Run As  ${provider}
  ...      Створити чернетку вимоги про виправлення умов лоту
  ...      ${TENDER['TENDER_UAID']}
  ...      ${claim}
  ...      ${lot_id}
  ${claim_data}=  Create Dictionary
  ...      claim=${claim}
  ...      complaintID=${complaintID}
  ${claim_data}=  munch_dict  arg=${claim_data}
  Set To Dictionary  ${USERS.users['${provider}']}  claim_data  ${claim_data}
  Log  ${USERS.users['${provider}'].claim_data}


Додати документ до вимоги
  ${file_path}  ${file_name}  ${file_content}=  create_fake_doc
  Run As  ${provider}
  ...      Завантажити документацію до вимоги
  ...      ${TENDER['TENDER_UAID']}
  ...      ${USERS.users['${provider}']['claim_data']['complaintID']}
  ...      ${file_path}
  ${doc_id}=  get_id_from_string  ${file_name}
  ${claim_doc}=  Create Dictionary
  ...      doc_name=${file_name}
  ...      doc_id=${doc_id}
  ...      doc_content=${file_content}
  ${claim_doc}=  munch_dict  arg=${claim_doc}
  Set To Dictionary  ${USERS.users['${provider}'].claim_data}  documents  ${claim_doc}
  Remove File  ${file_path}
  Log  ${USERS.users['${provider}'].claim_data}


Можливість подати вимогу
  ${data}=  Create Dictionary  status=claim
  ${confirmation_data}=  Create Dictionary  data=${data}
  Run As  ${provider}
  ...      Подати вимогу
  ...      ${TENDER['TENDER_UAID']}
  ...      ${USERS.users['${provider}']['claim_data']['complaintID']}
  ...      ${confirmation_data}


Подати вимогу про виправлення умов закупівлі лоту
  ${data}=  Create Dictionary  status=claim
  ${confirmation_data}=  Create Dictionary  data=${data}
  Run As  ${provider}
  ...      Подати вимогу
  ...      ${TENDER['TENDER_UAID']}
  ...      ${USERS.users['${provider}']['claim_data']['complaintID']}
  ...      ${confirmation_data}
  Log  ${USERS.users['${provider}'].claim_data}


Можливість створити чернетку вимоги про виправлення визначення ${award_index} переможця
  ${claim}=  Підготувати дані для подання вимоги
  ${complaintID}=  Run As  ${provider}
  ...      Створити чернетку вимоги/скарги про виправлення визначення переможця
  ...      ${TENDER['TENDER_UAID']}
  ...      ${claim}
  ...      ${award_index}
  ${claim_data}=  Create Dictionary
  ...      claim=${claim}
  ...      complaintID=${complaintID}
  ${claim_data}=  munch_dict  arg=${claim_data}
  Set To Dictionary  ${USERS.users['${provider}']}  claim_data  ${claim_data}


Можливість створити чернетку вимоги про виправлення кваліфікації ${qualification_index} учасника
  ${claim}=  Підготувати дані для подання вимоги
  ${complaintID}=  Run As  ${provider}
  ...      Створити чернетку вимоги/скарги про виправлення кваліфікації учасника
  ...      ${TENDER['TENDER_UAID']}
  ...      ${claim}
  ...      ${qualification_index}
  ${claim_data}=  Create Dictionary
  ...      complaint=${complaint}
  ...      complaintID=${complaintID}
  ${claim_data}=  munch_dict  arg=${claim_data}
  Set To Dictionary  ${USERS.users['${provider}']}  claim_data  ${claim_data}


Можливість створити вимогу про виправлення умов закупівлі із документацією
  ${claim}=  Підготувати дані для подання вимоги
  ${file_path}  ${file_name}  ${file_content}=  create_fake_doc
  ${complaintID}=  Run As  ${provider}
  ...      Створити вимогу про виправлення умов закупівлі
  ...      ${TENDER['TENDER_UAID']}
  ...      ${claim}
  ...      ${file_path}
  ${doc_id}=  get_id_from_string  ${file_name}
  ${claim_data}=  Create Dictionary
  ...      claim=${claim}
  ...      complaintID=${complaintID}
  ...      doc_name=${file_name}
  ...      doc_id=${doc_id}
  ...      doc_content=${file_content}
  ${claim_data}=  munch_dict  arg=${claim_data}
  Set To Dictionary  ${USERS.users['${provider}']}  claim_data  ${claim_data}
  Remove File  ${file_path}


Можливість створити вимогу про виправлення умов ${lot_index} лоту із документацією
  ${claim}=  Підготувати дані для подання вимоги
  ${lot_id}=  get_id_from_object  ${USERS.users['${provider}'].tender_data.data.lots[${lot_index}]}
  ${file_path}  ${file_name}  ${file_content}=  create_fake_doc
  ${complaintID}=  Run As  ${provider}
  ...      Створити вимогу про виправлення умов лоту
  ...      ${TENDER['TENDER_UAID']}
  ...      ${claim}
  ...      ${lot_id}
  ...      ${file_path}
  ${doc_id}=  get_id_from_string  ${file_name}
  ${claim_data}=  Create Dictionary
  ...      claim=${claim}
  ...      complaintID=${complaintID}
  ...      doc_name=${file_name}
  ...      doc_id=${doc_id}
  ...      doc_content=${file_content}
  ${claim_data}=  munch_dict  arg=${claim_data}
  Set To Dictionary  ${USERS.users['${provider}']}  claim_data  ${claim_data}
  Remove File  ${file_path}


Можливість створити вимогу про виправлення визначення ${award_index} переможця із документацією
  ${claim}=  Підготувати дані для подання вимоги
  ${file_path}  ${file_name}  ${file_content}=  create_fake_doc
  ${complaintID}=  Run As  ${provider}
  ...      Створити вимогу про виправлення визначення переможця
  ...      ${TENDER['TENDER_UAID']}
  ...      ${claim}
  ...      ${award_index}
  ...      ${file_path}
  ${doc_id}=  get_id_from_string  ${file_name}
  ${claim_data}=  Create Dictionary
  ...      claim=${claim}
  ...      complaintID=${complaintID}
  ...      doc_name=${file_name}
  ...      doc_id=${doc_id}
  ...      doc_content=${file_content}
  ${claim_data}=  munch_dict  arg=${claim_data}
  Set To Dictionary  ${USERS.users['${provider}']}  claim_data  ${claim_data}
  Remove File  ${file_path}


Можливість створити скаргу про виправлення визначення ${award_index} переможця із документацією
  ${claim}=  Підготувати дані для подання вимоги
  ${file_path}  ${file_name}  ${file_content}=  create_fake_doc
  ${complaintID}=  Run As  ${provider}
  ...      Створити скаргу про виправлення визначення переможця
  ...      ${TENDER['TENDER_UAID']}
  ...      ${claim}
  ...      ${award_index}
  ...      ${file_path}
  ${doc_id}=  get_id_from_string  ${file_name}
  ${claim_data}=  Create Dictionary
  ...      claim=${claim}
  ...      complaintID=${complaintID}
  ...      doc_name=${file_name}
  ...      doc_id=${doc_id}
  ...      doc_content=${file_content}
  ${claim_data}=  munch_dict  arg=${claim_data}
  Set To Dictionary  ${USERS.users['${provider}']}  claim_data  ${claim_data}
  Remove File  ${file_path}


Можливість скасувати вимогу про виправлення умов закупівлі
  ${cancellation_reason}=  create_fake_sentence
  ${data}=  Create Dictionary
  ...      status=cancelled
  ...      cancellationReason=${cancellation_reason}
  ${cancellation_data}=  Create Dictionary  data=${data}
  ${cancellation_data}=  munch_dict  arg=${cancellation_data}
  Run As  ${provider}
  ...      Скасувати вимогу про виправлення умов закупівлі
  ...      ${TENDER['TENDER_UAID']}
  ...      ${USERS.users['${provider}']['tender_claim_data']['complaintID']}
  ...      ${cancellation_data}
  Set To Dictionary  ${USERS.users['${provider}'].tender_claim_data}  cancellation  ${cancellation_data}
  Wait until keyword succeeds
  ...      40 min 15 sec
  ...      15 sec
  ...      Звірити статус вимоги/скарги
  ...      ${provider}
  ...      ${TENDER['TENDER_UAID']}
  ...      ${USERS.users['${provider}']['tender_claim_data']['complaintID']}
  ...      cancelled
  Log  ${USERS.users['${provider}'].tender_claim_data}


Можливість скасувати вимогу про виправлення умов лоту
  ${cancellation_reason}=  create_fake_sentence
  ${data}=  Create Dictionary
  ...      status=cancelled
  ...      cancellationReason=${cancellation_reason}
  ${cancellation_data}=  Create Dictionary  data=${data}
  ${cancellation_data}=  munch_dict  arg=${cancellation_data}
  Run As  ${provider}
  ...      Скасувати вимогу про виправлення умов лоту
  ...      ${TENDER['TENDER_UAID']}
  ...      ${USERS.users['${provider}']['lot_claim_data']['complaintID']}
  ...      ${cancellation_data}
  Set To Dictionary  ${USERS.users['${provider}'].lot_claim_data}  cancellation  ${cancellation_data}
  Wait until keyword succeeds
  ...      40 min 15 sec
  ...      15 sec
  ...      Звірити статус вимоги/скарги
  ...      ${provider}
  ...      ${TENDER['TENDER_UAID']}
  ...      ${USERS.users['${provider}']['lot_claim_data']['complaintID']}
  ...      cancelled


Можливість скасувати вимогу/скаргу про виправлення визначення ${award_index} переможця, надавши їй статус ${claim_status}
  ${cancellation_reason}=  create_fake_sentence
  ${status}=  Set variable  ${claim_status}
  ${data}=  Create Dictionary
  ...      status=${status}
  ...      cancellationReason=${cancellation_reason}
  ${cancellation_data}=  Create Dictionary  data=${data}
  ${cancellation_data}=  munch_dict  arg=${cancellation_data}
  Run As  ${provider}
  ...      Скасувати вимогу про виправлення визначення переможця
  ...      ${TENDER['TENDER_UAID']}
  ...      ${USERS.users['${provider}']['claim_data']['complaintID']}
  ...      ${cancellation_data}
  ...      ${award_index}
  Set To Dictionary  ${USERS.users['${provider}'].claim_data}  cancellation  ${cancellation_data}
  Wait until keyword succeeds
  ...      40 min 15 sec
  ...      15 sec
  ...      Звірити статус вимоги/скарги
  ...      ${provider}
  ...      ${TENDER['TENDER_UAID']}
  ...      ${USERS.users['${provider}']['claim_data']['complaintID']}
  ...      ${status}
  ...      ${award_index}


Можливість перетворити вимогу про виправлення умов закупівлі в скаргу
  ${data}=  Create Dictionary
  ...      status=pending
  ...      satisfied=${False}
  ${escalation_data}=  Create Dictionary  data=${data}
  ${escalation_data}=  munch_dict  arg=${escalation_data}
  Run As  ${provider}
  ...      Перетворити вимогу про виправлення умов закупівлі в скаргу
  ...      ${TENDER['TENDER_UAID']}
  ...      ${USERS.users['${provider}']['tender_claim_data']['complaintID']}
  ...      ${escalation_data}
  Set To Dictionary  ${USERS.users['${provider}'].tender_claim_data}  escalation  ${escalation_data}
  Wait until keyword succeeds
  ...      40 min 15 sec
  ...      15 sec
  ...      Звірити статус вимоги/скарги
  ...      ${provider}
  ...      ${TENDER['TENDER_UAID']}
  ...      ${USERS.users['${provider}']['tender_claim_data']['complaintID']}
  ...      pending


Можливість перетворити вимогу про виправлення умов лоту в скаргу
  ${data}=  Create Dictionary
  ...      status=pending
  ...      satisfied=${False}
  ${escalation_data}=  Create Dictionary  data=${data}
  ${escalation_data}=  munch_dict  arg=${escalation_data}
  Run As  ${provider}
  ...      Перетворити вимогу про виправлення умов лоту в скаргу
  ...      ${TENDER['TENDER_UAID']}
  ...      ${USERS.users['${provider}']['lot_claim_data']['complaintID']}
  ...      ${escalation_data}
  Set To Dictionary  ${USERS.users['${provider}'].lot_claim_data}  escalation  ${escalation_data}
  Wait until keyword succeeds
  ...      40 min 15 sec
  ...      15 sec
  ...      Звірити статус вимоги/скарги
  ...      ${provider}
  ...      ${TENDER['TENDER_UAID']}
  ...      ${USERS.users['${provider}']['lot_claim_data']['complaintID']}
  ...      pending


Можливість перетворити вимогу про виправлення визначення ${award_index} переможця в скаргу
  ${data}=  Create Dictionary
  ...      status=pending
  ...      satisfied=${False}
  ${escalation_data}=  Create Dictionary  data=${data}
  ${escalation_data}=  munch_dict  arg=${escalation_data}
  Run As  ${provider}
  ...      Перетворити вимогу про виправлення визначення переможця в скаргу
  ...      ${TENDER['TENDER_UAID']}
  ...      ${USERS.users['${provider}']['claim_data']['complaintID']}
  ...      ${escalation_data}
  ...      ${award_index}
  Set To Dictionary  ${USERS.users['${provider}'].claim_data}  escalation  ${escalation_data}
  Wait until keyword succeeds
  ...      40 min 15 sec
  ...      15 sec
  ...      Звірити статус вимоги/скарги
  ...      ${provider}
  ...      ${TENDER['TENDER_UAID']}
  ...      ${USERS.users['${provider}']['claim_data']['complaintID']}
  ...      pending
  ...      ${award_index}


Звірити відображення поля ${field} для вимоги ${complaintID} із ${data} для користувача ${username}
  Звірити поле скарги із значенням
  ...      ${username}
  ...      ${TENDER['TENDER_UAID']}
  ...      ${data}
  ...      ${field}
  ...      ${complaintID}


Звірити відображення поля ${field} вимоги про виправлення умов ${lot_index} лоту із ${data} для користувача ${username}
  Звірити поле скарги із значенням
  ...      ${username}
  ...      ${TENDER['TENDER_UAID']}
  ...      ${data}
  ...      ${field}
  ...      ${USERS.users['${provider}'].lot_claim_data['complaintID']}
  ...      ${lot_index}


Звірити відображення поля ${field} вимоги про виправлення визначення ${award_index} переможця із ${data} для користувача ${username}
  Звірити поле скарги із значенням
  ...      ${username}
  ...      ${TENDER['TENDER_UAID']}
  ...      ${data}
  ...      ${field}
  ...      ${USERS.users['${provider}'].claim_data['complaintID']}
  ...      ${award_index}


Можливість відповісти ${status} на вимогу про виправлення умов ${tender_or_lot}
  ${answer_data}=  test_claim_answer_data  ${status}
  Log  ${answer_data}
  ${data}=  Set Variable If  '${tender_or_lot}' == 'tender'  ${USERS.users['${provider}']['tender_claim_data']['complaintID']}  ${USERS.users['${provider}']['lot_claim_data']['complaintID']}
  Run As  ${tender_owner}
  ...      Відповісти на вимогу про виправлення умов закупівлі
  ...      ${TENDER['TENDER_UAID']}
  ...      ${data}
  ...      ${answer_data}
  ${claim_data}=  Create Dictionary  claim_answer=${answer_data}
  ${claim_data}=  munch_dict  arg=${claim_data}
  Run Keyword If  '${tender_or_lot}' == 'tender'
  ...       Set To Dictionary  ${USERS.users['${tender_owner}']}  tender_claim_data  ${claim_data}
  ...       ELSE
  ...       Set To Dictionary  ${USERS.users['${tender_owner}']}  lot_claim_data  ${claim_data}
  Wait until keyword succeeds
  ...      40 min 15 sec
  ...      15 sec
  ...      Звірити статус вимоги/скарги
  ...      ${provider}
  ...      ${TENDER['TENDER_UAID']}
  ...      ${data}
  ...      answered


Можливість відповісти ${status} на вимогу про виправлення визначення ${award_index} переможця
  ${answer_data}=  test_claim_answer_data  ${status}
  Log  ${answer_data}
  Run As  ${tender_owner}
  ...      Відповісти на вимогу про виправлення визначення переможця
  ...      ${TENDER['TENDER_UAID']}
  ...      ${USERS.users['${provider}']['claim_data']['complaintID']}
  ...      ${answer_data}
  ...      ${award_index}
  ${claim_data}=  Create Dictionary  claim_answer=${answer_data}
  ${claim_data}=  munch_dict  arg=${claim_data}
  Set To Dictionary  ${USERS.users['${tender_owner}']}  claim_data  ${claim_data}
  Wait until keyword succeeds
  ...      40 min 15 sec
  ...      15 sec
  ...      Звірити статус вимоги/скарги
  ...      ${provider}
  ...      ${TENDER['TENDER_UAID']}
  ...      ${USERS.users['${provider}']['claim_data']['complaintID']}
  ...      answered
  ...      ${award_index}


Можливість підтвердити задоволення вимоги про виправлення умов закупівлі
  ${data}=  Create Dictionary
  ...      satisfied=${True}
  ...      status=resolved
  ${confirmation_data}=  Create Dictionary  data=${data}
  ${confirmation_data}=  munch_dict  arg=${confirmation_data}
  Run As  ${provider}
  ...      Підтвердити вирішення вимоги про виправлення умов закупівлі
  ...      ${TENDER['TENDER_UAID']}
  ...      ${USERS.users['${provider}']['tender_claim_data']['complaintID']}
  ...      ${confirmation_data}
  Set To Dictionary  ${USERS.users['${provider}']['tender_claim_data']}  claim_answer_confirm  ${confirmation_data}


Можливість підтвердити задоволення вимоги про виправлення визначення ${award_index} переможця
  ${data}=  Create Dictionary
  ...       satisfied=${True}
  ${confirmation_data}=  Create Dictionary  data=${data}
  ${confirmation_data}=  munch_dict  arg=${confirmation_data}
  Run As  ${provider}
  ...      Підтвердити вирішення вимоги про виправлення визначення переможця
  ...      ${TENDER['TENDER_UAID']}
  ...      ${USERS.users['${provider}']['claim_data']['complaintID']}
  ...      ${confirmation_data}
  ...      ${award_index}
  Set To Dictionary  ${USERS.users['${provider}']['claim_data']}  claim_answer_confirm  ${confirmation_data}
  Wait until keyword succeeds
  ...      40 min 15 sec
  ...      15 sec
  ...      Звірити статус вимоги/скарги
  ...      ${provider}
  ...      ${TENDER['TENDER_UAID']}
  ...      ${USERS.users['${provider}']['claim_data']['complaintID']}
  ...      resolved
  ...      ${award_index}


Звірити відображення поля ${field} документа ${doc_id} до скарги ${complaintID} з ${left} для користувача ${username}
  ${right}=  Run As  ${username}  Отримати інформацію із документа до скарги  ${TENDER['TENDER_UAID']}  ${complaintID}  ${doc_id}  ${field}
  Порівняти об'єкти  ${left}  ${right}


Звірити відображення вмісту документа ${doc_id} до скарги ${complaintID} з ${left} для користувача ${username}
  ${file_name}=  Run as  ${username}  Отримати документ до скарги  ${TENDER['TENDER_UAID']}  ${complaintID}  ${doc_id}
  ${right}=  Get File  ${OUTPUT_DIR}${/}${file_name}
  Порівняти об'єкти  ${left}  ${right}

##############################################################################################
#             BIDDING
##############################################################################################

Можливість подати цінову пропозицію користувачем ${username}
  ${bid}=  Підготувати дані для подання пропозиції
  ${bidresponses}=  Create Dictionary  bid=${bid}
  Set To Dictionary  ${USERS.users['${username}']}  bidresponses=${bidresponses}
  ${lots}=  Get Variable Value  ${USERS.users['${tender_owner}'].initial_data.data.lots}  ${None}
  ${lots_ids}=  Run Keyword IF  ${lots}
  ...     Отримати ідентифікатори об’єктів  ${username}  lots
  ...     ELSE  Set Variable  ${None}
  ${features}=  Get Variable Value  ${USERS.users['${tender_owner}'].initial_data.data.features}  ${None}
  ${features_ids}=  Run Keyword IF  ${features}
  ...     Отримати ідентифікатори об’єктів  ${username}  features
  ...     ELSE  Set Variable  ${None}
  Run As  ${username}  Подати цінову пропозицію  ${TENDER['TENDER_UAID']}  ${bid}  ${lots_ids}  ${features_ids}


Можливість подати цінову пропозицію на другому етапі рамкової угоди користувачем
  [Arguments]  ${username}  ${index}=${0}
  ${bid}=  Підготувати дані для подання пропозиції другого етапу рамкової угоди  ${index}
  ${bidresponses}=  Create Dictionary  bid=${bid}
  Set To Dictionary  ${USERS.users['${username}']}  bidresponses=${bidresponses}
  ${lots}=  Get Variable Value  ${USERS.users['${tender_owner}'].initial_data.data.lots}  ${None}
  ${lots_ids}=  Run Keyword IF  ${lots}
  ...     Отримати ідентифікатори об’єктів  ${username}  lots
  ...     ELSE  Set Variable  ${None}
  Run As  ${username}  Подати цінову пропозицію  ${TENDER['TENDER_UAID']}  ${bid}  ${lots_ids}


Можливість подати цінову пропозицію на другий етап користувачем ${username}
  ${bid}=  Підготувати дані для подання пропозиції для другого етапу  ${username}
  ${bidresponses}=  Create Dictionary  bid=${bid}
  Set To Dictionary  ${USERS.users['${username}']}  bidresponses=${bidresponses}
  ${lots}=  Get Variable Value  ${USERS.users['${username}'].tender_data.data.lots}  ${None}
  ${lots_ids}=  Run Keyword IF  ${lots}
  ...     Отримати ідентифікатори об’єктів  ${username}  lots
  ...     ELSE  Set Variable  ${None}
  ${features}=  Get Variable Value  ${USERS.users['${username}'].tender_data.data.features}  ${None}
  ${features_ids}=  Run Keyword IF  ${features}
  ...     Отримати ідентифікатори об’єктів  ${username}  features
  ...     ELSE  Set Variable  ${None}
  Run As  ${username}  Подати цінову пропозицію  ${TENDER['TENDER_UAID']}  ${bid}  ${lots_ids}  ${features_ids}


Можливість подати цінову пропозицію priceQuotation користувачем ${username}
  ${bid}=  Підготувати дані для подання пропозиції priceQuotation  ${username}
  ${bidresponses}=  Create Dictionary  bid=${bid}
  Set To Dictionary  ${USERS.users['${username}']}  bidresponses=${bidresponses}
  ${lots}=  Get Variable Value  ${USERS.users['${tender_owner}'].initial_data.data.lots}  ${None}
  ${lots_ids}=  Run Keyword IF  ${lots}
  ...     Отримати ідентифікатори об’єктів  ${username}  lots
  ...     ELSE  Set Variable  ${None}
  Run As  ${username}  Подати цінову пропозицію  ${TENDER['TENDER_UAID']}  ${bid}  ${lots_ids}


Неможливість подати цінову пропозицію без прив’язки до лоту користувачем ${username}
  ${bid}=  Підготувати дані для подання пропозиції
  ${values}=  Get Variable Value  ${bid.data.lotValues[0]}
  Remove From Dictionary  ${bid.data}  lotValues
  Set_To_Object  ${bid}  data  ${values}
  Require Failure  ${username}  Подати цінову пропозицію  ${TENDER['TENDER_UAID']}  ${bid}


Неможливість подати цінову пропозицію без нецінових показників користувачем ${username}
  ${bid}=  Підготувати дані для подання пропозиції
  Remove From Dictionary  ${bid.data}  parameters
  Require Failure  ${username}  Подати цінову пропозицію  ${TENDER['TENDER_UAID']}  ${bid}


Можливість зменшити пропозицію до ${percent} відсотків користувачем ${username}
  ${percent}=  Convert To Number  ${percent}
  ${divider}=  Convert To Number  0.01
  ${field}=  Set variable if  ${NUMBER_OF_LOTS} == 0  value.amount  lotValues[0].value.amount
  ${value}=  Run As  ${username}  Отримати інформацію із пропозиції  ${TENDER['TENDER_UAID']}  ${field}
  ${value}=  mult_and_round  ${value}  ${percent}  ${divider}  precision=${2}
  Run as  ${username}  Змінити цінову пропозицію  ${TENDER['TENDER_UAID']}  ${field}  ${value}


Можливість завантажити документ в пропозицію користувачем ${username}
  ${file_path}  ${file_name}  ${file_content}=  create_fake_doc
  ${doc_id}=  get_id_from_string  ${file_name}
  ${bid_document_data}=  Create Dictionary
  ...      doc_name=${file_name}
  ...      doc_content=${file_content}
  ...      doc_id=${doc_id}
  Run As  ${username}  Завантажити документ в ставку  ${file_path}  ${TENDER['TENDER_UAID']}
  Set To Dictionary  ${USERS.users['${username}']}  bid_document=${bid_document_data}
  Remove File  ${file_path}


Можливість змінити документацію цінової пропозиції користувачем ${username}
  ${file_path}  ${file_name}  ${file_content}=  create_fake_doc
  ${doc_id}=  get_id_from_string  ${file_name}
  ${bid_document_modified_data}=  Create Dictionary
  ...      doc_name=${file_name}
  ...      doc_content=${file_content}
  ...      doc_id=${doc_id}
  Run As  ${username}  Змінити документ в ставці  ${TENDER['TENDER_UAID']}  ${file_path}  ${USERS.users['${username}']['bid_document']['doc_id']}
  Set To Dictionary  ${USERS.users['${username}']}  bid_document_modified=${bid_document_modified_data}
  Remove File  ${file_path}

##############################################################################################
#             Cancellations
##############################################################################################

Можливість скасувати цінову пропозицію користувачем ${username}
  Run As  ${username}  Скасувати цінову пропозицію  ${TENDER['TENDER_UAID']}


Можливість скасувати ${cancellations_index} cancellation
  Run As  ${tender_owner}  Скасувати cancellation  ${TENDER['TENDER_UAID']}  ${cancellations_index}

##############################################################################################
#             Awarding
##############################################################################################

Можливість зареєструвати, додати документацію і підтвердити першого постачальника до закупівлі
  ${lotIndex} =  Set Variable If  ${NUMBER_OF_LOTS} > 0  0  -1
  ${supplier_data}=  Підготувати дані про постачальника  ${tender_owner}  ${lotIndex}
  ${file_path}  ${file_name}  ${file_content}=  create_fake_doc
  Run as  ${tender_owner}
  ...      Створити постачальника, додати документацію і підтвердити його
  ...      ${TENDER['TENDER_UAID']}
  ...      ${supplier_data}
  ...      ${file_path}
  ${doc_id}=  get_id_from_string  ${file_name}
  Set to dictionary  ${USERS.users['${tender_owner}']}  award_doc_name=${file_name}  award_doc_id=${doc_id}  award_doc_content=${file_content}
  Remove File  ${file_path}


Можливість завантажити документ в ${contract_index} угоду користувачем ${username}
  ${file_path}  ${file_name}  ${file_content}=  create_fake_doc
  ${doc_id}=  get_id_from_string  ${file_name}
  ${doc}=  Create Dictionary
  ...      id=${doc_id}
  ...      name=${file_name}
  ...      content=${file_content}
  Set to dictionary  ${USERS.users['${tender_owner}']}  contract_doc=${doc}
  Run As  ${username}  Завантажити документ в угоду  ${file_path}  ${TENDER['TENDER_UAID']}  ${contract_index}
  Remove File  ${file_path}


Можливість завантажити документ для рамкової угоди користувачем ${username}
  ${file_path}  ${file_name}  ${file_content}=  create_fake_doc
  ${doc_id}=  get_id_from_string  ${file_name}
  ${doc}=  Create Dictionary
  ...      id=${doc_id}
  ...      name=${file_name}
  ...      content=${file_content}
  Set to dictionary  ${USERS.users['${username}']}  contract_doc=${doc}
  Run As  ${username}  Завантажити документ в рамкову угоду  ${file_path}  ${USERS.users['${username}'].tender_data.data.agreements[0].agreementID}
  Remove File  ${file_path}


Можливість завантажити документ для зміни у рамковій угоді користувачем ${username}
  ${file_path}  ${file_name}  ${file_content}=  create_fake_doc
  ${doc_id}=  get_id_from_string  ${file_name}
  ${doc}=  Create Dictionary
  ...      id=${doc_id}
  ...      name=${file_name}
  ...      content=${file_content}
  Set to dictionary  ${USERS.users['${username}']}  contract_doc=${doc}
  Run As  ${username}  Завантажити документ для зміни у рамковій угоді
  ...      ${file_path}
  ...      ${USERS.users['${username}'].tender_data.data.agreements[0].agreementID}
  ...      ${USERS.users['${username}'].modification_data.data.modifications[0].itemId}
  Remove File  ${file_path}


Можливість укласти угоду для закупівлі
  Run as  ${tender_owner}
  ...      Підтвердити підписання контракту
  ...      ${TENDER['TENDER_UAID']}
  ...      ${0}
  Run Keyword And Ignore Error  Remove From Dictionary  ${USERS.users['${viewer}'].tender_data.data.contracts[0]}  status

##############################################################################################
#             Pre-Qualifications
##############################################################################################

Дочекатися перевірки прекваліфікацій
  [Documentation]
  ...       [Arguments] Username, tender uaid
  ...       [Description]  Waint until edr bridge check qualifications
  ...       [Return]  Nothing
  [Arguments]  ${username}  ${tender_uaid}
  ${tender}=  openprocurement_client.Пошук тендера по ідентифікатору  ${username}  ${tender_uaid}
  :FOR  ${qualification}  IN  @{tender.data.qualifications}
  \   ${res}=  Wait until keyword succeeds
  \   ...      10 min 15 sec
  \   ...      30 sec
  \   ...      Перевірити документ прекваліфікіції ${qualification.id} для користувача ${username} в тендері ${tender_uaid}


Перевірити документ прекваліфікіції ${qualification_id} для користувача ${username} в тендері ${tender_uaid}
  ${document}=  openprocurement_client.Отримати останній документ прекваліфікації з типом registerExtract  ${username}  ${tender_uaid}  ${qualification_id}
  Порівняти об'єкти  ${document['title']}  edr_identification.yaml

##############################################################################################
#             Qualifications
##############################################################################################

Дочекатися перевірки кваліфікацій
  [Documentation]
  ...       [Arguments] Username, tender uaid
  ...       [Description]  Waint until edr bridge create check award
  ...       [Return]  Nothing
  [Arguments]  ${username}  ${tender_uaid}
  ${tender}=  openprocurement_client.Пошук тендера по ідентифікатору  ${username}  ${tender_uaid}
  :FOR  ${award}  IN  @{tender.data.awards}
  \   Wait until keyword succeeds
  \   ...      10 min 15 sec
  \   ...      30 sec
  \   ...      Перевірити документ кваліфікіції ${award.id} для користувача ${username} в тендері ${tender_uaid}


Перевірити документ кваліфікіції ${award_id} для користувача ${username} в тендері ${tender_uaid}
  ${document}=  openprocurement_client.Отримати останній документ кваліфікації з типом registerExtract  ${username}  ${tender_uaid}  ${award_id}
  Порівняти об'єкти  ${document['title']}  edr_identification.yaml


Дочекатися перевірки кваліфікацій ДФС
  [Documentation]
  ...       [Arguments] Username, tender uaid
  ...       [Description]  Waint until edr bridge create check award
  ...       [Return]  Nothing
  [Arguments]  ${username}  ${tender_uaid}
  ${tender}=  openprocurement_client.Пошук тендера по ідентифікатору  ${username}  ${tender_uaid}
  :FOR  ${award}  IN  @{tender.data.awards}
  \   Wait until keyword succeeds
  \   ...      10 min 15 sec
  \   ...      30 sec
  \   ...      Перевірити наявність першої квитанції від ДФС ${award.id} для користувача ${username} в тендері ${tender_uaid}


Перевірити наявність першої квитанції від ДФС ${award_id} для користувача ${username} в тендері ${tender_uaid}
  ${document}=  openprocurement_client.Отримати останній документ кваліфікації з типом registerFiscal  ${username}  ${tender_uaid}  ${award_id}
  Порівняти об'єкти  ${document['documentType']}  registerFiscal

##############################################################################################
#             PLAN
##############################################################################################

Можливість скасувати план
  ${cancellation_data}=  Підготувати дані про скасування плану
  Run As  ${tender_owner}
  ...      Скасувати план
  ...      ${TENDER['TENDER_UAID']}
  ...      ${cancellation_data}
  Set To Dictionary  ${USERS.users['${tender_owner}']}  plan_cancellation_data=${cancellation_data}


Можливість перевірити статус плану після публікації тендера
  ${file_path}=  Get Variable Value  ${ARTIFACT_FILE}  artifact_plan.yaml
  ${ARTIFACT}=  load_data_from  ${file_path}
  Log  ${ARTIFACT.tender_uaid}
  Звірити статус плану  ${tender_owner}  ${ARTIFACT.tender_uaid}  complete


Можливість змінити на ${percent} відсотки бюджет плану
  ${percent}=  Convert To Number  ${percent}
  ${divider}=  Convert To Number  0.01
  ${value}=  mult_and_round  ${USERS.users['${tender_owner}'].tender_data.data.budget.amount}  ${percent}  ${divider}  precision=${2}
  Можливість змінити поле budget.amount плану на ${value}