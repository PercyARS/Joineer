__author__ = 'Peixi Zhao'

from flask import Flask, request, make_response, jsonify
from flask_restful import Resource, Api
from bson.objectid import ObjectId
from Server.objects_pool.joineer_flask import joineer_flask
from Server.resources.test import Test



if __name__ == '__main__':
    app = joineer_flask().app
    app.run(debug=True)
