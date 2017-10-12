__author__ = 'Peixi Zhao'

from Server.resources.user import Users
import bcrypt
from flask_restful import Resource, reqparse
import logging
from Server.utilities.rest_utils import *
from flask import jsonify

'''
    Check the username and password pair
'''


class Login(Resource):
    collection = Users.collection
    logger = logging.getLogger('root')

    def __init__(self):
        self.logger = logging.getLogger('root')
        self.parser = reqparse.RequestParser()
        self.parser.add_argument('username', required=True, type=str)
        self.parser.add_argument('password', required=True, type=str)

    @classmethod
    def check_auth(cls, username, password):
        user = Login.collection.find_one({'username': username})
        if user is None:
            return False

        # the password we stored into db
        db_hashed_password = user['password']
        # the password user provided
        encoded_password = password.encode('utf-8')
        # compare the hashed with the db
        encrypted_password = bcrypt.hashpw(encoded_password, db_hashed_password)
        check_if_correct_password = (encrypted_password == db_hashed_password)
        return check_if_correct_password

    def post(self):
        args = self.parser.parse_args(strict=True)
        if Login.check_auth(args["username"], args["password"]):
            user = self.collection.find_one({'username': args["username"]})
            return response({"userID": str(user["_id"]), "password": "verified"})
        else:
            return response({"password/username": "incorrect"}, 401)
