from jwt_functions.validate_jwt import validate_jwt
import jwt
from decouple import config

def get_uid(token):
    if not(validate_jwt(token)):
        return False
    
    data = jwt.decode(token,config("JWT_PASS"), algorithms=["HS256"])

    return data['id']

def get_rol(token):
    if not(validate_jwt(token)):
        return False
    
    data = jwt.decode(token,config("JWT_PASS"), algorithms=["HS256"])

    return data['rol']
