__author__ = 'Peixi Zhao'

from flask import Flask, request, make_response, jsonify
from flask_restful import Resource, Api
from bson.objectid import ObjectId
from .resources.boot_resources import *
from .utilities.mongo_json_encoder import JSONEncoder


class MyObject(Resource):

    def post(self):
        new_myobject = request.json
        myobject_collection = app.db.myobjects
        result = myobject_collection.insert_one(request.json)

        myobject = myobject_collection.find_one({"_id": ObjectId(result.inserted_id)})

        return myobject

    def get(self, myobject_id):
        myobject_collection = app.db.myobjects
        myobject = myobject_collection.find_one({"_id": ObjectId(myobject_id)})

        if myobject is None:
            response = jsonify(data=[])
            response.status_code = 404
            return response
        else:
            return myobject

# Add REST resource to API
api.add_resource(MyObject, '/myobject/','/myobject/<string:myobject_id>')

# provide a custom JSON serializer for flaks_restful
@api.representation('application/json')
def output_json(data, code, headers=None):
    resp = make_response(JSONEncoder().encode(data), code)
    resp.headers.extend(headers or {})
    return resp

if __name__ == '__main__':
    # Turn this on in debug mode to get detailled information about request related exceptions: http://flask.pocoo.org/docs/0.10/config/
    app.run(debug=True)