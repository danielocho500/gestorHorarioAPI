import jwt
from decouple import config
from models.Token import Token_Model
from utils.db import db

def generate_jwt(id):
    encoded = jwt.encode({"id": id}, config("JWT_PASS"), algorithm="HS256")
    token = Token_Model(
        value=encoded
    )

    db.session.add(token)
    db.session.commit()

    return encoded