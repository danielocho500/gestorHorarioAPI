from sqlalchemy import Column, Integer, DateTime, Time
from utils.db import db

class estudianteGrupo_Model(db.Model):
    __tablename__ = "estudianteGrupo"

    id = Column(Integer, primary_key= True)
    idEstudiante = Column(Integer, db.ForeignKey('Usuario.uid'))
    idGrupo = Column(Integer, db.ForeignKey('Grupo.id'))
    isRepite = Column(Integer)
    createdAt = Column(DateTime)
    updatedAt = Column(DateTime)

    def __init__(self, idEstudiante, idGrupo, isRepite, createdAt, updatedAt):
        self.idEstudiante = idEstudiante
        self.idGrupo = idGrupo
        self.isRepite = isRepite
        self.createdAt = createdAt
        self.updatedAt = updatedAt