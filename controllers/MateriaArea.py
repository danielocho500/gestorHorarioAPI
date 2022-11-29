import time    
from flask_restful import Resource, reqparse, abort
from models.Area import Area_Model

from models.Materia import Materia_Model
from models.MateriaArea import MateriaArea_Model
from utils.db import db
from utils.response_template import response_template

#abort(404, message="video id is not valid")

materiaArea_patch_args = reqparse.RequestParser()
materiaArea_patch_args.add_argument("idArea", type=int, help="Id del area", required = True)
materiaArea_patch_args.add_argument("idMateria", type=int, help="Id de la materia", required = True)

materiaArea_post_args = reqparse.RequestParser()
materiaArea_post_args.add_argument("idArea", type=int, help="Id de la materia", required = True)
materiaArea_post_args.add_argument("idMateria", type=int, help="Id del semestre", required = True)

class MateriaArea(Resource):
    def patch(self, idMateria):
        args = materiaArea_patch_args.parse_args()

        try:
            materiaArea = db.get_or_404(MateriaArea_Model, idMateria)
        except:
            return response_template.not_found('La relacion no fue encontrada')

        materiaArea.idMateria = args.idMateria
        materiaArea.idArea = args.idArea

        db.session().commit()
        return response_template.succesful({},"Relacion modificada", 204 )

class MateriaAreas(Resource):
    def post(self):
        args = materiaArea_post_args.parse_args() 

        materiaArea = MateriaArea_Model(
            idMateria= args.idMateria,
            idArea=args.idArea,
        )

        db.session.add(materiaArea)
        db.session.commit()

        return response_template.created(msg='Materia y Area relacionada con exito')
    
    def get(self):
        materiaAreas_models = db.session.execute(db.select(MateriaArea_Model)).scalars().fetchall()
        data = []

        for materiaArea in materiaAreas_models:
            data.append({
            'idMateria' : materiaArea.idMateria,
            'idArea': materiaArea.idArea,
            })

        return response_template.succesful(data=data, msg='', code=200)

class MateriasArea(Resource):
    def get(self, idArea):

        try:
            materiaArea = db.get_or_404(Area_Model, idArea)
        except:
            return response_template.not_found('El area no fue encontrada')

        materiasArea_models = db.session.execute(db.select(MateriaArea_Model).filter(MateriaArea_Model.idArea == idArea)).scalars().fetchall()
        data = []

        for materiaArea in materiasArea_models:
            data.append({
            'idMateria' : materiaArea.idMateria,
            'idArea': materiaArea.idArea,
            })

        return response_template.succesful(data=data, msg='', code=200)