from sqlalchemy import Column, Integer, String, DateTime
from utils.db import db

class Area_Model(db.Model):
    __tablename__ = "area"

    id = Column(Integer, primary_key= True)
    nombre = Column(String(200))
    createdAt = Column(DateTime)
    updatedAt = Column(DateTime)

    def __init__(self, nombre, createdAt, updatedAt):
        self.nombre = nombre
        self.createdAt = createdAt
        self.updatedAt = updatedAt

