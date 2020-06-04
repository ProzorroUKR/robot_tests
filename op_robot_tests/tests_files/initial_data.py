# -*- coding: utf-8 -
import os
import random
import hashlib
from datetime import timedelta
from tempfile import NamedTemporaryFile
from uuid import uuid4
from faker import Factory
from faker.providers.company.en_US import Provider as CompanyProviderEnUs
from faker.providers.company.ru_RU import Provider as CompanyProviderRuRu
from munch import munchify
from op_faker import OP_Provider
from .local_time import get_now, TZ

fake_en = Factory.create(locale='en_US')
fake_ru = Factory.create(locale='ru_RU')
fake_uk = Factory.create(locale='uk_UA')
fake_uk.add_provider(OP_Provider)
fake = fake_uk
used_identifier_id = []
mode_open = ["belowThreshold", "aboveThresholdUA", "aboveThresholdEU",
             "aboveThresholdUA.defense", "competitiveDialogueUA", "competitiveDialogueEU", "esco",
             "closeFrameworkAgreementUA"]
mode_limited = ["reporting", "negotiation.quick", "negotiation"]
mode_selective = ["priceQuotation"]
violationType = ["corruptionDescription", "corruptionProcurementMethodType", "corruptionChanges",
                 "corruptionPublicDisclosure", "corruptionBiddingDocuments", "documentsForm",
                 "corruptionAwarded", "corruptionCancelled", "corruptionContracting"]

# This workaround fixes an error caused by missing "catch_phrase" class method
# for the "ru_RU" locale in Faker >= 0.7.4
fake_ru.add_provider(CompanyProviderEnUs)
fake_ru.add_provider(CompanyProviderRuRu)


def create_fake_sentence():
    return fake.sentence(nb_words=10, variable_nb_words=True)


def create_fake_funder():
    return fake.funders_data()


def get_fake_funder_scheme():
    return fake.funder_scheme()


def create_fake_amount(award_amount, tender_value_added_tax_included, contract_value_added_tax_included):
    min_amount_net = award_amount / 1.2
    range_amount_net = award_amount - min_amount_net
    half_min_amount_net = min_amount_net + range_amount_net / 2
    half_max_amount_net = half_min_amount_net + range_amount_net
    if tender_value_added_tax_included == True and contract_value_added_tax_included == True:
        return round(random.uniform(half_min_amount_net, award_amount), 2)
    if tender_value_added_tax_included == False and contract_value_added_tax_included == True:
        return round(random.uniform(award_amount, half_max_amount_net), 2)
    if tender_value_added_tax_included == True and contract_value_added_tax_included == False:
        return round(random.uniform(half_min_amount_net, award_amount), 2)
    if tender_value_added_tax_included == False and contract_value_added_tax_included == False:
        return round(random.uniform(half_min_amount_net, award_amount), 2)


def create_fake_amount_net(award_amount, tender_value_added_tax_included, contract_value_added_tax_included):
    min_amount_net = award_amount / 1.2
    range_amount_net = award_amount - min_amount_net
    half_min_amount_net = min_amount_net + range_amount_net / 2
    if tender_value_added_tax_included == True and contract_value_added_tax_included == True:
        return round(random.uniform(min_amount_net, half_min_amount_net), 2)
    if tender_value_added_tax_included == False and contract_value_added_tax_included == True:
        return round(random.uniform(half_min_amount_net, award_amount), 2)
    if tender_value_added_tax_included == True and contract_value_added_tax_included == False:
        return round(random.uniform(half_min_amount_net, award_amount), 2)
    if tender_value_added_tax_included == False and contract_value_added_tax_included == False:
        return round(random.uniform(half_min_amount_net, award_amount), 2)


def create_fake_amount_paid(contract_amount, contract_amountNet):
    minimum = contract_amountNet
    maximum = contract_amount
    range = maximum - minimum
    half_min_range = minimum + range / 2
    return round(random.uniform(minimum, half_min_range), 2)


def create_fake_number(min_number, max_number):
    return random.randint(int(min_number), int(max_number))


def create_fake_number_float(min_number, max_number):
    return round(random.uniform(float(min_number), float(max_number)), 3)


def create_fake_title():
    return u"[ТЕСТУВАННЯ] {}".format(fake.title())


def create_fake_date():
    return get_now().isoformat()


def create_fake_period(days=0, hours=0, minutes=0):
    data = {
        "startDate": get_now().isoformat(),
        "endDate": (get_now() + timedelta(days=days, hours=hours, minutes=minutes)).isoformat()
    }
    return data


def subtraction(value1, value2):
    if "." in str(value1) or "." in str(value2):
        return (float(value1) - float(value2))
    else:
        return (int(value1) - int(value2))


def create_fake_value_amount():
    return fake.random_int(min=1)


def get_number_of_minutes(days, accelerator):
    return 1440 * int(days) / accelerator


def field_with_id(prefix, sentence):
    return u"{}-{}: {}".format(prefix, fake.uuid4()[:8], sentence)


