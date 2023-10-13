*** Settings ***
Resource    base_keywords.robot
Suite Setup     Test Suite Setup
Suite Teardown  Test Suite Teardown Framework


*** Variables ***
@{USED_ROLES}   tender_owner  viewer  provider  provider1  provider2


*** Test Cases ***

Можливість створити фреймворк
  [Tags]   ${USERS.users['${tender_owner}'].broker}: Оголошення фреймворку
  ...      tender_owner
  ...      ${USERS.users['${tender_owner}'].broker}
  ...      create_framework
  ...      critical
  Можливість створити фреймворк  *
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


Відображення поля title фреймворку
  [Tags]   ${USERS.users['${viewer}'].broker}: Відображення основних даних фреймворку
  ...      viewer
  ...      ${USERS.users['${viewer}'].broker}
  ...      framework_view  level1
  ...      critical
  Звірити відображення поля title фреймворку для користувача ${viewer}


Відображення поля description фреймворку
    [Tags]   ${USERS.users['${viewer}'].broker}: Відображення основних даних фреймворку
  ...      viewer
  ...      ${USERS.users['${viewer}'].broker}
  ...      framework_view  level2
  ...      non-critical
  Звірити відображення поля description фреймворку для користувача ${viewer}


Відображення поля name замовника y фреймворку
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
  ...      framework_view  level2
  ...      non-critical
  Звірити відображення поля frameworkType фреймворку для усіх користувачів


Відображення закінчення термiну дii оголошеня
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


#===== PATCH_frameworks{id} draft =====

Неможливість оновити фреймворк, якщо поле "procuringEntity.contactPoint.email" не відповідає формату, статус "draft"
  [Tags]   ${USERS.users['${tender_owner}'].broker}: Оновленя фреймворку
  ...      tender_owner
  ...      ${USERS.users['${tender_owner}'].broker}
  ...      update_framework
  ...      critical
  ${error_message}  Run Keyword And Expect Error    *
  ...    Неможливість оновити кваліфікаціi  ${tender_owner}  procuringEntity.contactPoint.email  'аал@aa.com'
  Should Contain    ${error_message}  "Not a well formed email address."


Неможливість оновити фреймворк, не заповнивши поле "procuringEntity.contactPoint", статус "draft"
  [Tags]   ${USERS.users['${tender_owner}'].broker}: Оновленя фреймворку
  ...      tender_owner
  ...      ${USERS.users['${tender_owner}'].broker}
  ...      update_framework
  ...      critical
  ${error_message}  Run Keyword And Expect Error    *
  ...    Неможливість оновити кваліфікаціi  ${tender_owner}  procuringEntity.contactPoint  ${Null}
  Should Contain    ${error_message}  "This field is required."


Mожливість оновити фреймворк, не заповнивши поле "procuringEntity.contactPoint.telephone", статус "draft"
  [Tags]   ${USERS.users['${tender_owner}'].broker}: Оновленя фреймворку
  ...      tender_owner
  ...      ${USERS.users['${tender_owner}'].broker}
  ...      update_framework
  ...      critical
  Run Keyword   Неможливість оновити кваліфікаціi  ${tender_owner}  procuringEntity.contactPoint.telephone  ${Null}


Неможливість оновити фреймворк, не заповнивши поле "procuringEntity.contactPoint.name", статус "draft"
  [Tags]   ${USERS.users['${tender_owner}'].broker}: Оновленя фреймворку
  ...      tender_owner
  ...      ${USERS.users['${tender_owner}'].broker}
  ...      update_framework
  ...      critical
  ${error_message}  Run Keyword And Expect Error    *
  ...    Неможливість оновити кваліфікаціi  ${tender_owner}  procuringEntity.contactPoint.name  ${Null}
  Should Contain    ${error_message}  "This field is required."


Неможливість оновити фреймворк, не заповнивши поле "procuringEntity.contactPoint.email", статус "draft"
  [Tags]   ${USERS.users['${tender_owner}'].broker}: Оновленя фреймворку
  ...      tender_owner
  ...      ${USERS.users['${tender_owner}'].broker}
  ...      update_framework
  ...      critical
  ${error_message}  Run Keyword And Expect Error    *
  ...    Неможливість оновити кваліфікаціi  ${tender_owner}  procuringEntity.contactPoint.email  ${Null}
  Should Contain    ${error_message}  "This field is required."


Неможливість оновити фреймворк, не заповнивши поле "procuringEntity.identifier", статус "draft"
  [Tags]   ${USERS.users['${tender_owner}'].broker}: Оновленя фреймворку
  ...      tender_owner
  ...      ${USERS.users['${tender_owner}'].broker}
  ...      update_framework
  ...      critical
  ${error_message}  Run Keyword And Expect Error    *
  ...    Неможливість оновити кваліфікаціi  ${tender_owner}  procuringEntity.identifier  ${Null}
  Should Contain    ${error_message}  "This field is required."


Неможливість оновити фреймворк, не заповнивши поле "procuringEntity.identifier.scheme", статус "draft"
  [Tags]   ${USERS.users['${tender_owner}'].broker}: Оновленя фреймворку
  ...      tender_owner
  ...      ${USERS.users['${tender_owner}'].broker}
  ...      update_framework
  ...      critical
  ${error_message}  Run Keyword And Expect Error    *
  ...    Неможливість оновити кваліфікаціi  ${tender_owner}  procuringEntity.identifier.scheme  ${Null}
  Should Contain    ${error_message}  "This field is required."


Неможливість оновити фреймворк, не заповнивши поле "procuringEntity.identifier.id", статус "draft"
  [Tags]   ${USERS.users['${tender_owner}'].broker}: Оновленя фреймворку
  ...      tender_owner
  ...      ${USERS.users['${tender_owner}'].broker}
  ...      update_framework
  ...      critical
  ${error_message}  Run Keyword And Expect Error    *
  ...    Неможливість оновити кваліфікаціi  ${tender_owner}  procuringEntity.identifier.id  ${Null}
  Should Contain    ${error_message}  "This field is required."


Неможливість оновити фреймворк, не заповнивши поле "procuringEntity.identifier.legalName", статус "draft"
  [Tags]   ${USERS.users['${tender_owner}'].broker}: Оновленя фреймворку
  ...      tender_owner
  ...      ${USERS.users['${tender_owner}'].broker}
  ...      update_framework
  ...      critical
  ${error_message}  Run Keyword And Expect Error    *
  ...    Неможливість оновити кваліфікаціi  ${tender_owner}  procuringEntity.identifier.legalName  ${Null}
  Should Contain    ${error_message}  "This field is required."


Неможливість оновити фреймворк, якщо поле "procuringEntity.identifier.scheme" не відповідає формату, статус "draft"
  [Tags]   ${USERS.users['${tender_owner}'].broker}: Оновленя фреймворку
  ...      tender_owner
  ...      ${USERS.users['${tender_owner}'].broker}
  ...      update_framework
  ...      critical
  ${error_message}  Run Keyword And Expect Error    *
  ...    Неможливість оновити кваліфікаціi  ${tender_owner}  procuringEntity.identifier.scheme  'UA-EDR1'
  Should Contain    ${error_message}  "Value must be one of ['AE-ACCI', 'AE-ADCD', 'AE-AFZ', 'AE-DCCI', 'AE-DFSA', 'AE-DIFC', 'AE-FFZ', 'AE-FUJCCI', 'AE-HFZA', 'AE-RAKIA', 'AE-SAIF', 'AE-SCCI', 'AE-UAQCCI', 'AF-CBR', 'AF-MOE', 'AM-SRLE', 'AR-CENOC', 'AR-CUIT', 'AT-FN', 'AU-ABN', 'AU-ACNC', 'AZ-IVI', 'BD-NAB', 'BE-BCE_KBO', 'BE-GTCF', 'BG-EIK', 'BR-CNPJ', 'BY-UNP', 'CA-CRA_ACR', 'CH-ZEFIX', 'CL-RUT', 'CN-SAIC', 'CO-CCB', 'CY-DRCOR', 'CZ-ICO', 'DE-CRP', 'DK-CVR', 'EE-RIK', 'EG-MOSS', 'ES-DIR3', 'ES-RMS', 'ET-MFA', 'FI-PRO', 'FR-INSEE', 'FR-RCS', 'GB-CHC', 'GB-COH', 'GB-EDU', 'GB-GOV', 'GB-GOVUK', 'GB-NIC', 'GB-REV', 'GB-SC', 'GB-UKPRN', 'GE-NAPR', 'GG-RCE', 'GH-DSW', 'GR-GECR', 'HR-MBS', 'HR-OIB', 'HU-VAT', 'ID-KDN', 'ID-KHH', 'ID-KLN', 'ID-PRO', 'IE-CHY', 'IE-CRO', 'IL-ROC', 'IM-CR', 'IM-GR', 'IN-MCA', 'IT-RI', 'JE-CR', 'JE-OAC', 'JO-CCD', 'JO-MSD', 'JP-JCN', 'KE-NCB', 'KE-RCO', 'KE-RSO', 'KG-ID', 'KR-BIZID', 'KZ-BIN', 'LS-LCN', 'LT-PVM', 'LT-RC', 'LV-RE', 'MD-IDNO', 'MM-MHA', 'MT-MFSA', 'MW-CNM', 'MW-MRA', 'MW-NBM', 'MW-RG', 'MY-SSM', 'MZ-MOJ', 'NG-CAC', 'NL-KVK', 'NO-BRC', 'NP-CRO', 'NP-SWC', 'PA-RPP', 'PK-PCP', 'PK-VSWA', 'PL-KRS', 'PL-NIP', 'PL-REGON', 'PT-NIPPC', 'RO-CUI', 'RS-APR', 'RU-INN', 'RU-OGRN', 'SA-CRS', 'SE-BLV', 'SG-ACRA', 'SI-PRS', 'SI-TIN', 'SK-ZRSR', 'TR-MERSIS', 'TR-MOI', 'TR-VAT', 'TZ-BRLA', 'UA-EDR', 'UA-FIN', 'UA-IPN', 'UG-NGB', 'UG-RSB', 'US-DOS', 'US-EIN', 'US-USAGOV', 'UZ-KTUT', 'XI-IATI', 'XI-PB', 'XM-DAC', 'XM-EORI', 'XM-OCHA', 'ZA-CIP', 'ZA-NPO', 'ZA-PBO', 'ZM-NRB', 'ZM-PCR', 'ZW-PVO', 'ZW-ROD', 'MK-CR', 'MX-RFC', 'LUX', 'UY-DGR']."


Неможливість оновити фреймворк, якщо поле "procuringEntity.kind" не відповідає формату, статус "draft"
  [Tags]   ${USERS.users['${tender_owner}'].broker}: Оновленя фреймворку
  ...      tender_owner
  ...      ${USERS.users['${tender_owner}'].broker}
  ...      update_framework
  ...      critical
  ${error_message}  Run Keyword And Expect Error    *
  ...    Неможливість оновити кваліфікаціi  ${tender_owner}  procuringEntity.kind  'defense1'
  Should Contain    ${error_message}  "Value must be one of ('authority', 'central', 'defense', 'general', 'other', 'social', 'special')."


Неможливість оновити фреймворк, не заповнивши поле "procuringEntity.address", статус "draft"
  [Tags]   ${USERS.users['${tender_owner}'].broker}: Оновленя фреймворку
  ...      tender_owner
  ...      ${USERS.users['${tender_owner}'].broker}
  ...      update_framework
  ...      critical
  ${error_message}  Run Keyword And Expect Error    *
  ...    Неможливість оновити кваліфікаціi  ${tender_owner}  procuringEntity.address  ${Null}
  Should Contain    ${error_message}  "This field is required."


Неможливість оновити фреймворк, не заповнивши поле "procuringEntity.address.countryName", статус "draft"
  [Tags]   ${USERS.users['${tender_owner}'].broker}: Оновленя фреймворку
  ...      tender_owner
  ...      ${USERS.users['${tender_owner}'].broker}
  ...      update_framework
  ...      critical
  ${error_message}  Run Keyword And Expect Error    *
  ...    Неможливість оновити кваліфікаціi  ${tender_owner}  procuringEntity.address.countryName  ${Null}
  Should Contain    ${error_message}  "This field is required."


Неможливість оновити фреймворк, не заповнивши поле "procuringEntity.address.postalCode", статус "draft"
  [Tags]   ${USERS.users['${tender_owner}'].broker}: Оновленя фреймворку
  ...      tender_owner
  ...      ${USERS.users['${tender_owner}'].broker}
  ...      update_framework
  ...      critical
  ${error_message}  Run Keyword And Expect Error    *
  ...    Неможливість оновити кваліфікаціi  ${tender_owner}  procuringEntity.address.postalCode  ${Null}
  Should Contain    ${error_message}  "This field is required."


Неможливість оновити фреймворк, не заповнивши поле "procuringEntity.address.region", статус "draft"
  [Tags]   ${USERS.users['${tender_owner}'].broker}: Оновленя фреймворку
  ...      tender_owner
  ...      ${USERS.users['${tender_owner}'].broker}
  ...      update_framework
  ...      critical
  ${error_message}  Run Keyword And Expect Error    *
  ...    Неможливість оновити кваліфікаціi  ${tender_owner}  procuringEntity.address.region  ${Null}
  Should Contain    ${error_message}  "This field is required."


Неможливість оновити фреймворк, не заповнивши поле "procuringEntity.address.streetAddress", статус "draft"
  [Tags]   ${USERS.users['${tender_owner}'].broker}: Оновленя фреймворку
  ...      tender_owner
  ...      ${USERS.users['${tender_owner}'].broker}
  ...      update_framework
  ...      critical
  ${error_message}  Run Keyword And Expect Error    *
  ...    Неможливість оновити кваліфікаціi  ${tender_owner}  procuringEntity.address.streetAddress  ${Null}
  Should Contain    ${error_message}  "This field is required."


Неможливість оновити фреймворк, не заповнивши поле "procuringEntity.address.locality", статус "draft"
  [Tags]   ${USERS.users['${tender_owner}'].broker}: Оновленя фреймворку
  ...      tender_owner
  ...      ${USERS.users['${tender_owner}'].broker}
  ...      update_framework
  ...      critical
  ${error_message}  Run Keyword And Expect Error    *
  ...    Неможливість оновити кваліфікаціi  ${tender_owner}  procuringEntity.address.locality  ${Null}
  Should Contain    ${error_message}  "This field is required."


Неможливість оновити фреймворк, якщо поле "procuringEntity.address.countryName" не відповідає формату, статус "draft"
  [Tags]   ${USERS.users['${tender_owner}'].broker}: Оновленя фреймворку
  ...      tender_owner
  ...      ${USERS.users['${tender_owner}'].broker}
  ...      update_framework
  ...      critical
  ${error_message}  Run Keyword And Expect Error    *
  ...    Неможливість оновити кваліфікаціi  ${tender_owner}  procuringEntity.address.countryName  'Украина1'
  Should Contain    ${error_message}  "field address:countryName not exist in countries catalog"


Неможливість оновити фреймворк, якщо поле "procuringEntity.address.region" не відповідає формату, статус "draft"
  [Tags]   ${USERS.users['${tender_owner}'].broker}: Оновленя фреймворку
  ...      tender_owner
  ...      ${USERS.users['${tender_owner}'].broker}
  ...      update_framework
  ...      critical
  ${error_message}  Run Keyword And Expect Error    *
  ...    Неможливість оновити кваліфікаціi  ${tender_owner}  procuringEntity.address.region  'м. Киiв1'
  Should Contain    ${error_message}  "field address:region not exist in ua_regions catalog"


Неможливість оновити фреймворк, якщо поле "classification.id" не відповідає формату, статус "draft"
  [Tags]   ${USERS.users['${tender_owner}'].broker}: Оновленя фреймворку
  ...      tender_owner
  ...      ${USERS.users['${tender_owner}'].broker}
  ...      update_framework
  ...      critical
  Run Keyword And Expect Error    *
  ...    Неможливість оновити кваліфікаціi  ${tender_owner}  classification.id  '42000000-66'


Неможливість оновити фреймворк, не заповнивши поле "classification.id", статус "draft"
  [Tags]   ${USERS.users['${tender_owner}'].broker}: Оновленя фреймворку
  ...      tender_owner
  ...      ${USERS.users['${tender_owner}'].broker}
  ...      update_framework
  ...      critical
  ${error_message}  Run Keyword And Expect Error    *
  ...    Неможливість оновити кваліфікаціi  ${tender_owner}  classification.id  ${Null}
  Should Contain    ${error_message}  "This field is required."


Неможливість оновити фреймворк, якщо поле "classification.scheme" не відповідає формату, статус "draft"
  [Tags]   ${USERS.users['${tender_owner}'].broker}: Оновленя фреймворку
  ...      tender_owner
  ...      ${USERS.users['${tender_owner}'].broker}
  ...      update_framework
  ...      critical
  Run Keyword And Expect Error    *
  ...    Неможливість оновити кваліфікаціi  ${tender_owner}  classification.scheme  'ДК0211'


Неможливість оновити фреймворк, не заповнивши поле "classification.scheme", статус "draft"
  [Tags]   ${USERS.users['${tender_owner}'].broker}: Оновленя фреймворку
  ...      tender_owner
  ...      ${USERS.users['${tender_owner}'].broker}
  ...      update_framework
  ...      critical
  ${error_message}  Run Keyword And Expect Error    *
  ...    Неможливість оновити кваліфікаціi  ${tender_owner}  classification.scheme  ${Null}
  Should Contain    ${error_message}  "This field is required."


Неможливість оновити фреймворк, не заповнивши поле "classification.description", статус "draft"
  [Tags]   ${USERS.users['${tender_owner}'].broker}: Оновленя фреймворку
  ...      tender_owner
  ...      ${USERS.users['${tender_owner}'].broker}
  ...      update_framework
  ...      critical
  ${error_message}  Run Keyword And Expect Error    *
  ...    Неможливість оновити кваліфікаціi  ${tender_owner}  classification.description  ${Null}
  Should Contain    ${error_message}  "This field is required."


Неможливість оновити фреймворк, не заповнивши поле "qualificationPeriod.endDate", статус "draft"
  [Tags]   ${USERS.users['${tender_owner}'].broker}: Оновленя фреймворку
  ...      tender_owner
  ...      ${USERS.users['${tender_owner}'].broker}
  ...      update_framework
  ...      critical
  ${error_message}  Run Keyword And Expect Error    *
  ...    Неможливість оновити кваліфікаціi  ${tender_owner}  qualificationPeriod.endDate  ${Null}
  Should Contain    ${error_message}  "This field is required."


