from __future__ import print_function
from openprocurement_client.resources.tenders import Client
from openprocurement_client.resources.edr import EDRClient
from openprocurement_client.resources.agreements import AgreementClient
from openprocurement_client.dasu_client import DasuClient
from openprocurement_client.resources.document_service import DocumentServiceClient
from openprocurement_client.resources.plans import PlansClient
from openprocurement_client.resources.contracts import ContractingClient
from openprocurement_client.exceptions import IdNotFound
from http.client import BadStatusLine
from retrying import retry
from time import sleep
import os
import requests
import urllib.request
from openprocurement_client.resources.tenders import TenderCreateClient
from openprocurement_client.resources.tenders import PaymentClient


def retry_if_request_failed(exception):
    status_code = getattr(exception, 'status_code', None)
    print(status_code)
    if 500 <= status_code < 600 or status_code in (409, 429, 412):
        return True
    else:
        return isinstance(exception, BadStatusLine)


class StableClient(Client):
    @retry(stop_max_attempt_number=100, wait_random_min=500,
           wait_random_max=4000, retry_on_exception=retry_if_request_failed)
    def request(self, *args, **kwargs):
        return super(StableClient, self).request(*args, **kwargs)


class StableDsClient(DocumentServiceClient):
    @retry(stop_max_attempt_number=100, wait_random_min=500,
           wait_random_max=4000, retry_on_exception=retry_if_request_failed)
    def request(self, *args, **kwargs):
        return super(StableDsClient, self).request(*args, **kwargs)


class StableAgreementClient(AgreementClient):
    @retry(stop_max_attempt_number=100, wait_random_min=500,
           wait_random_max=4000, retry_on_exception=retry_if_request_failed)
    def request(self, *args, **kwargs):
        return super(StableAgreementClient, self).request(*args, **kwargs)


def prepare_api_wrapper(key, resource, host_url, api_version, ds_config=None):
    return StableClient(key, resource, host_url, api_version,
                        ds_config=ds_config)


def prepare_ds_api_wrapper(ds_host_url, auth_ds):
    return StableDsClient(ds_host_url, auth_ds)


def prepare_agreement_api_wrapper(key, resource, host_url, api_version, ds_config=None):
    return StableAgreementClient(key, resource, host_url, api_version,
                        ds_config=ds_config)


class ContractingStableClient(ContractingClient):
    @retry(stop_max_attempt_number=100, wait_random_min=500, wait_random_max=4000, retry_on_exception=retry_if_request_failed)
    def request(self, *args, **kwargs):
        return super(ContractingStableClient, self).request(*args, **kwargs)


def prepare_contract_api_wrapper(key, resource, host_url, api_version, ds_config=None):
    return ContractingStableClient(key, resource, host_url, api_version, ds_config=ds_config)


class StableEDRClient(EDRClient):
    @retry(stop_max_attempt_number=100, wait_random_min=500,
           wait_random_max=4000, retry_on_exception=retry_if_request_failed)
    def request(self, *args, **kwargs):
        try:
            res = super(StableEDRClient, self).request(*args, **kwargs)
        except requests.exceptions.HTTPError as re:
            if re.response.status_code == 429:
                sleep(int(re.response.headers.get('Retry-After', '30')))
            raise re
        else:
            return res


def prepare_edr_wrapper(host_url, api_version, username, password):
    return StableEDRClient(host_url, api_version, username, password)


def get_complaint_internal_id(tender, complaintID):
    try:
        for complaint in tender.data.complaints:
            if complaint.complaintID == complaintID:
                return complaint.id
    except AttributeError:
        pass
    try:
        for award in tender.data.awards:
            for complaint in award.complaints:
                if complaint.complaintID == complaintID:
                    return complaint.id
    except AttributeError:
        pass
    try:
        for qualification in tender.data.qualifications:
            for complaint in qualification.complaints:
                if complaint.complaintID == complaintID:
                    return complaint.id
    except AttributeError:
        pass
    try:
        for cancellation in tender.data.cancellations:
            for complaint in cancellation.complaints:
                if complaint.complaintID == complaintID:
                    return complaint.id
    except AttributeError:
        pass
    raise IdNotFound