def translate_country_en(country):
    if country == u"Україна":
        return "Ukraine"
    else:
        raise Exception(u"Cannot translate country to english: {}".format(country))


def convert_amount(amount):
    return ("{:,}".format(float(amount))).replace(',', ' ').replace('.', ',')


def translate_country_ru(country):
    if country == u"Україна":
        return u"Украина"
    else:
        raise Exception(u"Cannot translate country to russian: {}".format(country))


def create_fake_doc():
    content = fake.text()
    suffix = fake.random_element(('.doc', '.docx', '.pdf'))
    prefix = "{}-{}{}".format("d", fake.uuid4()[:8], fake_en.word())
    tf = NamedTemporaryFile(delete=False, suffix=suffix, prefix=prefix)
    tf.write(content)
    tf.close()
    return tf.name.replace('\\', '\\\\'), os.path.basename(tf.name), content


def create_fake_IsoDurationType(
        years=0, months=0, days=0):
    return u"P{}Y{}M{}D".format(years, months, days)


def test_tender_data(params,
                     plan_data,
                     periods=("enquiry", "tender"),
                     submissionMethodDetails=None,
                     funders=None,
                     accelerator=None):
    submissionMethodDetails = submissionMethodDetails \
        if submissionMethodDetails else "quick"
    now = get_now()
    value_amount = round(random.uniform(3000, 99999999.99), 2)  # max value equals to budget of Ukraine in hryvnias
    vat_included = params.get('vat_included', True)
    data = {
        "mode": "test",
        "submissionMethodDetails": submissionMethodDetails,
        "description": fake.description(),
        "description_en": fake_en.sentence(nb_words=10, variable_nb_words=True),
        "description_ru": fake_ru.sentence(nb_words=10, variable_nb_words=True),
        "title": fake.title(),
        "title_en": fake_en.catch_phrase(),
        "title_ru": fake_ru.catch_phrase(),
        "procuringEntity": fake.procuringEntity(),
        "procurementMethodType": "belowThreshold",
        "value": {
            "amount": value_amount,
            "currency": u"UAH",
            "valueAddedTaxIncluded": vat_included
        },
        "minimalStep": {
            "amount": round(random.uniform(0.005, 0.03) * value_amount, 2),
            "currency": u"UAH",
            "valueAddedTaxIncluded": vat_included
        },
        "items": [],
        "features": []
    }
    if params.get("mode") == "open_framework":
        data["mainProcurementCategory"] = random.choice(['goods', 'services'])
    elif params.get("mode") == "open_competitive_dialogue":
        data["mainProcurementCategory"] = random.choice(['services', 'works'])
    else:
        data["mainProcurementCategory"] = random.choice(['goods', 'services', 'works'])
    accelerator = accelerator \
        if accelerator else params['intervals']['accelerator']
    data['procurementMethodDetails'] = 'quick, ' \
                                       'accelerator={}'.format(accelerator)
    data["procuringEntity"]["kind"] = "other"
    if data.get("mode") == "test":
        data["title"] = u"[ТЕСТУВАННЯ] {}".format(data["title"])
        data["title_en"] = u"[TESTING] {}".format(data["title_en"])
        data["title_ru"] = u"[ТЕСТИРОВАНИЕ] {}".format(data["title_ru"])
    period_dict = {}
    inc_dt = now
    for period_name in periods:
        period_dict[period_name + "Period"] = {}
        for i, j in zip(range(2), ("start", "end")):
            inc_dt += timedelta(minutes=params['intervals'][period_name][i])
            period_dict[period_name + "Period"][j + "Date"] = inc_dt.astimezone(TZ).isoformat()
    data.update(period_dict)
    if params.get('plan_tender'):
        data["procuringEntity"]["name"] = plan_data["data"]["procuringEntity"]["name"]
        data["procuringEntity"]["identifier"] = plan_data["data"]["procuringEntity"]["identifier"]
        cpv_group = plan_data["data"]["classification"]["id"]
    elif params.get('moz_integration'):
        cpv_group = 336
    elif params.get('road_index'):
        cpv_group = 'road'
    elif params.get('gmdn_index'):
        cpv_group = 'gmdn'
    else:
        cpv_group = fake.cpv()[:4]
    if params.get('number_of_lots'):
        data['lots'] = []
        for lot_number in range(params['number_of_lots']):
            lot_id = uuid4().hex
            new_lot = test_lot_data(data['value']['amount'], vat_included)
            data['lots'].append(new_lot)
            data['lots'][lot_number]['id'] = lot_id
            for i in range(params['number_of_items']):
                new_item = test_item_data(cpv_group)
                new_item['relatedLot'] = lot_id
                data['items'].append(new_item)
        value_amount = round(sum(lot['value']['amount'] for lot in data['lots']), 2)
        minimalStep = min(lot['minimalStep']['amount'] for lot in data['lots'])
        data['value']['amount'] = value_amount
        data['minimalStep']['amount'] = minimalStep
        if params.get('lot_meat'):
            new_feature = test_feature_data()
            new_feature['featureOf'] = "lot"
            data['lots'][0]['id'] = data['lots'][0].get('id', uuid4().hex)
            new_feature['relatedItem'] = data['lots'][0]['id']
            data['features'].append(new_feature)
    else:
        for i in range(params['number_of_items']):
            new_item = test_item_data(cpv_group)
            data['items'].append(new_item)
    milestones = params.get('number_of_milestones')
    if milestones:
        data['milestones'] = []
        percentage_data = percentage_generation(milestones)
        for percentage in percentage_data:
            milestone_element = test_milestone_data()
            milestone_element['sequenceNumber'] = len(data['milestones'])
            milestone_element['percentage'] = percentage
            if milestone_element['title'] == 'anotherEvent':
                milestone_element['description'] = fake.sentence(nb_words=40, variable_nb_words=True)
            if params.get('number_of_lots'):
                milestone_element['relatedLot'] = lot_id
            data["milestones"].append(milestone_element)
    if params.get('tender_meat'):
        new_feature = test_feature_data()
        new_feature.featureOf = "tenderer"
        data['features'].append(new_feature)
    if params.get('item_meat'):
        new_feature = test_feature_data()
        new_feature['featureOf'] = "item"
        data['items'][0]['id'] = data['items'][0].get('id', uuid4().hex)
        new_feature['relatedItem'] = data['items'][0]['id']
        data['features'].append(new_feature)
    if not data['features']:
        del data['features']
    if funders is not None:
        data['funders'] = [fake.funders_data() for _ in range(int(funders))]
    data['status'] = 'draft'
    return munchify(data)


