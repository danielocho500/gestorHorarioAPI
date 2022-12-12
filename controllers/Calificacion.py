from flask_restful import Resource, reqparse
from flask import request
from sqlalchemy.sql import text
from jwt_functions.validate_jwt import validate_jwt
from jwt_functions import get_info_token
from models.Usuario import Usuario_Model
from models.Clase import Clase_Model
from utils.db import db
from utils.response_template import response_template

class CalificacionEstudiante(Resource):
    def get(self, idEstudiante):
        try:
            db.get_or_404(Usuario_Model, idEstudiante)
        except:
            return response_template.not_found('El estudiante no fue encontrado')

        statement = text("SELECT ac.nrc, ac.esFinal, ac.calificacion, ac.esOrdinario, estgru.isRepite, prof.primerNombre, prof.segundoNombre, prof.primerApellido, prof.segundoApellido, mat.nombre as materia, gru.semestre, gru.bloque FROM acta as ac INNER JOIN estudiantegrupo as estgru INNER JOIN usuario as us INNER JOIN clase as clas INNER JOIN usuario as prof INNER JOIN materia as mat INNER JOIN grupo as gru WHERE ac.idEstGrupo = estgru.id AND us.uid = estgru.idEstudiante AND clas.nrc = ac.nrc AND clas.idProfesor = prof.uid AND mat.id = clas.idMateria AND estgru.idGrupo = gru.id AND us.uid = {};".format(idEstudiante))

        calificaciones_info = db.session.execute(statement).fetchall()
        calificaiones = []

        cantidad = 0

        for calif in calificaciones_info:
            cantidad += 1
            calificaiones.append({
                'nrc': calif[0],
                'esFinal': calif[1],
                'calificacion': calif[2],
                'esOrdinario': calif[3],
                'esRepite': calif[4],
                'Maestro': '{} {} {}'.format(calif[5],calif[7],calif[8]),
                'materia': calif[9],
                'semestre': calif[10],
                'bloque': calif[11],
            })

        return response_template.succesful({
            'cantidad':cantidad,
            'calificaiones': calificaiones
        }, msg='', code=200)

class CalificacionToken(Resource):
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
            return response_template.not_found('El estudiante no fue encontrado')

        statement = text("SELECT ac.nrc, ac.esFinal, ac.calificacion, ac.esOrdinario, estgru.isRepite, prof.primerNombre, prof.segundoNombre, prof.primerApellido, prof.segundoApellido, mat.nombre as materia, gru.semestre, gru.bloque FROM acta as ac INNER JOIN estudiantegrupo as estgru INNER JOIN usuario as us INNER JOIN clase as clas INNER JOIN usuario as prof INNER JOIN materia as mat INNER JOIN grupo as gru WHERE ac.idEstGrupo = estgru.id AND us.uid = estgru.idEstudiante AND clas.nrc = ac.nrc AND clas.idProfesor = prof.uid AND mat.id = clas.idMateria AND estgru.idGrupo = gru.id AND us.uid = {};".format(idEstudiante))

        calificaciones_info = db.session.execute(statement).fetchall()
        calificaiones = []

        cantidad = 0

        for calif in calificaciones_info:
            cantidad += 1
            calificaiones.append({
                'nrc': calif[0],
                'esFinal': calif[1],
                'calificacion': calif[2],
                'esOrdinario': calif[3],
                'esRepite': calif[4],
                'Maestro': '{} {} {}'.format(calif[5],calif[7],calif[8]),
                'materia': calif[9],
                'semestre': calif[10],
                'bloque': calif[11],
            })

        return response_template.succesful({
            'cantidad':cantidad,
            'calificaiones': calificaiones
        }, msg='', code=200)


class CalificacionClase(Resource):
    def get(self, nrc):

        try:
            db.get_or_404(Clase_Model, nrc)
        except:
            return response_template.not_found('La clase no fue encontrada')

        statement = text("SELECT ac.nrc, ac.esFinal, ac.calificacion, ac.esOrdinario, estgru.isRepite, prof.primerNombre, prof.segundoNombre, prof.primerApellido, prof.segundoApellido, mat.nombre as materia, gru.semestre, gru.bloque FROM acta as ac INNER JOIN estudiantegrupo as estgru INNER JOIN usuario as us INNER JOIN clase as clas INNER JOIN usuario as prof INNER JOIN materia as mat INNER JOIN grupo as gru WHERE ac.idEstGrupo = estgru.id AND us.uid = estgru.idEstudiante AND clas.nrc = ac.nrc AND clas.idProfesor = prof.uid AND mat.id = clas.idMateria AND estgru.idGrupo = gru.id AND clas.nrc = {};".format(nrc))

        calificaciones_info = db.session.execute(statement).fetchall()
        calificaiones = []

        cantidad = 0

        for calif in calificaciones_info:
            cantidad += 1
            calificaiones.append({
                'esFinal': calif[1],
                'calificacion': calif[2],
                'esOrdinario': calif[3],
                'esRepite': calif[4],
                'materia': calif[9],
                'semestre': calif[10],
                'bloque': calif[11],
            })

        return response_template.succesful({
            'cantidad':cantidad,
            'calificaiones': calificaiones
        }, msg='', code=200)