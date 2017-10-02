__author__ = 'Peixi Zhao'

import json
from bson.objectid import ObjectId
from datetime import date, datetime


# Custom JSONEncoder that extracts the strings from special types
class JSONEncoder(json.JSONEncoder):
    def default(self, o):
        if isinstance(o, ObjectId):
            return str(o)
        if isinstance(o, (datetime, date)):
            return o.isoformat()
        return json.JSONEncoder.default(self, o)
