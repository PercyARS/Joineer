__author__ = 'Peixi Zhao'
from flask_restful import Resource, reqparse
from flask import request, jsonify, make_response
from Server.objects.joineer_db import JoineerDB
from Server.objects.joineer_flask import JoineerFlask
from bson.objectid import ObjectId
from Server.utilities.rest_utils import *
from pymongo import GEO2D
import pymongo
from bson.json_util import dumps
from bson.son import SON

import logging
import bcrypt


class Test(Resource):
    collection = JoineerDB().db.events
    logger = logging.getLogger('root')

    def __init__(self):
        self.root_parser = reqparse.RequestParser()
        self.root_parser.add_argument('location', required=False, type=dict)
        self.location_parser = reqparse.RequestParser()
        self.location_parser.add_argument('latitude', type=float, required=True, location='location')
        self.location_parser.add_argument('longitude', type=float, required=True, location='location')

    def post(self):
        args = self.root_parser.parse_args(strict=True)
        location = self.location_parser.parse_args(req=args)
        if 'location' in args:
            self.collection.create_index([("location", pymongo.GEOSPHERE)])
            events_nearby = self.collection.aggregate([{"$geoNear": {"near": {"type": "Point",
                    "coordinates": [float(args['location']['latitude']), float(args['location']['longitude'])]},
                    "maxDistance": 5000, "spherical": True, "distanceField": "distance"}}])
            return list(events_nearby)
        else:
            return response({"No": "location query"}, 401)
