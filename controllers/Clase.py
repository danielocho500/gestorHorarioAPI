import time    
from flask_restful import Resource, reqparse, abort
from sqlalchemy.sql import text
from models.Clase import Clase_Model
from models.Grupo import Grupo_Model
from models.Materia import Materia_Model
from models.Usuario import Usuario_Model
from utils.db import db
from utils.response_template import response_template

class Clase(Resource):
    def get(self, idMateria):
        try:
            materia = db.get_or_404(Clase_Model, idMateria)
        except:
            return response_template.not_found('La materia no fue encontrada')
        data = {
            'id': materia.id,
            'nombre': materia.nombre,
            'semestre': materia.semestre
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
            'semestre': materia.semestre
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

clase_post_args = reqparse.RequestParser()
clase_post_args.add_argument("nrc", type=str, help="NRC de la clase", required = True)
clase_post_args.add_argument("idProfesor", type=int, help="id del profesor que tomara la clase", required = True)
clase_post_args.add_argument("idMateria", type=int, help="id de la materia de la clase", required = True)
clase_post_args.add_argument("idGrupo", type=int, help="id del grupo la clase", required = True)

class Clases(Resource):
    def post(self):
        args = clase_post_args.parse_args() 
        try:
            db.get_or_404(Grupo_Model, args.idGrupo)
        except:
            return response_template.not_found('El grupo no fue encontrado')

        try:
            db.get_or_404(Materia_Model, args.idMateria)
        except:
            return response_template.not_found('La materia no fue encontrada')

        try:
            db.get_or_404(Usuario_Model, args.idProfesor)
        except:
            return response_template.not_found('El profesor no fue encontrado')

        clase = Clase_Model(
            nrc=args.nrc,
            idGrupo=args.idGrupo,
            idMateria=args.idMateria,
            idProfesor=args.idProfesor,
            createdAt=time.strftime('%Y-%m-%d %H:%M:%S'),
            updatedAt=time.strftime('%Y-%m-%d %H:%M:%S')
        )

        db.session.add(clase)
        
        db.session.commit()

        return response_template.succesful({}, 'Clase creada', 200)
    
    def get(self):

        statement = text("SELECT * FROM gestorhorario.clase_info_completa;")

        clases_info = db.session.execute(statement).fetchall()
        clases = []
        cantidad = 0

        for clase in clases_info:
            cantidad += 1
            clases.append({
                'nrc': clase[0],
                'profesorUid': clase[1],
                'primerNombre': clase[2],
                'segundoNombre': clase[3],
                'primerApellido': clase[4],
                'segundoApellido': clase[5],
                'claveEmpleado': clase[6],
                'materia': clase[7],
                'area': clase[8],
                'semestre': clase[9],
                'bloque': clase[10],
                'fechaInicio': str(clase[11]),
                'fechaFin': str(clase[12]),
                'fechaOrdinario': str(clase[13]),
                'fechaExtra': str(clase[14]),
            })

        return response_template.succesful({
            'cantidad':cantidad,
            'clases': clases 
        }, msg='', code=200)