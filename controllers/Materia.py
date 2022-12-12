import time    
from flask_restful import Resource, reqparse, abort

from models.Materia import Materia_Model
from utils.db import db
from utils.response_template import response_template

materia_patch_args = reqparse.RequestParser()
materia_patch_args.add_argument("nombre", type=str, help="Nombre de la materia", required = True)
materia_patch_args.add_argument("semestre", type=str, help="Número del semestre", required = True)

materia_post_args = reqparse.RequestParser()
materia_post_args.add_argument("nombre", type=str, help="Nombre de la materia", required = True)
materia_post_args.add_argument("semestre", type=str, help="Número del semestre", required = True)

class Materia(Resource):
    def get(self, idMateria):
        try:
            materia = db.get_or_404(Materia_Model, idMateria)
        except:
            return response_template.not_found('La materia no fue encontrada')
        data = {
            'id': materia.id,
            'nombre': materia.nombre,
        }
        return response_template.succesful(data, '', 200)
    def put(self, idMateria):
        args = materia_patch_args.parse_args()

        try:
            materia = db.get_or_404(Materia_Model, idMateria)
        except:
            return response_template.not_found('La materia no fue encontrada')
        materia.nombre = args.nombre
        materia.semestre = args.semestre
        materia.updatedAt = time.strftime('%Y-%m-%d %H:%M:%S')

        db.session().commit()
        data = {
            'id': materia.id,
            'nombre': materia.nombre,
        }
        return response_template.succesful(data,"Materia modificada", 204 )
    def delete(self, idMateria):
        try:
            materia = db.get_or_404(Materia_Model, idMateria)
        except:
            return response_template.not_found('La materia no fue encontrada')
        
        db.session.delete(materia)
        db.session.commit()
        return response_template.succesful({}, "materia eliminada", 200)

class Materias(Resource):
    def post(self):
        args = materia_post_args.parse_args() 
        
        materia = Materia_Model(
            nombre=args.nombre,
            semestre=args.semestre,
            createdAt=time.strftime('%Y-%m-%d %H:%M:%S'),
            updatedAt=time.strftime('%Y-%m-%d %H:%M:%S')
        )

        db.session.add(materia)
        
        db.session.commit()

        data = {
            'id': materia.id,
            'nombre': materia.nombre,
            'semestre': materia.semestre
        }
        return response_template.succesful(data, 'Materia creada', 200)
    
    def get(self):
        materias_models = db.session.execute(db.select(Materia_Model)).scalars().fetchall()
        data = []

        for materia in materias_models:
            data.append({
                'id': materia.id,
                'nombre': materia.nombre,
                'semestre': materia.semestre
            })

        return response_template.succesful(data=data, msg='', code=200)