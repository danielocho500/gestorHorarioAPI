from flask import Flask
from flask_restful import Api
from decouple import config

from controllers.Edificio import Edificio, Edificios
from controllers.Salon import Salon, Salones
from controllers.Rol import Roles
from controllers.Register import Register
from controllers.Login import Login
from controllers.Materia import Materia, Materias
from controllers.Area import Area, Areas
from controllers.DiaSemana import DiaSemana, DiasSemana
from controllers.Horario import Horario, Horarios

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

api.add_resource(Materia, "/api/materia/<int:idMateria>")
api.add_resource(Materias,"/api/materia" )

api.add_resource(Area, "/api/area/<int:idArea>")
api.add_resource(Areas,"/api/area")

api.add_resource(DiaSemana, "/api/diaSemana/<int:idDiaSemana>")
api.add_resource(DiasSemana,"/api/diaSemana")

api.add_resource(Horario, "/api/horario/<int:idHorario>")
api.add_resource(Horarios,"/api/horario")

if __name__ == "__main__":
    app.run(debug=True)