def test_tender_data_planning(params):
    data = {
        "budget": {
            "amountNet": round(random.uniform(3000, 999999.99), 2),
            "description": fake.description(),
            "project": {
                "id": str(fake.random_int(min=1, max=999)),
                "name": fake.description(),
            },
            "currency": "UAH",
            "amount": round(random.uniform(3000, 99999999.99), 2),
            "id": str(fake.random_int(min=1, max=99999999999)) + "-" + str(fake.random_int(min=1, max=9)),
            "breakdown": [],
            "period": {
                "startDate": get_now().replace(hour=0, minute=0, second=0, microsecond=0).isoformat(),
                "endDate": get_now().replace(hour=0, minute=0, second=0, microsecond=0).isoformat()
            }
        },
        "procuringEntity": {
            "identifier": {
                "scheme": "UA-EDR",
                "id": random.choice(["13313462", "00037256"]),
                "legalName": random.choice([u"Київський Тестовий Ліцей", u"Київська Тестова міська клінічна лікарня"]),
            },
        },
        "tender": {
            "procurementMethod": "",
            "procurementMethodType": params['mode'],
            "tenderPeriod": {
                "startDate": get_now().replace(hour=0, minute=0, second=0, microsecond=0).isoformat()
            }
        },
        "mode": "test",
        "items": [],
        "buyers": []
    }
    data["procuringEntity"]["name"] = data["procuringEntity"]["identifier"]["legalName"]
    buyers = test_buyers_data()
    buyers["name"] = buyers["identifier"]["legalName"]
    data['buyers'].append(buyers)
    if params.get('moz_integration'):
        id_cpv = 336
    elif params.get('road_index'):
        id_cpv = fake.road_cpv()[:4]
    elif params.get('gmdn_index'):
        id_cpv = fake.gmdn_cpv()[:4]
    else:
        id_cpv = fake.cpv()[:4]
    cpv_data = test_item_data(id_cpv)
    data.update(cpv_data)
    del data['deliveryDate']
    del data['description']
    del data['description_en']
    del data['description_ru']
    del data['deliveryAddress']
    del data['deliveryLocation']
    del data['quantity']
    del data['unit']
    for i in range(params['number_of_items']):
        item_data = test_item_data(id_cpv)
        del item_data['deliveryAddress']
        del item_data['deliveryLocation']
        item_data['deliveryDate']['endDate'] = (get_now() + timedelta(days=10)).replace(hour=0, minute=0, second=0,
                                                                                        microsecond=0).isoformat()
        del item_data['deliveryDate']['startDate']
        data['items'].append(item_data)
    if params['mode'] in mode_open:
        data["tender"]["procurementMethod"] = "open"
    if params['mode'] in mode_limited:
        data["tender"]["procurementMethod"] = "limited"
    if params['mode'] in mode_selective:
        data["tender"]["procurementMethod"] = "selective"
    if params.get('number_of_breakdown'):
        value_data = breakdown_value_generation(params['number_of_breakdown'], data['budget']['amount'])
        for value in value_data:
            breakdown_element = test_breakdown_data()
            breakdown_element['value']['amount'] = value
            data['budget']['breakdown'].append(breakdown_element)
    return munchify(data)


