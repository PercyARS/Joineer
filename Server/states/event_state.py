__author__ = 'Peixi Zhao'

from transitions import Machine
import logging
import datetime

'''
     condition-checking methods 
'''

# >>> lump.state
# 'liquid'
#lump.to_gas()
#machine.set_state('solid')



# transitions = [
#     { 'trigger': 'melt', 'source': 'solid', 'dest': 'liquid', 'before': 'make_hissing_noises'},
#     { 'trigger': 'evaporate', 'source': 'liquid', 'dest': 'gas', 'after': 'disappear' }
# ]

'''
    Pass arguments
'''
#     def set_environment(self, event):
#         self.temp = event.kwargs.get('temp', 0)
#         self.pressure = event.kwargs.get('pressure', 101.325)
#
#     def print_pressure(self): print("Current pressure is %.2f kPa." % self.pressure)
#
# lump = Matter()
# machine = Machine(lump, ['solid', 'liquid'], send_event=True, initial='solid')
# machine.add_transition('melt', 'solid', 'liquid', before='set_environment')
#
# lump.melt(temp=45, pressure=1853.68)  # keyword args

class EventState(object):

    # state names
    ANY = "*"
    NEW = "new"
    EXPIRED = "expired"


    #TODO: Define all possible states
    states = [NEW, EXPIRED]

    #TODO: Define all possible transitions into dict
    transitions = [
        {'trigger': "check_expire", 'source': ANY, 'dest': EXPIRED, 'before': 'notify_event_expiry', 'conditions': 'check_if_expired'}
    ]


    '''
        initialize event state state machine
    '''
    def __init__(self, event_dict):
        self.logger = logging.getLogger('root')
        self.event_dict = event_dict
        self.machine = Machine(name=str(event_dict["_id"]), model=self, states=EventState.states, transitions=EventState.transitions,
                               initial=event_dict["state"], send_event=True, after_state_change='update_event_state')



    '''
        Define all callbacks
    '''

    def update_event_state(self, event):
        self.event_dict["state"] = self.state

    def notify_event_expiry(self, event):
        pass
        #TODO: notify all users

    '''
        Define condition checks
    '''

    # Check if the event has already expired
    def check_if_expired(self, event):
        if "endtime" not in self.event_dict["time"]:
            return False
        else:
            iso_utc_current = datetime.datetime.utcnow()
            if iso_utc_current >= self.event_dict["time"]["endtime"]:
                return True

