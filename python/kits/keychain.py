from ctypes import *
from ctypes import util

_security = cdll.LoadLibrary(util.find_library("Security"))

def exists(service, account):
    pwd = retrieve(service, account)
    return True if pwd is not None else False

def store(service, account, password):
    service_len = c_ulong(len(service))
    service_data = c_char_p(service)
    account_len = c_ulong(len(account))
    account_data = c_char_p(account)
    password_len = c_ulong(len(password))
    password_data = c_char_p(password)
    _security.SecKeychainAddGenericPassword(
        None,
        service_len,
        service_data,
        account_len,
        account_data,
        password_len,
        password_data,
        None
    )

def retrieve(service, account):
    service_len = c_ulong(len(service))
    service_data = c_char_p(service)
    account_len = c_ulong(len(account))
    account_data = c_char_p(account)
    password_data = pointer(c_char_p())
    password_len = pointer(c_ulong())
    _security.SecKeychainFindGenericPassword(
        None,
        service_len,
        service_data,
        account_len,
        account_data,
        password_len,
        password_data,
        None
    )
    if password_data.contents.value is None:
        return None
    return password_data.contents.value[:password_len.contents.value]

def modify(service, account, new_password):
    service_len = c_ulong(len(service))
    service_data = c_char_p(service)
    account_len = c_ulong(len(account))
    account_data = c_char_p(account)
    new_password_len = c_ulong(len(new_password))
    new_password_data = create_string_buffer(new_password)
    item_ref = pointer(c_void_p())
    _security.SecKeychainFindGenericPassword(
        None,
        service_len,
        service_data,
        account_len,
        account_data,
        None,
        None,
        item_ref
    )
    _security.SecKeychainItemModifyAttributesAndData(
        item_ref.contents,
        None,
        new_password_len,
        new_password_data
    )

def delete(service, account):
    service_len = c_ulong(len(service))
    service_data = c_char_p(service)
    account_len = c_ulong(len(account))
    account_data = c_char_p(account)
    item_ref = pointer(c_void_p())
    _security.SecKeychainFindGenericPassword(
        None,
        service_len,
        service_data,
        account_len,
        account_data,
        None,
        None,
        byref(item_ref)
    )
    _security.SecKeychainItemDelete(item_ref)