def test_tender_data_limited(params, plan_data):
    data = test_tender_data(params, plan_data)
    del data["submissionMethodDetails"]
    del data["minimalStep"]
    del data["enquiryPeriod"]
    del data["tenderPeriod"]
    for lot in data.get('lots', []):
        lot.pop('minimalStep', None)
    data["procuringEntity"]["kind"] = "general"
    data.update({"procurementMethodType": params['mode'], "procurementMethod": "limited"})
    if params['mode'] == "negotiation":
        cause_variants = (
            "artContestIP",
            "noCompetition",
            "twiceUnsuccessful",
            "additionalPurchase",
            "additionalConstruction",
            "stateLegalServices"
        )
        cause = fake.random_element(cause_variants)
    elif params['mode'] == "negotiation.quick":
        cause_variants = ('quick',)
    if params['mode'] in ("negotiation", "negotiation.quick"):
        cause = fake.random_element(cause_variants)
        data.update({
            "cause": cause,
            "causeDescription": fake.description()
        })
    return munchify(data)


def test_feature_data():
    words = fake.words()
    feature = {
        "code": uuid4().hex,
        "title": field_with_id("f", fake.title()),
        "title_en": field_with_id('f', fake_en.sentence(nb_words=5, variable_nb_words=True)),
        "title_ru": field_with_id('f', fake_ru.sentence(nb_words=5, variable_nb_words=True)),
        "description": fake.description(),
        "enum": [
            {
                "value": 0.05,
                "title": words[0]
            },
            {
                "value": 0.01,
                "title": words[1]
            },
            {
                "value": 0,
                "title": words[2]
            }
        ]
    }
    return munchify(feature)


def test_question_data():
    data = {
        "author": fake.procuringTenderer(),
        "description": fake.description(),
        "title": field_with_id("q", fake.title())
    }
    del data['author']['scale']
    return munchify({'data': data})


def test_related_question(question, relation, obj_id):
    question.data.update({"questionOf": relation, "relatedItem": obj_id})
    return munchify(question)


def test_question_answer_data():
    return munchify({
        "data": {
            "answer": fake.sentence(nb_words=40, variable_nb_words=True)
        }
    })


def test_complaint_data():
    data = {
        "author": fake.procuringTenderer(),
        "description": fake.description(),
        "title": field_with_id("q", fake.title()),
        "type": "complaint"
    }
    del data['author']['scale']
    return munchify({'data': data})


def test_payment_data(token, complaint_value, complaint_uaid):
    data = {
            "amount": str(complaint_value),
            "currency": "UAH",
            "description": generate_payment_description(token, complaint_uaid),
            "type": "credit",
            "date_oper": get_now().isoformat(),
            "account": "UA723004380000026001503374077",
            "okpo": "14360570",
            "mfo": "123456",
            "name": u"Плат.интер-эквайрин через LiqPay"
    }
    return data


def generate_payment_description(token, complaint_uaid):
    full_hash = hashlib.sha512(token).hexdigest()
    short_hash = full_hash[0:8]
    description = complaint_uaid + '-' + short_hash + ' [TESTING, ROBOT TESTS]'
    return description


def test_accept_complaint_data():
    data = {
        "status": "accepted",
        "reviewDate": get_now().isoformat(),
        "reviewPlace": "Place of review"
    }
    return munchify({'data': data})


def test_reject_complaint_data():
    data = {
        "rejectReason": random.choice(["lawNonCompliance", "buyerViolationsCorrected", "alreadyExists", "tenderCancelled"])
    }
    return munchify({'data': data})


def test_award_complaint_data():
    data = {
        "author": fake.procuringTenderer(),
        "description": fake.description(),
        "title": field_with_id("q", fake.title()),
        "type": "complaint"
    }
    del data['author']['scale']
    return munchify({'data': data})


def test_claim_data():
    data = {
        "author": fake.procuringTenderer(),
        "description": fake.description(),
        "title": field_with_id("q", fake.title()),
        "type": "claim"
    }
    del data['author']['scale']
    return munchify({'data': data})


def test_claim_answer_data(status):
    return munchify({
        "data": {
            "status": "answered",
            "resolutionType": status,
            "tendererAction": fake.sentence(nb_words=10, variable_nb_words=True),
            "resolution": fake.sentence(nb_words=15, variable_nb_words=True)
        }
    })


def test_confirm_data(id):
    return munchify({
        "data": {
            "status": "active",
            "id": id
        }
    })


def test_cancel_pending_data(id):
    return munchify({
        "data": {
            "status": "pending",
            "id": id
        }
    })


def test_submit_claim_data(claim_id):
    return munchify({
        "data": {
            "id": claim_id,
            "status": "claim"
        }
    })


def test_complaint_reply_data():
    return munchify({
        "data": {
            "status": "resolved"
        }
    })


