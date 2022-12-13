from sqlalchemy import Column, Integer, DateTime, Time
from utils.db import db

class Horario_Model(db.Model):
    __tablename__ = "horario"

    id = Column(Integer, primary_key= True)
    idSemana = Column(Integer, db.ForeignKey('diaSemana.id'))
    idSalon = Column(Integer, db.ForeignKey('salon.id'))
    idClase = Column(Integer, db.ForeignKey('Clase.id'))
    horaInicio = Column(Time)
    horaFin = Column(Time)
    createdAt = Column(DateTime)
    updatedAt = Column(DateTime)

    def __init__(self, idSemana, idSalon, idClase,horaInicio, horaFin, createdAt, updatedAt):
        self.idSemana = idSemana
        self.idSalon = idSalon
        self.idClase = idClase
        self.horaInicio = horaInicio
        self.horaFin = horaFin
        self.createdAt = createdAt
        self.updatedAt = updatedAt