import time    
import datetime
import json

from sqlalchemy import and_
from flask_restful import Resource, reqparse
from helpers.validateTime import regexTime, is_time_between
from models.Horario import Horario_Model
from models.DiaSemana import DiaSemana_Model
from models.Salon import Salon_Model
from utils.db import db
from utils.response_template import response_template

#abort(404, message="video id is not valid")

horario_patch_args = reqparse.RequestParser()
horario_patch_args.add_argument("idSemana", type=int, help="Id de la semana", required = True)
horario_patch_args.add_argument("idSalon", type=int, help="Id del salon", required = True)
horario_patch_args.add_argument("horarioInicio", type=str, help="Horario de inicio", required = True)
horario_patch_args.add_argument("horarioFin", type=str, help="Horario de fin", required = True)

horario_post_args = reqparse.RequestParser()
horario_post_args.add_argument("idSemana", type=int, help="Id de la semana", required = True)
horario_post_args.add_argument("idSalon", type=int, help="Id del salon", required = True)
horario_post_args.add_argument("horarioInicio", type=str, help="Horario de inicio", required = True)
horario_post_args.add_argument("horarioFin", type=str, help="Horario de fin", required = True)

class Horario(Resource):
    def get(self, idHorario):
        try:
            horario = db.get_or_404(Horario_Model, idHorario)
        except:
            return response_template.not_found('El horario no fue encontrado')

        data = {
            'idHorario' : horario.id,
            'idSemana': horario.idSemana,
            'idSalon': horario.idSalon,
            'horanicio': str(horario.horaInicio),
            'horaFin': str(horario.horaFin)
        }
        return response_template.succesful(data, '', 200)
    def put(self, idHorario):
        args = horario_patch_args.parse_args()

        try:
            horario = db.get_or_404(Horario_Model, idHorario)
        except:
            return response_template.not_found('El horario no fue encontrado')

        try:
            db.get_or_404(Salon_Model, args.idSalon)
        except:
            return response_template.not_found('El salon no fue encontrado')

        try:
            db.get_or_404(DiaSemana_Model, args.idSemana)
        except:
            return response_template.not_found('El dia de la semana no fue encontrado')

        if not(regexTime(args.horarioInicio) and regexTime(args.horarioFin)):
            return response_template.bad_request(msg='Horario incorrecto')
    
        horarioInicioCadena = datetime.datetime.strptime(args.horarioInicio, '%H:%M').time()
        horarioFinCadena = datetime.datetime.strptime(args.horarioFin, '%H:%M').time()

        if horarioInicioCadena == horarioFinCadena:
            return response_template.bad_request(msg='No se puede iniciar y terminar en la misma hora')

        horarios_models = db.session.execute(db.select(Horario_Model).filter(and_(Horario_Model.idSalon == args.idSalon ,Horario_Model.idSemana == args.idSemana, Horario_Model.id != idHorario))).scalars().fetchall()
        checarHorario = None
        for horarioCoincidentes in horarios_models:
            checarHorario = is_time_between(horarioCoincidentes.horaInicio, horarioCoincidentes.horaFin, horarioFinCadena, horarioInicioCadena)
            if checarHorario:
                return response_template.bad_request(msg='Hora no valido. Existe choque de horarios') 

        horario.idSemana = args.idSemana
        horario.idSalon = args.idSalon
        horario.horaInicio = args.horarioInicio
        horario.horaFin = args.horarioFin
        horario.updatedAt = time.strftime('%Y-%m-%d %H:%M:%S')

        db.session().commit()
        return response_template.succesful({},"Horario modificado", 204 )
    def delete(self, idHorario):
        try:
            horario = db.get_or_404(Horario_Model, idHorario)
        except:
            return response_template.not_found('El horario no fue encontrado')
        
        db.session.delete(horario)
        db.session.commit()
        return response_template.succesful({}, "horario eliminado", 200)

class Horarios(Resource):
    def post(self):
        args = horario_post_args.parse_args() 

        try:
            db.get_or_404(Salon_Model, args.idSalon)
        except:
            return response_template.not_found('El salon no fue encontrado')

        try:
            db.get_or_404(DiaSemana_Model, args.idSemana)
        except:
            return response_template.not_found('El dia de la semana no fue encontrado')

        if not(regexTime(args.horarioInicio) and regexTime(args.horarioFin)):
            return response_template.bad_request(msg='Formato de hora incorrecto')

        horarioInicioCadena = datetime.datetime.strptime(args.horarioInicio, '%H:%M').time()
        horarioFinCadena = datetime.datetime.strptime(args.horarioFin, '%H:%M').time()

        if horarioInicioCadena == horarioFinCadena:
            return response_template.bad_request(msg='No se puede iniciar y terminar en la misma hora')

        horarios_models = db.session.execute(db.select(Horario_Model).filter(and_(Horario_Model.idSalon == args.idSalon ,Horario_Model.idSemana == args.idSemana))).scalars().fetchall()
        checarHorario = None
        for horarioCoincidentes in horarios_models:
            checarHorario = is_time_between(horarioCoincidentes.horaInicio, horarioCoincidentes.horaFin, horarioFinCadena, horarioInicioCadena)
            if checarHorario:
                return response_template.bad_request(msg='Hora no valido. Existe choque de horarios')

        horario = Horario_Model(
            idSemana= args.idSemana,
            idSalon= args.idSalon,
            horaInicio = horarioInicioCadena,
            horaFin = horarioFinCadena,
            createdAt=time.strftime('%Y-%m-%d %H:%M:%S'),
            updatedAt=time.strftime('%Y-%m-%d %H:%M:%S')
        )

        db.session.add(horario)
        db.session.commit()

        return response_template.created(msg='Horario creado')
    
    def get(self):
        horarios_models = db.session.execute(db.select(Horario_Model)).scalars().fetchall()
        data = []
        for horario in horarios_models:
            data.append({
            'idHorario' : horario.id,
            'idSemana': horario.idSemana,
            'idSalon': horario.idSalon,
            'horaInicio': str(horario.horaInicio),
            'horaFin': str(horario.horaFin)
            })

        return response_template.succesful(data=data, msg='', code=200)

class HorariosSalon(Resource):
    def get(self, idSalon):

        try:
            horario = db.get_or_404(Salon_Model, idSalon)
        except:
            return response_template.not_found('El salon no fue encontrado')

        horarios_models = db.session.execute(db.select(Horario_Model).filter(Horario_Model.idSalon == idSalon)).scalars().fetchall()
        data = []

        for horario in horarios_models:
            data.append({
            'idHorario' : horario.id,
            'idSemana': horario.idSemana,
            'idSalon': horario.idSalon,
            'horarioInicio': str(horario.horaInicio),
            'horarioFin': str(horario.horaFin)
            })

        return response_template.succesful(data=data, msg='', code=200)