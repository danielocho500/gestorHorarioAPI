from sqlalchemy import Column, Integer, String, DateTime
from utils.db import db

class MateriaArea_Model(db.Model):
    __tablename__ = "materiaArea"

    idMateria = Column(Integer, db.ForeignKey('materia.id'))
    idArea = Column(Integer, db.ForeignKey('area.id'))

    def __init__(self, idMateria, idArea):
        self.idMateria = idMateria
        self.idArea = idArea