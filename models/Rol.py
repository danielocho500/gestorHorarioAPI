from sqlalchemy import Column, Integer, String, DateTime
from utils.db import db

class Rol_Model(db.Model):
    __tablename__ = "rol"

    id = Column(Integer, primary_key= True)
    nombre = Column(String(100))

    def __init__(self, nombre, pisos, createdAt, updatedAt):
        self.nombre = nombre
