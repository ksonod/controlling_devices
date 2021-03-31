import sys
import clr

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

if result==0:
    print('Success')
else: 
    print('Fail')
    
# Dummy arguments of the expected type 
# https://stackoverflow.com/questions/54692267/python-net-call-c-sharp-method-which-has-a-return-value-and-an-out-parameter
dummy_out0 = Double(0.)
dummy_out1 = String('')

# Call DLS functions. Here, VE is used.
result=myDLS.TP(dummy_out0,dummy_out1)

print("current position:",result)

# Close DLS connection   
myDLS.CloseInstrument()