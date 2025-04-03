# initializes the application

from flask import Flask
from flask_sqlalchemy import SQLAlchemy
from app.config.config import Config 

db = SQLAlchemy()

def create_app():
    app = Flask(__name__)
    app.config['SQLALCHEMY_DATABASE_URI'] = "postgresql://postgres:montana30@localhost:5432/ehotel_db"
    db.init_app(app)
    from app.routes.api_routes import api
    app.register_blueprint(api)

    return app
    