*** Settings ***
Resource        base_keywords.robot
Suite Setup     Test Suite Setup
Suite Teardown  Test Suite Teardown


*** Variables ***
${MODE}=  openeu
@{USED_ROLES}       tender_owner  provider  provider1  provider2  viewer
${DIALOGUE_TYPE}    EU

${NUMBER_OF_ITEMS}  ${1}
${NUMBER_OF_LOTS}   ${1}
${TENDER_MEAT}      ${True}
${LOT_MEAT}         ${True}
${ITEM_MEAT}        ${True}
${MOZ_INTEGRATION}  ${True}


*** Test Cases ***
Перевірка валідації для MNN при створенні тендеру для першого варіанту данних
  Можливість оголосити тендер з використанням валідації для MNN  ${1}


Перевірка валідації для MNN при створенні тендеру для другого варіанту данних
  Можливість оголосити тендер з використанням валідації для MNN  ${2}


Перевірка валідації для MNN при створенні тендеру для третього варіанту данних
  Можливість оголосити тендер з використанням валідації для MNN  ${3}
