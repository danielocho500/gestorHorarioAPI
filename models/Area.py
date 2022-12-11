from sqlalchemy import Column, Integer, String, DateTime
from utils.db import db

class Area_Model(db.Model):
    __tablename__ = "area"

    id = Column(Integer, primary_key= True)
    nombre = Column(String(200))
    semestre = Column(Integer)
    createdAt = Column(DateTime)
    updatedAt = Column(DateTime)

    def __init__(self, nombre,semestre, createdAt, updatedAt):
        self.nombre = nombre
        self.createdAt = createdAt
        self.updatedAt = updatedAt
        self.semestre = semestre

