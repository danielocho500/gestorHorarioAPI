import time
from flask_restful import Resource, reqparse, abort

from models.Periodo import Periodo_Model
from utils.db import db
from utils.response_template import response_template
from helpers.validateDate import is_date, getDate, validarFechasPeriodo

periodo_post_args = reqparse.RequestParser()
periodo_post_args.add_argument("fechaInicio", type=str, help="Fecha de inicio del periodo", required = True)
periodo_post_args.add_argument("fechaFin", type=str, help="Fecha de termino del periodo", required = True)
periodo_post_args.add_argument("fechaOrdinario", type=str, help="Fecha de ordinario", required = True)
periodo_post_args.add_argument("fechaExtra", type=str, help="Fecha de extraordinario", required = True)


periodo_put_args = reqparse.RequestParser()
periodo_put_args.add_argument("fechaInicio", type=str, help="Fecha de inicio del periodo", required = True)
periodo_put_args.add_argument("fechaFin", type=str, help="Fecha de termino del periodo", required = True)
periodo_put_args.add_argument("fechaOrdinario", type=str, help="Fecha de ordinario", required = True)
periodo_put_args.add_argument("fechaExtra", type=str, help="Fecha de extraordinario", required = True)

class PeriodoActivo(Resource):
    def get(self):
        try:
            periodos_models = db.session.execute(db.Query(Periodo_Model).filter_by(activo=1)).scalars().fetchall()
            if not (periodos_models[0]):
                return response_template.not_found('No hay un periodo activo')

            print(periodos_models[0].fechaInicio)

            data = {
                "fechaInicio": str(periodos_models[0].fechaInicio),
                "fechaFin": str(periodos_models[0].fechaFin),
                "fechaOrdinario": str(periodos_models[0].fechaOrdinario),
                "fechaExtra": str(periodos_models[0].fechaExtra),
            }

            print(data)
            return response_template.succesful(data, 'Periodo Activo encontrado', 200)
        except:
            return response_template.not_found('No hay un periodo activo')

class PeriodoActivoPut(Resource):
    def put(self, idPeriodo):

        try:
            db.get_or_404(Periodo_Model, idPeriodo)
        except:
            return response_template.not_found('El periodo no fue encontrada')

        periodos_models = db.session.execute(db.select(Periodo_Model)).scalars().fetchall()

        for periodo in periodos_models:
            if(periodo.id == idPeriodo and periodo.activo == 0):
                periodo.activo = 1
                periodo.updatedAt = time.strftime('%Y-%m-%d %H:%M:%S')
            elif(periodo.id != idPeriodo and periodo.activo == 1):
                periodo.activo = 0
                periodo.updatedAt = time.strftime('%Y-%m-%d %H:%M:%S')
            db.session().commit()
            print(periodo.activo)

        return response_template.succesful({},"Periodo activado", 204 )
            

class Periodos(Resource):
    def get(self):
        periodos_models = db.session.execute(db.select(Periodo_Model)).scalars().fetchall()
        data = []

        for periodo in periodos_models:
            data.append({
                "id": periodo.id,
                "fechaInicio": str(periodo.fechaInicio),
                "fechaFin": str(periodo.fechaFin),
                "fechaOrdinario": str(periodo.fechaOrdinario),
                "fechaExtra": str(periodo.fechaExtra),
                "activo": periodo.activo
            })

        return response_template.succesful(data=data, msg='', code=200)
    def post(self):
        args = periodo_post_args.parse_args() 

        if not(is_date(args.fechaInicio) and is_date(args.fechaOrdinario) and is_date(args.fechaExtra) and is_date(args.fechaFin)):
            return response_template.bad_request(msg='Formato de fecha incorrecto')

        fechaInicio =  getDate(args.fechaInicio)
        fechaOrdinario = getDate(args.fechaOrdinario)
        fechaExtra = getDate(args.fechaExtra)
        fechaFin = getDate(args.fechaFin)

        responseDates = validarFechasPeriodo(fechaInicio, fechaOrdinario, fechaExtra, fechaFin)

        if not(responseDates['ok']):
            return response_template.bad_request(responseDates['msg'])
        
        periodo = Periodo_Model(
            fechaInicio= fechaInicio,
            fechaFin= fechaFin,
            fechaOrdinario= fechaOrdinario,
            fechaExtra= fechaExtra,
            activo=0,
            createdAt=time.strftime('%Y-%m-%d %H:%M:%S'),
            updatedAt=time.strftime('%Y-%m-%d %H:%M:%S')
        )

        db.session.add(periodo)
        db.session.commit()

        return response_template.succesful({}, 'Periodo creado', 200)


class Periodo(Resource):
    def get(self, idPeriodo):
        try:
            periodo = db.get_or_404(Periodo_Model, idPeriodo)
        except:
            return response_template.not_found('El periodo no fue encontrado')
        data = {
            "id": periodo.id,
            "fechaInicio": str(periodo.fechaInicio),
            "fechaFin": str(periodo.fechaFin),
            "fechaOrdinario": str(periodo.fechaOrdinario),
            "fechaExtra": str(periodo.fechaExtra),
            "activo": periodo.activo
        }
        return response_template.succesful(data, '', 200)
    def put(self, idPeriodo):
        args = periodo_put_args.parse_args()

        try:
            periodo = db.get_or_404(Periodo_Model, idPeriodo)
        except:
            return response_template.not_found('El periodo no fue encontrada')

        if not(is_date(args.fechaInicio) and is_date(args.fechaOrdinario) and is_date(args.fechaExtra) and is_date(args.fechaFin)):
            return response_template.bad_request(msg='Formato de fecha incorrecto')

        fechaInicio =  getDate(args.fechaInicio)
        fechaOrdinario = getDate(args.fechaOrdinario)
        fechaExtra = getDate(args.fechaExtra)
        fechaFin = getDate(args.fechaFin)

        responseDates = validarFechasPeriodo(fechaInicio, fechaOrdinario, fechaExtra, fechaFin)

        if not(responseDates['ok']):
            return response_template.bad_request(responseDates['msg'])

        periodo.fechaInicio = args.fechaInicio
        periodo.fechaOrdinario = args.fechaOrdinario
        periodo.fechaExtra = args.fechaExtra
        periodo.fechaFin = args.fechaFin
        periodo.updatedAt = time.strftime('%Y-%m-%d %H:%M:%S')

        db.session().commit()

        return response_template.succesful({},"Periodo modificado", 204 )
    def delete(self, idPeriodo):
        try:
            periodo = db.get_or_404(Periodo_Model, idPeriodo)
        except:
            return response_template.not_found('El periodo no fue encontrado')
        
        db.session.delete(periodo)
        db.session.commit()
        return response_template.succesful({}, "periodo eliminado", 200)

