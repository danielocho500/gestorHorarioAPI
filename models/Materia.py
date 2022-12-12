from sqlalchemy import Column, Integer, String, DateTime
from utils.db import db

class Materia_Model(db.Model):
    __tablename__ = "materia"

    id = Column(Integer, primary_key= True)
    idArea= Column(Integer, db.ForeignKey('area.id'))
    nombre = Column(String(200))
    createdAt = Column(DateTime)
    updatedAt = Column(DateTime)

    def __init__(self, idArea,nombre, createdAt, updatedAt):
        self.idArea = idArea
        self.nombre = nombre
        self.createdAt = createdAt
        self.updatedAt = updatedAt
