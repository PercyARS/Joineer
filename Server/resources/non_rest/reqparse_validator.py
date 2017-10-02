__author__ = 'Peixi Zhao'

import datetime
from datetime import timezone


'''
    package contains all the customized reqparse types 
'''

def utc_timestamp(timestamp):
    return datetime.datetime.fromtimestamp(int(timestamp), timezone.utc)

