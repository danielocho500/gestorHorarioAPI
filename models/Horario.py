from sqlalchemy import Column, Integer, DateTime, Time, String
from utils.db import db

class Horario_Model(db.Model):
    __tablename__ = "horario"

    id = Column(Integer, primary_key= True)
    idSemana = Column(Integer, db.ForeignKey('diaSemana.id'))
    idSalon = Column(Integer, db.ForeignKey('salon.id'))
    nrc = Column(String(20), db.ForeignKey('Clase.nrc'))
    horaInicio = Column(Time)
    horaFin = Column(Time)
    createdAt = Column(DateTime)
    updatedAt = Column(DateTime)

    def __init__(self, idSemana, idSalon, nrc,horaInicio, horaFin, createdAt, updatedAt):
        self.idSemana = idSemana
        self.idSalon = idSalon
        self.nrc = nrc
        self.horaInicio = horaInicio
        self.horaFin = horaFin
        self.createdAt = createdAt
        self.updatedAt = updatedAt