def test_bid_competitive_data():
    bid = munchify({
        "data": {
            "tenderers": [
                fake.procuringTenderer()
            ]
        }
    })
    if len(used_identifier_id) == 3:
        del used_identifier_id[0]
    id = bid.data.tenderers[0].identifier.id
    while (id in used_identifier_id):
        bid = munchify({
            "data": {
                "tenderers": [
                    fake.procuringTenderer()
                ]
            }
        })
        id = bid.data.tenderers[0].identifier.id
    used_identifier_id.append(id)
    bid.data.tenderers[0].address.countryName_en = translate_country_en(bid.data.tenderers[0].address.countryName)
    bid.data.tenderers[0].address.countryName_ru = translate_country_ru(bid.data.tenderers[0].address.countryName)
    bid.data['status'] = 'draft'
    return bid


def test_bid_data():
    bid = munchify({
        "data": {
            "tenderers": [
                fake.procuringTenderer()
            ]
        }
    })
    bid.data.tenderers[0].address.countryName_en = translate_country_en(bid.data.tenderers[0].address.countryName)
    bid.data.tenderers[0].address.countryName_ru = translate_country_ru(bid.data.tenderers[0].address.countryName)
    bid.data['status'] = 'draft'
    return bid


def test_bid_value(max_value_amount, vat_included):
    return munchify({
        "value": {
            "currency": "UAH",
            "amount": round(random.uniform((0.95 * max_value_amount), max_value_amount), 2),
            "valueAddedTaxIncluded": vat_included
        }
    })


def test_bid_value_esco(tender_data):
    annual_cost = []
    for i in range(0, 21):
        cost = round(random.uniform(1, 100), 2)
        annual_cost.append(cost)
    if tender_data['fundingKind'] == "budget":
        yearly_percentage = round(random.uniform(0.01, float(tender_data['yearlyPaymentsPercentageRange'])), 5)
    else:
        yearly_percentage = 0.8
    # when tender fundingKind is budget, yearlyPaymentsPercentageRange should be less or equal 0.8, and more or equal 0
    # when tender fundingKind is other, yearlyPaymentsPercentageRange should be equal 0.8
    return munchify({
        "value": {
            "currency": "UAH",
            "valueAddedTaxIncluded": True,
            "yearlyPaymentsPercentage": yearly_percentage,
            "annualCostsReduction": annual_cost,
            "contractDuration": {
                "years": random.randint(7, 14),
                "days": random.randint(1, 364)
            }
        }
    })


def test_bid_data_selection(data, index):
    bid = munchify({
        "data": {
            "tenderers": [
                data['agreements'][0]['contracts'][index]['suppliers'][0]
            ]
        }
    })
    bid.data['status'] = 'draft'
    bid.data['parameters'] = data['agreements'][0]['contracts'][index]['parameters']
    bid.data['lotValues'] = [test_bid_value(data['agreements'][0]['contracts'][index]['value']['amount'],
                                            data['agreements'][0]['contracts'][index]['value'][
                                                'valueAddedTaxIncluded'])]
    return bid


def test_bid_data_pq(data):
    bid = test_bid_data()
    bid.data.requirementResponses = []
    for criteria in data['criteria']:
        for requirements in criteria['requirementGroups']:
            for requirement in requirements['requirements']:
                if requirement.get('expectedValue'):
                    value = requirement.get('expectedValue')
                else:
                    value = requirement.get('minValue', '1')

                requirement = {
                    "requirement": {"id": requirement['id']},
                    "value": value
                }
                bid.data.requirementResponses.append(requirement)
    bid.data['status'] = 'draft'
    bid.data.update(test_bid_value(1000, True))
    return bid


def test_supplier_data():
    return munchify({
        "data": {
            "suppliers": [
                fake.procuringTenderer()
            ],
            "value": {
                "amount": fake.random_int(min=1),
                "currency": "UAH",
                "valueAddedTaxIncluded": True
            },
            "qualified": True
        }
    })


def test_item_data(cpv=None):
    data = fake.fake_item(cpv)
    data["description"] = field_with_id("i", data["description"])
    data["description_en"] = field_with_id("i", data["description_en"])
    data["description_ru"] = field_with_id("i", data["description_ru"])
    startDate = fake.random_int(min=1, max=30)
    endDate = startDate + fake.random_int(min=1, max=7)
    data["deliveryDate"] = {
        "startDate": (get_now() + timedelta(days=startDate)).astimezone(TZ).replace(hour=0, minute=0, second=0,
                                                                                    microsecond=0).isoformat(),
        "endDate": (get_now() + timedelta(days=endDate)).astimezone(TZ).replace(hour=0, minute=0, second=0,
                                                                                microsecond=0).isoformat()
    }
    data["deliveryAddress"]["countryName_en"] = translate_country_en(data["deliveryAddress"]["countryName"])
    data["deliveryAddress"]["countryName_ru"] = translate_country_ru(data["deliveryAddress"]["countryName"])
    return munchify(data)


def test_invalid_features_data():
    return [
        {
            "code": "ee3e24bc17234a41bd3e3a04cc28e9c6",
            "featureOf": "tenderer",
            "title": fake.title(),
            "description": fake.description(),
            "enum": [
                {
                    "value": 0.35,
                    "title": fake.word()
                },
                {
                    "value": 0,
                    "title": fake.word()
                }
            ]
        }
    ]


