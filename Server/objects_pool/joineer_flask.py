from flask import Flask,make_response
from Server.objects_pool.singleton import SingletonDecorator
from pymongo import MongoClient
import logging
import sys
from flask_restful import Api,Resource
from Server.utilities.mongo_json_encoder import JSONEncoder
from Server.resources.test import Test
from Server.resources.test2 import Test2
__author__ = 'Peixi Zhao'


class joineer_flask:
    app = None
    api = None

    def set_up_logger(self):
        handler = logging.StreamHandler(sys.stdout)
        handler.setFormatter(logging.Formatter(
            '%(asctime)s - %(name)s - %(levelname)s - %(message)s'))
        self.app.logger.addHandler(handler)
        self.app.logger.setLevel(logging.DEBUG)


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
        return api


    def __init__(self):
        self.app = Flask("Joineer")
        self.app.db = self.get_db()
        self.app.config['TRAP_BAD_REQUEST_ERRORS'] = True
        # Allow for special characters
        self.app.config['JSON_AS_ASCII'] = False
        self.api = self.get_api()
        self.set_up_logger()

joiner_flask = SingletonDecorator(joineer_flask)