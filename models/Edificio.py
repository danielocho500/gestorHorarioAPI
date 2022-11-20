from sqlalchemy import Column, Integer, String, DateTime
from utils.db import db

class Edificio_Model(db.Model):
    __tablename__ = "edificio"

    id = Column(Integer, primary_key= True)
    nombre = Column(String(100))
    pisos = Column(Integer)
    createdAt = Column(DateTime)
    updatedAt = Column(DateTime)

    def __init__(self, nombre, pisos, createdAt, updatedAt):
        self.nombre = nombre
        self.pisos = pisos
        self.createdAt = createdAt
        self.updatedAt = updatedAt
