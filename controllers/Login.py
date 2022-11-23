import time    
from flask_restful import Resource, reqparse
from sqlalchemy import and_

from models.Usuario import Usuario_Model

from utils.db import db
from utils.response_template import response_template
from jwt_functions import generate_jwt

login_post_args = reqparse.RequestParser()
login_post_args.add_argument("correo", type=str, help="Correo del usuario", required = True)
login_post_args.add_argument("password", type=str, help="contraseña", required = True)

class Login(Resource):
    def post(self):
        args = login_post_args.parse_args() 

        user = db.session.query(Usuario_Model).filter_by(correo = args.correo, password = args.password).first()
        if (user == None):
            return response_template.not_authorized('Credenciales invalidas')

        token = generate_jwt.generate_jwt(user.uid)

        data = {
            'token': token, 
            'isActivo': user.isActivo,
            'primerNombre': user.primerNombre,
            'segundoNombre': user.segundoNombre,
            'primerApellido': user.primerApellido,
            'segundoApellido': user.segundoApellido
        }
        
        if(user.rol == 1):
            data['matricula'] = user.matricula
        else:
            data['claveEmpleado'] = user.claveEmpleado

        return response_template.succesful(data, 'Credenciales correctas', 200)