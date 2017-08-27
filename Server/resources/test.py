from flask_restful import Resource
from flask import request, jsonify, logging


__author__= 'Peixi Zhao'

'''
    This is just a test resource
'''


class Test(Resource):
    def post(self):
        new_mytest = request.json
        #logging.getLogger().info("Received: ", new_mytest)
        return "Received"

    def get(self, str):
        #logging.getLogger().info("Received: ", str)
        print("haha")
        response = jsonify(data=[])
        response.status_code = 404
        return {'hello': 'world'}



