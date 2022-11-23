from flask import Flask
from flask_restful import Api
from decouple import config

from controllers.Edificio import Edificio, Edificios
from controllers.Salon import Salon, Salones
from controllers.Rol import Roles
from controllers.Register import Register
from controllers.Login import Login

from utils.db import db
app = Flask(__name__)

app.config["SQLALCHEMY_DATABASE_URI"] = 'mysql://{}:{}@{}/{}'.format(config('MYSQL_USER'),config('MYSQL_PASS'),config('MYSQL_HOST'),config('MYSQL_DB'))
app.config["SQLALCHEMY_TRACK_MODIFICATIONS"] = False

db.init_app(app)

api = Api(app)

api.add_resource(Edificio,"/api/edificio/<int:idEdificio>" )
api.add_resource(Edificios,"/api/edificio" )

api.add_resource(Salon, "/api/salon/<int:idSalon>" )
api.add_resource(Salones,"/api/salon" )

api.add_resource(Roles, '/api/rol')

api.add_resource(Register, '/api/register')
api.add_resource(Login, '/api/login')

if __name__ == "__main__":
    app.run(debug=True)