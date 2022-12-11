from sqlalchemy import Column, Integer, DateTime, Time
from utils.db import db

class Periodo_Model(db.Model):
    __tablename__ = "Periodo"

    id = Column(Integer, primary_key= True)
    fechaInicio = Column(DateTime)
    fechaFin = Column(DateTime)
    fechaOrdinario = Column(DateTime)
    fechaExtra = Column(DateTime)
    activo = Column(Integer)
    createdAt = Column(DateTime)
    updatedAt = Column(DateTime)

    def __init__(self, fechaInicio, fechaFin, fechaOrdinario, fechaExtra,activo, createdAt, updatedAt):
        self.fechaInicio = fechaInicio
        self.fechaFin = fechaFin
        self.fechaOrdinario = fechaOrdinario
        self.fechaExtra = fechaExtra
        self.activo = activo
        self.createdAt = createdAt
        self.updatedAt = updatedAt