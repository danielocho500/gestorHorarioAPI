import time    
from flask_restful import Resource, reqparse, abort

from models.Edificio import Edificio_Model
from utils.db import db
from utils.response_template import response_template

#abort(404, message="video id is not valid")

edificio_patch_args = reqparse.RequestParser()
edificio_patch_args.add_argument("nombre", type=str, help="Nombre del edificio", required = True)
edificio_patch_args.add_argument("pisos", type=int, help="Numero de pisos", required = True)

edificio_post_args = reqparse.RequestParser()
edificio_post_args.add_argument("nombre", type=str, help="Nombre del edificio", required = True)
edificio_post_args.add_argument("pisos", type=int, help="Pisos con los que cuenta el edificio", required = True)

class Edificio(Resource):
    def get(self, idEdificio):
        try:
            edificio = db.get_or_404(Edificio_Model, idEdificio)
        except:
            return response_template.not_found('El edificio no fue encontrado')
        data = {
            'id': edificio.id,
            'nombre': edificio.nombre,
            'pisos': edificio.pisos
        }
        return response_template.succesful(data, '', 200)
    def patch(self, idEdificio):
        args = edificio_patch_args.parse_args()

        try:
            edificio = db.get_or_404(Edificio_Model, idEdificio)
        except:
            return response_template.not_found('El edificio no fue encontrado')
        edificio.nombre = args.nombre
        edificio.pisos = args.pisos
        edificio.updatedAt = time.strftime('%Y-%m-%d %H:%M:%S')

        db.session().commit()
        return response_template.succesful({},"Edificio modificado", 204 )
    def delete(self, idEdificio):
        try:
            edificio = db.get_or_404(Edificio_Model, idEdificio)
        except:
            return response_template.not_found('El edificio no fue encontrado')
        
        db.session.delete(edificio)
        db.session.commit()
        return response_template.succesful({}, "edificio eliminado", 200)

class Edificios(Resource):
    def post(self):
        args = edificio_post_args.parse_args() 
        
        edificio = Edificio_Model(
            nombre=args.nombre,
            pisos=args.pisos,
            createdAt=time.strftime('%Y-%m-%d %H:%M:%S'),
            updatedAt=time.strftime('%Y-%m-%d %H:%M:%S')
        )

        db.session.add(edificio)
        db.session.commit()

        return response_template.created(msg='Edificio creado')
    
    def get(self):
        edificios_models = db.session.execute(db.select(Edificio_Model)).scalars().fetchall()
        data = []

        for edificio in edificios_models:
            data.append({
                'id': edificio.id,
                'nombre': edificio.nombre,
                'pisos': edificio.pisos
            })

        return response_template.succesful(data=data, msg='', code=200)