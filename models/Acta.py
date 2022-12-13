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

    def __init__(self, idEstGrupo,nrc,esFinal, calificacion, esOrdinario, createdAt, updatedAt):
        self.idEstGrupo = idEstGrupo
        self.nrc = nrc
        self.esFinal = esFinal
        self.calificacion = calificacion
        self.esOrdinario = esOrdinario
        self.createdAt = createdAt
        self.updatedAt = updatedAt