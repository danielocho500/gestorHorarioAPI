import time    
from flask_restful import Resource, reqparse
from sqlalchemy import and_

from models.Usuario import Usuario_Model

from utils.db import db
from utils.response_template import response_template
from flask import request
from jwt_functions.validate_jwt import validate_jwt
from jwt_functions import get_info_token

register_post_args = reqparse.RequestParser()
register_post_args.add_argument("correo", type=str, help="Correo del usuario", required = True)
register_post_args.add_argument("password", type=str, help="contraseña", required = True)
register_post_args.add_argument("primerNombre", type=str, help="primerNombre", required = True)
register_post_args.add_argument("segundoNombre", type=str, help="segundoNombre", required = False)
register_post_args.add_argument("primerApellido", type=str, help="primerApellido", required = True)
register_post_args.add_argument("segundoApellido", type=str, help="segundoApellido", required = False)
register_post_args.add_argument("rol", type=int, help="rol del usuario (del 0 al 2)", required = True)
register_post_args.add_argument("fechaNacimiento", type=str, help="fechaNacimiento", required = True)
register_post_args.add_argument("claveEmpleado", type=str, help="claveEmpleado", required = False)
register_post_args.add_argument("matricula", type=str, help="matricula", required = False)

class Register(Resource):
    def post(self):
        args = register_post_args.parse_args() 
        token = request.headers.get('auth_token')

        if(token == None):
            return response_template.not_authorized("No hay token en el header (auth_token)")
        
        if not (validate_jwt(token)):
            response_template.not_authorized("token inválido")

        rol = get_info_token.get_rol(token)

        if not (rol == 3 or rol == 4):
            return response_template.not_authorized("No tienes permisos para realizar esta acción")

        query = db.session.query(Usuario_Model).filter_by(correo = args.correo).first()
        if (query != None):
            return response_template.not_authorized('El correo ya existe')

        if(args.rol < 0 or args.rol > 4):
            return response_template.bad_request('Rol invalido')

        if args.rol == 1 and args.matricula is None:
            return response_template.bad_request('Debes incluir la matricula')

        if args.rol != 1 and args.claveEmpleado is None:
            return response_template.bad_request('Debes incluir la clave de empleado')

        if args.rol == 1:
            return RegisterUser.registerEstudiante(args)
        else:
            return RegisterUser.registerPersonal(args)

class RegisterUser():
    def registerEstudiante(args):
        
        user = db.session.query(Usuario_Model).filter_by(matricula = args.matricula).first()
        if not(user == None):
            return response_template.not_authorized('Matricula registrada anteriormente')

        usuario = Usuario_Model(
            correo=args.correo,
            password=args.password,
            isActivo=1,
            primerApellido= args.primerApellido,
            segundoApellido= args.segundoApellido,
            primerNombre=args.primerNombre,
            segundoNombre=args.segundoNombre,
            rol=args.rol,
            fechaNacimiento=args.fechaNacimiento,
            createdAt=time.strftime('%Y-%m-%d %H:%M:%S'),
            updatedAt=time.strftime('%Y-%m-%d %H:%M:%S'),
            matricula=args.matricula
        )

        db.session.add(usuario)
        db.session.commit()

        return response_template.created("Estudiante creado")

    def registerPersonal(args):

        user = db.session.query(Usuario_Model).filter_by(claveEmpleado = args.claveEmpleado).first()
        if not(user == None):
            return response_template.not_authorized('Clave registrada anteriormente')

        usuario = Usuario_Model(
            correo=args.correo,
            password=args.password,
            isActivo=1,
            primerApellido= args.primerApellido,
            segundoApellido= args.segundoApellido,
            primerNombre=args.primerNombre,
            segundoNombre=args.segundoNombre,
            rol=args.rol,
            fechaNacimiento=args.fechaNacimiento,
            createdAt=time.strftime('%Y-%m-%d %H:%M:%S'),
            updatedAt=time.strftime('%Y-%m-%d %H:%M:%S'),
            claveEmpleado=args.claveEmpleado
        )

        db.session.add(usuario)
        db.session.commit()

        return response_template.created("Profesor o administrador creado")