from sqlalchemy import Column, Integer, DateTime, Time, String
from utils.db import db

class Grupo_Model(db.Model):
    __tablename__ = "Grupo"

    id = Column(Integer, primary_key= True)
    idPeriodo = Column(Integer, db.ForeignKey('Periodo.id'))
    idArea = Column(Integer, db.ForeignKey('area.id'))
    semestre = Column(Integer)
    bloque = Column(String(25))
    createdAt = Column(DateTime)
    updatedAt = Column(DateTime)

    def __init__(self, idPeriodo,idArea,semestre,bloque, createdAt, updatedAt):
        self.idPeriodo = idPeriodo
        self.idArea = idArea
        self.semestre = semestre
        self.bloque = bloque
        self.createdAt = createdAt
        self.updatedAt = updatedAt