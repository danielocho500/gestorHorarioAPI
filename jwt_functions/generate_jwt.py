import jwt
from decouple import config
from datetime import datetime, timedelta

def generate_jwt(id, rol):
    token = jwt.encode({
        "id": id,
        "rol": rol,
        "expiration": str(datetime.utcnow() + timedelta(hours=3))
    }, config("JWT_PASS"), algorithm="HS256")

    return token