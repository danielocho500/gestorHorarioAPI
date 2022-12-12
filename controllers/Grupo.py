from utils.db import db
import time
from flask_restful import Resource, reqparse, abort
from sqlalchemy.sql import text
from flask import request
from models.Grupo import Grupo_Model
from models.Area import Area_Model
from models.Periodo import Periodo_Model
from models.EstudianteGrupo import estudianteGrupo_Model
from models.Usuario import Usuario_Model
from utils.response_template import response_template
from helpers.validateIds import validateIds

grupo_post_args = reqparse.RequestParser()
grupo_post_args.add_argument("idArea", type=str, help="id del Area", required = True)
grupo_post_args.add_argument("bloque", type=str, help="bloque del grupo", required = True)

class Grupos(Resource):
    def get(self):

        semestre = request.args.get('semestre')
        
        periodos_models = db.session.execute(db.Query(Periodo_Model).filter_by(activo=1)).scalars().fetchall()
        if not (periodos_models[0]):
            return response_template.not_found('No hay un periodo activo')

        idPeriodo=periodos_models[0].id
        print(idPeriodo)

        if(semestre):
            grupos_models = db.session.execute(db.Query(Grupo_Model).filter_by(idPeriodo=idPeriodo, semestre=semestre)).scalars().fetchall()
        else:    
            grupos_models = db.session.execute(db.Query(Grupo_Model).filter_by(idPeriodo=idPeriodo)).scalars().fetchall()

        data = []

        for grupo in grupos_models:
            data.append({
                'id': grupo.id,
                'idArea': grupo.idArea,
                'semestre': grupo.semestre,
                'bloque': grupo.bloque
            })

        return response_template.succesful(data, "Grupos", 200)
    def post(self):
        args = grupo_post_args.parse_args()

        try:
            area = db.get_or_404(Area_Model, args.idArea)
        except:
            return response_template.not_found('El area no fue encontrada')

        semestre = area.semestre

        periodos_models = db.session.execute(db.Query(Periodo_Model).filter_by(activo=1)).scalars().fetchall()
        if not (periodos_models[0]):
            return response_template.not_found('No hay un periodo activo')

        idPeriodo = periodos_models[0].id

        print(idPeriodo)

        grupo = Grupo_Model(
            idArea=args.idArea,
            idPeriodo=idPeriodo,
            semestre=semestre,
            bloque=args.bloque,
            createdAt=time.strftime('%Y-%m-%d %H:%M:%S'),
            updatedAt=time.strftime('%Y-%m-%d %H:%M:%S')
        )
        
        db.session.add(grupo)
        
        db.session.commit()

        return response_template.succesful({}, 'Grupo creado', 200)

class Grupo(Resource):
    def delete(self, idGrupo):
        try:
            grupo = db.get_or_404(Grupo_Model, idGrupo)
        except:
            return response_template.not_found('El grupo no fue encontrado')
        
        db.session.delete(grupo)
        db.session.commit()
        return response_template.succesful({}, "grupo eliminado", 200)
    def get(self, idGrupo):
        try:
            grupo = db.get_or_404(Grupo_Model, idGrupo)
        except:
            return response_template.not_found('El grupo no fue encontrado')

        estudianteGrupo_models = db.session.execute(db.Query(estudianteGrupo_Model).filter_by(idGrupo=idGrupo)).scalars().fetchall()
        estudiantes = []

        for estudianteGrupo in estudianteGrupo_models:
            estudiante = db.get_or_404(Usuario_Model, estudianteGrupo.idEstudiante)
            estudiantes.append({
                'uid': estudiante.uid,
                'correo': estudiante.correo,
                'primerNombre': estudiante.primerNombre,
                'segundoNombre': estudiante.segundoNombre,
                'primerApellido': estudiante.primerApellido,
                'segundoApellido': estudiante.segundoApellido,
                'fechaNacimiento': str(estudiante.fechaNacimiento),
                'matricula': estudiante.matricula,
            })

        data = {
            'semestre': grupo.semestre,
            'bloque': grupo.bloque,
            'estudiantes': estudiantes
        }

        return response_template.succesful(data,'Grupo', 200)

class GrupoEstudianteValido(Resource):
    def get(self, semestre):
        statement = text("SELECT * FROM estudiantes_libres_periodo;")

        if not(semestre > 0 and semestre <= 6):
            return response_template.bad_request('Semestre fuera del rango permitido (1-6)')

        estudiantes_libres = db.session.execute(statement).fetchall()
        estudiantes = []
        cantidad = 0
        for estudiante in estudiantes_libres:
            if not (estudiante[7]<semestre):
                continue
            cantidad += 1
            estudiantes.append({
                'uid': estudiante[0],
                'correo': estudiante[1],
                'primerNombre': estudiante[2],
                'segundoNombre': estudiante[3],
                'primerApellido': estudiante[4],
                'segundoApellido': estudiante[5],
                'matricula': estudiante[6],
                'ultimoSemestre': estudiante[7]
            })

        return response_template.succesful({
            'cantidad': cantidad,
            'estudiantes': estudiantes
        }, "Estudiantes libres con semestre valido", 200)

grupoEstudiante_post_args = reqparse.RequestParser()
grupoEstudiante_post_args.add_argument("idsEstudiantes", type=str, help="ids de los estudiantes", required = True)

class GrupoEstudiante(Resource):
    def post(self, idGrupo):
        try:
            db.get_or_404(Grupo_Model, idGrupo)
        except:
            return response_template.not_found('El grupo no fue encontrado')
        args = grupoEstudiante_post_args.parse_args()
        idsEstudiantes = args.idsEstudiantes

        if not(validateIds(idsEstudiantes)):
            return response_template.bad_request("Formato de ids invalido, debe ser (1,2,3,4)")

        idsEstudiantes = validateIds(idsEstudiantes)
        
        for id in idsEstudiantes:
            estgru = estudianteGrupo_Model(
                idEstudiante=id,
                idGrupo=idGrupo,
                isRepite=0,
                createdAt=time.strftime('%Y-%m-%d %H:%M:%S'),
                updatedAt=time.strftime('%Y-%m-%d %H:%M:%S')
            )

            db.session.add(estgru)
            db.session.commit()