Неможливість оновити фреймворк, не заповнивши поле "procuringEntity.name", статус "draft"
  [Tags]   ${USERS.users['${tender_owner}'].broker}: Оновленя фреймворку
  ...      tender_owner
  ...      ${USERS.users['${tender_owner}'].broker}
  ...      update_framework
  ...      critical
  ${error_message}  Run Keyword And Expect Error    *
  ...    Неможливість оновити кваліфікаціi  ${tender_owner}  procuringEntity.name  ${Null}
  Should Contain    ${error_message}  "This field is required."


Mожливість оновити фреймворк, не заповнивши поле "procuringEntity.kind", статус "draft"
  [Tags]   ${USERS.users['${tender_owner}'].broker}: Оновленя фреймворку
  ...      tender_owner
  ...      ${USERS.users['${tender_owner}'].broker}
  ...      update_framework
  ...      critical
  Run Keyword   Неможливість оновити кваліфікаціi  ${tender_owner}  procuringEntity.kind  ${Null}
  Звірити поле кваліфікаціi із значенням  ${viewer}  ${QUALIFICATION['QUALIFICATION_UAID']}   general  procuringEntity.kind


#===== POST_frameworks{id}/documents draft=====

Mожливість завантажити документ у фреймворк, у статусi "draft"
  [Tags]   ${USERS.users['${tender_owner}'].broker}: Завантажити документ у кваліфікацію
  ...      tender_owner
  ...      ${USERS.users['${tender_owner}'].broker}
  ...      document_negative_tests
  ...      critical
  [Teardown]  Оновити QUALIFICATION_LAST_MODIFICATION_DATE
   ${file_path}  ${file_name}  ${file_content}=  create_fake_doc
   Run As  ${tender_owner}  Завантажити документ у фреймворк  ${file_path}
   ${framework_doc}=  Create Dictionary
   ...    doc_name=${file_name}
   ...    doc_content=${file_content}
   Set To Dictionary   ${USERS.users['${tender_owner}']}  framework_document=${framework_doc}
   Remove File  ${file_path}


Неможливість додати документ, якщо запит не відповідає формату "documentOf", статус "draft"
  [Tags]   ${USERS.users['${tender_owner}'].broker}: Оновити документ
  ...      tender_owner
  ...      ${USERS.users['${tender_owner}'].broker}
  ...      document_negative_tests
  ...      critical
  [Teardown]  Оновити QUALIFICATION_LAST_MODIFICATION_DATE
  ${document}=  Set Variable    ${USERS.users['${tender_owner}'].documents}
  ${lot}=  Set Variable    lot
  Set To Dictionary    ${document.data}  documentOf=${lot}
  ${error}  Run Keyword And Expect Error  *
  ...    Додати зареєстрований документ у фреймворк  ${tender_owner}  ${document}
  Should Contain    ${error}   "name": "documentOf", "description": "Rogue field"
  Remove From Dictionary    ${USERS.users['${tender_owner}'].documents.data}    documentOf


Неможливість додати документ, якщо запит не відповідає формату "documentType", статус "draft"
  [Tags]   ${USERS.users['${tender_owner}'].broker}: Оновити документ
  ...      tender_owner
  ...      ${USERS.users['${tender_owner}'].broker}
  ...      document_negative_tests
  ...      critical
  [Teardown]  Оновити QUALIFICATION_LAST_MODIFICATION_DATE
  ${document}=  Set Variable    ${USERS.users['${tender_owner}'].documents}
  Set To Dictionary    ${document.data}  documentType=lot
  ${error}  Run Keyword And Expect Error  *
  ...    Додати зареєстрований документ у фреймворк  ${tender_owner}  ${document}
  Should Contain    ${error}   "Value must be one of ['tenderNotice', 'awardNotice',
  Remove From Dictionary    ${USERS.users['${tender_owner}'].documents.data}  documentType


Заборонено передавати "confidentiality", статус "draft"
  [Tags]   ${USERS.users['${tender_owner}'].broker}: Оновити документ
  ...      tender_owner
  ...      ${USERS.users['${tender_owner}'].broker}
  ...      document_negative_tests
  ...      critical
  [Teardown]  Оновити QUALIFICATION_LAST_MODIFICATION_DATE
  ${document}=  Set Variable    ${USERS.users['${tender_owner}'].documents}
  Set To Dictionary    ${document.data}  confidentiality=buyerOnly
  ${error}  Run Keyword And Expect Error  *
  ...    Додати зареєстрований документ у фреймворк  ${tender_owner}  ${document}
  Should Contain    ${error}    "name": "confidentiality", "description": "Rogue field"
  Remove From Dictionary    ${USERS.users['${tender_owner}'].documents.data}  confidentiality


