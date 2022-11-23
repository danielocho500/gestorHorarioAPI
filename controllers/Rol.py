from flask_restful import Resource

from models.Rol import Rol_Model
from utils.db import db
from utils.response_template import response_template

class Roles(Resource):
    def get(self):
        roles_models = db.session.execute(db.select(Rol_Model)).scalars().fetchall()

        data = []

        for rol in roles_models:
            data.append({
                'rol' : rol.id,
                'nombre': rol.nombre
            })

        return response_template.succesful(data=data, msg='', code=200)