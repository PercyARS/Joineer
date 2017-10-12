__author__ = 'Peixi Zhao'
from flask_restful import Resource, reqparse
from flask import request, jsonify, make_response
from Server.objects.joineer_db import JoineerDB
from Server.objects.joineer_flask import JoineerFlask
from bson.objectid import ObjectId
from Server.utilities.rest_utils import *
import logging
import bcrypt




'''
    In charge of user creation and validation on user id 
'''

class Users(Resource):
    collection = JoineerDB().db.users
    logger = logging.getLogger('root')

    def __init__(self):
        self.parser = reqparse.RequestParser()
        self.parser.add_argument('username', required=True, type=str)
        self.parser.add_argument('gender', required=True, type=bool)
        self.parser.add_argument('password', required=True, type=str)
        self.parser.add_argument('age', required=True, type=int)

    @classmethod
    def if_user_exists(cls, user_id):
        if cls.collection.find({"_id": ObjectId(user_id)}).count() > 0:
            return True
        else:
            return False

    @classmethod
    def get_user_object(cls, user_id):
        user_profile_without_pw = cls.collection.find_one({"_id": ObjectId(user_id)}, {"password":0})
        return user_profile_without_pw

    def post(self):
        args = self.parser.parse_args(strict=True)
        # If the username already exists
        if self.collection.find({"username": args["username"]}).count() > 0:
            self.logger.info("Attempted to Creat Username:" + args["username"] + " That Already Exists")
            existing_profile = self.collection.find_one({"username":args["username"]})
            return response({"userID": str(existing_profile["_id"]), "status": "exists"}, 401)
        # encrypt the password
        encoded_password = args["password"].encode('utf-8')
        hashed_password = bcrypt.hashpw(encoded_password, bcrypt.gensalt(JoineerFlask().app.bcrypt_rounds))
        args["password"] = hashed_password
        result = self.collection.insert_one(args)
        self.logger.info("Added User Id: " + str(result.inserted_id))
        return response({"userID": str(result.inserted_id), "status": "created"}, 201)

    def get(self, user_id):
        self.logger.info("Attempted check if user %s exists", user_id)
        user_profile_without_pw = self.collection.find_one({"_id": ObjectId(user_id)}, {"password":0})
        if user_profile_without_pw is None:
            return response({"userID": user_id, "status": "does not exist"}, 404)
        else:
            self.logger.debug("User profile retrieved: " + str(user_profile_without_pw))
            return user_profile_without_pw
