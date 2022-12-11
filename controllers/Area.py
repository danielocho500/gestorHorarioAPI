import time    
from flask_restful import Resource, reqparse, abort

from models.Area import Area_Model
from utils.db import db
from utils.response_template import response_template

#abort(404, message="video id is not valid")

area_patch_args = reqparse.RequestParser()
area_patch_args.add_argument("nombre", type=str, help="Nombre del área", required = True)

area_post_args = reqparse.RequestParser()
area_post_args.add_argument("nombre", type=str, help="Nombre de la materia", required = True)
area_post_args.add_argument("semestre", type=str, help="Semestre del area", required = True)

class Area(Resource):
    def get(self, idArea):
        try:
            area = db.get_or_404(Area_Model, idArea)
        except:
            return response_template.not_found('El area no fue encontrada')
        data = {
            'id': area.id,
            'nombre': area.nombre,
        }
        return response_template.succesful(data, '', 200)
    def put(self, idArea):
        args = area_patch_args.parse_args()

        try:
            area = db.get_or_404(Area_Model, idArea)
        except:
            return response_template.not_found('El area no fue encontrada')
        area.nombre = args.nombre
        area.updatedAt = time.strftime('%Y-%m-%d %H:%M:%S')

        db.session().commit()
        return response_template.succesful({},"Area modificada", 204 )
    def delete(self, idArea):
        try:
            area = db.get_or_404(Area_Model, idArea)
        except:
            return response_template.not_found('El area no fue encontrada')
        
        db.session.delete(area)
        db.session.commit()
        return response_template.succesful({}, "area eliminada", 200)

class Areas(Resource):
    def post(self):
        args = area_post_args.parse_args() 
        
        area = Area_Model(
            nombre=args.nombre,
            semestre=args.semestre,
            createdAt=time.strftime('%Y-%m-%d %H:%M:%S'),
            updatedAt=time.strftime('%Y-%m-%d %H:%M:%S')
        )

        db.session.add(area)
        db.session.commit()

        return response_template.created(msg='Area creada')
    
    def get(self):
        areas_models = db.session.execute(db.select(Area_Model)).scalars().fetchall()
        data = []

        for area in areas_models:
            data.append({
                'id': area.id,
                'nombre': area.nombre,
            })

        return response_template.succesful(data=data, msg='', code=200)