from cryptography.fernet import Fernet
from decouple import config

def encrypt(str):
    fernet = Fernet(config('CRYPT_PASS').encode())
    enc = fernet.encrypt(str.encode())

    return enc

def decrypt(str):
    fernet = Fernet(config('CRYPT_PASS').encode())
    dec = fernet.decrypt(str).decode()

    return dec