def test_lot_data(max_value_amount, vat_included=True):
    value_amount = round(random.uniform(1, max_value_amount), 2)
    return munchify(
        {
            "description": fake.description(),
            "title": field_with_id('l', fake.title()),
            "title_en": field_with_id('l', fake_en.sentence(nb_words=5, variable_nb_words=True)),
            "title_ru": field_with_id('l', fake_ru.sentence(nb_words=5, variable_nb_words=True)),
            "value": {
                "currency": "UAH",
                "amount": value_amount,
                "valueAddedTaxIncluded": vat_included
            },
            "minimalStep": {
                "currency": "UAH",
                "amount": round(random.uniform(0.005, 0.03) * value_amount, 2),
                "valueAddedTaxIncluded": vat_included
            },
            "status": "active"
        })


def test_lot_document_data(document, lot_id):
    document.data.update({"documentOf": "lot", "relatedItem": lot_id})
    return munchify(document)


def test_change_document_data(document, change_id):
    document.data.update({"documentOf": "change", "relatedItem": change_id})
    return munchify(document)


def test_tender_data_openua(params, submissionMethodDetails, plan_data):
    # We should not provide any values for `enquiryPeriod` when creating
    # an openUA or openEU procedure. That field should not be present at all.
    # Therefore, we pass a nondefault list of periods to `test_tender_data()`.
    data = test_tender_data(params, plan_data, ('tender',), submissionMethodDetails)
    data['procurementMethodType'] = 'aboveThresholdUA'
    data['procuringEntity']['kind'] = 'general'
    return data


def test_tender_data_openua_defense(params, submissionMethodDetails, plan_data):
    """We should not provide any values for `enquiryPeriod` when creating
    an openUA, openEU or openUA_defense procedure. That field should not be present at all.
    Therefore, we pass a nondefault list of periods to `test_tender_data()`."""
    data = test_tender_data(params, plan_data, ('tender',), submissionMethodDetails)
    data['procurementMethodType'] = 'aboveThresholdUA.defense'
    data['procuringEntity']['kind'] = 'defense'
    return data


def test_tender_data_openeu(params, submissionMethodDetails, plan_data):
    # We should not provide any values for `enquiryPeriod` when creating
    # an openUA or openEU procedure. That field should not be present at all.
    # Therefore, we pass a nondefault list of periods to `test_tender_data()`.
    data = test_tender_data(params, plan_data, ('tender',), submissionMethodDetails)
    data['procurementMethodType'] = 'aboveThresholdEU'
    data['title_en'] = "[TESTING]"
    for item_number, item in enumerate(data['items']):
        item['description_en'] = "Test item #{}".format(item_number)
    data['procuringEntity']['name_en'] = fake_en.name()
    data['procuringEntity']['contactPoint']['name_en'] = fake_en.name()
    data['procuringEntity']['contactPoint']['availableLanguage'] = "en"
    data['procuringEntity']['identifier'][
        'legalName_en'] = u"Institution \"Vinnytsia City Council primary and secondary general school № 10\""
    data['procuringEntity']['kind'] = 'general'
    return data


def test_tender_data_framework_agreement(params, submissionMethodDetails, plan_data):
    data = test_tender_data_openeu(params, submissionMethodDetails, plan_data)
    data['procurementMethodType'] = 'closeFrameworkAgreementUA'
    data['maxAwardsCount'] = fake.random_int(min=3, max=5)
    data['agreementDuration'] = create_fake_IsoDurationType(
        years=fake.random_int(min=1, max=3),
        months=fake.random_int(min=1, max=8),
        days=fake.random_int(min=1, max=6)
    )
    return data


def test_tender_data_competitive_dialogue(params, submissionMethodDetails, plan_data):
    # We should not provide any values for `enquiryPeriod` when creating
    # an openUA or openEU procedure. That field should not be present at all.
    # Therefore, we pass a nondefault list of periods to `test_tender_data()`.
    data = test_tender_data(params, plan_data, ('tender',), submissionMethodDetails)
    if params.get('dialogue_type') == 'UA':
        data['procurementMethodType'] = 'competitiveDialogueUA'
    else:
        data['procurementMethodType'] = 'competitiveDialogueEU'
        data['procuringEntity']['contactPoint']['availableLanguage'] = "en"
    data['title_en'] = "[TESTING] {}".format(fake_en.sentence(nb_words=3, variable_nb_words=True))
    for item in data['items']:
        item['description_en'] = fake_en.sentence(nb_words=3, variable_nb_words=True)
    data['procuringEntity']['name_en'] = fake_en.name()
    data['procuringEntity']['contactPoint']['name_en'] = fake_en.name()
    data['procuringEntity']['identifier']['legalName_en'] = fake_en.sentence(nb_words=10, variable_nb_words=True)
    data['procuringEntity']['kind'] = 'general'
    return data


