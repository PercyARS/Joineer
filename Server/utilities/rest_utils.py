__author__ = 'Peixi Zhao'

from flask import jsonify

'''
    helper function to generate rest response
'''


def response(resp_dict, code=200):
    resp = jsonify(resp_dict)
    resp.status_code = code
    return resp
