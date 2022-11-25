import time    
from flask_restful import Resource, reqparse, abort

from models.DiaSemana import DiaSemana_Model
from utils.db import db
from utils.response_template import response_template

#abort(404, message="video id is not valid")

diaSemana_patch_args = reqparse.RequestParser()
diaSemana_patch_args.add_argument("nombre", type=str, help="Nombre del edificio", required = True)

diaSemana_post_args = reqparse.RequestParser()
diaSemana_post_args.add_argument("nombre", type=str, help="Nombre del edificio", required = True)

class DiaSemana(Resource):
    def get(self, idDiaSemana):
        try:
            diaSemana = db.get_or_404(DiaSemana_Model, idDiaSemana)
        except:
            return response_template.not_found('El día no fue encontrado')
        data = {
            'id' : diaSemana.id,
            'nombre': diaSemana.nombre,
        }
        return response_template.succesful(data, '', 200)

class DiasSemana(Resource):    
    def get(self):
        diaSemana_models = db.session.execute(db.select(DiaSemana_Model)).scalars().fetchall()
        data = []

        for diaSemana in diaSemana_models:
            data.append({
            'id' : diaSemana.id,
            'nombre': diaSemana.nombre,
            })

        return response_template.succesful(data=data, msg='', code=200)