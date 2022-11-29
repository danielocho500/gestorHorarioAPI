import time    
from flask_restful import Resource, reqparse, abort

from models.Materia import Materia_Model
from models.MateriaArea import MateriaArea_Model
from utils.db import db
from utils.response_template import response_template

#abort(404, message="video id is not valid")

materiaArea_patch_args = reqparse.RequestParser()
materiaArea_patch_args.add_argument("idArea", type=str, help="Id del area", required = True)
materiaArea_patch_args.add_argument("idMateria", type=str, help="Id de la materia", required = True)

materiaArea_post_args = reqparse.RequestParser()
materiaArea_post_args.add_argument("nombre", type=str, help="Nombre de la materia", required = True)
materiaArea_post_args.add_argument("semestre", type=str, help="Número del semestre", required = True)

class Area(Resource):
    def get(self, idArea):
        try:
            area = db.get_or_404(Area_Model, idArea)
        except:
            return response_template.not_found('El area no fue encontrada')
        data = {
            'id': area.id,
            'nombre': area.nombre,
            'semestre': area.semestre
        }
        return response_template.succesful(data, '', 200)
    def patch(self, idArea):
        args = area_patch_args.parse_args()

        try:
            area = db.get_or_404(Area_Model, idArea)
        except:
            return response_template.not_found('El area no fue encontrada')
        area.nombre = args.nombre
        area.semestre = args.semestre
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

class MateriaAreas(Resource):
    def post(self, idArea, idMateria):
        args = materiaArea_post_args.parse_args() 
        
        materiaArea = MateriaArea_Model(
            idMateria= args.idMateria,
            idArea=args.idArea,
        )

        db.session.add(area)
        db.session.commit()

        return response_template.created(msg='Area creada')
    
    def get(self, idMateria):
        try:
            materia = db.get_or_404(Materia_Model, idMateria)
        except:
            return response_template.not_found('La materia no fue encontrada')
        data = {
            'id': materia.id,
        }

        materiaAreas_models = db.session.execute(db.select(MateriaArea_Model)).scalars().fetchall()
        data = []

        for materia in materiaAreas_models:
            data.append({
                'id': materia.id,
                'nombre': materia.nombre,
                'semestre': materia.semestre
            })

        return response_template.succesful(data=data, msg='', code=200)