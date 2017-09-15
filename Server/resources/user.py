__author__ = 'Peixi Zhao'
from flask_restful import Resource, reqparse
from flask import request, jsonify, make_response
from Server.objects.joineer_db import JoineerDB
from Server.objects.joineer_flask import JoineerFlask
from bson.objectid import ObjectId
import logging
import bcrypt

logger = logging.getLogger('root')
parser = reqparse.RequestParser()
parser.add_argument('username', required=True, type=str)
parser.add_argument('gender', required=True, type=bool)
parser.add_argument('password', required=True, type=str)
parser.add_argument('age', required=True, type=int)

'''
    In charge of user creation and validation on user id 
'''


class Users(Resource):
    collection = JoineerDB().db.users

    def post(self):
        args = parser.parse_args(strict=True)
        # If the username already exists
        if self.collection.find({"username": args["username"]}).count() > 0:
            logger.info("Attempted to Creat Username:" + args["username"] + " That Already Exists")
            existing_profile = self.collection.find_one({"username":args["username"]})
            resp = jsonify({"userID": str(existing_profile["_id"]), "status": "exists"})
            resp.status_code = 401
            return resp
        # encrypt the password
        encoded_password = args["password"].encode('utf-8')
        hashed_password = bcrypt.hashpw(encoded_password, bcrypt.gensalt(JoineerFlask().app.bcrypt_rounds))
        args["password"] = hashed_password
        result = self.collection.insert_one(args)
        logger.info("Added User Id: " + str(result.inserted_id))
        resp = jsonify({"userID": str(result.inserted_id), "status": "created"})
        resp.status_code = 201
        return resp

    def get(self, user_id):
        logger.info("Attempted check if %s exists", user_id)
        user_profile_without_pw = self.collection.find_one({"_id": ObjectId(user_id)}, {"password":0})
        if user_profile_without_pw is None:
            resp = jsonify({"userID": user_id, "status": "does not exist"})
            resp.status_code = 404
            return resp
        else:
            logger.debug("User profile retrieved: " + str(user_profile_without_pw))
            return user_profile_without_pw