Неможливість додати документ, не заповнивши поле "title", статус "draft"
  [Tags]   ${USERS.users['${tender_owner}'].broker}: Оновленя фреймворку
  ...      tender_owner
  ...      ${USERS.users['${tender_owner}'].broker}
  ...      document_negative_tests
  ...      critical
  ${document}=  Set Variable    ${USERS.users['${tender_owner}'].documents}
  Set To Dictionary    ${document.data}  title=${Null}
  Log  ${document}
  ${error}  Run Keyword And Expect Error  *
  ...    Додати зареєстрований документ у фреймворк  ${tender_owner}  ${document}
  Should Contain    ${error}    "name": "title", "description": ["This field is required."


Mожливість отримати документ з фреймворку, використовуючи "document_id"
  [Tags]   ${USERS.users['${tender_owner}'].broker}: Отримати документ з фреймворку
  ...      tender_owner
  ...      ${USERS.users['${tender_owner}'].broker}
  ...      document_view
  ...      critical
  ${document_id}=  Set Variable    ${USERS.users['${tender_owner}']['documents']['data']['id']}
  ${reply}=  Oтримати документ з фреймворку  ${tender_owner}  ${document_id}
  Log      ${reply}
  Should Be Equal    ${document_id}  ${reply.data.id}


Mожливість отримати усi наявнi документи з фреймворку
  [Tags]   ${USERS.users['${tender_owner}'].broker}: Отримати документ з фреймворку
  ...      tender_owner
  ...      ${USERS.users['${tender_owner}'].broker}
  ...      document_view
  ...      critical
  ${reply}=  Oтримати документи з фреймворку  ${tender_owner}
  Log      ${reply}


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
  ...      document_view
  Звірити відображення вмісту документа ${USERS.users['${tender_owner}']['documents']['data']} до фреймворку з ${USERS.users['${tender_owner}']['framework_document']['doc_content']} для користувача ${viewer}


Можливість завантажити другий документ у фреймворк
  [Tags]   ${USERS.users['${tender_owner}'].broker}: Завантажити документ у кваліфікацію
  ...      tender_owner
  ...      ${USERS.users['${tender_owner}'].broker}
  ...      add_doc_to_framework
  ...      critical
  [Teardown]  Оновити QUALIFICATION_LAST_MODIFICATION_DATE
   ${file_path}  ${file_name}  ${file_content}=  create_fake_doc
   Set Global Variable    ${file_path}
   Run As  ${tender_owner}  Завантажити документ у фреймворк  ${file_path}
   ${framework_doc}=  Create Dictionary
   ...    doc_name=${file_name}
   ...    doc_content=${file_content}
   Set To Dictionary   ${USERS.users['${tender_owner}']}  framework_document=${framework_doc}


Відображення другого документу у фреймворку
  [Tags]   ${USERS.users['${viewer}'].broker}: Відображення документації
  ...      viewer
  ...      ${USERS.users['${viewer}'].broker}
  ...       document_view
  Звірити відображення вмісту документа ${USERS.users['${tender_owner}']['documents']['data']} до фреймворку з ${USERS.users['${tender_owner}']['framework_document']['doc_content']} для користувача ${viewer}


# ===== PUT_frameworks{id}/documents{id} draft =====

Можливість завантажити документ поверх старої версії
  [Tags]   ${USERS.users['${tender_owner}'].broker}: Оновити документ у кваліфікацію
  ...      tender_owner
  ...      ${USERS.users['${tender_owner}'].broker}
  ...      add_doc_to_framework
  ...      critical
  [Teardown]  Оновити QUALIFICATION_LAST_MODIFICATION_DATE
  Run As  ${tender_owner}  Оновити документ у фреймворку  ${file_path}
  Remove File  ${file_path}


Можливість перевірити, що є два завантажених документа
  [Tags]   ${USERS.users['${viewer}'].broker}: Відображення документації
  ...      viewer
  ...      ${USERS.users['${viewer}'].broker}
  ...      document_view
  Звірити відображення вмісту документа ${USERS.users['${tender_owner}']['documents']['data']} до фреймворку з ${USERS.users['${tender_owner}']['framework_document']['doc_content']} для користувача ${viewer}
  ${doc_reply}=  Call Method  ${USERS.users['${viewer}'].framework_client}  get_document
  ...      ${QUALIFICATION.QUALIFICATION_ID}
  ...      ${USERS.users['${tender_owner}']['documents']['data']['id']}
  ...      access_token=${USERS.users['${tender_owner}'].access_token}
  Dictionary Should Contain Key    ${doc_reply.data}  previousVersions


Неможливість оновити завантажений документ, якщо запит не відповідає формату "documentOf", статус "draft"
  [Tags]   ${USERS.users['${tender_owner}'].broker}: Завантажити документ у кваліфікацію
  ...      tender_owner
  ...      ${USERS.users['${tender_owner}'].broker}
  ...      document_negative_tests
  ...      critical
  [Teardown]  Оновити QUALIFICATION_LAST_MODIFICATION_DATE
  ${document}=  Set Variable    ${USERS.users['${tender_owner}'].documents}
  ${lot}=  Set Variable    lot
  Set To Dictionary    ${document.data}  documentOf=${lot}
  ${error}  Run Keyword And Expect Error  *
  ...    Оновити зареєстрований документ у фреймворку  ${tender_owner}  ${document}
  Should Contain    ${error}   "name": "documentOf", "description": "Rogue field"
  Remove From Dictionary    ${USERS.users['${tender_owner}'].documents.data}    documentOf


Неможливість оновити завантажений документ, якщо запит не відповідає формату "documentType", статус "draft"
  [Tags]   ${USERS.users['${tender_owner}'].broker}: Оновити документ
  ...      tender_owner
  ...      ${USERS.users['${tender_owner}'].broker}
  ...      document_negative_tests
  ...      critical
  [Teardown]  Оновити QUALIFICATION_LAST_MODIFICATION_DATE
  ${document}=  Set Variable    ${USERS.users['${tender_owner}'].documents}
  Set To Dictionary    ${document.data}  documentType=lot
  ${error}  Run Keyword And Expect Error  *
  ...    Оновити зареєстрований документ у фреймворку  ${tender_owner}  ${document}
  Should Contain    ${error}   "Value must be one of ['tenderNotice', 'awardNotice',
  Remove From Dictionary    ${USERS.users['${tender_owner}'].documents.data}  documentType


Заборонено передавати "confidentiality" під час оновлення, статус "draft"
  [Tags]   ${USERS.users['${tender_owner}'].broker}: Оновити документ
  ...      tender_owner
  ...      ${USERS.users['${tender_owner}'].broker}
  ...      document_negative_tests
  ...      critical
  [Teardown]  Оновити QUALIFICATION_LAST_MODIFICATION_DATE
  ${document}=  Set Variable    ${USERS.users['${tender_owner}'].documents}
  Set To Dictionary    ${document.data}  confidentiality=buyerOnly
  ${error}  Run Keyword And Expect Error  *
  ...    Оновити зареєстрований документ у фреймворку  ${tender_owner}  ${document}
  Should Contain    ${error}    "name": "confidentiality", "description": "Rogue field"
  Remove From Dictionary    ${USERS.users['${tender_owner}'].documents.data}  confidentiality


Неможливість оновити документ, не заповнивши поле "title", статус "draft"
  [Tags]   ${USERS.users['${tender_owner}'].broker}: Оновленя документу
  ...      tender_owner
  ...      ${USERS.users['${tender_owner}'].broker}
  ...      document_negative_tests
  ...      critical
  ${document}=  Set Variable    ${USERS.users['${tender_owner}'].documents}
  Set To Dictionary    ${document.data}  title=${Null}
  Log  ${document}
  ${error}  Run Keyword And Expect Error  *
  ...    Оновити зареєстрований документ у фреймворку  ${tender_owner}  ${document}
  Should Contain    ${error}    "name": "title", "description": ["This field is required."


#===== PATCH_frameworks{id}/documents{id} draft =====

Mожливість змiнити значеня поля "title" у документi, статус "draft"
  [Tags]   ${USERS.users['${tender_owner}'].broker}: Оновленя документу
  ...      tender_owner
  ...      ${USERS.users['${tender_owner}'].broker}
  ...      document_negative_tests
  ...      critical
  ${field}=  Set Variable    title
  ${value}=  Set Variable    new title patch
  ${document}=  change_field_value_in_document  ${field}  ${value}
  ${reply}=  Run Keyword  Оновити значеня поля у документi  ${tender_owner}  ${document}
  Should Be Equal    ${value}  ${reply.data.title}


Неможливість змiнити значеня поля "title", передавши Null, статус "active"
  [Tags]   ${USERS.users['${tender_owner}'].broker}: Оновленя документу
  ...      tender_owner
  ...      ${USERS.users['${tender_owner}'].broker}
  ...      document_negative_tests
  ...      critical
  ${field}=  Set Variable    title
  ${document}=  change_field_value_in_document  ${field}  ${Null}
  Log   ${document}
  ${error}  Run Keyword And Expect Error  *
  ...    Оновити значеня поля у документi  ${tender_owner}  ${document}
  Should Contain    ${error}     "name": "title", "description": ["This field is required."]


Неможливість змiнити значеня поля "documentType", якщо значеня не вiдповiдае формату, статус "draft"
  [Tags]   ${USERS.users['${tender_owner}'].broker}: Оновити документ
  ...      tender_owner
  ...      ${USERS.users['${tender_owner}'].broker}
  ...      document_negative_tests
  ...      critical
  [Teardown]  Оновити QUALIFICATION_LAST_MODIFICATION_DATE
  ${field}=  Set Variable    documentType
  ${value}=  Set Variable    patch
  ${document}=  change_field_value_in_document  ${field}  ${value}
  ${error}  Run Keyword And Expect Error  *
  ...    Оновити значеня поля у документi  ${tender_owner}  ${document}
  Should Contain    ${error}    "name": "documentType", "description": ["Value must be one of ['tenderNotice',


Неможливість змiнити значеня поля "documentOf" у документi, статус "draft"
  [Tags]   ${USERS.users['${tender_owner}'].broker}: Оновити документ
  ...      tender_owner
  ...      ${USERS.users['${tender_owner}'].broker}
  ...      document_negative_tests
  ...      critical
  [Teardown]  Оновити QUALIFICATION_LAST_MODIFICATION_DATE
  ${field}=  Set Variable    documentOf
  ${value}=  Set Variable    lot
  ${document}=  change_field_value_in_document  ${field}  ${value}
  ${error}  Run Keyword And Expect Error  *
  ...    Оновити значеня поля у документi  ${tender_owner}  ${document}
  Should Contain    ${error}    "name": "documentOf", "description": "Rogue field"


Неможливість змiнити значеня поля "confidentiality" у документi, статус "draft"
  [Tags]   ${USERS.users['${tender_owner}'].broker}: Оновити документ
  ...      tender_owner
  ...      ${USERS.users['${tender_owner}'].broker}
  ...      document_negative_tests
  ...      critical
  [Teardown]  Оновити QUALIFICATION_LAST_MODIFICATION_DATE
  ${field}=  Set Variable    confidentiality
  ${value}=  Set Variable    buyerOnly
  ${document}=  change_field_value_in_document  ${field}  ${value}
  ${error}  Run Keyword And Expect Error  *
  ...    Оновити значеня поля у документi  ${tender_owner}  ${document}
  Should Contain    ${error}     "name": "confidentiality", "description": "Rogue field"


Неможливість змінити статус фреймворку, якщо значеня поля "data.status" не відповідає дозволеним
  [Tags]   ${USERS.users['${tender_owner}'].broker}: Зміна статусу
  ...      tender_owner
  ...      ${USERS.users['${tender_owner}'].broker}
  ...      change_status  level1
  ...      critical
  [Teardown]  Оновити QUALIFICATION_LAST_MODIFICATION_DATE
  ${error_message}  Run Keyword And Expect Error  *
  ...      Змiнити статус фреймворка на  ${tender_owner}  activee
  Should Contain    ${error_message}  "name": "status", "description": ["Value must be one of ['draft', 'active', 'complete', 'unsuccessful']


Неможливість змінити статус фреймворку з "draft" на "unsuccessful"
  [Tags]   ${USERS.users['${tender_owner}'].broker}: Зміна статусу
  ...      tender_owner
  ...      ${USERS.users['${tender_owner}'].broker}
  ...      change_status  level1
  ...      critical
  [Teardown]  Оновити QUALIFICATION_LAST_MODIFICATION_DATE
  ${error_message}=  Run Keyword And Expect Error  *
  ...      Змiнити статус фреймворка на  ${tender_owner}  unsuccessful
  Should Contain    ${error_message}  "Can't switch to unsuccessful status"


Неможливість змінити статус фреймворку з "draft" на "deleted"
  [Tags]   ${USERS.users['${tender_owner}'].broker}: Зміна статусу
  ...      tender_owner
  ...      ${USERS.users['${tender_owner}'].broker}
  ...      change_status  level1
  ...      critical
  [Teardown]  Оновити QUALIFICATION_LAST_MODIFICATION_DATE
  ${error_message}=  Run Keyword And Expect Error  *
  ...      Змiнити статус фреймворка на  ${tender_owner}  deleted
  Should Contain    ${error_message}  "name": "status", "description": ["Value must be one of ['draft', 'active', 'complete', 'unsuccessful']


Неможливість змінити статус фреймворку з "draft" на "complete"
  [Tags]   ${USERS.users['${tender_owner}'].broker}: Зміна статусу
  ...      tender_owner
  ...      ${USERS.users['${tender_owner}'].broker}
  ...      change_status  level1
  ...      critical
  [Teardown]  Оновити QUALIFICATION_LAST_MODIFICATION_DATE
  ${error_message}=  Run Keyword And Expect Error  *
  ...      Змiнити статус фреймворка на  ${tender_owner}  complete
  Should Contain    ${error_message}  "Can't switch to complete status"


Неможливість подати заявку yчасником, якщо фреймворк у статусі draft
  [Tags]   ${USERS.users['${provider}'].broker}: Подання пропозиції
  ...      provider
  ...      ${USERS.users['${provider}'].broker}
  ...      add_submission
  ...      critical
  [Teardown]  Оновити QUALIFICATION_LAST_MODIFICATION_DATE
  ${error_message}  Run Keyword And Expect Error    *
  ...      Можливість зареєструвати заявку  ${provider}
  Should Contain    ${error_message}  "description": "Submission cannot be add without framework enquiryPeriod or period"


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


Mожливість змінити статус фреймворку з "active" на "draft"
  [Tags]   ${USERS.users['${tender_owner}'].broker}: Зміна статусу
  ...      tender_owner
  ...      ${USERS.users['${tender_owner}'].broker}
  ...      change_status  level1
  ...      critical
  [Teardown]  Оновити QUALIFICATION_LAST_MODIFICATION_DATE
  Run Keyword    Змiнити статус фреймворка на  ${tender_owner}  draft


Неможливість змінити статус фреймворку з "active" на "deleted"
  [Tags]   ${USERS.users['${tender_owner}'].broker}: Зміна статусу
  ...      tender_owner
  ...      ${USERS.users['${tender_owner}'].broker}
  ...      change_status  level1
  ...      critical
  [Teardown]  Оновити QUALIFICATION_LAST_MODIFICATION_DATE
  ${error_message}=  Run Keyword And Expect Error  *
  ...      Змiнити статус фреймворка на  ${tender_owner}  deleted
  Should Contain    ${error_message}  "name": "status", "description": ["Value must be one of ['draft', 'active', 'complete', 'unsuccessful']


Неможливість змінити статус фреймворку з "active" на "complete"
  [Tags]   ${USERS.users['${tender_owner}'].broker}: Зміна статусу
  ...      tender_owner
  ...      ${USERS.users['${tender_owner}'].broker}
  ...      change_status  level1
  ...      critical
  [Teardown]  Оновити QUALIFICATION_LAST_MODIFICATION_DATE
  ${error_message}=  Run Keyword And Expect Error  *
  ...      Змiнити статус фреймворка на  ${tender_owner}  complete
  Should Contain    ${error_message}  "Can't switch to complete status"


Неможливість змінити статус фреймворку з "active" на "unsuccessful"
  [Tags]   ${USERS.users['${tender_owner}'].broker}: Зміна статусу
  ...      tender_owner
  ...      ${USERS.users['${tender_owner}'].broker}
  ...      change_status  level1
  ...      critical
  [Teardown]  Оновити QUALIFICATION_LAST_MODIFICATION_DATE
  ${error_message}=  Run Keyword And Expect Error  *
  ...      Змiнити статус фреймворка на  ${tender_owner}  unsuccessful
  Should Contain    ${error_message}  "Can't switch to unsuccessful status"


#===== PATCH_frameworks{id} active =====

Mожливість оновити фреймворк, не заповнивши поле "frameworkType"
  [Tags]   ${USERS.users['${tender_owner}'].broker}: Оновленя фреймворку
  ...      tender_owner
  ...      ${USERS.users['${tender_owner}'].broker}
  ...      update_framework
  ...      critical
  Run Keyword   Неможливість оновити кваліфікаціi  ${tender_owner}  frameworkType  ${Null}
  Звірити поле кваліфікаціi із значенням  ${viewer}  ${QUALIFICATION['QUALIFICATION_UAID']}   dynamicPurchasingSystem  frameworkType


Неможливість оновити фреймворк, якщо поле "procuringEntity.contactPoint.email" не відповідає формату, статус "active"
  [Tags]   ${USERS.users['${tender_owner}'].broker}: Оновленя фреймворку
  ...      tender_owner
  ...      ${USERS.users['${tender_owner}'].broker}
  ...      update_framework
  ...      critical
  ${error_message}  Run Keyword And Expect Error    *
  ...    Неможливість оновити кваліфікаціi  ${tender_owner}  procuringEntity.contactPoint.email  'аал@aa.com'
  Should Contain    ${error_message}  "Not a well formed email address."


Неможливість оновити фреймворк, не заповнивши поле "procuringEntity.contactPoint", статус "active"
  [Tags]   ${USERS.users['${tender_owner}'].broker}: Оновленя фреймворку
  ...      tender_owner
  ...      ${USERS.users['${tender_owner}'].broker}
  ...      update_framework
  ...      critical
  ${error_message}  Run Keyword And Expect Error    *
  ...    Неможливість оновити кваліфікаціi  ${tender_owner}  procuringEntity.contactPoint  ${Null}
  Should Contain    ${error_message}  "This field is required."


Mожливість оновити фреймворк, не заповнивши поле "procuringEntity.contactPoint.telephone", статус "active"
  [Tags]   ${USERS.users['${tender_owner}'].broker}: Оновленя фреймворку
  ...      tender_owner
  ...      ${USERS.users['${tender_owner}'].broker}
  ...      update_framework
  ...      critical
  Run Keyword   Неможливість оновити кваліфікаціi  ${tender_owner}  procuringEntity.contactPoint.telephone  ${Null}


Неможливість оновити фреймворк, не заповнивши поле "procuringEntity.contactPoint.name", статус "active"
  [Tags]   ${USERS.users['${tender_owner}'].broker}: Оновленя фреймворку
  ...      tender_owner
  ...      ${USERS.users['${tender_owner}'].broker}
  ...      update_framework
  ...      critical
  ${error_message}  Run Keyword And Expect Error    *
  ...    Неможливість оновити кваліфікаціi  ${tender_owner}  procuringEntity.contactPoint.name  ${Null}
  Should Contain    ${error_message}  "This field is required."


Неможливість оновити фреймворк, не заповнивши поле "procuringEntity.contactPoint.email", статус "active"
  [Tags]   ${USERS.users['${tender_owner}'].broker}: Оновленя фреймворку
  ...      tender_owner
  ...      ${USERS.users['${tender_owner}'].broker}
  ...      update_framework
  ...      critical
  ${error_message}  Run Keyword And Expect Error    *
  ...    Неможливість оновити кваліфікаціi  ${tender_owner}  procuringEntity.contactPoint.email  ${Null}
  Should Contain    ${error_message}  "This field is required."


Неможливість оновити фреймворк, не заповнивши поле "procuringEntity.identifier", статус "active"
  [Tags]   ${USERS.users['${tender_owner}'].broker}: Оновленя фреймворку
  ...      tender_owner
  ...      ${USERS.users['${tender_owner}'].broker}
  ...      update_framework
  ...      critical
  ${error_message}  Run Keyword And Expect Error    *
  ...    Неможливість оновити кваліфікаціi  ${tender_owner}  procuringEntity.identifier  ${Null}
  Should Contain    ${error_message}  "This field is required."


Неможливість оновити фреймворк, не заповнивши поле "procuringEntity.identifier.scheme", статус "active"
  [Tags]   ${USERS.users['${tender_owner}'].broker}: Оновленя фреймворку
  ...      tender_owner
  ...      ${USERS.users['${tender_owner}'].broker}
  ...      update_framework
  ...      critical
  ${error_message}  Run Keyword And Expect Error    *
  ...    Неможливість оновити кваліфікаціi  ${tender_owner}  procuringEntity.identifier.scheme  ${Null}
  Should Contain    ${error_message}  "This field is required."


Неможливість оновити фреймворк, не заповнивши поле "procuringEntity.identifier.id", статус "active"
  [Tags]   ${USERS.users['${tender_owner}'].broker}: Оновленя фреймворку
  ...      tender_owner
  ...      ${USERS.users['${tender_owner}'].broker}
  ...      update_framework
  ...      critical
  ${error_message}  Run Keyword And Expect Error    *
  ...    Неможливість оновити кваліфікаціi  ${tender_owner}  procuringEntity.identifier.id  ${Null}
  Should Contain    ${error_message}  "This field is required."


Неможливість оновити фреймворк, не заповнивши поле "procuringEntity.identifier.legalName", статус "active"
  [Tags]   ${USERS.users['${tender_owner}'].broker}: Оновленя фреймворку
  ...      tender_owner
  ...      ${USERS.users['${tender_owner}'].broker}
  ...      update_framework
  ...      critical
  ${error_message}  Run Keyword And Expect Error    *
  ...    Неможливість оновити кваліфікаціi  ${tender_owner}  procuringEntity.identifier.legalName  ${Null}
  Should Contain    ${error_message}  "This field is required."


Неможливість оновити фреймворк, якщо поле "procuringEntity.identifier.scheme" не відповідає формату, статус "active"
  [Tags]   ${USERS.users['${tender_owner}'].broker}: Оновленя фреймворку
  ...      tender_owner
  ...      ${USERS.users['${tender_owner}'].broker}
  ...      update_framework
  ...      critical
  ${error_message}  Run Keyword And Expect Error    *
  ...    Неможливість оновити кваліфікаціi  ${tender_owner}  procuringEntity.identifier.scheme  'UA-EDR1'
  Should Contain    ${error_message}  "Value must be one of ['AE-ACCI', 'AE-ADCD', 'AE-AFZ', 'AE-DCCI', 'AE-DFSA', 'AE-DIFC', 'AE-FFZ', 'AE-FUJCCI', 'AE-HFZA', 'AE-RAKIA', 'AE-SAIF', 'AE-SCCI', 'AE-UAQCCI', 'AF-CBR', 'AF-MOE', 'AM-SRLE', 'AR-CENOC', 'AR-CUIT', 'AT-FN', 'AU-ABN', 'AU-ACNC', 'AZ-IVI', 'BD-NAB', 'BE-BCE_KBO', 'BE-GTCF', 'BG-EIK', 'BR-CNPJ', 'BY-UNP', 'CA-CRA_ACR', 'CH-ZEFIX', 'CL-RUT', 'CN-SAIC', 'CO-CCB', 'CY-DRCOR', 'CZ-ICO', 'DE-CRP', 'DK-CVR', 'EE-RIK', 'EG-MOSS', 'ES-DIR3', 'ES-RMS', 'ET-MFA', 'FI-PRO', 'FR-INSEE', 'FR-RCS', 'GB-CHC', 'GB-COH', 'GB-EDU', 'GB-GOV', 'GB-GOVUK', 'GB-NIC', 'GB-REV', 'GB-SC', 'GB-UKPRN', 'GE-NAPR', 'GG-RCE', 'GH-DSW', 'GR-GECR', 'HR-MBS', 'HR-OIB', 'HU-VAT', 'ID-KDN', 'ID-KHH', 'ID-KLN', 'ID-PRO', 'IE-CHY', 'IE-CRO', 'IL-ROC', 'IM-CR', 'IM-GR', 'IN-MCA', 'IT-RI', 'JE-CR', 'JE-OAC', 'JO-CCD', 'JO-MSD', 'JP-JCN', 'KE-NCB', 'KE-RCO', 'KE-RSO', 'KG-ID', 'KR-BIZID', 'KZ-BIN', 'LS-LCN', 'LT-PVM', 'LT-RC', 'LV-RE', 'MD-IDNO', 'MM-MHA', 'MT-MFSA', 'MW-CNM', 'MW-MRA', 'MW-NBM', 'MW-RG', 'MY-SSM', 'MZ-MOJ', 'NG-CAC', 'NL-KVK', 'NO-BRC', 'NP-CRO', 'NP-SWC', 'PA-RPP', 'PK-PCP', 'PK-VSWA', 'PL-KRS', 'PL-NIP', 'PL-REGON', 'PT-NIPPC', 'RO-CUI', 'RS-APR', 'RU-INN', 'RU-OGRN', 'SA-CRS', 'SE-BLV', 'SG-ACRA', 'SI-PRS', 'SI-TIN', 'SK-ZRSR', 'TR-MERSIS', 'TR-MOI', 'TR-VAT', 'TZ-BRLA', 'UA-EDR', 'UA-FIN', 'UA-IPN', 'UG-NGB', 'UG-RSB', 'US-DOS', 'US-EIN', 'US-USAGOV', 'UZ-KTUT', 'XI-IATI', 'XI-PB', 'XM-DAC', 'XM-EORI', 'XM-OCHA', 'ZA-CIP', 'ZA-NPO', 'ZA-PBO', 'ZM-NRB', 'ZM-PCR', 'ZW-PVO', 'ZW-ROD', 'MK-CR', 'MX-RFC', 'LUX', 'UY-DGR']."


Неможливість оновити фреймворк, якщо поле "procuringEntity.kind" не відповідає формату, статус "active"
  [Tags]   ${USERS.users['${tender_owner}'].broker}: Оновленя фреймворку
  ...      tender_owner
  ...      ${USERS.users['${tender_owner}'].broker}
  ...      update_framework
  ...      critical
  ${error_message}  Run Keyword And Expect Error    *
  ...    Неможливість оновити кваліфікаціi  ${tender_owner}  procuringEntity.kind  'defense1'
  Should Contain    ${error_message}  "Value must be one of ('authority', 'central', 'defense', 'general', 'other', 'social', 'special')."


Неможливість оновити фреймворк, не заповнивши поле "procuringEntity.address", статус "active"
  [Tags]   ${USERS.users['${tender_owner}'].broker}: Оновленя фреймворку
  ...      tender_owner
  ...      ${USERS.users['${tender_owner}'].broker}
  ...      update_framework
  ...      critical
  ${error_message}  Run Keyword And Expect Error    *
  ...    Неможливість оновити кваліфікаціi  ${tender_owner}  procuringEntity.address  ${Null}
  Should Contain    ${error_message}  "This field is required."


Неможливість оновити фреймворк, не заповнивши поле "procuringEntity.address.countryName", статус "active"
  [Tags]   ${USERS.users['${tender_owner}'].broker}: Оновленя фреймворку
  ...      tender_owner
  ...      ${USERS.users['${tender_owner}'].broker}
  ...      update_framework
  ...      critical
  ${error_message}  Run Keyword And Expect Error    *
  ...    Неможливість оновити кваліфікаціi  ${tender_owner}  procuringEntity.address.countryName  ${Null}
  Should Contain    ${error_message}  "This field is required."


Неможливість оновити фреймворк, не заповнивши поле "procuringEntity.address.postalCode", статус "active"
  [Tags]   ${USERS.users['${tender_owner}'].broker}: Оновленя фреймворку
  ...      tender_owner
  ...      ${USERS.users['${tender_owner}'].broker}
  ...      update_framework
  ...      critical
  ${error_message}  Run Keyword And Expect Error    *
  ...    Неможливість оновити кваліфікаціi  ${tender_owner}  procuringEntity.address.postalCode  ${Null}
  Should Contain    ${error_message}  "This field is required."


Неможливість оновити фреймворк, не заповнивши поле "procuringEntity.address.region", статус "active"
  [Tags]   ${USERS.users['${tender_owner}'].broker}: Оновленя фреймворку
  ...      tender_owner
  ...      ${USERS.users['${tender_owner}'].broker}
  ...      update_framework
  ...      critical
  ${error_message}  Run Keyword And Expect Error    *
  ...    Неможливість оновити кваліфікаціi  ${tender_owner}  procuringEntity.address.region  ${Null}
  Should Contain    ${error_message}  "This field is required."


Неможливість оновити фреймворк, не заповнивши поле "procuringEntity.address.streetAddress", статус "active"
  [Tags]   ${USERS.users['${tender_owner}'].broker}: Оновленя фреймворку
  ...      tender_owner
  ...      ${USERS.users['${tender_owner}'].broker}
  ...      update_framework
  ...      critical
  ${error_message}  Run Keyword And Expect Error    *
  ...    Неможливість оновити кваліфікаціi  ${tender_owner}  procuringEntity.address.streetAddress  ${Null}
  Should Contain    ${error_message}  "This field is required."


Неможливість оновити фреймворк, не заповнивши поле "procuringEntity.address.locality", статус "active"
  [Tags]   ${USERS.users['${tender_owner}'].broker}: Оновленя фреймворку
  ...      tender_owner
  ...      ${USERS.users['${tender_owner}'].broker}
  ...      update_framework
  ...      critical
  ${error_message}  Run Keyword And Expect Error    *
  ...    Неможливість оновити кваліфікаціi  ${tender_owner}  procuringEntity.address.locality  ${Null}
  Should Contain    ${error_message}  "This field is required."


Неможливість оновити фреймворк, якщо поле "procuringEntity.address.countryName" не відповідає формату, статус "active"
  [Tags]   ${USERS.users['${tender_owner}'].broker}: Оновленя фреймворку
  ...      tender_owner
  ...      ${USERS.users['${tender_owner}'].broker}
  ...      update_framework
  ...      critical
  ${error_message}  Run Keyword And Expect Error    *
  ...    Неможливість оновити кваліфікаціi  ${tender_owner}  procuringEntity.address.countryName  'Украина1'
  Should Contain    ${error_message}  "field address:countryName not exist in countries catalog"


Неможливість оновити фреймворк, якщо поле "procuringEntity.address.region" не відповідає формату, статус "active"
  [Tags]   ${USERS.users['${tender_owner}'].broker}: Оновленя фреймворку
  ...      tender_owner
  ...      ${USERS.users['${tender_owner}'].broker}
  ...      update_framework
  ...      critical
  ${error_message}  Run Keyword And Expect Error    *
  ...    Неможливість оновити кваліфікаціi  ${tender_owner}  procuringEntity.address.region  'м. Киiв1'
  Should Contain    ${error_message}  "field address:region not exist in ua_regions catalog"


Неможливість оновити фреймворк, якщо поле "classification.id" не відповідає формату, статус "active"
  [Tags]   ${USERS.users['${tender_owner}'].broker}: Оновленя фреймворку
  ...      tender_owner
  ...      ${USERS.users['${tender_owner}'].broker}
  ...      update_framework
  ...      critical
  Run Keyword And Expect Error    *
  ...    Неможливість оновити кваліфікаціi  ${tender_owner}  classification.id  '42000000-66'


Неможливість оновити фреймворк, не заповнивши поле "classification.id", статус "active"
  [Tags]   ${USERS.users['${tender_owner}'].broker}: Оновленя фреймворку
  ...      tender_owner
  ...      ${USERS.users['${tender_owner}'].broker}
  ...      update_framework
  ...      critical
  ${error_message}  Run Keyword And Expect Error    *
  ...    Неможливість оновити кваліфікаціi  ${tender_owner}  classification.id  ${Null}
  Should Contain    ${error_message}  "This field is required."


Неможливість оновити фреймворк, якщо поле "classification.scheme" не відповідає формату, статус "active"
  [Tags]   ${USERS.users['${tender_owner}'].broker}: Оновленя фреймворку
  ...      tender_owner
  ...      ${USERS.users['${tender_owner}'].broker}
  ...      update_framework
  ...      critical
  Run Keyword And Expect Error    *
  ...    Неможливість оновити кваліфікаціi  ${tender_owner}  classification.scheme  'ДК0211'


Неможливість оновити фреймворк, не заповнивши поле "classification.scheme", статус "active"
  [Tags]   ${USERS.users['${tender_owner}'].broker}: Оновленя фреймворку
  ...      tender_owner
  ...      ${USERS.users['${tender_owner}'].broker}
  ...      update_framework
  ...      critical
  ${error_message}  Run Keyword And Expect Error    *
  ...    Неможливість оновити кваліфікаціi  ${tender_owner}  classification.scheme  ${Null}
  Should Contain    ${error_message}  "This field is required."


Неможливість оновити фреймворк, не заповнивши поле "classification.description", статус "active"
  [Tags]   ${USERS.users['${tender_owner}'].broker}: Оновленя фреймворку
  ...      tender_owner
  ...      ${USERS.users['${tender_owner}'].broker}
  ...      update_framework
  ...      critical
  ${error_message}  Run Keyword And Expect Error    *
  ...    Неможливість оновити кваліфікаціi  ${tender_owner}  classification.description  ${Null}
  Should Contain    ${error_message}  "This field is required."


Неможливість оновити фреймворк, не заповнивши поле "qualificationPeriod.endDate", статус "active"
  [Tags]   ${USERS.users['${tender_owner}'].broker}: Оновленя фреймворку
  ...      tender_owner
  ...      ${USERS.users['${tender_owner}'].broker}
  ...      update_framework
  ...      critical
  ${error_message}  Run Keyword And Expect Error    *
  ...    Неможливість оновити кваліфікаціi  ${tender_owner}  qualificationPeriod.endDate  ${Null}
  Should Contain    ${error_message}  "This field is required."


Неможливість оновити фреймворк, не заповнивши поле "procuringEntity.name", статус "active"
  [Tags]   ${USERS.users['${tender_owner}'].broker}: Оновленя фреймворку
  ...      tender_owner
  ...      ${USERS.users['${tender_owner}'].broker}
  ...      update_framework
  ...      critical
  ${error_message}  Run Keyword And Expect Error    *
  ...    Неможливість оновити кваліфікаціi  ${tender_owner}  procuringEntity.name  ${Null}
  Should Contain    ${error_message}  "This field is required."


Mожливість оновити фреймворк, не заповнивши поле "procuringEntity.kind", статус "active"
  [Tags]   ${USERS.users['${tender_owner}'].broker}: Оновленя фреймворку
  ...      tender_owner
  ...      ${USERS.users['${tender_owner}'].broker}
  ...      update_framework
  ...      critical
  Run Keyword   Неможливість оновити кваліфікаціi  ${tender_owner}  procuringEntity.kind  ${Null}
  Звірити поле кваліфікаціi із значенням  ${viewer}  ${QUALIFICATION['QUALIFICATION_UAID']}   general  procuringEntity.kind


Mожливість оновити фреймворк, не заповнивши поле "title", статус "active"
  [Tags]   ${USERS.users['${tender_owner}'].broker}: Оновленя фреймворку
  ...      tender_owner
  ...      ${USERS.users['${tender_owner}'].broker}
  ...      update_framework
  ...      critical
  ${field}=  Set Variable    ${USERS.users['${tender_owner}'].initial_data.data.title}
  Run Keyword  Неможливість оновити кваліфікаціi  ${tender_owner}  title  ${Null}
  Звірити поле кваліфікаціi із значенням  ${tender_owner}  ${QUALIFICATION['QUALIFICATION_UAID']}   ${field}  title


Mожливість оновити фреймворк, не заповнивши поле "description", статус "active"
  [Tags]   ${USERS.users['${tender_owner}'].broker}: Оновленя фреймворку
  ...      tender_owner
  ...      ${USERS.users['${tender_owner}'].broker}
  ...      update_framework
  ...      critical
  ${field}=  Set Variable    ${USERS.users['${tender_owner}'].initial_data.data.description}
  Run Keyword  Неможливість оновити кваліфікаціi  ${tender_owner}  title  ${Null}
  Звірити поле кваліфікаціi із значенням  ${tender_owner}  ${QUALIFICATION['QUALIFICATION_UAID']}   ${field}  description


#===== POST_frameworks{id}/documents active =====

Mожливість завантажити документ у фреймворк, у статусi "active"
  [Tags]   ${USERS.users['${tender_owner}'].broker}: Завантажити документ у кваліфікацію
  ...      tender_owner
  ...      ${USERS.users['${tender_owner}'].broker}
  ...      document_negative_tests
  ...      critical
  [Teardown]  Оновити QUALIFICATION_LAST_MODIFICATION_DATE
   ${file_path}  ${file_name}  ${file_content}=  create_fake_doc
   Run As  ${tender_owner}  Завантажити документ у фреймворк  ${file_path}
   ${framework_doc}=  Create Dictionary
   ...    doc_name=${file_name}
   ...    doc_content=${file_content}
   Set To Dictionary   ${USERS.users['${tender_owner}']}  framework_document=${framework_doc}
   Remove File  ${file_path}


Неможливість додати документ, якщо запит не відповідає формату "documentOf", статус "active"
  [Tags]   ${USERS.users['${tender_owner}'].broker}: Оновити документ
  ...      tender_owner
  ...      ${USERS.users['${tender_owner}'].broker}
  ...      document_negative_tests
  ...      critical
  [Teardown]  Оновити QUALIFICATION_LAST_MODIFICATION_DATE
  ${document}=  Set Variable    ${USERS.users['${tender_owner}'].documents}
  ${lot}=  Set Variable    lot
  Set To Dictionary    ${document.data}  documentOf=${lot}
  ${error}=  Run Keyword And Expect Error  *
  ...    Додати зареєстрований документ у фреймворк  ${tender_owner}  ${document}
  Should Contain    ${error}   "name": "documentOf", "description": "Rogue field"
  Remove From Dictionary    ${USERS.users['${tender_owner}'].documents.data}    documentOf


Неможливість додати документ, якщо запит не відповідає формату "documentType", статус "active"
  [Tags]   ${USERS.users['${tender_owner}'].broker}: Оновити документ
  ...      tender_owner
  ...      ${USERS.users['${tender_owner}'].broker}
  ...      document_negative_tests
  ...      critical
  [Teardown]  Оновити QUALIFICATION_LAST_MODIFICATION_DATE
  ${document}=  Set Variable    ${USERS.users['${tender_owner}'].documents}
  Set To Dictionary    ${document.data}  documentType=lot
  ${error}=  Run Keyword And Expect Error  *
  ...    Додати зареєстрований документ у фреймворк  ${tender_owner}  ${document}
  Should Contain    ${error}   "Value must be one of ['tenderNotice', 'awardNotice',
  Remove From Dictionary    ${USERS.users['${tender_owner}'].documents.data}  documentType


Заборонено передавати "confidentiality", статус "active"
  [Tags]   ${USERS.users['${tender_owner}'].broker}: Оновити документ
  ...      tender_owner
  ...      ${USERS.users['${tender_owner}'].broker}
  ...      document_negative_tests
  ...      critical
  [Teardown]  Оновити QUALIFICATION_LAST_MODIFICATION_DATE
  ${document}=  Set Variable    ${USERS.users['${tender_owner}'].documents}
  Set To Dictionary    ${document.data}  confidentiality=buyerOnly
  ${error}=  Run Keyword And Expect Error  *
  ...    Додати зареєстрований документ у фреймворк  ${tender_owner}  ${document}
  Should Contain    ${error}    "name": "confidentiality", "description": "Rogue field"
  Remove From Dictionary    ${USERS.users['${tender_owner}'].documents.data}  confidentiality


Неможливість додати документ, не заповнивши поле "title", статус "active"
  [Tags]   ${USERS.users['${tender_owner}'].broker}: Оновленя фреймворку
  ...      tender_owner
  ...      ${USERS.users['${tender_owner}'].broker}
  ...      document_negative_tests
  ...      critical
  ${document}=  Set Variable    ${USERS.users['${tender_owner}'].documents}
  Set To Dictionary    ${document.data}  title=${Null}
  Log  ${document}
  ${error}=  Run Keyword And Expect Error  *
  ...    Додати зареєстрований документ у фреймворк  ${tender_owner}  ${document}
  Should Contain    ${error}    "name": "title", "description": ["This field is required."


Mожливість отримати документ з фреймворку, використовуючи "document_id", статус "active"
  [Tags]   ${USERS.users['${tender_owner}'].broker}: Отримати документ з фреймворку
  ...      tender_owner
  ...      ${USERS.users['${tender_owner}'].broker}
  ...      document_view
  ...      critical
  ${document_id}=  Set Variable    ${USERS.users['${tender_owner}']['documents']['data']['id']}
  ${reply}=  Oтримати документ з фреймворку  ${tender_owner}  ${document_id}
  Log      ${reply}
  Should Be Equal    ${document_id}  ${reply.data.id}


Mожливість отримати усi наявнi документи з фреймворку, статус "active"
  [Tags]   ${USERS.users['${tender_owner}'].broker}: Отримати документ з фреймворку
  ...      tender_owner
  ...      ${USERS.users['${tender_owner}'].broker}
  ...      document_view
  ...      critical
  ${reply}=  Oтримати документи з фреймворку  ${tender_owner}
  Log      ${reply}


# ===== PUT_frameworks{id}/documents{id} active =====

Можливість завантажити документ поверх старої версії, статус "active"
  [Tags]   ${USERS.users['${tender_owner}'].broker}: Завантажити документ у кваліфікацію
  ...      tender_owner
  ...      ${USERS.users['${tender_owner}'].broker}
  ...      add_doc_to_framework
  ...      critical
  [Teardown]  Оновити QUALIFICATION_LAST_MODIFICATION_DATE
  ${file_path}  ${file_name}  ${file_content}=  create_fake_doc
  Run As  ${tender_owner}  Оновити документ у фреймворку  ${file_path}
  Remove File  ${file_path}


Неможливість оновити завантажений документ, якщо запит не відповідає формату "documentOf", статус "active"
  [Tags]   ${USERS.users['${tender_owner}'].broker}: Завантажити документ у кваліфікацію
  ...      tender_owner
  ...      ${USERS.users['${tender_owner}'].broker}
  ...      document_negative_tests
  ...      critical
  [Teardown]  Оновити QUALIFICATION_LAST_MODIFICATION_DATE
  ${document}=  Set Variable    ${USERS.users['${tender_owner}'].documents}
  ${lot}=  Set Variable    lot
  Set To Dictionary    ${document.data}  documentOf=${lot}
  ${error}=  Run Keyword And Expect Error  *
  ...    Оновити зареєстрований документ у фреймворку  ${tender_owner}  ${document}
  Should Contain    ${error}   "name": "documentOf", "description": "Rogue field"
  Remove From Dictionary    ${USERS.users['${tender_owner}'].documents.data}    documentOf


Неможливість оновити завантажений документ, якщо запит не відповідає формату "documentType", статус "active"
  [Tags]   ${USERS.users['${tender_owner}'].broker}: Оновити документ
  ...      tender_owner
  ...      ${USERS.users['${tender_owner}'].broker}
  ...      document_negative_tests
  ...      critical
  [Teardown]  Оновити QUALIFICATION_LAST_MODIFICATION_DATE
  ${document}=  Set Variable    ${USERS.users['${tender_owner}'].documents}
  Set To Dictionary    ${document.data}  documentType=lot
  ${error}=  Run Keyword And Expect Error  *
  ...    Оновити зареєстрований документ у фреймворку  ${tender_owner}  ${document}
  Should Contain    ${error}   "Value must be one of ['tenderNotice', 'awardNotice',
  Remove From Dictionary    ${USERS.users['${tender_owner}'].documents.data}  documentType


Заборонено передавати "confidentiality" під час оновлення, статус "active"
  [Tags]   ${USERS.users['${tender_owner}'].broker}: Оновити документ
  ...      tender_owner
  ...      ${USERS.users['${tender_owner}'].broker}
  ...      document_negative_tests
  ...      critical
  [Teardown]  Оновити QUALIFICATION_LAST_MODIFICATION_DATE
  ${document}=  Set Variable    ${USERS.users['${tender_owner}'].documents}
  Set To Dictionary    ${document.data}  confidentiality=buyerOnly
  ${error}=  Run Keyword And Expect Error  *
  ...    Оновити зареєстрований документ у фреймворку  ${tender_owner}  ${document}
  Should Contain    ${error}    "name": "confidentiality", "description": "Rogue field"
  Remove From Dictionary    ${USERS.users['${tender_owner}'].documents.data}  confidentiality


Неможливість оновити документ, не заповнивши поле "title", статус "active"
  [Tags]   ${USERS.users['${tender_owner}'].broker}: Оновленя фреймворку
  ...      tender_owner
  ...      ${USERS.users['${tender_owner}'].broker}
  ...      document_negative_tests
  ...      critical
  ${document}=  Set Variable    ${USERS.users['${tender_owner}'].documents}
  Set To Dictionary    ${document.data}  title=${Null}
  Log  ${document}
  ${error}=  Run Keyword And Expect Error  *
  ...    Оновити зареєстрований документ у фреймворку  ${tender_owner}  ${document}
  Should Contain    ${error}    "name": "title", "description": ["This field is required."


#===== PATCH_frameworks{id}/documents{id} active =====

Mожливість змiнити значеня поля "title" у документi, статус "active"
  [Tags]   ${USERS.users['${tender_owner}'].broker}: Оновленя документу
  ...      tender_owner
  ...      ${USERS.users['${tender_owner}'].broker}
  ...      document_negative_tests
  ...      critical
  ${field}=  Set Variable    title
  ${value}=  Set Variable    new title patch
  ${document}=  change_field_value_in_document  ${field}  ${value}
  ${reply}=  Run Keyword  Оновити значеня поля у документi  ${tender_owner}  ${document}
  Should Be Equal    ${value}  ${reply.data.title}


Неможливість змiнити значеня поля "title" у документi, передавши Null, статус "active"
  [Tags]   ${USERS.users['${tender_owner}'].broker}: Оновленя документу
  ...      tender_owner
  ...      ${USERS.users['${tender_owner}'].broker}
  ...      document_negative_tests
  ...      critical
  ${field}=  Set Variable    title
  ${document}=  change_field_value_in_document  ${field}  ${Null}
  Log   ${document}
  ${error}=  Run Keyword And Expect Error  *
  ...    Оновити значеня поля у документi  ${tender_owner}  ${document}
  Should Contain    ${error}     "name": "title", "description": ["This field is required."]


Неможливість змiнити значеня поля "documentType", якщо значеня не вiдповiдае формату, статус "active"
  [Tags]   ${USERS.users['${tender_owner}'].broker}: Оновити документ
  ...      tender_owner
  ...      ${USERS.users['${tender_owner}'].broker}
  ...      document_negative_tests
  ...      critical
  [Teardown]  Оновити QUALIFICATION_LAST_MODIFICATION_DATE
  ${field}=  Set Variable    documentType
  ${value}=  Set Variable    patch
  ${document}=  change_field_value_in_document  ${field}  ${value}
  ${error}=  Run Keyword And Expect Error  *
  ...    Оновити значеня поля у документi  ${tender_owner}  ${document}
  Should Contain    ${error}    "name": "documentType", "description": ["Value must be one of ['tenderNotice',


Неможливість змiнити значеня поля "documentOf" у документi, статус "active"
  [Tags]   ${USERS.users['${tender_owner}'].broker}: Оновити документ
  ...      tender_owner
  ...      ${USERS.users['${tender_owner}'].broker}
  ...      document_negative_tests
  ...      critical
  [Teardown]  Оновити QUALIFICATION_LAST_MODIFICATION_DATE
  ${field}=  Set Variable    documentOf
  ${value}=  Set Variable    lot
  ${document}=  change_field_value_in_document  ${field}  ${value}
  ${error}=  Run Keyword And Expect Error  *
  ...    Оновити значеня поля у документi  ${tender_owner}  ${document}
  Should Contain    ${error}    "name": "documentOf", "description": "Rogue field"


Неможливість змiнити значеня поля "confidentiality" у документi, статус "active"
  [Tags]   ${USERS.users['${tender_owner}'].broker}: Оновити документ
  ...      tender_owner
  ...      ${USERS.users['${tender_owner}'].broker}
  ...      document_negative_tests
  ...      critical
  [Teardown]  Оновити QUALIFICATION_LAST_MODIFICATION_DATE
  ${field}=  Set Variable    confidentiality
  ${value}=  Set Variable    buyerOnly
  ${document}=  change_field_value_in_document  ${field}  ${value}
  ${error}=  Run Keyword And Expect Error  *
  ...    Оновити значеня поля у документi  ${tender_owner}  ${document}
  Should Contain    ${error}     "name": "confidentiality", "description": "Rogue field"


Неможливість aктивувати кваліфікацію якщо qualificationPeriod.endDate у проміжку менш ніж 30 або більш ніж 1095 календарних днів
  [Tags]   ${USERS.users['${tender_owner}'].broker}: Процес кваліфікації
  ...      tender_owner
  ...      ${USERS.users['${tender_owner}'].broker}
  ...      activate_framework_expected_error  level1
  ...      critical
  [Teardown]  Оновити QUALIFICATION_LAST_MODIFICATION_DATE
  Run Keyword And Expect Error    *  Aктивувати фреймворк  ${tender_owner}


Можливість змінити значеня поля телефон для замовника
  [Tags]   ${USERS.users['${tender_owner}'].broker}: Редагування фреймворку
  ...      tender_owner
  ...      ${USERS.users['${tender_owner}'].broker}
  ...      update_framework
  ...      critical
  [Teardown]  Оновити QUALIFICATION_LAST_MODIFICATION_DATE
  ${field_name}=  Set Variable    telephone
  ${patch_data}=  get_payload_for_patching_framework  ${field_name}
  Set to dictionary  ${USERS.users['${tender_owner}'].initial_data.data.procuringEntity.contactPoint}  telephone=${patch_data.data.procuringEntity.contactPoint.telephone}
  Run As  ${tender_owner}  Редагувати фреймворк  ${patch_data}


Відображення зміненого поля телефон у фреймворку
  [Tags]   ${USERS.users['${viewer}'].broker}: Відображення основних даних фреймворку
  ...      tender_owner
  ...      ${USERS.users['${viewer}'].broker}
  ...      framework_view  level2
  ...      non-critical
  Звірити відображення поля procuringEntity.contactPoint.telephone фреймворку для користувача ${tender_owner}


Можливість змінити значеня поля name для замовника
  [Tags]   ${USERS.users['${tender_owner}'].broker}: Редагування фреймворку
  ...      tender_owner
  ...      ${USERS.users['${tender_owner}'].broker}
  ...      update_framework
  ...      critical
  [Teardown]  Оновити QUALIFICATION_LAST_MODIFICATION_DATE
  ${field_name}=  Set Variable    name
  ${patch_data}=  get_payload_for_patching_framework  ${field_name}
  Set to dictionary  ${USERS.users['${tender_owner}'].initial_data.data.procuringEntity.contactPoint}  name=${patch_data.data.procuringEntity.contactPoint.name}
  Run As  ${tender_owner}  Редагувати фреймворк  ${patch_data}


Відображення зміненого поля name у фреймворку
  [Tags]   ${USERS.users['${viewer}'].broker}: Відображення основних даних фреймворку
  ...      tender_owner
  ...      ${USERS.users['${viewer}'].broker}
  ...      framework_view  level2
  ...      non-critical
  Звірити відображення поля procuringEntity.contactPoint.name фреймворку для користувача ${tender_owner}


Можливість змінити значеня поля пошта для замовника
  [Tags]   ${USERS.users['${tender_owner}'].broker}: Редагування фреймворку
  ...      tender_owner
  ...      ${USERS.users['${tender_owner}'].broker}
  ...      update_framework
  ...      critical
  [Teardown]  Оновити QUALIFICATION_LAST_MODIFICATION_DATE
  ${field_name}=  Set Variable    email
  ${patch_data}=  get_payload_for_patching_framework  ${field_name}
  Set to dictionary  ${USERS.users['${tender_owner}'].initial_data.data.procuringEntity.contactPoint}  email=${patch_data.data.procuringEntity.contactPoint.email}
  Run As  ${tender_owner}  Редагувати фреймворк  ${patch_data}


Відображення зміненого поля пошта у фреймворку
  [Tags]   ${USERS.users['${viewer}'].broker}: Відображення основних даних фреймворку
  ...      tender_owner
  ...      ${USERS.users['${viewer}'].broker}
  ...      framework_view  level2
  ...      non-critical
  Звірити відображення поля procuringEntity.contactPoint.email фреймворку для користувача ${tender_owner}


Можливість змінити значеня поля опис для замовника
  [Tags]   ${USERS.users['${tender_owner}'].broker}: Редагування фреймворку
  ...      tender_owner
  ...      ${USERS.users['${tender_owner}'].broker}
  ...      update_framework
  ...      critical
  [Teardown]  Оновити QUALIFICATION_LAST_MODIFICATION_DATE
  ${patch_data}=  get_description_for_patching_framework
  Set to dictionary  ${USERS.users['${tender_owner}'].initial_data.data}  description=${patch_data.data.description}
  Run As  ${tender_owner}  Редагувати фреймворк  ${patch_data}


Відображення зміненого поля опис у фреймворку
  [Tags]   ${USERS.users['${viewer}'].broker}: Відображення основних даних фреймворку
  ...      tender_owner
  ...      ${USERS.users['${viewer}'].broker}
  ...      framework_view  level2
  ...      non-critical
  Звірити відображення поля description фреймворку для користувача ${tender_owner}


Можливість дочекатись дати закінчення періоду уточнень
  [Tags]   ${USERS.users['${viewer}'].broker}: Очікування початку періоду кваліфікації
  ...      tender_owner
  ...      ${USERS.users['${viewer}'].broker}
  ...      wait_enquiryPeriod_endDate
  Дочекатись дати закінчення періоду уточнень кваліфікації  ${viewer}  ${QUALIFICATION['QUALIFICATION_UAID']}


Можливість подати заявку першим учасником
  [Tags]   ${USERS.users['${provider}'].broker}: Подання пропозиції
  ...      provider
  ...      ${USERS.users['${provider}'].broker}
  ...      add_submission
  ...      critical
  [Teardown]  Оновити QUALIFICATION_LAST_MODIFICATION_DATE
  Можливість зареєструвати заявку  ${provider}


Можливість подати заявку другим учасником
  [Tags]   ${USERS.users['${provider1}'].broker}: Подання пропозиції
  ...      provider1
  ...      ${USERS.users['${provider1}'].broker}
  ...      add_submission
  ...      critical
  [Teardown]  Оновити QUALIFICATION_LAST_MODIFICATION_DATE
  Можливість зареєструвати заявку  ${provider1}


Можливість подати заявку третім учасником
  [Tags]   ${USERS.users['${provider2}'].broker}: Подання пропозиції
  ...      provider2
  ...      ${USERS.users['${provider2}'].broker}
  ...      add_submission
  ...      critical
  [Teardown]  Оновити QUALIFICATION_LAST_MODIFICATION_DATE
  Можливість зареєструвати заявку  ${provider2}


Можливість завантажити документ по першiй заявці
  [Tags]   ${USERS.users['${provider}'].broker}: Завантажити документ по заявці
  ...      provider
  ...      ${USERS.users['${provider}'].broker}
  ...      add_doc_to_submission
  ...      critical
  [Teardown]  Оновити QUALIFICATION_LAST_MODIFICATION_DATE
   ${file_path}  ${file_name}  ${file_content}=  create_fake_doc
   Run As  ${provider}  Завантажити документ по заявці  ${file_path}
   ${submission_doc}=  Create Dictionary
   ...    doc_name=${file_name}
   ...    doc_content=${file_content}
   Set To Dictionary   ${USERS.users['${provider}']}  submission_init_document=${submission_doc}
   Remove File  ${file_path}


Відображення вмісту документації по першiй заявці
  [Tags]   ${USERS.users['${provider}'].broker}: Відображення документації
  ...      provider
  ...      ${USERS.users['${provider}'].broker}
  ...      document_view
  Звірити відображення вмісту документа ${USERS.users['${provider}']['submission_document']['data']} до фреймворку з ${USERS.users['${provider}']['submission_init_document']['doc_content']} для користувача ${provider}


Можливість завантажити документ по другiй заявці
  [Tags]   ${USERS.users['${provider1}'].broker}: Завантажити документ по заявці
  ...      provider1
  ...      ${USERS.users['${provider1}'].broker}
  ...      add_doc_to_submission
  ...      critical
  [Teardown]  Оновити QUALIFICATION_LAST_MODIFICATION_DATE
   ${file_path}  ${file_name}  ${file_content}=  create_fake_doc
   Run As  ${provider1}  Завантажити документ по заявці  ${file_path}
   ${submission_doc}=  Create Dictionary
   ...    doc_name=${file_name}
   ...    doc_content=${file_content}
   Set To Dictionary   ${USERS.users['${provider1}']}  submission_init_document=${submission_doc}
   Remove File  ${file_path}


Відображення вмісту документації по другiй заявці
  [Tags]   ${USERS.users['${provider1}'].broker}: Відображення документації
  ...      provider1
  ...      ${USERS.users['${provider1}'].broker}
  ...      document_view
  Звірити відображення вмісту документа ${USERS.users['${provider1}']['submission_document']['data']} до фреймворку з ${USERS.users['${provider1}']['submission_init_document']['doc_content']} для користувача ${provider1}


Можливість завантажити документ по третiй заявці
  [Tags]   ${USERS.users['${provider2}'].broker}: Завантажити документ по заявці
  ...      provider2
  ...      ${USERS.users['${provider2}'].broker}
  ...      add_doc_to_submission
  ...      critical
  [Teardown]  Оновити QUALIFICATION_LAST_MODIFICATION_DATE
   ${file_path}  ${file_name}  ${file_content}=  create_fake_doc
   Run As  ${provider1}  Завантажити документ по заявці  ${file_path}
   ${submission_doc}=  Create Dictionary
   ...    doc_name=${file_name}
   ...    doc_content=${file_content}
   Set To Dictionary   ${USERS.users['${provider1}']}  submission_init_document=${submission_doc}
   Remove File  ${file_path}


Можливість активувати заявку другого постачальника у кваліфікації
  [Tags]   ${USERS.users['${provider1}'].broker}: Редагування заявки
  ...      provider1
  ...      ${USERS.users['${provider1}'].broker}
  ...      activate_submission
  ...      critical
  Можливість редагувати заявку  ${provider1}  active


#===== POST_submissions =====

Неможливість подати заявку учасником, якщо відсутнє поле "tenderers"
  [Tags]   ${USERS.users['${provider}'].broker}: Подання пропозиції
  ...      provider
  ...      ${USERS.users['${provider}'].broker}
  ...      submission_negative_tests
  ...      critical
  [Teardown]  Оновити QUALIFICATION_LAST_MODIFICATION_DATE
  ${submission_data}=  Підготувати дані для регістрації заявки
  Delete From Dictionary    ${submission_data.data}  tenderers
  ${error_message}  Run Keyword And Expect Error    *
  ...      Неможливість зареєструвати заявку, якщо запит не вiдповiдае формату  ${provider}  ${submission_data}
  Should Contain    ${error_message}  "name": "tenderers", "description": ["This field is required."]


Неможливість подати заявку учасником, якщо поле "tenderers" не вiдповiдае формату
  [Tags]   ${USERS.users['${provider}'].broker}: Подання пропозиції
  ...      provider
  ...      ${USERS.users['${provider}'].broker}
  ...      submission_negative_tests
  ...      critical
  [Teardown]  Оновити QUALIFICATION_LAST_MODIFICATION_DATE
  ${list}=  Create List  ${null}
  ${submission_data}=  Підготувати дані для регістрації заявки
  Set To Dictionary     ${submission_data.data}  tenderers=${list}
  Log    ${submission_data}
  ${error_message}  Run Keyword And Expect Error    *
  ...      Неможливість зареєструвати заявку, якщо запит не вiдповiдае формату  ${provider}  ${submission_data}
  Should Contain    ${error_message}   "name": "tenderers", "description": [["This field is required."]]}


Неможливість подати заявку учасником, якщо відсутнє поле "tenderers.name"
  [Tags]   ${USERS.users['${provider}'].broker}: Подання пропозиції
  ...      provider
  ...      ${USERS.users['${provider}'].broker}
  ...      submission_negative_tests
  ...      critical
  [Teardown]  Оновити QUALIFICATION_LAST_MODIFICATION_DATE
  ${submission_data}=  Підготувати дані для регістрації заявки
  Delete From Dictionary    ${submission_data.data.tenderers[0]}  name
  ${error_message}  Run Keyword And Expect Error    *
  ...      Неможливість зареєструвати заявку, якщо запит не вiдповiдае формату  ${provider}  ${submission_data}
  Should Contain    ${error_message}   "description": [{"name": ["This field is required."]}]


Неможливість подати заявку учасником, якщо поле "tenderers.name" null
  [Tags]   ${USERS.users['${provider}'].broker}: Подання пропозиції
  ...      provider
  ...      ${USERS.users['${provider}'].broker}
  ...      submission_negative_tests
  ...      critical
  [Teardown]  Оновити QUALIFICATION_LAST_MODIFICATION_DATE
  ${submission_data}=  Підготувати дані для регістрації заявки
  Set To Dictionary    ${submission_data.data.tenderers[0]}  name=${Null}
  ${error_message}  Run Keyword And Expect Error    *
  ...      Неможливість зареєструвати заявку, якщо запит не вiдповiдае формату  ${provider}  ${submission_data}
  Should Contain    ${error_message}   "description": [{"name": ["This field is required."]}]


Неможливість подати заявку учасником, якщо відсутнє поле "tenderers.identifier"
  [Tags]   ${USERS.users['${provider}'].broker}: Подання пропозиції
  ...      provider
  ...      ${USERS.users['${provider}'].broker}
  ...      submission_negative_tests
  ...      critical
  [Teardown]  Оновити QUALIFICATION_LAST_MODIFICATION_DATE
  ${submission_data}=  Підготувати дані для регістрації заявки
  Delete From Dictionary    ${submission_data.data.tenderers[0]}  identifier
  ${error_message}  Run Keyword And Expect Error    *
  ...      Неможливість зареєструвати заявку, якщо запит не вiдповiдае формату  ${provider}  ${submission_data}
  Should Contain    ${error_message}    "description": [{"identifier": ["This field is required."


Неможливість подати заявку учасником, якщо поле "tenderers.identifier" null
  [Tags]   ${USERS.users['${provider}'].broker}: Подання пропозиції
  ...      provider
  ...      ${USERS.users['${provider}'].broker}
  ...      submission_negative_tests
  ...      critical
  [Teardown]  Оновити QUALIFICATION_LAST_MODIFICATION_DATE
  ${submission_data}=  Підготувати дані для регістрації заявки
  Set To Dictionary    ${submission_data.data.tenderers[0]}  identifier=${Null}
  ${error_message}  Run Keyword And Expect Error    *
  ...      Неможливість зареєструвати заявку, якщо запит не вiдповiдае формату  ${provider}  ${submission_data}
  Should Contain    ${error_message}   "description": [{"identifier": ["This field is required."]


Неможливість подати заявку учасником, якщо відсутнє поле "tenderers.identifier.legalName"
  [Tags]   ${USERS.users['${provider}'].broker}: Подання пропозиції
  ...      provider
  ...      ${USERS.users['${provider}'].broker}
  ...      submission_negative_tests
  ...      critical
  [Teardown]  Оновити QUALIFICATION_LAST_MODIFICATION_DATE
  ${submission_data}=  Підготувати дані для регістрації заявки
  Delete From Dictionary    ${submission_data.data.tenderers[0].identifier}  legalName
  ${error_message}  Run Keyword And Expect Error    *
  ...      Неможливість зареєструвати заявку, якщо запит не вiдповiдае формату  ${provider}  ${submission_data}
  Should Contain    ${error_message}     "description": [{"identifier": {"legalName": ["This field is required."]


Неможливість подати заявку учасником, якщо поле "tenderers.identifier.legalName" null
  [Tags]   ${USERS.users['${provider}'].broker}: Подання пропозиції
  ...      provider
  ...      ${USERS.users['${provider}'].broker}
  ...      submission_negative_tests
  ...      critical
  [Teardown]  Оновити QUALIFICATION_LAST_MODIFICATION_DATE
  ${submission_data}=  Підготувати дані для регістрації заявки
  Set To Dictionary    ${submission_data.data.tenderers[0].identifier}  legalName=${Null}
  ${error_message}  Run Keyword And Expect Error    *
  ...      Неможливість зареєструвати заявку, якщо запит не вiдповiдае формату  ${provider}  ${submission_data}
  Should Contain    ${error_message}    "description": [{"identifier": {"legalName": ["This field is required."]


Неможливість подати заявку учасником, якщо відсутнє поле "tenderers.identifier.scheme"
  [Tags]   ${USERS.users['${provider}'].broker}: Подання пропозиції
  ...      provider
  ...      ${USERS.users['${provider}'].broker}
  ...      submission_negative_tests
  ...      critical
  [Teardown]  Оновити QUALIFICATION_LAST_MODIFICATION_DATE
  ${submission_data}=  Підготувати дані для регістрації заявки
  Delete From Dictionary    ${submission_data.data.tenderers[0].identifier}  scheme
  ${error_message}  Run Keyword And Expect Error    *
  ...      Неможливість зареєструвати заявку, якщо запит не вiдповiдае формату  ${provider}  ${submission_data}
  Should Contain    ${error_message}    "description": [{"identifier": {"scheme": ["This field is required."]


Неможливість подати заявку учасником, якщо поле "tenderers.identifier.scheme" null
  [Tags]   ${USERS.users['${provider}'].broker}: Подання пропозиції
  ...      provider
  ...      ${USERS.users['${provider}'].broker}
  ...      submission_negative_tests
  ...      critical
  [Teardown]  Оновити QUALIFICATION_LAST_MODIFICATION_DATE
  ${submission_data}=  Підготувати дані для регістрації заявки
  Set To Dictionary    ${submission_data.data.tenderers[0].identifier}  scheme=${Null}
  ${error_message}  Run Keyword And Expect Error    *
  ...      Неможливість зареєструвати заявку, якщо запит не вiдповiдае формату  ${provider}  ${submission_data}
  Should Contain    ${error_message}    "description": [{"identifier": {"scheme": ["This field is required."]


Неможливість подати заявку учасником, якщо поле "tenderers.identifier.scheme" не відповідає формату
  [Tags]   ${USERS.users['${provider}'].broker}: Подання пропозиції
  ...      provider
  ...      ${USERS.users['${provider}'].broker}
  ...      submission_negative_tests
  ...      critical
  [Teardown]  Оновити QUALIFICATION_LAST_MODIFICATION_DATE
  ${submission_data}=  Підготувати дані для регістрації заявки
  Set To Dictionary    ${submission_data.data.tenderers[0].identifier}  scheme=AE-ACC13
  ${error_message}  Run Keyword And Expect Error    *
  ...      Неможливість зареєструвати заявку, якщо запит не вiдповiдае формату  ${provider}  ${submission_data}
  Should Contain    ${error_message}   "description": [{"identifier": {"scheme": ["Value must be one of ['AE-ACCI',


Неможливість подати заявку учасником, якщо відсутнє поле "tenderers.identifier.id"
  [Tags]   ${USERS.users['${provider}'].broker}: Подання пропозиції
  ...      provider
  ...      ${USERS.users['${provider}'].broker}
  ...      submission_negative_tests
  ...      critical
  [Teardown]  Оновити QUALIFICATION_LAST_MODIFICATION_DATE
  ${submission_data}=  Підготувати дані для регістрації заявки
  Delete From Dictionary    ${submission_data.data.tenderers[0].identifier}  id
  ${error_message}  Run Keyword And Expect Error    *
  ...      Неможливість зареєструвати заявку, якщо запит не вiдповiдае формату  ${provider}  ${submission_data}
  Should Contain    ${error_message}     "description": [{"identifier": {"id": ["This field is required."]


Неможливість подати заявку учасником, якщо поле "tenderers.identifier.id" null
  [Tags]   ${USERS.users['${provider}'].broker}: Подання пропозиції
  ...      provider
  ...      ${USERS.users['${provider}'].broker}
  ...      submission_negative_tests
  ...      critical
  [Teardown]  Оновити QUALIFICATION_LAST_MODIFICATION_DATE
  ${submission_data}=  Підготувати дані для регістрації заявки
  Set To Dictionary    ${submission_data.data.tenderers[0].identifier}  id=${Null}
  ${error_message}  Run Keyword And Expect Error    *
  ...      Неможливість зареєструвати заявку, якщо запит не вiдповiдае формату  ${provider}  ${submission_data}
  Should Contain    ${error_message}    "description": [{"identifier": {"id": ["This field is required."]


Неможливість подати заявку учасником, якщо відсутнє поле "tenderers.address"
  [Tags]   ${USERS.users['${provider}'].broker}: Подання пропозиції
  ...      provider
  ...      ${USERS.users['${provider}'].broker}
  ...      submission_negative_tests
  ...      critical
  [Teardown]  Оновити QUALIFICATION_LAST_MODIFICATION_DATE
  ${submission_data}=  Підготувати дані для регістрації заявки
  Delete From Dictionary    ${submission_data.data.tenderers[0]}  address
  ${error_message}  Run Keyword And Expect Error    *
  ...      Неможливість зареєструвати заявку, якщо запит не вiдповiдае формату  ${provider}  ${submission_data}
  Should Contain    ${error_message}    "description": [{"address": ["This field is required."]


Неможливість подати заявку учасником, якщо поле "tenderers.address" null
  [Tags]   ${USERS.users['${provider}'].broker}: Подання пропозиції
  ...      provider
  ...      ${USERS.users['${provider}'].broker}
  ...      submission_negative_tests
  ...      critical
  [Teardown]  Оновити QUALIFICATION_LAST_MODIFICATION_DATE
  ${submission_data}=  Підготувати дані для регістрації заявки
  Set To Dictionary    ${submission_data.data.tenderers[0]}  address=${Null}
  ${error_message}  Run Keyword And Expect Error    *
  ...      Неможливість зареєструвати заявку, якщо запит не вiдповiдае формату  ${provider}  ${submission_data}
  Should Contain    ${error_message}    "description": [{"address": ["This field is required."]


Неможливість подати заявку учасником, якщо відсутнє поле "tenderers.address.countryName"
  [Tags]   ${USERS.users['${provider}'].broker}: Подання пропозиції
  ...      provider
  ...      ${USERS.users['${provider}'].broker}
  ...      submission_negative_tests
  ...      critical
  [Teardown]  Оновити QUALIFICATION_LAST_MODIFICATION_DATE
  ${submission_data}=  Підготувати дані для регістрації заявки
  Delete From Dictionary    ${submission_data.data.tenderers[0].address}  countryName
  ${error_message}  Run Keyword And Expect Error    *
  ...      Неможливість зареєструвати заявку, якщо запит не вiдповiдае формату  ${provider}  ${submission_data}
  Should Contain    ${error_message}     "description": [{"address": {"countryName": ["This field is required."]


Неможливість подати заявку учасником, якщо поле "tenderers.address.countryName" null
  [Tags]   ${USERS.users['${provider}'].broker}: Подання пропозиції
  ...      provider
  ...      ${USERS.users['${provider}'].broker}
  ...      submission_negative_tests
  ...      critical
  [Teardown]  Оновити QUALIFICATION_LAST_MODIFICATION_DATE
  ${submission_data}=  Підготувати дані для регістрації заявки
  Set To Dictionary    ${submission_data.data.tenderers[0].address}  countryName=${Null}
  ${error_message}  Run Keyword And Expect Error    *
  ...      Неможливість зареєструвати заявку, якщо запит не вiдповiдае формату  ${provider}  ${submission_data}
  Should Contain    ${error_message}    "description": [{"address": {"countryName": ["This field is required."]


Неможливість подати заявку учасником, якщо поле "tenderers.address.countryName" не відповідає формату
  [Tags]   ${USERS.users['${provider}'].broker}: Подання пропозиції
  ...      provider
  ...      ${USERS.users['${provider}'].broker}
  ...      submission_negative_tests
  ...      critical
  [Teardown]  Оновити QUALIFICATION_LAST_MODIFICATION_DATE
  ${submission_data}=  Підготувати дані для регістрації заявки
  Set To Dictionary    ${submission_data.data.tenderers[0].address}  countryName=Украiна4
  ${error_message}  Run Keyword And Expect Error    *
  ...      Неможливість зареєструвати заявку, якщо запит не вiдповiдае формату  ${provider}  ${submission_data}
  Should Contain    ${error_message}    "description": [{"address": {"countryName": ["field address:countryName not exist in countries catalog"]


Неможливість подати заявку учасником, якщо відсутнє поле "tenderers.address.postalCode"
  [Tags]   ${USERS.users['${provider}'].broker}: Подання пропозиції
  ...      provider
  ...      ${USERS.users['${provider}'].broker}
  ...      submission_negative_tests
  ...      critical
  [Teardown]  Оновити QUALIFICATION_LAST_MODIFICATION_DATE
  ${submission_data}=  Підготувати дані для регістрації заявки
  Delete From Dictionary    ${submission_data.data.tenderers[0].address}  postalCode
  ${error_message}  Run Keyword And Expect Error    *
  ...      Неможливість зареєструвати заявку, якщо запит не вiдповiдае формату  ${provider}  ${submission_data}
  Should Contain    ${error_message}      "description": [{"address": {"postalCode": ["This field is required."]


Неможливість подати заявку учасником, якщо поле "tenderers.address.postalCode" null
  [Tags]   ${USERS.users['${provider}'].broker}: Подання пропозиції
  ...      provider
  ...      ${USERS.users['${provider}'].broker}
  ...      submission_negative_tests
  ...      critical
  [Teardown]  Оновити QUALIFICATION_LAST_MODIFICATION_DATE
  ${submission_data}=  Підготувати дані для регістрації заявки
  Set To Dictionary    ${submission_data.data.tenderers[0].address}  postalCode=${Null}
  ${error_message}  Run Keyword And Expect Error    *
  ...      Неможливість зареєструвати заявку, якщо запит не вiдповiдае формату  ${provider}  ${submission_data}
  Should Contain    ${error_message}    "description": [{"address": {"postalCode": ["This field is required."]


Неможливість подати заявку учасником, якщо відсутнє поле "tenderers.address.region"
  [Tags]   ${USERS.users['${provider}'].broker}: Подання пропозиції
  ...      provider
  ...      ${USERS.users['${provider}'].broker}
  ...      submission_negative_tests
  ...      critical
  [Teardown]  Оновити QUALIFICATION_LAST_MODIFICATION_DATE
  ${submission_data}=  Підготувати дані для регістрації заявки
  Delete From Dictionary    ${submission_data.data.tenderers[0].address}  region
  ${error_message}  Run Keyword And Expect Error    *
  ...      Неможливість зареєструвати заявку, якщо запит не вiдповiдае формату  ${provider}  ${submission_data}
  Should Contain    ${error_message}     "description": [{"address": {"region": ["This field is required."]}


Неможливість подати заявку учасником, якщо поле "tenderers.address.region" null
  [Tags]   ${USERS.users['${provider}'].broker}: Подання пропозиції
  ...      provider
  ...      ${USERS.users['${provider}'].broker}
  ...      submission_negative_tests
  ...      critical
  [Teardown]  Оновити QUALIFICATION_LAST_MODIFICATION_DATE
  ${submission_data}=  Підготувати дані для регістрації заявки
  Set To Dictionary    ${submission_data.data.tenderers[0].address}  region=${Null}
  ${error_message}  Run Keyword And Expect Error    *
  ...      Неможливість зареєструвати заявку, якщо запит не вiдповiдае формату  ${provider}  ${submission_data}
  Should Contain    ${error_message}    "description": [{"address": {"region": ["This field is required."]}


Неможливість подати заявку учасником, якщо відсутнє поле "tenderers.address.locality"
  [Tags]   ${USERS.users['${provider}'].broker}: Подання пропозиції
  ...      provider
  ...      ${USERS.users['${provider}'].broker}
  ...      submission_negative_tests
  ...      critical
  [Teardown]  Оновити QUALIFICATION_LAST_MODIFICATION_DATE
  ${submission_data}=  Підготувати дані для регістрації заявки
  Delete From Dictionary    ${submission_data.data.tenderers[0].address}  locality
  ${error_message}  Run Keyword And Expect Error    *
  ...      Неможливість зареєструвати заявку, якщо запит не вiдповiдае формату  ${provider}  ${submission_data}
  Should Contain    ${error_message}     "description": [{"address": {"locality": ["This field is required."]


Неможливість подати заявку учасником, якщо поле "tenderers.address.locality" null
  [Tags]   ${USERS.users['${provider}'].broker}: Подання пропозиції
  ...      provider
  ...      ${USERS.users['${provider}'].broker}
  ...      submission_negative_tests
  ...      critical
  [Teardown]  Оновити QUALIFICATION_LAST_MODIFICATION_DATE
  ${submission_data}=  Підготувати дані для регістрації заявки
  Set To Dictionary    ${submission_data.data.tenderers[0].address}  locality=${Null}
  ${error_message}  Run Keyword And Expect Error    *
  ...      Неможливість зареєструвати заявку, якщо запит не вiдповiдае формату  ${provider}  ${submission_data}
  Should Contain    ${error_message}    "description": [{"address": {"locality": ["This field is required."]


Неможливість подати заявку учасником, якщо відсутнє поле "tenderers.address.streetAddress"
  [Tags]   ${USERS.users['${provider}'].broker}: Подання пропозиції
  ...      provider
  ...      ${USERS.users['${provider}'].broker}
  ...      submission_negative_tests
  ...      critical
  [Teardown]  Оновити QUALIFICATION_LAST_MODIFICATION_DATE
  ${submission_data}=  Підготувати дані для регістрації заявки
  Delete From Dictionary    ${submission_data.data.tenderers[0].address}  streetAddress
  ${error_message}  Run Keyword And Expect Error    *
  ...      Неможливість зареєструвати заявку, якщо запит не вiдповiдае формату  ${provider}  ${submission_data}
  Should Contain    ${error_message}     "description": [{"address": {"streetAddress": ["This field is required."]


Неможливість подати заявку учасником, якщо поле "tenderers.address.streetAddress" null
  [Tags]   ${USERS.users['${provider}'].broker}: Подання пропозиції
  ...      provider
  ...      ${USERS.users['${provider}'].broker}
  ...      submission_negative_tests
  ...      critical
  [Teardown]  Оновити QUALIFICATION_LAST_MODIFICATION_DATE
  ${submission_data}=  Підготувати дані для регістрації заявки
  Set To Dictionary    ${submission_data.data.tenderers[0].address}  streetAddress=${Null}
  ${error_message}  Run Keyword And Expect Error    *
  ...      Неможливість зареєструвати заявку, якщо запит не вiдповiдае формату  ${provider}  ${submission_data}
  Should Contain    ${error_message}    "description": [{"address": {"streetAddress": ["This field is required."]


Неможливість подати заявку учасником, якщо відсутнє поле "tenderers.contactPoint"
  [Tags]   ${USERS.users['${provider}'].broker}: Подання пропозиції
  ...      provider
  ...      ${USERS.users['${provider}'].broker}
  ...      submission_negative_tests
  ...      critical
  [Teardown]  Оновити QUALIFICATION_LAST_MODIFICATION_DATE
  ${submission_data}=  Підготувати дані для регістрації заявки
  Delete From Dictionary    ${submission_data.data.tenderers[0]}  contactPoint
  ${error_message}  Run Keyword And Expect Error    *
  ...      Неможливість зареєструвати заявку, якщо запит не вiдповiдае формату  ${provider}  ${submission_data}
  Should Contain    ${error_message}      "description": [{"contactPoint": ["This field is required."]


Неможливість подати заявку учасником, якщо поле "tenderers.contactPoint" null
  [Tags]   ${USERS.users['${provider}'].broker}: Подання пропозиції
  ...      provider
  ...      ${USERS.users['${provider}'].broker}
  ...      submission_negative_tests
  ...      critical
  [Teardown]  Оновити QUALIFICATION_LAST_MODIFICATION_DATE
  ${submission_data}=  Підготувати дані для регістрації заявки
  Set To Dictionary    ${submission_data.data.tenderers[0]}  contactPoint=${Null}
  ${error_message}  Run Keyword And Expect Error    *
  ...      Неможливість зареєструвати заявку, якщо запит не вiдповiдае формату  ${provider}  ${submission_data}
  Should Contain    ${error_message}     "description": [{"contactPoint": ["This field is required."]


Неможливість подати заявку учасником, якщо відсутнє поле "tenderers.contactPoint.name"
  [Tags]   ${USERS.users['${provider}'].broker}: Подання пропозиції
  ...      provider
  ...      ${USERS.users['${provider}'].broker}
  ...      submission_negative_tests
  ...      critical
  [Teardown]  Оновити QUALIFICATION_LAST_MODIFICATION_DATE
  ${submission_data}=  Підготувати дані для регістрації заявки
  Delete From Dictionary    ${submission_data.data.tenderers[0].contactPoint}  name
  ${error_message}  Run Keyword And Expect Error    *
  ...      Неможливість зареєструвати заявку, якщо запит не вiдповiдае формату  ${provider}  ${submission_data}
  Should Contain    ${error_message}      "description": [{"contactPoint": {"name": ["This field is required."]


Неможливість подати заявку учасником, якщо поле "tenderers.contactPoint.name" null
  [Tags]   ${USERS.users['${provider}'].broker}: Подання пропозиції
  ...      provider
  ...      ${USERS.users['${provider}'].broker}
  ...      submission_negative_tests
  ...      critical
  [Teardown]  Оновити QUALIFICATION_LAST_MODIFICATION_DATE
  ${submission_data}=  Підготувати дані для регістрації заявки
  Set To Dictionary    ${submission_data.data.tenderers[0].contactPoint}  name=${Null}
  ${error_message}  Run Keyword And Expect Error    *
  ...      Неможливість зареєструвати заявку, якщо запит не вiдповiдае формату  ${provider}  ${submission_data}
  Should Contain    ${error_message}     "description": [{"contactPoint": {"name": ["This field is required."]


Неможливість подати заявку учасником, якщо відсутнє поле "tenderers.contactPoint.email"
  [Tags]   ${USERS.users['${provider}'].broker}: Подання пропозиції
  ...      provider
  ...      ${USERS.users['${provider}'].broker}
  ...      submission_negative_tests
  ...      critical
  [Teardown]  Оновити QUALIFICATION_LAST_MODIFICATION_DATE
  ${submission_data}=  Підготувати дані для регістрації заявки
  Delete From Dictionary    ${submission_data.data.tenderers[0].contactPoint}  email
  ${error_message}  Run Keyword And Expect Error    *
  ...      Неможливість зареєструвати заявку, якщо запит не вiдповiдае формату  ${provider}  ${submission_data}
  Should Contain    ${error_message}     "description": [{"contactPoint": {"email": ["This field is required."]}


Неможливість подати заявку учасником, якщо поле "tenderers.contactPoint.email" null
  [Tags]   ${USERS.users['${provider}'].broker}: Подання пропозиції
  ...      provider
  ...      ${USERS.users['${provider}'].broker}
  ...      submission_negative_tests
  ...      critical
  [Teardown]  Оновити QUALIFICATION_LAST_MODIFICATION_DATE
  ${submission_data}=  Підготувати дані для регістрації заявки
  Set To Dictionary    ${submission_data.data.tenderers[0].contactPoint}  email=${Null}
  ${error_message}  Run Keyword And Expect Error    *
  ...      Неможливість зареєструвати заявку, якщо запит не вiдповiдае формату  ${provider}  ${submission_data}
  Should Contain    ${error_message}    "description": [{"contactPoint": {"email": ["This field is required."]}


Неможливість подати заявку учасником, якщо поле "tenderers.contactPoint.email" не відповідає формату
  [Tags]   ${USERS.users['${provider}'].broker}: Подання пропозиції
  ...      provider
  ...      ${USERS.users['${provider}'].broker}
  ...      submission_negative_tests
  ...      critical
  [Teardown]  Оновити QUALIFICATION_LAST_MODIFICATION_DATE
  ${submission_data}=  Підготувати дані для регістрації заявки
  Set To Dictionary    ${submission_data.data.tenderers[0].contactPoint}  email=aap#1aa1.com
  ${error_message}  Run Keyword And Expect Error    *
  ...      Неможливість зареєструвати заявку, якщо запит не вiдповiдае формату  ${provider}  ${submission_data}
  Should Contain    ${error_message}     "description": [{"contactPoint": {"email": ["Not a well formed email address."]


Неможливість подати заявку учасником, якщо відсутнє поле "tenderers.scale"
  [Tags]   ${USERS.users['${provider}'].broker}: Подання пропозиції
  ...      provider
  ...      ${USERS.users['${provider}'].broker}
  ...      submission_negative_tests
  ...      critical
  [Teardown]  Оновити QUALIFICATION_LAST_MODIFICATION_DATE
  ${submission_data}=  Підготувати дані для регістрації заявки
  Delete From Dictionary    ${submission_data.data.tenderers[0]}  scale
  ${error_message}  Run Keyword And Expect Error    *
  ...      Неможливість зареєструвати заявку, якщо запит не вiдповiдае формату  ${provider}  ${submission_data}
  Should Contain    ${error_message}     "description": [{"scale": ["This field is required."]


Неможливість подати заявку учасником, якщо поле "tenderers.scale" null
  [Tags]   ${USERS.users['${provider}'].broker}: Подання пропозиції
  ...      provider
  ...      ${USERS.users['${provider}'].broker}
  ...      submission_negative_tests
  ...      critical
  [Teardown]  Оновити QUALIFICATION_LAST_MODIFICATION_DATE
  ${submission_data}=  Підготувати дані для регістрації заявки
  Set To Dictionary    ${submission_data.data.tenderers[0]}  scale=${Null}
  ${error_message}  Run Keyword And Expect Error    *
  ...      Неможливість зареєструвати заявку, якщо запит не вiдповiдае формату  ${provider}  ${submission_data}
  Should Contain    ${error_message}    "description": [{"scale": ["This field is required."]


Неможливість подати заявку учасником, якщо поле "tenderers.scale" не відповідає формату
  [Tags]   ${USERS.users['${provider}'].broker}: Подання пропозиції
  ...      provider
  ...      ${USERS.users['${provider}'].broker}
  ...      submission_negative_tests
  ...      critical
  [Teardown]  Оновити QUALIFICATION_LAST_MODIFICATION_DATE
  ${submission_data}=  Підготувати дані для регістрації заявки
  Set To Dictionary    ${submission_data.data.tenderers[0]}  scale=micro6
  ${error_message}  Run Keyword And Expect Error    *
  ...      Неможливість зареєструвати заявку, якщо запит не вiдповiдае формату  ${provider}  ${submission_data}
  Should Contain    ${error_message}     "description": [{"scale": ["Value must be one of ['micro', 'sme', 'mid', 'large', 'not specified']


Неможливість подати заявку учасником, якщо не вказати "frameworkID"
  [Tags]   ${USERS.users['${provider}'].broker}: Подання пропозиції
  ...      provider
  ...      ${USERS.users['${provider}'].broker}
  ...      submission_negative_tests
  ...      critical
  [Teardown]  Оновити QUALIFICATION_LAST_MODIFICATION_DATE
  ${submission_data}=  Підготувати дані для регістрації заявки
  Delete From Dictionary    ${submission_data.data}  frameworkID
  ${error_message}  Run Keyword And Expect Error    *
  ...      Неможливість зареєструвати заявку, якщо запит не вiдповiдае формату  ${provider}  ${submission_data}
  Should Contain    ${error_message}     "description": "frameworkID must be one of exists frameworks"}


Неможливість подати заявку учасником, якщо вказати неіснуючий "frameworkID"
  [Tags]   ${USERS.users['${provider}'].broker}: Подання пропозиції
  ...      provider
  ...      ${USERS.users['${provider}'].broker}
  ...      submission_negative_tests
  ...      critical
  [Teardown]  Оновити QUALIFICATION_LAST_MODIFICATION_DATE
  ${submission_data}=  Підготувати дані для регістрації заявки
  Set To Dictionary    ${submission_data.data}  frameworkID=123456789
  ${error_message}  Run Keyword And Expect Error    *
  ...      Неможливість зареєструвати заявку, якщо запит не вiдповiдае формату  ${provider}  ${submission_data}
  Should Contain    ${error_message}     "description": "frameworkID must be one of exists frameworks"}


Неможливість подати заявку учасником, якщо вказати "frameworkID" null
  [Tags]   ${USERS.users['${provider}'].broker}: Подання пропозиції
  ...      provider
  ...      ${USERS.users['${provider}'].broker}
  ...      submission_negative_tests
  ...      critical
  [Teardown]  Оновити QUALIFICATION_LAST_MODIFICATION_DATE
  ${submission_data}=  Підготувати дані для регістрації заявки
  Set To Dictionary    ${submission_data.data}  frameworkID=${Null}
  ${error_message}  Run Keyword And Expect Error    *
  ...      Неможливість зареєструвати заявку, якщо запит не вiдповiдае формату  ${provider}  ${submission_data}
  Should Contain    ${error_message}     "description": "frameworkID must be one of exists frameworks"}


#===== PATCH_submissions{id} =====

Неможливість перевести заявку з draft в complete
  [Tags]   ${USERS.users['${provider}'].broker}: Редагування заявки
  ...      ${provider}
  ...      ${USERS.users['${provider}'].broker}
  ...      change_status
  ...      critical
  ${error_message}  Run Keyword And Expect Error    *
  ...      Можливість редагувати заявку   ${provider}  complete
  Should Contain    ${error_message}  "description": "Can't update submission from current (draft) to new (complete) status"}


Можливість перевести заявку з draft в update
  [Tags]   ${USERS.users['${provider}'].broker}: Редагування заявки
  ...      provider1
  ...      ${USERS.users['${provider}'].broker}
  ...      change_status
  ...      critical
  Можливість редагувати заявку  ${provider}  update


Можливість видалити заявку першого постачальника з кваліфікації
  [Tags]   ${USERS.users['${provider}'].broker}: Редагування заявки
  ...      ${provider}
  ...      ${USERS.users['${provider}'].broker}
  ...      delete_submission
  ...      critical
  Можливість редагувати заявку   ${provider}  deleted


Неможливість змiнити статус заявки зi статусу delete
  [Tags]   ${USERS.users['${provider}'].broker}: Редагування заявки
  ...      ${provider}
  ...      ${USERS.users['${provider}'].broker}
  ...      change_status
  ...      critical
  Run Keyword And Expect Error    *  Можливість редагувати заявку  ${provider}  update


Неможливість завантажити документ по заявці, якщо заявка у статусi "deleted"
  [Tags]   ${USERS.users['${provider}'].broker}: Завантажити документ по заявці
  ...      provider
  ...      ${USERS.users['${provider}'].broker}
  ...      add_doc_to_submission
  ...      critical
  [Teardown]  Оновити QUALIFICATION_LAST_MODIFICATION_DATE
   ${file_path}  ${file_name}  ${file_content}=  create_fake_doc
   ${error_message}  Run Keyword And Expect Error    *  Завантажити документ по заявці  ${provider}  ${file_path}
   Should Contain    ${error_message}   "Can't add document in current (deleted) submission status"
   Remove File  ${file_path}


Неможливість оновити документ по заявці, якщо заявка у статусi "deleted"
  [Tags]   ${USERS.users['${provider}'].broker}: Оновленя документу
  ...      tender_owner
  ...      ${USERS.users['${provider}'].broker}
  ...      document_negative_tests
  ...      critical
  ${file_path}  ${file_name}  ${file_content}=  create_fake_doc
  ${error}  Run Keyword And Expect Error  *
  ...    Оновити зареєстрований документ у заявцi  ${provider}  ${file_path}
  Should Contain    ${error}   "Can't update document in current (deleted) submission status"


Неможливість змiнити документ, якщо заявка у статусi "deleted"
  [Tags]   ${USERS.users['${provider}'].broker}: Оновленя документу
  ...      tender_owner
  ...      ${USERS.users['${provider}'].broker}
  ...      document_negative_tests
  ...      critical
  ${field}=  Set Variable    title
  ${document}=  change_field_value_in_document  ${field}  title
  ${error}=  Run Keyword And Expect Error  *
  ...    Оновити значеня поля документа у заявцi  ${provider}  ${document}
  Should Contain    ${error}     "Can't update document in current (deleted) submission status"


Неможливість повторно активувати заявку другого постачальника у кваліфікації
  [Tags]   ${USERS.users['${provider1}'].broker}: Редагування заявки
  ...      provider1
  ...      ${USERS.users['${provider1}'].broker}
  ...      submission_negative_tests
  ...      critical
  ${error_message}  Run Keyword And Expect Error    *
  ...      Можливість редагувати заявку  ${provider1}  active
  Should Contain    ${error_message}  "description": "Can't update submission in current (active) status"


Неможливість перевести заявку з active в deleted
  [Tags]   ${USERS.users['${provider1}'].broker}: Редагування заявки
  ...      provider1
  ...      ${USERS.users['${provider1}'].broker}
  ...      change_status
  ...      critical
  ${error_message}  Run Keyword And Expect Error    *
  ...      Можливість редагувати заявку  ${provider1}  deleted
  Should Contain    ${error_message}  "description": "Can't update submission in current (active) status"


Неможливість перевести заявку з active в complete
  [Tags]   ${USERS.users['${provider1}'].broker}: Редагування заявки
  ...      provider1
  ...      ${USERS.users['${provider1}'].broker}
  ...      change_status
  ...      critical
  ${error_message}  Run Keyword And Expect Error    *
  ...      Можливість редагувати заявку  ${provider1}  complete
  Should Contain    ${error_message}  "description": "Can't update submission in current (active) status"


Неможливість повторно подати заявку, якщо у учасника вже е заявка у стаусi "active"
  [Tags]   ${USERS.users['${provider1}'].broker}: Подання пропозиції
  ...      provider1
  ...      ${USERS.users['${provider1}'].broker}
  ...      change_status
  ...      critical
  [Teardown]  Оновити QUALIFICATION_LAST_MODIFICATION_DATE
  Можливість зареєструвати заявку  ${provider1}
  ${error_message}  Run Keyword And Expect Error    *
  ...      Можливість редагувати заявку  ${provider1}  active
  Should Contain    ${error_message}   "description": "Tenderer already have active submission for framework


Неможливість активувати заявку постачальника, aкщо статус не відповідає формату
  [Tags]   ${USERS.users['${provider1}'].broker}: Редагування заявки
  ...      provider1
  ...      ${USERS.users['${provider1}'].broker}
  ...      change_status
  ...      critical
  ${error_message}  Run Keyword And Expect Error    *
  ...      Можливість редагувати заявку  ${provider1}  active3
  Should Contain    ${error_message}  "description": ["Value must be one of ['draft', 'active', 'deleted', 'complete']


Можливість знайти заявку по ідентифікатору
  [Tags]   ${USERS.users['${viewer}'].broker}: Пошук заявки
  ...      viewer  tender_owner
  ...      ${USERS.users['${viewer}'].broker}  ${USERS.users['${tender_owner}'].broker}
  ...      find_submission
  ...      critical
  ${submission_id}=  Set Variable    ${USERS.users['${provider1}'].submission_data.data.id}
  Run As  ${viewer}  Пошук заявки по ідентифікатору  ${submission_id}


Неможливість змiнити заявку учасником у статусі active
  [Tags]   ${USERS.users['${provider1}'].broker}: Подання пропозиції
  ...      provider1
  ...      ${USERS.users['${provider1}'].broker}
  ...      submission_negative_tests
  ...      critical
  [Teardown]  Оновити QUALIFICATION_LAST_MODIFICATION_DATE
  ${submission_data}=  Підготувати дані для регістрації заявки
  Set To Dictionary    ${submission_data.data.tenderers[0]}  scale=micro
  ${error_message}  Run Keyword And Expect Error    *
  ...      Неможливість редагувати заявку  ${provider1}  ${submission_data}
  Should Contain    ${error_message}     "Can't update submission in current (active) status"


Неможливість змiнити заявку учасником, якщо поле "tenderers.scale" не відповідає формату
  [Tags]   ${USERS.users['${provider2}'].broker}: Подання пропозиції
  ...      provider2
  ...      ${USERS.users['${provider2}'].broker}
  ...      submission_negative_tests
  ...      critical
  [Teardown]  Оновити QUALIFICATION_LAST_MODIFICATION_DATE
  ${submission_data}=  Підготувати дані для регістрації заявки
  Set To Dictionary    ${submission_data.data.tenderers[0]}  scale=micro6
  ${error_message}  Run Keyword And Expect Error    *
  ...      Неможливість редагувати заявку  ${provider2}  ${submission_data}
  Should Contain    ${error_message}     "description": [{"scale": ["Value must be one of ['micro', 'sme', 'mid', 'large', 'not specified']


Неможливість змiнити заявку учасником, якщо поле "tenderers.identifier.scheme" не відповідає формату
  [Tags]   ${USERS.users['${provider2}'].broker}: Подання пропозиції
  ...      provider2
  ...      ${USERS.users['${provider2}'].broker}
  ...      submission_negative_tests
  ...      critical
  [Teardown]  Оновити QUALIFICATION_LAST_MODIFICATION_DATE
  ${submission_data}=  Підготувати дані для регістрації заявки
  Set To Dictionary    ${submission_data.data.tenderers[0].identifier}  scheme=AE-ACC13
  ${error_message}  Run Keyword And Expect Error    *
  ...      Неможливість редагувати заявку  ${provider2}  ${submission_data}
  Should Contain    ${error_message}   "description": [{"identifier": {"scheme": ["Value must be one of ['AE-ACCI',


Неможливість змiнити заявку учасником, якщо поле "tenderers.address.countryName" не відповідає формату
  [Tags]   ${USERS.users['${provider2}'].broker}: Подання пропозиції
  ...      provider2
  ...      ${USERS.users['${provider2}'].broker}
  ...      submission_negative_tests
  ...      critical
  [Teardown]  Оновити QUALIFICATION_LAST_MODIFICATION_DATE
  ${submission_data}=  Підготувати дані для регістрації заявки
  Set To Dictionary    ${submission_data.data.tenderers[0].address}  countryName=Украiна4
  ${error_message}  Run Keyword And Expect Error    *
  ...      Неможливість редагувати заявку  ${provider2}  ${submission_data}
  Should Contain    ${error_message}    "description": [{"address": {"countryName": ["field address:countryName not exist in countries catalog"]


Неможливість змiнити заявку учасником, якщо поле "tenderers.contactPoint.email" не відповідає формату
  [Tags]   ${USERS.users['${provider2}'].broker}: Подання пропозиції
  ...      provider2
  ...      ${USERS.users['${provider2}'].broker}
  ...      submission_negative_tests
  ...      critical
  [Teardown]  Оновити QUALIFICATION_LAST_MODIFICATION_DATE
  ${submission_data}=  Підготувати дані для регістрації заявки
  Set To Dictionary    ${submission_data.data.tenderers[0].contactPoint}  email=aap#1aa1.com
  ${error_message}  Run Keyword And Expect Error    *
  ...      Неможливість редагувати заявку  ${provider2}  ${submission_data}
  Should Contain    ${error_message}     "description": [{"contactPoint": {"email": ["Not a well formed email address."]






Перевірити статус об’єкта рішення по заявці pending
  [Tags]   ${USERS.users['${provider1}'].broker}: Відображення кваліфікації
  ...      provider1
  ...      ${USERS.users['${provider1}'].broker}
  ...      framework_view
  ...      critical
  Run As  ${provider1}  Можливість перевірити статус об’єкта рішення по заявці  pending


Можливість завантажити документ рішення кваліфікаційної комісії для підтвердження другого постачальника
  [Tags]  ${USERS.users['${tender_owner}'].broker}: Процес кваліфікації
  ...  tender_owner
  ...  ${USERS.users['${tender_owner}'].broker}
  ...  add_doc_to_framework
  ...  critical
  ${submission}=  Set Variable    ${USERS.users['${provider1}'].submission_data}
  ${file_path}  ${file_name}  ${file_content}=   create_fake_doc
  Run As   ${tender_owner}   Завантажити документ рішення кваліфікаційної комісії по заявці   ${file_path}  ${submission}
  Remove File  ${file_path}


Можливість відхилити другого постачальника
  [Tags]  ${USERS.users['${tender_owner}'].broker}: Процес кваліфікації
  ...  tender_owner
  ...  ${USERS.users['${tender_owner}'].broker}
  ...  delete_submission
  ...  critical
  ${submission}=  Set Variable    ${USERS.users['${provider1}'].submission_data}
  Run As  ${tender_owner}  Змiнити статус по заявці  ${submission}  unsuccessful


Перевірити статус по заявці complete
  [Tags]   ${USERS.users['${viewer}'].broker}: Відображення кваліфікації
  ...      viewer
  ...      ${USERS.users['${viewer}'].broker}
  ...      view_submissions
  ...      critical
  Run As  ${viewer}  Можливість перевірити статус по заявці  complete


Mожливість активувати заявку третього постачальника у кваліфікації
  [Tags]   ${USERS.users['${provider2}'].broker}: Редагування заявки
  ...      provider2
  ...      ${USERS.users['${provider2}'].broker}
  ...      activate_submission
  ...      critical
  Run Keyword  Можливість редагувати заявку  ${provider2}  active


Можливість завантажити документ рішення кваліфікаційної комісії для підтвердження третього постачальника
  [Tags]  ${USERS.users['${tender_owner}'].broker}: Процес кваліфікації
  ...  tender_owner
  ...  ${USERS.users['${tender_owner}'].broker}
  ...  add_doc_to_framework
  ...  critical
  ${submission}=  Set Variable    ${USERS.users['${provider2}'].submission_data}
  ${file_path}  ${file_name}  ${file_content}=   create_fake_doc
  Run As   ${tender_owner}   Завантажити документ рішення кваліфікаційної комісії по заявці   ${file_path}  ${submission}
  Remove File  ${file_path}


Можливість підтвердження рішення по заявці для третього постачальника
  [Tags]  ${USERS.users['${tender_owner}'].broker}: Процес кваліфікації
  ...  tender_owner
  ...  ${USERS.users['${tender_owner}'].broker}
  ...  confirm_submission
  ...  critical
  ${submission}=  Set Variable    ${USERS.users['${provider2}'].submission_data}
  Run As  ${tender_owner}  Змiнити статус по заявці  ${submission}  active


Перевірити наявність поля agreementID у квалiфiкацii після підтвердження рішення по заявці
  [Tags]  ${USERS.users['${tender_owner}'].broker}: Процес кваліфікації
  ...  tender_owner
  ...  ${USERS.users['${tender_owner}'].broker}
  ...  framework_view
  ...  critical
  ${field}=  Set Variable    agreementID
  FOR  ${username}  IN  @{USED_ROLES}
    ${framework}=  Run As  ${${username}}  Пошук фреймворку по ідентифікатору  ${QUALIFICATION['QUALIFICATION_UAID']}
  END
  Звірити наявність поля agreementID фреймворку для усіх користувачів


Можливість oтримання реєстру
  [Tags]  ${USERS.users['${tender_owner}'].broker}: Відображення реєстру
  ...  tender_owner
  ...  ${USERS.users['${tender_owner}'].broker}
  ...  framework_view
  ...  critical
  ${agreement_id}=  Set Variable    ${USERS.users['${tender_owner}'].qualification_data.data.agreementID}
  ${agreement}=  Run As  ${tender_owner}  Oтримання реєстру  ${agreement_id}
  Set to Dictionary  ${USERS.users['${tender_owner}']}  agreement_data=${agreement}
  Log   ${agreement}


Можливість завантажити документ у milestone
  [Tags]   ${USERS.users['${tender_owner}'].broker}: Завантажити документ у milestone
  ...      tender_owner
  ...      ${USERS.users['${tender_owner}'].broker}
  ...      add_doc_to_framework
  ...      critical
  [Teardown]  Оновити QUALIFICATION_LAST_MODIFICATION_DATE
   ${file_path}  ${file_name}  ${file_content}=  create_fake_doc
   Run As  ${tender_owner}  Завантажити документ у milestone  ${file_path}
   ${milestone_doc}=  Create Dictionary
   ...    doc_name=${file_name}
   ...    doc_content=${file_content}
   Set To Dictionary   ${USERS.users['${tender_owner}']}  milestone_document=${milestone_doc}
   Remove File  ${file_path}


Бан контракту
  [Tags]   ${USERS.users['${tender_owner}'].broker}: Бан контракту
  ...      tender_owner
  ...      ${USERS.users['${tender_owner}'].broker}
  ...      ban_contract
  ...      critical
  ${document}=  Set Variable   ${USERS.users['${tender_owner}'].documents}
  ${data}=  test_ban_contract_data  ${document}
  log  ${data}
  ${reply}=  Call Method  ${USERS.users['${tender_owner}'].agreement_client}  ban_contract
  ...      ${USERS.users['${tender_owner}'].qualification_data.data.agreementID}
  ...      ${USERS.users['${tender_owner}'].agreement_data.data.contracts[0].id}
  ...      ${data}
  ...      access_token=${USERS.users['${tender_owner}'].access_token}
  Log  ${reply}


Перевірити статус по контракту пiсля бану
  [Tags]   ${USERS.users['${viewer}'].broker}: Відображення статусу по контракту
  ...      viewer
  ...      ${USERS.users['${viewer}'].broker}
  ...      framework_view
  ...      critical
  Run As  ${viewer}  Можливість перевірити статус по контракту  suspended


Можливість дискваліфікувати контракт
  [Tags]   ${USERS.users['${tender_owner}'].broker}: Дискваліфікацiя контракту
  ...      tender_owner
  ...      ${USERS.users['${tender_owner}'].broker}
  ...      disqualify_contract
  ...      critical
  ${data}=  test_status_data  met
  ${reply}=  Call Method  ${USERS.users['${tender_owner}'].agreement_client}  disqualify_contract
  ...      ${USERS.users['${tender_owner}'].qualification_data.data.agreementID}
  ...      ${USERS.users['${tender_owner}'].agreement_data.data.contracts[0].id}
  ...      ${USERS.users['${tender_owner}'].agreement_data.data.contracts[0].milestones[0].id}
  ...      ${data}
  ...      access_token=${USERS.users['${tender_owner}'].access_token}
  Log  ${reply}


Перевірити статус по контракту пiсля дискваліфікацii
  [Tags]   ${USERS.users['${viewer}'].broker}: Відображення статусу по контракту
  ...      viewer
  ...      ${USERS.users['${viewer}'].broker}
  ...      framework_view
  ...      critical
  Run As  ${viewer}  Можливість перевірити статус по контракту  terminated


#===== POST_frameworks =====

Неможливість оголосити фреймворк, не заповнивши поле "procuringEntity"
  [Tags]   ${USERS.users['${tender_owner}'].broker}: Оголошення фреймворку
  ...      tender_owner
  ...      ${USERS.users['${tender_owner}'].broker}
  ...      create_framework_with_wrong_fields
  ...      critical
  Run Keyword And Expect Error    *  Можливість створити фреймворк  procuringEntity


Неможливість оголосити фреймворк, не заповнивши поле "procuringEntity.contactPoint"
  [Tags]   ${USERS.users['${tender_owner}'].broker}: Оголошення фреймворку
  ...      tender_owner
  ...      ${USERS.users['${tender_owner}'].broker}
  ...      create_framework_with_wrong_fields
  ...      critical
  Run Keyword And Expect Error    *  Можливість створити фреймворк  contactPoint


Неможливість оголосити фреймворк, не заповнивши поле "email"
  [Tags]   ${USERS.users['${tender_owner}'].broker}: Оголошення фреймворку
  ...      tender_owner
  ...      ${USERS.users['${tender_owner}'].broker}
  ...      create_framework_with_wrong_fields
  ...      critical
  Run Keyword And Expect Error    *  Можливість створити фреймворк  email


Неможливість оголосити фреймворк, якщо поле "email" не відповідає формату
  [Tags]   ${USERS.users['${tender_owner}'].broker}: Оголошення фреймворку
  ...      tender_owner
  ...      ${USERS.users['${tender_owner}'].broker}
  ...      create_framework_with_wrong_fields
  ...      critical
  Run Keyword And Expect Error    *  Можливість створити фреймворк  bad_format_email


Неможливість оголосити фреймворк, не заповнивши поле "name"
  [Tags]   ${USERS.users['${tender_owner}'].broker}: Оголошення фреймворку
  ...      tender_owner
  ...      ${USERS.users['${tender_owner}'].broker}
  ...      create_framework_with_wrong_fields
  ...      critical
  Run Keyword And Expect Error    *  Можливість створити фреймворк  name


Неможливість оголосити фреймворк, не заповнивши поле "identifier"
  [Tags]   ${USERS.users['${tender_owner}'].broker}: Оголошення фреймворку
  ...      tender_owner
  ...      ${USERS.users['${tender_owner}'].broker}
  ...      create_framework_with_wrong_fields
  ...      critical
  Run Keyword And Expect Error    *  Можливість створити фреймворк  identifier


Неможливість оголосити фреймворк, не заповнивши поле "Назва закупівлі"
  [Tags]   ${USERS.users['${tender_owner}'].broker}: Оголошення фреймворку
  ...      tender_owner
  ...      ${USERS.users['${tender_owner}'].broker}
  ...      create_framework_with_wrong_fields
  ...      critical
  Run Keyword And Expect Error    *  Можливість створити фреймворк  title


Неможливість оголосити фреймворк, не заповнивши поле "Строк дії оголошення"
  [Tags]   ${USERS.users['${tender_owner}'].broker}: Оголошення фреймворку
  ...      tender_owner
  ...      ${USERS.users['${tender_owner}'].broker}
  ...      create_framework_with_wrong_fields
  ...      critical
  Run Keyword And Expect Error    *  Можливість створити фреймворк  qualificationPeriod


Неможливість оголосити фреймворк, не заповнивши поле "Код предмета закупівлі"
  [Tags]   ${USERS.users['${tender_owner}'].broker}: Оголошення фреймворку
  ...      tender_owner
  ...      ${USERS.users['${tender_owner}'].broker}
  ...      create_framework_with_wrong_fields
  ...      critical
  Run Keyword And Expect Error    *  Можливість створити фреймворк  scheme


Неможливість оголосити фреймворк, якщо поле "Код предмета закупівлі" не відповідає формату
  [Tags]   ${USERS.users['${tender_owner}'].broker}: Оголошення фреймворку
  ...      tender_owner
  ...      ${USERS.users['${tender_owner}'].broker}
  ...      create_framework_with_wrong_fields
  ...      critical
  Run Keyword And Expect Error    *  Можливість створити фреймворк  bad_format_scheme


Неможливість оголосити фреймворк, не заповнивши поле "id"
  [Tags]   ${USERS.users['${tender_owner}'].broker}: Оголошення фреймворку
  ...      tender_owner
  ...      ${USERS.users['${tender_owner}'].broker}
  ...      create_framework_with_wrong_fields
  ...      critical
  Run Keyword And Expect Error    *  Можливість створити фреймворк  id


Неможливість оголосити фреймворк, не заповнивши поле "legalName"
  [Tags]   ${USERS.users['${tender_owner}'].broker}: Оголошення фреймворку
  ...      tender_owner
  ...      ${USERS.users['${tender_owner}'].broker}
  ...      create_framework_with_wrong_fields
  ...      critical
  Run Keyword And Expect Error    *  Можливість створити фреймворк  legalName


Mожливість оголосити фреймворк, не заповнивши поле "kind"
  [Tags]   ${USERS.users['${tender_owner}'].broker}: Оголошення фреймворку
  ...      tender_owner
  ...      ${USERS.users['${tender_owner}'].broker}
  ...      create_framework_with_wrong_fields
  ...      critical
  Run Keyword  Можливість створити фреймворк  kind
  Звірити поле кваліфікаціi із значенням  ${viewer}  ${QUALIFICATION['QUALIFICATION_UAID']}   general  procuringEntity.kind


Неможливість оголосити фреймворк, не заповнивши поле "address"
  [Tags]   ${USERS.users['${tender_owner}'].broker}: Оголошення фреймворку
  ...      tender_owner
  ...      ${USERS.users['${tender_owner}'].broker}
  ...      create_framework_with_wrong_fields
  ...      critical
  Run Keyword And Expect Error    *  Можливість створити фреймворк  address


Неможливість оголосити фреймворк, не заповнивши поле "countryName"
  [Tags]   ${USERS.users['${tender_owner}'].broker}: Оголошення фреймворку
  ...      tender_owner
  ...      ${USERS.users['${tender_owner}'].broker}
  ...      create_framework_with_wrong_fields
  ...      critical
  Run Keyword And Expect Error    *  Можливість створити фреймворк  countryName


Неможливість оголосити фреймворк, не заповнивши поле "postalCode"
  [Tags]   ${USERS.users['${tender_owner}'].broker}: Оголошення фреймворку
  ...      tender_owner
  ...      ${USERS.users['${tender_owner}'].broker}
  ...      create_framework_with_wrong_fields
  ...      critical
  Run Keyword And Expect Error    *  Можливість створити фреймворк  postalCode


Неможливість оголосити фреймворк, не заповнивши поле "region"
  [Tags]   ${USERS.users['${tender_owner}'].broker}: Оголошення фреймворку
  ...      tender_owner
  ...      ${USERS.users['${tender_owner}'].broker}
  ...      create_framework_with_wrong_fields
  ...      critical
  Run Keyword And Expect Error    *  Можливість створити фреймворк  region


Неможливість оголосити фреймворк, якщо поле "region" не відповідає формату
  [Tags]   ${USERS.users['${tender_owner}'].broker}: Оголошення фреймворку
  ...      tender_owner
  ...      ${USERS.users['${tender_owner}'].broker}
  ...      create_framework_with_wrong_fields
  ...      critical
  Run Keyword And Expect Error    *  Можливість створити фреймворк  bad_format_region


Неможливість оголосити фреймворк, не заповнивши поле "streetAddress"
  [Tags]   ${USERS.users['${tender_owner}'].broker}: Оголошення фреймворку
  ...      tender_owner
  ...      ${USERS.users['${tender_owner}'].broker}
  ...      create_framework_with_wrong_fields
  ...      critical
  Run Keyword And Expect Error    *  Можливість створити фреймворк  streetAddress


Неможливість оголосити фреймворк, не заповнивши поле "locality"
  [Tags]   ${USERS.users['${tender_owner}'].broker}: Оголошення фреймворку
  ...      tender_owner
  ...      ${USERS.users['${tender_owner}'].broker}
  ...      create_framework_with_wrong_fields
  ...      critical
  Run Keyword And Expect Error    *  Можливість створити фреймворк  locality


Неможливість оголосити фреймворк, не заповнивши поле "classification"
  [Tags]   ${USERS.users['${tender_owner}'].broker}: Оголошення фреймворку
  ...      tender_owner
  ...      ${USERS.users['${tender_owner}'].broker}
  ...      create_framework_with_wrong_fields
  ...      critical
  Run Keyword And Expect Error    *  Можливість створити фреймворк  classification


Неможливість оголосити фреймворк, не заповнивши поле "description"
  [Tags]   ${USERS.users['${tender_owner}'].broker}: Оголошення фреймворку
  ...      tender_owner
  ...      ${USERS.users['${tender_owner}'].broker}
  ...      create_framework_with_wrong_fields
  ...      critical
  Run Keyword And Expect Error    *  Можливість створити фреймворк  description


Неможливість оголосити фреймворк, не заповнивши поле "title"
  [Tags]   ${USERS.users['${tender_owner}'].broker}: Оголошення фреймворку
  ...      tender_owner
  ...      ${USERS.users['${tender_owner}'].broker}
  ...      create_framework_with_wrong_fields
  ...      critical
  Run Keyword And Expect Error    *  Можливість створити фреймворк  title


Неможливість оголосити фреймворк, не заповнивши поле "qualificationPeriod"
  [Tags]   ${USERS.users['${tender_owner}'].broker}: Оголошення фреймворку
  ...      tender_owner
  ...      ${USERS.users['${tender_owner}'].broker}
  ...      create_framework_with_wrong_fields
  ...      critical
  Run Keyword And Expect Error    *  Можливість створити фреймворк  qualificationPeriod


Зміна статусу кваліфікації на unsuccessful за відсутності активних заявок
  [Tags]   ${USERS.users['${viewer}'].broker}: Відображення кваліфікації
  ...      viewer
  ...      ${USERS.users['${viewer}'].broker}
  ...      view_submissions_unsuccessful
  ...      critical
  Wait until keyword succeeds
  ...      10 min 15 sec
  ...      15 sec
  ...      Можливість перевірити статус об’єкта кваліфікації
  ...      ${viewer}
  ...      ${QUALIFICATION.QUALIFICATION_ID}
  ...      unsuccessful


Можливість дочекатись дати закінчення кваліфікації
  [Tags]   ${USERS.users['${viewer}'].broker}: Очікування дати закінчення кваліфікації
  ...      tender_owner
  ...      ${USERS.users['${viewer}'].broker}
  ...      wait_framework_end_date
  Дочекатись дати завершення кваліфікації  ${viewer}  ${QUALIFICATION['QUALIFICATION_UAID']}


Зміна статусу кваліфікації на complete, після настання дати "qualificationPeriod.endDate"
  [Tags]   ${USERS.users['${viewer}'].broker}: Відображення кваліфікації
  ...      viewer
  ...      ${USERS.users['${viewer}'].broker}
  ...      status_complete
  ...      critical
  Wait until keyword succeeds
  ...      10 min 15 sec
  ...      15 sec
  ...      Можливість перевірити статус об’єкта кваліфікації
  ...      ${viewer}
  ...      ${QUALIFICATION.QUALIFICATION_ID}
  ...      complete


Неможливість зaмiнити документ у фреймворк у статусi "unsuccessful"
  [Tags]   ${USERS.users['${tender_owner}'].broker}: Завантажити документ у кваліфікацію
  ...      tender_owner
  ...      ${USERS.users['${tender_owner}'].broker}
  ...      doc_manage_in_framework
  ...      critical
  [Teardown]  Оновити QUALIFICATION_LAST_MODIFICATION_DATE
  ${error}=  Run Keyword And Expect Error  *
  ...    Оновити документ у фреймворку  ${tender_owner}  ${file_path}
  Should Contain    ${error}    "Can't update document in current (unsuccessful) framework status"
  Remove File  ${file_path}


Неможливість завантажити документ у фреймворк у статусi "unsuccessful"
  [Tags]   ${USERS.users['${tender_owner}'].broker}: Завантажити документ у кваліфікацію
  ...      tender_owner
  ...      ${USERS.users['${tender_owner}'].broker}
  ...      doc_manage_in_framework
  ...      critical
  [Teardown]  Оновити QUALIFICATION_LAST_MODIFICATION_DATE
   ${file_path}  ${file_name}  ${file_content}=  create_fake_doc
   ${error_message}=  Run Keyword And Expect Error    *
   ...     Завантажити документ у фреймворк  ${tender_owner}  ${file_path}
   Should Contain    ${error_message}  "Can't add document in current (unsuccessful) framework status"
   Remove File  ${file_path}


Неможливість змiнити документ у фреймворк у статусi "unsuccessful"
  [Tags]   ${USERS.users['${tender_owner}'].broker}: Завантажити документ у кваліфікацію
  ...      tender_owner
  ...      ${USERS.users['${tender_owner}'].broker}
  ...      doc_manage_in_framework
  ...      critical
  [Teardown]  Оновити QUALIFICATION_LAST_MODIFICATION_DATE
  ${document}=  Set Variable    ${USERS.users['${tender_owner}'].documents}
  Set To Dictionary    ${document.data}  title=New title
  Log  ${document}
  ${error}=  Run Keyword And Expect Error  *
  ...    Оновити зареєстрований документ у фреймворку  ${tender_owner}  ${document}
  Should Contain    ${error}    "Can't update document in current (unsuccessful) framework status"


Неможливість зaмiнити документ у фреймворк у статусi "complete"
  [Tags]   ${USERS.users['${tender_owner}'].broker}: Завантажити документ у кваліфікацію
  ...      tender_owner
  ...      ${USERS.users['${tender_owner}'].broker}
  ...      document_negative_tests
  ...      critical
  [Teardown]  Оновити QUALIFICATION_LAST_MODIFICATION_DATE
  ${documents}=  Oтримати документи з фреймворку  ${tender_owner}
  Log  ${documents.data[0]}
  Set To Dictionary    ${USERS.users['${tender_owner}']['documents']}  data=${documents.data[0]}
  ${file_path}  ${file_name}  ${file_content}=  create_fake_doc
  ${error}=  Run Keyword And Expect Error  *
  ...    Оновити документ у фреймворку  ${tender_owner}  ${file_path}
  Should Contain    ${error}    "Can't update document in current (complete) framework status"
  Remove File  ${file_path}


Неможливість завантажити документ у фреймворк у статусi "complete"
  [Tags]   ${USERS.users['${tender_owner}'].broker}: Завантажити документ у кваліфікацію
  ...      tender_owner
  ...      ${USERS.users['${tender_owner}'].broker}
  ...      document_negative_tests
  ...      critical
  [Teardown]  Оновити QUALIFICATION_LAST_MODIFICATION_DATE
   ${file_path}  ${file_name}  ${file_content}=  create_fake_doc
   ${error_message}=  Run Keyword And Expect Error    *
   ...     Завантажити документ у фреймворк  ${tender_owner}  ${file_path}
   Should Contain    ${error_message}  "Can't add document in current (complete) framework status"
   Remove File  ${file_path}


Неможливість змiнити документ у фреймворк у статусi "complete"
  [Tags]   ${USERS.users['${tender_owner}'].broker}: Завантажити документ у кваліфікацію
  ...      tender_owner
  ...      ${USERS.users['${tender_owner}'].broker}
  ...      document_negative_tests
  ...      critical
  [Teardown]  Оновити QUALIFICATION_LAST_MODIFICATION_DATE
  ${documents}=  Oтримати документи з фреймворку  ${tender_owner}
  Set To Dictionary    ${USERS.users['${tender_owner}']['documents']}  data=${documents.data[0]}
  ${document}=  Set Variable    ${USERS.users['${tender_owner}'].documents}
  Set To Dictionary    ${document.data}  title=New title
  ${error}=  Run Keyword And Expect Error  *
  ...    Оновити зареєстрований документ у фреймворку  ${tender_owner}  ${document}
  Should Contain    ${error}    "Can't update document in current (complete) framework status"


Неможливість подати заявку yчасником, якщо фреймворк у статусі complete
  [Tags]   ${USERS.users['${provider}'].broker}: Подання пропозиції
  ...      provider
  ...      ${USERS.users['${provider}'].broker}
  ...      add_submission
  ...      critical
  [Teardown]  Оновити QUALIFICATION_LAST_MODIFICATION_DATE
  ${error_message}  Run Keyword And Expect Error    *
  ...      Можливість зареєструвати заявку  ${provider}
  Should Contain    ${error_message}  "Submission can be add only during the period: from











