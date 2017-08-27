from flask import Flask,make_response
from Server.objects_pool.singleton import SingletonDecorator
from pymongo import MongoClient
#from Server.objects_pool.joineer_db import joiner_db
from flask_restful import Api,Resource
from Server.utilities.mongo_json_encoder import JSONEncoder
from Server.resources.test import Test
__author__ = 'Peixi Zhao'


class joineer_flask:
    app = None
    api = None
    logger = None
    def get_db(self):
        client = MongoClient('localhost', 27017)
        return client.joineer_database

    def get_api(self):
        api = Api(self.app)
        @api.representation('application/json')
        def output_json(data, code, headers=None):
            resp = make_response(JSONEncoder().encode(data), code)
            resp.headers.extend(headers or {})
            return resp
        self.add_api_resources(api)
        return api


    def add_api_resources(self, api):
        api.add_resource(Test, '/test/', '/test/<string:str>')


    def __init__(self):
        self.app = Flask(__name__)
        self.app.db = self.get_db()
        self.app.config['TRAP_BAD_REQUEST_ERRORS'] = True
        self.api = self.get_api()
        self.logger = self.app.logger

joiner_flask = SingletonDecorator(joineer_flask)