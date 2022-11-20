from sqlalchemy import Column, Integer, String, DateTime
from utils.db import db

class Salon_Model(db.Model):
    __tablename__ = "salon"

    id = Column(Integer, primary_key= True)
    idEdificio = Column(Integer, db.ForeignKey('edificio.id'))
    nombre = Column(String(100))
    proyector = Column(Integer)
    totalCupo = Column(Integer)
    createdAt = Column(DateTime)
    updatedAt = Column(DateTime)

    def __init__(self, idEdificio, nombre, proyector, totalCupo, createdAt, updatedAt):
        self.nombre = nombre
        self.idEdificio = idEdificio
        self.proyector = proyector
        self.totalCupo = totalCupo
        self.createdAt = createdAt
        self.updatedAt = updatedAt

