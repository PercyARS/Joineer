__author__ = 'Peixi Zhao'
from flask_restful import Resource, reqparse
from flask import jsonify, request
from Server.objects.joineer_db import JoineerDB
from Server.resources.user import Users
from Server.utilities.rest_utils import *
from Server.resources.non_rest.reqparse_validator import *
from bson.objectid import ObjectId
from Server.states.event_state import *
import pymongo
import logging
import sys


'''
    In charge of user creation and validation on user id 
'''


class Events(Resource):
    logger = logging.getLogger('root')
    collection = JoineerDB().db.events

    def __init__(self):
        self.root_parser = reqparse.RequestParser()
        self.root_parser.add_argument('title', required=True, type=str)
        # expecting the json val
        # ue to be a list of strings
        self.root_parser.add_argument('host_id', required=True, type=str, action='append')
        self.root_parser.add_argument('time', required=True, type=dict)
        self.root_parser.add_argument('location', required=True, type=dict)
        self.root_parser.add_argument('payment', required=True, type=float)
        self.root_parser.add_argument('headcount', required=False, type=dict)
        self.root_parser.add_argument('constraint', required=False, type=dict, action='append')

        self.location_parser = reqparse.RequestParser()
        self.location_parser.add_argument('latitude', type=float, required=True, location='location')
        self.location_parser.add_argument('longitude', type=float, required=True, location='location')
        self.time_parser = reqparse.RequestParser()
        self.time_parser.add_argument('starttime', type=utc_timestamp, required=True, location='time')
        self.time_parser.add_argument('endtime', type=utc_timestamp, required=False, location='time')

        self.headcount_parser = reqparse.RequestParser()
        self.headcount_parser.add_argument('min', type=int, required=False, location='headcount')
        self.headcount_parser.add_argument('max', type=int, required=False, location='headcount')

    def events_massager(self, event_dict):
        event = dict()
        host_list = list()
        headcount_dict = dict()
        time_dict = dict()
        location_list = list()
        event["state"] = EventState.NEW
        event["title"] = event_dict["title"]

        event["payment"] = float(event_dict["payment"])
        event["joinee"] = list()

        # Set location list
        location_list = [float(event_dict['location']['latitude']), float(event_dict['location']['longitude'])]
        event['location'] = location_list

        # Set datetime object
        for time_key, time_str in event_dict["time"].items():
            time_dict[time_key] = utc_timestamp(time_str)
        event["time"] = time_dict

        # Embed host info
        for host_id in event_dict["host_id"]:
            user_json = Users.get_user_object(host_id)
            self.logger.debug("Added host object %s", user_json)
            host_list.append(user_json)
        event["hosts"] = host_list

        #TODO: Find the correct type to insert
        # Set headcount info
        if "headcount" in event_dict:
            headcount_dict = event_dict["headcount"]
            if "min" in headcount_dict:
                pass
            else:
                headcount_dict["min"] = 0
            if "max" in headcount_dict:
                pass
            else:
                # Default max headcount the max int
                headcount_dict["max"] = sys.maxsize
        else:
            headcount_dict["min"] = 0
            headcount_dict["max"] = sys.maxsize
        self.logger.debug("Added HeadCount Dict %s", headcount_dict)
        event["headcount"] = headcount_dict
        if "constraint" in event_dict:
            event["constraint"] = event_dict["constraint"]
        return event

    def post(self):
        # Validate Json format
        root_args = self.root_parser.parse_args(strict=True)
        location = self.location_parser.parse_args(req=root_args)
        time = self.time_parser.parse_args(req=root_args)
        headcount = self.headcount_parser.parse_args(req=root_args)

        # Further Validate Json contents
        for host_id in root_args["host_id"]:
            if not Users.if_user_exists(host_id):
                return response({"host_id": host_id, "status": "does not exist"}, 400)
        if "constraint" in root_args:
            for constraint in root_args["constraint"]:
                if "headcount" not in constraint:
                    return response({"constraint": constraint, "status": "has no headcount"}, 400)

        # Massage events object
        event = self.events_massager(root_args)

        #ensure Index
        self.collection.create_index([("location", pymongo.GEOSPHERE)])
        result = self.collection.insert_one(event)
        self.logger.info("Event document created: %s", result)
        return response({"eventID": str(result.inserted_id), "status": "created"}, 201)

    '''
        We will do lazy update on event objects, which means that we update event state only when
        a get request is issued

        Certain check we need:
        1. CurrentTime vs Event starttime/endtime
    '''

    def get(self, event_id):
        self.logger.info("Attempted check if event %s exists", event_id)
        event_json = self.collection.find_one({"_id": ObjectId(event_id)})
        if event_json is None:
            return response({"userID": event_id, "status": "does not exist"}, 404)
        event_state = EventState(event_json)

        # Lazy update the event states
        if event_state.check_expire():
            self.logger.info("Event %s expired alreday", event_id)
        self.collection.update_one({"_id": ObjectId(event_id)}, {"$set": {"state": event_state.state}})
        event_json = self.collection.find_one({"_id": ObjectId(event_id)})
        return event_json