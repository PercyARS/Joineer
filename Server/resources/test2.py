from flask_restful import Resource
from flask import request, jsonify
import logging


__author__= 'Peixi Zhao'

'''
    This is just a test resource
'''



class Test2(Resource):
    logger = logging.getLogger('root')

    def post(self):
        new_mytest = request.json
        return "Received"

    def get(self):
        return {'Test': 'Empty'}