def test_tender_data_selection(procedure_intervals, params, submissionMethodDetails, tender_data=None, plan_data=None):
    intervals = procedure_intervals['framework_selection']
    params['intervals'] = intervals
    data = test_tender_data(params, plan_data, (), submissionMethodDetails)
    data['title_en'] = "[TESTING]"
    data['procuringEntity'] = tender_data['data']['procuringEntity']
    del data['procuringEntity']['contactPoint']['availableLanguage']
    data['procurementMethodType'] = 'closeFrameworkAgreementSelectionUA'
    data['items'] = tender_data['data']['items']
    data['lots'] = tender_data['data']['lots']
    data['agreements'] = [{'id': tender_data['data']['agreements'][0]['id']}]
    del data['value']
    del data['minimalStep']
    return munchify({'data': data})


def test_change_data():
    return munchify(
        {
            "data":
                {
                    "rationale": fake.description(),
                    "rationale_en": fake_en.sentence(nb_words=10, variable_nb_words=True),
                    "rationale_ru": fake_ru.sentence(nb_words=10, variable_nb_words=True),
                    "rationaleTypes": fake.rationaleTypes(amount=3),
                    "status": "pending"
                }
        })


def test_agreement_change_data(rationaleType):
    return munchify(
        {
            "data":
                {
                    "rationale": fake.description(),
                    "rationale_en": fake_en.sentence(nb_words=10, variable_nb_words=True),
                    "rationale_ru": fake_ru.sentence(nb_words=10, variable_nb_words=True),
                    "rationaleType": rationaleType,
                }
        })


def test_modification_data(item_id, field_name, field_value):
    data = {
        "modifications": [
            {
                "itemId": item_id,
                field_name: field_value
            }
        ]
    }
    return munchify({'data': data})


def get_hash(file_contents):
    return ("md5:" + hashlib.md5(file_contents).hexdigest())


def test_monitoring_data(tender_id, accelerator=None):
    data = {"reasons": [random.choice(["public", "fiscal", "indicator", "authorities", "media"])],
            "tender_id": tender_id,
            "procuringStages": [random.choice(["awarding", "contracting", "planning"])],
            "parties": [test_party()],
            "mode": "test",
            'monitoringDetails': 'quick, ' 'accelerator={}'.format(accelerator)}
    return munchify({'data': data})


def test_party():
    party = fake.procuringEntity()
    party["roles"] = [random.choice(['sas', 'risk_indicator'])]
    party["name"] = "The State Audit Service of Ukraine"
    return munchify(party)


def test_dialogue():
    return munchify(
        {
            "data":
                {
                    "title": fake_en.sentence(nb_words=10, variable_nb_words=True),
                    "description": fake_en.sentence(nb_words=10, variable_nb_words=True)
                }
        })


def test_conclusion(violationOccurred, relatedParty_id):
    return munchify(
        {
            "data": {
                "conclusion": {
                    "violationOccurred": violationOccurred,
                    "violationType": random.choice(violationType),
                    "relatedParty": relatedParty_id,
                }
            }
        })


def test_status_data(status, relatedParty_id=None):
    data = {
        "data": {
            "status": status
        }
    }
    if status in ('stopped', 'cancelled'):
        data["data"]["cancellation"] = {}
        data["data"]["cancellation"]["description"] = fake_en.sentence(nb_words=10, variable_nb_words=True)
        data["data"]["cancellation"]["relatedParty"] = relatedParty_id
    return munchify(data)


def test_elimination_report(corruption, relatedParty_id):
    return munchify({
        "data": {
            "eliminationResolution": {
                "resultByType": {
                    corruption: random.choice(["eliminated", "not_eliminated", "no_mechanism"])
                },
                "relatedParty": relatedParty_id,
                "result": random.choice(["completely", "partly", "none"]),
                "description": fake_en.sentence(nb_words=10, variable_nb_words=True)
            }
        }
    })


