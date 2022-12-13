import time    
import datetime
from sqlalchemy.sql import text
from flask import request
from sqlalchemy import and_
from flask_restful import Resource, reqparse
from helpers.validateTime import regexTime, is_time_between
from models.Horario import Horario_Model
from models.DiaSemana import DiaSemana_Model
from models.Salon import Salon_Model
from models.Usuario import Usuario_Model
from models.Clase import Clase_Model
from utils.db import db
from utils.response_template import response_template
from jwt_functions.validate_jwt import validate_jwt
from jwt_functions import get_info_token

horario_patch_args = reqparse.RequestParser()
horario_patch_args.add_argument("idSemana", type=int, help="Id de la semana", required = True)
horario_patch_args.add_argument("idClase", type=str, help= "Id de la clase", required = True)
horario_patch_args.add_argument("idSalon", type=int, help="Id del salon", required = True)
horario_patch_args.add_argument("horarioInicio", type=str, help="Horario de inicio", required = True)
horario_patch_args.add_argument("horarioFin", type=str, help="Horario de fin", required = True)

horario_post_args = reqparse.RequestParser()
horario_post_args.add_argument("idSemana", type=int, help="Id de la semana", required = True)
horario_post_args.add_argument("idClase", type=str, help= "Id de la clase", required = True)
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
            'idClase': horario.idClase,
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

        try:
            db.get_or_404(Clase_Model, args.idClase)
        except:
            return response_template.not_found('Clase no encontrada')

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
        horario.idClase = args.idClase
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
        
        try:
            db.get_or_404(Clase_Model, args.idClase)
        except:
            return response_template.not_found('Clase no encontrada')

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
            idClase= args.idClase,
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
            'idClase': horario.idClase,
            'horaInicio': str(horario.horaInicio),
            'horaFin': str(horario.horaFin)
            })

        return response_template.succesful(data=data, msg='', code=200)

class HorariosSalon(Resource):
    def get(self, idSalon):

        try:
            db.get_or_404(Salon_Model, idSalon)
        except:
            return response_template.not_found('El salon no fue encontrado')

        statement = text("SELECT hor.idSemana, hor.idClase, hor.horaInicio, hor.horaFin, concat(prof.primerNombre, ' ' ,IFNULL(prof.segundoNombre, ''), ' ', prof.primerApellido, ' ', prof.segundoApellido) as nombreProfesor, mat.nombre, gru.semestre, gru.bloque FROM horario as hor INNER JOIN clase as cla INNER JOIN usuario as prof INNER JOIN materia as mat INNER JOIN grupo as gru WHERE cla.nrc = hor.idClase AND prof.uid = cla.idProfesor AND cla.idMateria = mat.id AND gru.id = cla.idGrupo AND hor.idSalon = {} ORDER BY hor.horaInicio ASC;".format(idSalon))

        horarios_filtrados = db.session.execute(statement).fetchall()
        horarios = {1:[], 2:[], 3:[], 4:[], 5:[] }

        for horario in horarios_filtrados:
            horarios[horario[0]].append({
                'nrc': horario[1],
                'horaInicio': str(horario[2]),
                'horaFIn': str(horario[3]),
                'maestro': horario[4],
                'materia': horario[5],
                'semestre': horario[6],
                'bloque': horario[7]
            })

        return response_template.succesful({
            'lunes': horarios[1],
            'martes': horarios[2],
            'miercoles': horarios[3],
            'jueves': horarios[4],
            'viernes': horarios[5],
        }, "materias validas", 200)

class HorarioEstudiante(Resource):
    def get(self, idEstudiante):
        try:
            db.get_or_404(Usuario_Model, idEstudiante)
        except:
            return response_template.not_found('El estudiante no fue encontrado')

        statement = text("SELECT hor.idSemana, hor.idClase, hor.horaInicio, hor.horaFin, concat(prof.primerNombre, ' ' ,IFNULL(prof.segundoNombre, ''), ' ', prof.primerApellido, ' ', prof.segundoApellido) as nombreProfesor, mat.nombre, sal.nombre as salon, edi.nombre as edificio FROM horario as hor INNER JOIN clase as cla INNER JOIN usuario as prof INNER JOIN materia as mat INNER JOIN grupo as gru INNER JOIN estudiantegrupo as estgru INNER JOIN usuario as us INNER JOIN salon as sal INNER JOIN edificio as edi WHERE cla.nrc = hor.idClase AND prof.uid = cla.idProfesor AND cla.idMateria = mat.id AND gru.id = cla.idGrupo AND estgru.idGrupo = gru.id AND estgru.idEstudiante = us.uid AND sal.id = hor.idSalon AND edi.id = sal.idEdificio AND us.uid = {} ORDER BY hor.horaInicio ASC;".format(idEstudiante))

        horarios_filtrados = db.session.execute(statement).fetchall()
        horarios = {1:[], 2:[], 3:[], 4:[], 5:[] }

        for horario in horarios_filtrados:
            horarios[horario[0]].append({
                'nrc': horario[1],
                'horaInicio': str(horario[2]),
                'horaFIn': str(horario[3]),
                'maestro': horario[4],
                'materia': horario[5],
                'salon': horario[6],
                'edificio': horario[7]
            })

        return response_template.succesful({
            'lunes': horarios[1],
            'martes': horarios[2],
            'miercoles': horarios[3],
            'jueves': horarios[4],
            'viernes': horarios[5],
        }, "materias validas", 200)

