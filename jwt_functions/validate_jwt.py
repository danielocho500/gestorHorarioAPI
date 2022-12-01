import jwt
from decouple import config
from datetime import datetime

def validate_jwt(token):
    try:
        data = jwt.decode(token,config("JWT_PASS"), algorithms=["HS256"])
        now_date = datetime.today()
        expiration_date = datetime.strptime(data['expiration'], '%Y-%m-%d %H:%M:%S.%f')

        if(expiration_date > now_date):
            return True
        else:
            return False
    except Exception as e:
        print(e)
        return False