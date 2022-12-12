from sqlalchemy import Column, Integer, String, DateTime
from utils.db import db

class Acta_Model(db.Model):
    __tablename__ = "Acta"

    id = Column(Integer, primary_key= True)
    idEstGrupo = Column(Integer, db.ForeignKey('estudianteGrupo.id'))
    nrc = Column(String, db.ForeignKey('Clase.nrc'))
    esFinal = Column(Integer)
    calificacion= Column(Integer)
    esOrdinario=Column(Integer)
    createdAt = Column(DateTime)
    updatedAt = Column(DateTime)

    def __init__(self, nombre, semestre, createdAt, updatedAt):
        self.nombre = nombre
        self.semestre = semestre
        self.createdAt = createdAt
        self.updatedAt = updatedAt