def test_tender_data_esco(params, submissionMethodDetails, plan_data):
    data = test_tender_data(params, plan_data, ('tender',), submissionMethodDetails)
    data['procurementMethodType'] = 'esco'
    data['title_en'] = "[TESTING]"
    for item_number, item in enumerate(data['items']):
        item['description_en'] = "Test item #{}".format(item_number)
        del item['unit']
    data['procuringEntity']['name_en'] = fake_en.name()
    data['procuringEntity']['contactPoint']['name_en'] = fake_en.name()
    data['procuringEntity']['contactPoint']['availableLanguage'] = "en"
    data['procuringEntity']['identifier']['legalName_en'] = fake_en.sentence(nb_words=10, variable_nb_words=True)
    data['procuringEntity']['kind'] = 'general'
    data['minimalStepPercentage'] = float(round(random.uniform(0.015, 0.03), 5))
    data['fundingKind'] = params['fundingKind']
    data['NBUdiscountRate'] = float(round(random.uniform(0, 0.99), 5))
    percentage_list = []
    del data["value"]
    del data["minimalStep"]
    del data["milestones"]
    for index in range(params['number_of_lots']):
        data['lots'][index]['fundingKind'] = data['fundingKind']
        if index == 0:
            data['lots'][index]['minimalStepPercentage'] = data['minimalStepPercentage']
        else:
            data['lots'][index]['minimalStepPercentage'] = round((float(data['minimalStepPercentage']) - 0.0002), 5)
        if data['fundingKind'] == "budget":
            data['lots'][index]['yearlyPaymentsPercentageRange'] = float(round(random.uniform(0.01, 0.8), 5))
        else:
            data['lots'][index]['yearlyPaymentsPercentageRange'] = 0.8
        percentage_list.append(data['lots'][index]['yearlyPaymentsPercentageRange'])
        del data['lots'][index]['value']
        del data['lots'][index]['minimalStep']
    if params['number_of_lots'] == 0:
        if data['fundingKind'] == "budget":
            data['yearlyPaymentsPercentageRange'] = float(round(random.uniform(0.01, 0.8), 3))
        else:
            data['yearlyPaymentsPercentageRange'] = 0.8
    else:
        data['yearlyPaymentsPercentageRange'] = min(percentage_list)
    for index in range(params['number_of_items']):
        del data['items'][index]['deliveryDate']
    return data


def test_tender_data_pq(params, submissionMethodDetails, plan_data):
    data = test_tender_data(params, plan_data, ('tender',), submissionMethodDetails)
    del data["minimalStep"]
    data['procurementMethodType'] = 'priceQuotation'
    if params['profile']:
        data['profile'] = fake.valid_profile()
    else:
        data['profile'] = fake.invalid_profile()
    return munchify(data)


def test_milestone_data():
    return munchify({
        "code": random.choice(["prepayment", "postpayment"]),
        "title": fake.milestone_title(),
        "duration": {
            "type": random.choice(["working", "banking", "calendar"]),
            "days": random.randint(1, 364)
        },
        "type": "financing"
    })


def percentage_generation(number_of_milestones):
    # input: number_of_milestones 1, 2, 3, ...
    # output: list of percentage numbers
    percentage_data = [random.randint(1, round(100 / number_of_milestones)) for _ in range(number_of_milestones - 1)]
    percentage_data.append(100 - sum(percentage_data))
    return percentage_data


def invalid_INN_data():
    return munchify({
        "scheme": "INN",
        "description": "Insulin (human)",
        "id": "insulin (human)"
    })


def invalid_cost_data():
    return munchify({
        "scheme": "UA-ROAD",
        "id": "H-08",
        "description": "Бориспіль - Дніпро - Запоріжжя (через м. Кременчук) - Маріуполь"
    })


def invalid_gmdn_data():
    return munchify({
        "scheme": "GMDN",
        "id": "10082",
        "description": "Змішувач амальгами для стоматології"
    })


def test_buyers_data():
    buyers = {
        "identifier": {
            "scheme": "UA-EDR",
            "id": random.choice(["13313462", "00037256"]),
            "legalName": random.choice([u"Київський Тестовий Ліцей", u"Київська Тестова міська клінічна лікарня"]),
        }
    }
    return munchify(buyers)


def invalid_buyers_data():
    buyers = {
        "identifier": {
            "scheme": "UA-EDR",
            "id": "13313462",
            "legalName": "Київський Тестовий Ліцей",
        },
        "name": "Київський Тестовий Ліцей"
    }
    return munchify(buyers)


def test_plan_cancel_data():
    plan_cancel = {
        "cancellation": {
            "reason": "Підстава для скасування",
            "reason_en": "Reason of the cancellation"
        }
    }
    return munchify(plan_cancel)


def test_confirm_plan_cancel_data():
    return munchify({
        "data": {
            "cancellation": {
                "status": "active"
            }
        }
    })


def test_breakdown_data():
    return munchify({
        "title": random.choice(["state", "local", "crimea", "own", "fund", "loan", "other"]),
        "description": fake.description(),
        "value": {
            "currency": "UAH"
        }
    })


def breakdown_value_generation(number_of_breakdown, plan_value):
    value_data = [round(random.uniform(1, plan_value / number_of_breakdown), 2) for _ in range(number_of_breakdown - 1)]
    value_data.append(round(plan_value - sum(value_data), 2))
    return value_data


def test_cancellation_data(procurement_method_type):
    if procurement_method_type == "aboveThresholdUA.defense":
        result = random.choice(["noDemand", "unFixable", "expensesCut"])
    elif procurement_method_type in ["negotiation", "negotiation.quick"]:
        result = random.choice(["noObjectiveness", "unFixable", "noDemand", "expensesCut", "dateViolation"])
    elif procurement_method_type == "belowThreshold":
        result = random.choice(["noDemand", "unFixable", "expensesCut"])
    else:
        result = random.choice(["noDemand", "unFixable", "forceMajeure", "expensesCut"])
    return munchify({"reasonType": result})
