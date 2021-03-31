*** Variables ***
${RESOURCE}      tenders   # possible values: tenders, auctions
${API_HOST_URL}  https://lb-api-staging.prozorro.gov.ua
${API_VERSION}   2.5
${BROKER}        Quinta
${DS_HOST_URL}   https://upload-docs-staging.prozorro.gov.ua
${ROLE}          viewer
${EDR_HOST_URL}  https://lb-edr-staging.prozorro.gov.ua
${EDR_VERSION}   1.0

${DASU_RESOURCE}      monitorings
${DASU_API_HOST_URL}  https://audit-api-staging.prozorro.gov.ua
${DASU_API_VERSION}   2.5

${DS_REGEXP}        ^https?:\/\/public-docs(?:-staging)?\.prozorro\.gov\.ua\/get\/([0-9A-Fa-f]{32})
${AUCTION_REGEXP}   ^https?:\/\/auction(?:-staging)?\.prozorro\.gov\.ua\/(esco-)?tenders\/([0-9A-Fa-f]{32})

${PAYMENT_API}              https://integration-staging.prozorro.gov.ua/liqpay
${PAYMENT_API_VERSION}      v1