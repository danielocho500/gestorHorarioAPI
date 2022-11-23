from sqlalchemy import Column, Integer, String, DateTime
from utils.db import db

class Token_Model(db.Model):
    __tablename__ = "token"

    id = Column(Integer, primary_key= True)
    value = Column(String(200))

    def __init__(self, value):
        self.value = value