def get_document_by_id(data, doc_id):
    for document in data.get('documents', []):
        if doc_id in document.get('title', ''):
            return document
    for complaint in data.get('complaints', []):
        for document in complaint.get('documents', []):
            if doc_id in document.get('title', ''):
                return document
    for contract in data.get('contracts', []):
        for document in contract.get('documents', []):
            if doc_id in document.get('title', ''):
                return document
    for award in data.get('awards', []):
        for document in award.get('documents', []):
            if doc_id in document.get('title', ''):
                return document
        for complaint in award.get('complaints', []):
            for document in complaint.get('documents', []):
                if doc_id in document.get('title', ''):
                    return document
    for cancellation in data.get('cancellations', []):
        for document in cancellation.get('documents', []):
            if doc_id in document.get('title', ''):
                return document
    for bid in data.get('bids', []):
        for document in bid.get('documents', []):
            if doc_id in document.get('title', ''):
                return document
    raise Exception('Document with id {} not found'.format(doc_id))


def get_tenders_feed(client, interval=0.5):
    for item in get_items_feed(client, 'get_tenders', interval):
        yield item


def get_plans_feed(client, interval=0.5):
    for item in get_items_feed(client, 'get_plans', interval):
        yield item


def get_contracts_feed(client, interval=0.5):
    for item in get_items_feed(client, 'get_contracts', interval):
        yield item


def get_items_feed(client, client_method, interval=0.5):
    items = True
    while items:
        items = getattr(client, client_method)()
        for item in items:
            yield item
        sleep(interval)


def download_file_from_url(url, path_to_save_file):
    f = open(path_to_save_file, 'wb')
    f.write(urllib.request.urlopen(url).read())
    f.close()
    return os.path.basename(f.name)


class StableClient_plan(PlansClient):
    @retry(stop_max_attempt_number=100, wait_random_min=500, wait_random_max=4000, retry_on_exception=retry_if_request_failed)
    def request(self, *args, **kwargs):
        return super(StableClient_plan, self).request(*args, **kwargs)


def prepare_plan_api_wrapper(key, resource, host_url, api_version):
    return StableClient_plan(key, resource, host_url, api_version)


class StableClient_dasu(DasuClient):
    @retry(stop_max_attempt_number=100, wait_random_min=500,
           wait_random_max=4000, retry_on_exception=retry_if_request_failed)
    def request(self, *args, **kwargs):
        return super(StableClient_dasu, self).request(*args, **kwargs)


def prepare_dasu_api_wrapper(resource, host_url, api_version, username, password, ds_config=None):
    return StableClient_dasu(resource, host_url, api_version, username, password, ds_config=ds_config)


class StableTenderCreateClient(TenderCreateClient):
    @retry(stop_max_attempt_number=100, wait_random_min=500,
           wait_random_max=4000, retry_on_exception=retry_if_request_failed)
    def request(self, *args, **kwargs):
        return super(StableTenderCreateClient, self).request(*args, **kwargs)


def prepare_tender_create_wrapper(key, resource, host_url, api_version, ds_config=None):
    return StableTenderCreateClient(key, resource, host_url, api_version, ds_config=ds_config)


class StableClientAmcu(Client):
    @retry(stop_max_attempt_number=100, wait_random_min=500,
           wait_random_max=4000, retry_on_exception=retry_if_request_failed)
    def request(self, *args, **kwargs):
        return super(StableClientAmcu, self).request(*args, **kwargs)


def prepare_amcu_api_wrapper(key, resource, host_url, api_version, ds_config=None):
    return StableClientAmcu(key, resource, host_url, api_version, ds_config=ds_config)


class StableClientPayment(PaymentClient):
    @retry(stop_max_attempt_number=100, wait_random_min=500,
           wait_random_max=4000, retry_on_exception=retry_if_request_failed)
    def request(self, *args, **kwargs):
        return super(StableClientPayment, self).request(*args, **kwargs)


def prepare_payment_wrapper(key, resource, host_url, api_version):
    return StableClientPayment(key, resource, host_url, api_version)
