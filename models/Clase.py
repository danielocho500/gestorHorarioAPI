from sqlalchemy import Column, Integer, String, DateTime
from utils.db import db

class Clase_Model(db.Model):
    __tablename__ = "Clase"

    nrc = Column(String, primary_key= True)
    idProfesor = Column(Integer, db.ForeignKey('usuario.uid'))
    idMateria = Column(Integer, db.ForeignKey('materia.id'))
    idGrupo = Column(Integer, db.ForeignKey('Grupo.id'))
    createdAt = Column(DateTime)
    updatedAt = Column(DateTime)

    def __init__(self, nrc, idProfesor, idMateria,idGrupo, createdAt, updatedAt):
        self.nrc = nrc
        self.idProfesor = idProfesor
        self.idMateria = idMateria
        self.idGrupo = idGrupo
        self.createdAt = createdAt
        self.updatedAt = updatedAt