from flask_restful import Resource, reqparse

from models.Usuario import Usuario_Model
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