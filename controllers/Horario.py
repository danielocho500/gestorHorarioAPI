import time    
from flask_restful import Resource, reqparse, abortsalon_post_args

from models.Horario import Horario_Model
from models.DiaSemana import DiaSemana_Model
from models.Salon import Salon_Model
from utils.db import db
from utils.response_template import response_template

#abort(404, message="video id is not valid")

horario_patch_args = reqparse.RequestParser()
horario_patch_args.add_argument("idSemana", type=str, help="Id de la semana", required = True)
horario_patch_args.add_argument("idSalon", type=int, help="Id del salon", required = True)
horario_patch_args.add_argument("horarioInicio", type=int, help="Horario de inicio", required = True)
horario_patch_args.add_argument("horarioFin", type=int, help="Horario de fin", required = True)

horario_post_args = reqparse.RequestParser()
horario_post_args.add_argument("idSemana", type=str, help="Id de la semana", required = True)
horario_post_args.add_argument("idSalon", type=int, help="Id del salon", required = True)
horario_post_args.add_argument("horarioInicio", type=int, help="Horario de inicio", required = True)
horario_post_args.add_argument("horarioFin", type=int, help="Horario de fin", required = True)

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
            'horarioInicio': horario.horarioInicio,
            'horarioFin': horario.horarioFin
        }
        return response_template.succesful(data, '', 200)
    def patch(self, idHorario):
        args = horario_patch_args.parse_args()

        try:
            horario = db.get_or_404(Horario_Model, idHorario)
        except:
            return response_template.not_found('El horario no fue encontrado')
            
        horario.horarioInicio = args.horarioInicio
        horario.horarioFin = args.horarioFin
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
        
        horario = Horario_Model(
            idSemana= args.idSemana,
            idSalon= args.idSalon,
            horarioInicio = args.horarioInicio,
            horarioFin = args.horarioFin,
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
            'horarioInicio': horario.horarioInicio,
            'horarioFin': horario.horarioFin
            })

        return response_template.succesful(data=data, msg='', code=200)
    
    def get(self, idSemana):

        try:
            horario = db.get_or_404(Horario_Model, idSemana)
        except:
            return response_template.not_found('El horario no fue encontrado')
        
        horarios_models = db.session.execute(db.select(Horario_Model).filter(Horario_Model.idSemana == idSemana)).scalars().fetchall()
        data = []

        for horario in horarios_models:
            data.append({
            'idHorario' : horario.id,
            'idSemana': horario.idSemana,
            'idSalon': horario.idSalon,
            'horarioInicio': horario.horarioInicio,
            'horarioFin': horario.horarioFin
            })

        return response_template.succesful(data=data, msg='', code=200)
    
    def get(self, idSalon):

        try:
            horario = db.get_or_404(Horario_Model, idSalon)
        except:
            return response_template.not_found('El horario no fue encontrado')

        horarios_models = db.session.execute(db.select(Horario_Model).filter(Horario_Model.idSalon == idSalon)).scalars().fetchall()
        data = []

        for horario in horarios_models:
            data.append({
            'idHorario' : horario.id,
            'idSemana': horario.idSemana,
            'idSalon': horario.idSalon,
            'horarioInicio': horario.horarioInicio,
            'horarioFin': horario.horarioFin
            })

        return response_template.succesful(data=data, msg='', code=200)