from sqlalchemy import Column, Integer, String, DateTime
from utils.db import db

class Usuario_Model(db.Model):
    __tablename__ = "usuario"

    uid = Column(Integer, primary_key= True)
    correo = Column(String(100))
    password = Column(String(250))
    isActivo = Column(Integer)
    primerNombre = Column(String(100))
    segundoNombre = Column(String(100), nullable=True)
    primerApellido = Column(String(100))
    segundoApellido = Column(String(100), nullable=True)
    rol = Column(Integer, db.ForeignKey('rol.id'))
    fechaNacimiento = Column(DateTime)
    createdAt = Column(DateTime)
    updatedAt =  Column(DateTime)
    claveEmpleado = Column(String(100), nullable=True)
    matricula = Column(String(100), nullable=True)

    def __init__(self,correo,password,isActivo,primerNombre,segundoNombre,primerApellido,segundoApellido,rol,fechaNacimiento,createdAt,updatedAt, claveEmpleado = None, matricula = None):
        self.correo = correo
        self.password = password
        self.isActivo = isActivo
        self.primerNombre = primerNombre
        self.segundoNombre = segundoNombre
        self.primerApellido = primerApellido
        self.segundoApellido = segundoApellido
        self.rol = rol
        self.fechaNacimiento = fechaNacimiento,
        self.createdAt = createdAt
        self.updatedAt = updatedAt
        self.claveEmpleado = claveEmpleado
        self.matricula = matricula
