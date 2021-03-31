import sys
import clr
import tkinter as tk
from time import sleep
import numpy as np

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

dummy_out0 = Double(0.)
dummy_out1 = String('')


def update(window, coord_params):
    current_pos=myDLS.TP(dummy_out0,dummy_out1)[1] # current position
    current_velo=myDLS.VA_Get(dummy_out0,dummy_out1)[1] # current velocity
    current_acc=myDLS.AC_Get(dummy_out0,dummy_out1)[1] # current acceleration

    my_dummy = tk.Label(window, text="%f     "%current_pos).place(x=coord_params['x_values'], y=coord_params['y1']) # showing the current position
    my_dummy = tk.Label(window, text="%f     "%current_velo).place(x=coord_params['x_values'], y=coord_params['y2']) # showing the velocity
    my_dummy = tk.Label(window, text="%f     "%current_acc).place(x=coord_params['x_values'], y=coord_params['y3']) # showing the acceleration
    
    
def move_stage(my_entry):
    my_dummy = myDLS.PA_Set(my_entry.get(), dummy_out1)[1] # move the stage
    
    
def change_velocity(my_entry):
    my_dummy = myDLS.VA_Set(my_entry.get(), dummy_out1)[1] # change the velocity
    

def change_acceleration(my_entry):
    my_dummy = myDLS.AC_Set(my_entry.get(), dummy_out1)[1] # change the acceleration

def change_everything(my_entry1, my_entry2, my_entry3,window,coord_params):
    # after changing the velocity and acceleration, the position is changed.
    
    acc_val = 0.0001  # acceptable value
    
    change_velocity(my_entry2)
    change_acceleration(my_entry3)

    sleep(0.01)

    move_stage(my_entry1)
    x_target=float(my_entry1.get())
    
    sleep(0.1)
    
    diff=1000 # arbitrary large value
    
    while diff>acc_val: # wait until the stage moves to the initial position
        x_current = myDLS.TP(dummy_out0,dummy_out1)[1] # get current position
        diff=np.abs(x_target-x_current) # difference between the current and target position
        sleep(0.5)

    update(window, coord_params)

def calc_time_setting(my_entry1, my_entry2, my_entry3, window, coord_params):
# my_entry1: initial position
# my_entry2: final position
# my_entry3: number of steps
    
    c_light=299792458 #speed of light
    
    x_init=float(my_entry1.get()) # initial position
    x_fin=float(my_entry2.get()) # final position
    n_step= int(my_entry3.get()) # number of steps
 
    dx=np.abs(x_fin-x_init)/float(n_step) # step
    t_step= 2 * dx/c_light*1e12 # fs
    t_range=2 * np.abs(x_fin-x_init)/c_light*1e12 # fs
  
    unit_tim_step = 'fs'
    unit_tim_range = 'fs'

    if t_step>1000:
        t_step = t_step/1000 # ps
        unit_tim_step = 'ps'        
    
    if t_range>1000:
        t_range = t_range/1000 # ps
        unit_tim_range='ps'
    
    my_dummy = tk.Label(window, text="%f %s     "%(t_step,unit_tim_step)).place(x=coord_params['x_values'], y=coord_params['y1']) # showing the time step
    my_dummy = tk.Label(window, text="%f %s     "%(t_range,unit_tim_range)).place(x=coord_params['x_values'], y=coord_params['y2']) # showing the temporal scan range
   
    
def delay_scan(my_entry1, my_entry2, my_entry3, my_entry4):
# my_entry1: initial position
# my_entry2: final position
# my_entry3: number of steps
# my_entry4: number of scans
    
    acc_val = 0.00015  # acceptable value
    x_init=float(my_entry1.get()) # initial position
    x_fin=float(my_entry2.get()) # final position
    n_step= int(my_entry3.get()) # number of steps
    n_scan= int(my_entry4.get()) # number of scans
   
    dx=(x_fin-x_init)/float(n_step) # step
    
    v_setting = float(myDLS.VA_Get(dummy_out0,dummy_out1)[1]) # current velocity
    a_setting = float(myDLS.AC_Get(dummy_out0,dummy_out1)[1]) # current acceleration
    
    print("DELAY STAGE SCAN")
    for i in range(n_scan): 
        
        my_dummy = myDLS.VA_Set(20.0, dummy_out1)  # change the velocity temporarily so that the stage can quickly go back to the initial position 
        my_dummy = myDLS.AC_Set(20.0, dummy_out1)  # change the acceleration temporarily
        my_dummy = myDLS.PA_Set(x_init, dummy_out1)[1] # change the position
    
        diff=1000 # arbitrary large value
        
        while diff>acc_val: # wait until the stage moves to the initial position
            x_current = myDLS.TP(dummy_out0,dummy_out1)[1] # get current position
            diff=np.abs(x_init-x_current) # difference between the current and initial target position
            sleep(0.5)
        
        my_dummy = myDLS.VA_Set(v_setting, dummy_out1)  # change the velocity to the original value
        my_dummy = myDLS.AC_Set(a_setting, dummy_out1)  # change the acceleration to the original value        
        
        print("SCAN [%d/%d]"%(i+1,n_scan)) # showing the progress of the scan
        print("initial position = ",myDLS.TP(dummy_out0,dummy_out1)[1]) # get initial position
    
        for j in range(n_step): # start scanning
            my_dummy = myDLS.PD(dx, dummy_out1, dummy_out1)[1] # move the stage by dx
            
            x_target= x_init + (j+1)*dx # target position
            diff=1000 # arbitrary large value
            
            while diff>acc_val: # wait until the stage moves to the target position
                x_current = myDLS.TP(dummy_out0,dummy_out1)[1]
                diff=np.abs(x_target-x_current)
                sleep(0.1)
            
            print("%d/%d"%(j+1,n_step)) # show the progress
        
    print("FINISH...")