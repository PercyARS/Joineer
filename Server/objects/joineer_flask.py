from flask import Flask, make_response
from Server.objects.singleton import SingletonDecorator
import logging
import sys
from flask_restful import Api
from Server.utilities.mongo_json_encoder import JSONEncoder
from Server.objects.joineer_db import JoineerDB
from Server.utilities.logger import get_flask_logger
__author__ = 'Peixi Zhao'


class JoineerFlask:
    app = None
    api = None

    def __init__(self):
        self.app = Flask("Joineer")
        self.app.db = JoineerDB()
        self.app.config['TRAP_BAD_REQUEST_ERRORS'] = True
        # Allow for special characters
        self.app.config['JSON_AS_ASCII'] = False
        # Bundle reqparser errors into one json
        self.app.config['BUNDLE_ERRORS'] = True
        # Define the encryption difficulty
        self.app.bcrypt_rounds = 6
        get_flask_logger(self.app.logger)
        self.api = Api(self.app)
        '''
            Set up the json encoder for mongodb objectIDs
        '''
        @self.api.representation('application/json')
        def output_json(data, code, headers=None):
            resp = make_response(JSONEncoder().encode(data), code)
            resp.headers.extend(headers or {})
            return resp




# Making the class singleton
JoineerFlask = SingletonDecorator(JoineerFlask)
