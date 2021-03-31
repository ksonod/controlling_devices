# Moving the Newport Delay Line Motorized Stage.

import sys
import clr
from time import sleep

# target position
target_pos = 100

# waiting time needed for ensuring that the stage has finished moving.
waiting_time = 0.5


# Add Newport.DLS.CommandInterface.dll in References of your script
sys.path.append(r'C:\\Windows\\Microsoft.NET\\assembly\\GAC_64\\Newport.DLS.CommandInterface\\v4.0_1.0.0.4__90ac4f829985d2bf')

#Add library path
clr.AddReference("C:\\Windows\\Microsoft.NET\\assembly\\GAC_64\\Newport.DLS.CommandInterface\\v4.0_1.0.0.4__90ac4f829985d2bf\\Newport.DLS.CommandInterface.dll")

from CommandInterfaceDLS import *
from System import String, Double

# COM port
instrument="COM3"

# Create an instance DLS interface
myDLS = DLS()

# Open a socket
result = myDLS.OpenInstrument(instrument)

if result==0: # If the connection is established...
    # Dummy arguments of the expected type 
    # https://stackoverflow.com/questions/54692267/python-net-call-c-sharp-method-which-has-a-return-value-and-an-out-parameter
    dummy_out0 = Double(0.)
    dummy_out1 = String('')
    
    # Call the DLS function for getting the current position.
    result=myDLS.TP(dummy_out0,dummy_out1)
    
    print("current position:",result[1])
    
    # Call the DLS function for moving the stage to the target position     
    result=myDLS.PA_Set(target_pos, dummy_out1)
    if result[0] == 0:
        print("moving the stage: success")
    else:
        print("moving the stage: fail")
    
    sleep(waiting_time)
    
    # Call the DLS function for getting the current position.
    result=myDLS.TP(dummy_out0,dummy_out1)
    
    print("current position:",result[1])
    
else: # connection is not established
    print('Fail')
    
# Close DLS connection   
myDLS.CloseInstrument()