class HorarioEstudianteToken(Resource):
    def get(self):
        token = request.headers.get('auth_token')

        if(token == None):
            return response_template.not_authorized("No hay token en el header (auth_token)")
        
        if not (validate_jwt(token)):
            response_template.not_authorized("token inválido")

        rol = get_info_token.get_rol(token)
        idEstudiante = get_info_token.get_uid(token)

        if not (rol == 1):
            return response_template.not_authorized("No tienes permisos para realizar esta acción")

        try:
            db.get_or_404(Usuario_Model, idEstudiante)
        except:
            return response_template.not_found('El salon no fue encontrado')

        statement = text("SELECT hor.idSemana, hor.idClase, hor.horaInicio, hor.horaFin, concat(prof.primerNombre, ' ' ,IFNULL(prof.segundoNombre, ''), ' ', prof.primerApellido, ' ', prof.segundoApellido) as nombreProfesor, mat.nombre, sal.nombre as salon, edi.nombre as edificio FROM horario as hor INNER JOIN clase as cla INNER JOIN usuario as prof INNER JOIN materia as mat INNER JOIN grupo as gru INNER JOIN estudiantegrupo as estgru INNER JOIN usuario as us INNER JOIN salon as sal INNER JOIN edificio as edi WHERE cla.nrc = hor.idClase AND prof.uid = cla.idProfesor AND cla.idMateria = mat.id AND gru.id = cla.idGrupo AND estgru.idGrupo = gru.id AND estgru.idEstudiante = us.uid AND sal.id = hor.idSalon AND edi.id = sal.idEdificio AND us.uid = {} ORDER BY hor.horaInicio ASC;".format(idEstudiante))

        horarios_filtrados = db.session.execute(statement).fetchall()
        horarios = {1:[], 2:[], 3:[], 4:[], 5:[] }

        for horario in horarios_filtrados:
            horarios[horario[0]].append({
                'nrc': horario[1],
                'horaInicio': str(horario[2]),
                'horaFIn': str(horario[3]),
                'maestro': horario[4],
                'materia': horario[5],
                'salon': horario[6],
                'edificio': horario[7]
            })

        return response_template.succesful({
            'lunes': horarios[1],
            'martes': horarios[2],
            'miercoles': horarios[3],
            'jueves': horarios[4],
            'viernes': horarios[5],
        }, "materias validas", 200)


class HorarioProfesor(Resource):
    def get(self, idProfesor):
        try:
            db.get_or_404(Usuario_Model, idProfesor)
        except:
            return response_template.not_found('El profesor no fue encontrado')

        statement = text("SELECT hor.idSemana, hor.idClase, hor.horaInicio, hor.horaFin,  mat.nombre, sal.nombre as salon, edi.nombre as edificio, gru.semestre, gru.bloque FROM horario as hor INNER JOIN clase as cla INNER JOIN usuario as prof INNER JOIN materia as mat INNER JOIN grupo as gru INNER JOIN salon as sal INNER JOIN edificio as edi WHERE cla.nrc = hor.idClase AND prof.uid = cla.idProfesor AND cla.idMateria = mat.id AND gru.id = cla.idGrupo AND sal.id = hor.idSalon AND edi.id = sal.idEdificio AND prof.uid = {} ORDER BY hor.horaInicio ASC;".format(idProfesor))

        horarios_filtrados = db.session.execute(statement).fetchall()
        horarios = {1:[], 2:[], 3:[], 4:[], 5:[] }

        for horario in horarios_filtrados:
            horarios[horario[0]].append({
                'nrc': horario[1],
                'horaInicio': str(horario[2]),
                'horaFIn': str(horario[3]),
                'materia': horario[4],
                'salon': horario[5],
                'edificio': horario[6],
                'semestre': horario[7],
                'bloque': horario[8]
            })

        return response_template.succesful({
            'lunes': horarios[1],
            'martes': horarios[2],
            'miercoles': horarios[3],
            'jueves': horarios[4],
            'viernes': horarios[5],
        }, "materias validas", 200)

class HorarioProfesorToken(Resource):
    def get(self):
        token = request.headers.get('auth_token')

        if(token == None):
            return response_template.not_authorized("No hay token en el header (auth_token)")
        
        if not (validate_jwt(token)):
            response_template.not_authorized("token inválido")

        rol = get_info_token.get_rol(token)
        idProfesor = get_info_token.get_uid(token)

        if not (rol == 2):
            return response_template.not_authorized("No tienes permisos para realizar esta acción")

        try:
            db.get_or_404(Usuario_Model, idProfesor)
        except:
            return response_template.not_found('El salon no fue encontrado')

        statement = text("SELECT hor.idSemana, hor.idClase, hor.horaInicio, hor.horaFin,  mat.nombre, sal.nombre as salon, edi.nombre as edificio, gru.semestre, gru.bloque FROM horario as hor INNER JOIN clase as cla INNER JOIN usuario as prof INNER JOIN materia as mat INNER JOIN grupo as gru INNER JOIN salon as sal INNER JOIN edificio as edi WHERE cla.nrc = hor.idClase AND prof.uid = cla.idProfesor AND cla.idMateria = mat.id AND gru.id = cla.idGrupo AND sal.id = hor.idSalon AND edi.id = sal.idEdificio AND prof.uid = {} ORDER BY hor.horaInicio ASC;".format(idProfesor))

        horarios_filtrados = db.session.execute(statement).fetchall()
        horarios = {1:[], 2:[], 3:[], 4:[], 5:[] }

        for horario in horarios_filtrados:
            horarios[horario[0]].append({
                'nrc': horario[1],
                'horaInicio': str(horario[2]),
                'horaFIn': str(horario[3]),
                'materia': horario[4],
                'salon': horario[5],
                'edificio': horario[6],
                'semestre': horario[7],
                'bloque': horario[8]
            })

        return response_template.succesful({
            'lunes': horarios[1],
            'martes': horarios[2],
            'miercoles': horarios[3],
            'jueves': horarios[4],
            'viernes': horarios[5],
        }, "materias validas", 200)
