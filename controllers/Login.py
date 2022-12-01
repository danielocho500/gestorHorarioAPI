from flask_restful import Resource, reqparse
from sqlalchemy import and_

from models.Usuario import Usuario_Model

from utils.db import db
from utils.response_template import response_template
from jwt_functions.generate_jwt import generate_jwt
from jwt_functions.validate_jwt import validate_jwt

login_post_args = reqparse.RequestParser()
login_post_args.add_argument("correo", type=str, help="Correo del usuario", required = True)
login_post_args.add_argument("password", type=str, help="contraseña", required = True)

class Login(Resource):
    def post(self):
        args = login_post_args.parse_args() 

        user = db.session.query(Usuario_Model).filter_by(correo = args.correo, password = args.password).first()
        if (user == None):
            return response_template.not_authorized('Credenciales invalidas')

        print(user.rol)

        token = generate_jwt(user.uid, user.rol)

        validate_jwt(token)

        data = {
            'token': token, 
            'isActivo': user.isActivo,
            'primerNombre': user.primerNombre,
            'segundoNombre': user.segundoNombre,
            'primerApellido': user.primerApellido,
            'segundoApellido': user.segundoApellido,
            'rol': user.rol
        }
        
        if(user.rol == 1):
            data['matricula'] = user.matricula
        else:
            data['claveEmpleado'] = user.claveEmpleado

        return response_template.succesful(data, 'Credenciales correctas', 200)