from flask import Flask
from flask_restful import Api
from pymongo import MongoClient

__author__ = 'Peixi Zhao'


'''
    This will provide the singleton objects of resources used in the application
'''

app = Flask(__name__)
app.config['TRAP_BAD_REQUEST_ERRORS'] = True
mongo = MongoClient('localhost', 27017)
app.db = mongo.develop_database
api = Api(app)

