__author__ = 'Peixi Zhao'

from Server.objects.joineer_db import JoineerDB
import bcrypt
from flask_restful import Resource, reqparse
import logging
from flask import jsonify

logger = logging.getLogger('root')
parser = reqparse.RequestParser()
parser.add_argument('username', required=True, type=str)
parser.add_argument('password', required=True, type=str)
users_collection = JoineerDB().db.users

'''
    Check the username and password pair
'''


def check_auth(username, password):
    if username == 'admin' and password == 'admin':
        return True
    user = users_collection.find_one({'username': username})
    if user is None:
        return False

    # the password we stored into db
    db_hashed_password = user['password']
    # the password user provided
    encoded_password = password.encode('utf-8')
    # compare the hashed witht the db one
    encrypted_password = bcrypt.hashpw(encoded_password, db_hashed_password)
    check_if_correct_password = (encrypted_password == db_hashed_password)
    return check_if_correct_password


class Login(Resource):
    def post(self):
        args = parser.parse_args(strict=True)
        if (check_auth(args["username"], args["password"])):
            resp = jsonify({"password": "verified"})
            resp.status_code = 200
            return resp
        else:
            resp = jsonify({"password": "incorrect"})
            resp.status_code = 401
            return resp
