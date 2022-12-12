import time    
from flask_restful import Resource, reqparse

from models.Usuario import Usuario_Model
from utils.db import db
from utils.response_template import response_template

class Profesor(Resource):
    def get(self, idProfesor):
        try:
            profesor = db.get_or_404(Usuario_Model, idProfesor)
        except:
            return response_template.not_found('El salon no fue encontrado')

        if not (profesor.rol == 2):
            return response_template.bad_request('THe id does not correspond to a student')

        data = {
            'correo': profesor.correo,
            'isActivo': profesor.isActivo,
            'primerNombre': profesor.primerNombre,
            'segundoNombre': profesor.segundoNombre,
            'primerApellido': profesor.primerApellido,
            'segundoApellido': profesor.segundoApellido,
            'fechaNacimiento': str(profesor.fechaNacimiento),
            'claveEmpleado': profesor.claveEmpleado
        }

        return response_template.succesful(data, 'Profesor encontrado', 200)

class Profesores(Resource):
    def get(self):
        profesores_models = db.session.execute(db.Query(Usuario_Model).filter_by(rol=2, isActivo=1)).scalars().fetchall()

        data = []

        for profesor in profesores_models:
            data.append({
                'uid': profesor.uid,
                'correo': profesor.correo,
                'primerNombre': profesor.primerNombre,
                'segundoNombre': profesor.segundoNombre,
                'primerApellido': profesor.primerApellido,
                'segundoApellido': profesor.segundoApellido,
                'fechaNacimiento': str(profesor.fechaNacimiento),
                'claveEmpleado': profesor.claveEmpleado
            })

        return response_template.succesful(data=data, msg='', code=200)