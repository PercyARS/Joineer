from flask import Flask,make_response
from Server.objects.singleton import SingletonDecorator
import logging
import sys
from flask_restful import Api,Resource
from Server.utilities.mongo_json_encoder import JSONEncoder
from Server.objects.joineer_db import JoineerDB
__author__ = 'Peixi Zhao'


class JoineerFlask:
    app = None
    api = None

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
        self.app.db = JoineerDB()
        self.app.config['TRAP_BAD_REQUEST_ERRORS'] = True
        # Allow for special characters
        self.app.config['JSON_AS_ASCII'] = False
        # Bundle reqparser errors into one json
        self.app.config['BUNDLE_ERRORS'] = True
        # Define the encryption difficulty
        self.app.bcrypt_rounds = 12
        self.api = self.get_api()
        self.set_up_logger()


    def set_up_logger(self):
        handler = logging.StreamHandler(sys.stdout)
        handler.setFormatter(logging.Formatter(
            '%(asctime)s - %(name)s - %(levelname)s - %(message)s'))
        self.app.logger.addHandler(handler)
        self.app.logger.setLevel(logging.DEBUG)


# Making the class singleton
JoineerFlask = SingletonDecorator(JoineerFlask)