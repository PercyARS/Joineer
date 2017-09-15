__author__ = 'Peixi Zhao'
from flask_restful import Resource, reqparse
from flask import jsonify, request
from Server.objects.joineer_db import JoineerDB
from Server.objects.joineer_flask import JoineerFlask
from bson.objectid import ObjectId
import logging
import bcrypt

logger = logging.getLogger('root')

root_parser = reqparse.RequestParser()
root_parser.add_argument('title', required=True, type=str)
# expecting the json value to be a list of strings
root_parser.add_argument('host_id', required=True, type=str, action='append')
root_parser.add_argument('time', required=True, type=dict)
root_parser.add_argument('location', required=True, type=dict)
root_parser.add_argument('headcount', required=False, type=dict)
root_parser.add_argument('payment', required=True, type=float)
root_parser.add_argument('constraint', required=False, type=dict, action='append')


location_parser = reqparse.RequestParser()
location_parser.add_argument('latitude', type=float, required=True, location='location')
location_parser.add_argument('longitude', type=float, required=True, location='location')

time_parser = reqparse.RequestParser()
time_parser.add_argument('starttime', type=int, required=True, location='time')
time_parser.add_argument('endtime', type=int, required=False, location='time')

headcount_parser = reqparse.RequestParser()
headcount_parser.add_argument('min', type=int, required=False, location='headcount')
headcount_parser.add_argument('max', type=int, required=False, location='headcount')

# constraint_parser = reqparse.RequestParser()
# constraint_parser.add_argument('age_min', type=int, required=False, location='constraint')
# constraint_parser.add_argument('age_max', type=int, required=False, location='constraint')
# constraint_parser.add_argument('gender', type=bool, required=False, location='constraint')
# constraint_parser.add_argument('headcount', type=int, required=True, location='constraint')


'''
    In charge of user creation and validation on user id 
'''


class Events(Resource):
    collection = JoineerDB().db.users

    def post(self):
        root_args = root_parser.parse_args(strict=True)
        location = location_parser.parse_args(req=root_args)
        time = time_parser.parse_args(req = root_args)
        headcount = headcount_parser.parse_args(req=root_args)
        #constraints = constraint_parser.parse_args(req=root_args)

        logger.info("Received EVENT location: %s", str(location))
        logger.info("Received EVENT time: %s", str(time))
        logger.info("Received EVENT headcount: %s", str(headcount))
        logger.info("Received EVENT constraints: %s", str(root_args["constraint"]))

        resp = jsonify({"eventID": "ALLGOOD", "status": "created"})
        resp.status_code = 201
        return resp

    def get(self, user_id):
        pass
