from sqlalchemy import Column, Integer, String, DateTime
from utils.db import db

class DiaSemana_Model(db.Model):
    __tablename__ = "diaSemana"

    id = Column(Integer, primary_key= True)
    nombre = Column(String(100))

    def __init__(self, nombre):
        self.nombre = nombre

