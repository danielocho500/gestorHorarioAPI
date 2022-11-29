from sqlalchemy import Column, Integer
from utils.db import db

class MateriaArea_Model(db.Model):
    __tablename__ = "materiaArea"

    id = Column(Integer, primary_key= True)
    idMateria = Column(Integer, db.ForeignKey('materia.id'))
    idArea = Column(Integer, db.ForeignKey('area.id'))

    def __init__(self, idMateria, idArea):
        self.idMateria = idMateria
        self.idArea = idArea