from flask_restful import Resource, reqparse

from models.Usuario import Usuario_Model
from models.Clase import Clase_Model
from sqlalchemy.sql import text
from utils.db import db
from utils.response_template import response_template

class Estudiantes(Resource):
    def get(self):
        estudiantes_models = db.session.execute(db.Query(Usuario_Model).filter_by(rol = 1, isActivo=1)).scalars().fetchall()

        estudiantes = []
        cantidad = 0

        for estudiante in estudiantes_models:
            cantidad += 1
            estudiantes.append({
                'uid': estudiante.uid,
                'correo': estudiante.correo,
                'nombre': '{} {} {} {}'.format(estudiante.primerNombre,estudiante.segundoNombre,estudiante.primerApellido,estudiante.segundoApellido),
                'fechaNacimiento': str(estudiante.fechaNacimiento)               
            })

        return response_template.succesful({
            'cantidad': cantidad,
            'estudiantes': estudiantes
        }, 'estudiantes encontrados', 200)

class EstudianteSinCalificacion(Resource):
    def get(self, nrc):
        try:
            db.get_or_404(Clase_Model, nrc)
        except:
            return response_template.not_found('La clase no fue encontrada')

        statement = text("SELECT us.uid, concat(us.primerNombre, ' ' ,IFNULL(us.segundoNombre, ''), ' ', us.primerApellido, ' ', us.segundoApellido) as nombre, estgru.id FROM estudiantegrupo as estgru INNER JOIN grupo as gru INNER JOIN clase as cla INNER JOIN usuario as us WHERE gru.id = estgru.idGrupo AND cla.idGrupo = gru.id AND estgru.id NOT IN (SELECT estgru.id as estgruId FROM acta as act INNER JOIN estudiantegrupo as estgru WHERE act.idEstGrupo = estgru.id AND act.nrc='{}') AND us.uid = estgru.idEstudiante AND cla.nrc ='{}';".format(nrc, nrc))

        estudiantes_sin_calif = db.session.execute(statement).fetchall()
        estudiantes = []

        cantidad = 0

        for calif in estudiantes_sin_calif:
            cantidad += 1
            estudiantes.append({
                'uid': calif[0],
                'nombre': calif[1],
                'idEstGru': calif[2]
            })

        return response_template.succesful({
            'cantidad':cantidad,
            'estudiantes': estudiantes
        }, msg='', code=200)