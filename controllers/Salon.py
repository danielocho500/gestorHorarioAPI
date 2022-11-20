import time    
from flask_restful import Resource, reqparse, abort

from models.Salon import Salon_Model
from models.Edificio import Edificio_Model
from utils.db import db
from utils.response_template import response_template

#abort(404, message="video id is not valid")

salon_patch_args = reqparse.RequestParser()
salon_patch_args.add_argument("nombre", type=str, help="Nombre del edificio", required = True)
salon_patch_args.add_argument("proyector", type=int, help="Existe proyector?", required = True)
salon_patch_args.add_argument("totalCupo", type=int, help="Total cupo", required = True)

salon_post_args = reqparse.RequestParser()
salon_post_args.add_argument("nombre", type=str, help="Nombre del edificio", required = True)
salon_post_args.add_argument("proyector", type=int, help="Existe proyector?", required = True)
salon_post_args.add_argument("idEdificio", type=int, help="Id del edificio", required = True)
salon_post_args.add_argument("totalCupo", type=int, help="Total cupo", required = True)

class Salon(Resource):
    def get(self, idSalon):
        try:
            salon = db.get_or_404(Salon_Model, idSalon)
        except:
            return response_template.not_found('El salon no fue encontrado')
        data = {
            'idSalon' : salon.id,
            'idEdificio': salon.idEdificio,
            'nombre': salon.nombre,
            'proyector': salon.proyector,
            'totalCupo': salon.totalCupo
        }
        return response_template.succesful(data, '', 200)
    def patch(self, idSalon):
        args = salon_patch_args.parse_args()

        try:
            salon = db.get_or_404(Salon_Model, idSalon)
        except:
            return response_template.not_found('El salon no fue encontrado')
            
        salon.nombre = args.nombre
        salon.proyector = args.proyector
        salon.totalCupo = args.totalCupo
        salon.updatedAt = time.strftime('%Y-%m-%d %H:%M:%S')

        db.session().commit()
        return response_template.succesful({},"Salon modificado", 204 )
    def delete(self, idSalon):
        try:
            salon = db.get_or_404(Salon_Model, idSalon)
        except:
            return response_template.not_found('El salon no fue encontrado')
        
        db.session.delete(salon)
        db.session.commit()
        return response_template.succesful({}, "salon eliminado", 200)

class Salones(Resource):
    def post(self):
        args = salon_post_args.parse_args() 

        try:
            db.get_or_404(Edificio_Model, args.idEdificio)
        except:
            return response_template.not_found('El edificio no fue encontrado')
        
        salon = Salon_Model(
            idEdificio= args.idEdificio,
            nombre=args.nombre,
            proyector = args.proyector,
            totalCupo = args.totalCupo,
            createdAt=time.strftime('%Y-%m-%d %H:%M:%S'),
            updatedAt=time.strftime('%Y-%m-%d %H:%M:%S')
        )

        db.session.add(salon)
        db.session.commit()

        return response_template.created(msg='Salon creado')
    
    def get(self):
        salones_models = db.session.execute(db.select(Salon_Model)).scalars().fetchall()
        data = []

        for salon in salones_models:
            data.append({
            'idSalon' : salon.id,
            'idEdificio': salon.idEdificio,
            'nombre': salon.nombre,
            'proyector': salon.proyector,
            'totalCupo': salon.totalCupo
            })

        return response_template.succesful(data=data, msg='', code=200)