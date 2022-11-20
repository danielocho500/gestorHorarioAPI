from flask import Flask
from flask_restful import Api, Resource
from flask_sqlalchemy import SQLAlchemy
from controllers.Edificio import Edificio, Edificios
from utils.db import db
app = Flask(__name__)

app.config["SQLALCHEMY_DATABASE_URI"] = 'mysql://root:mysql@localhost/gestorhorario'
app.config["SQLALCHEMY_TRACK_MODIFICATIONS"] = False

db.init_app(app)

api = Api(app)

api.add_resource(Edificio,"/api/edificio/<int:idEdificio>" )
api.add_resource(Edificios,"/api/edificio" )

if __name__ == "__main__":
    app.run(debug=True)