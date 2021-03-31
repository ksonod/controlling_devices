import tkinter as tk
from myfunc import *


window = tk.Tk()
window.title("Newport Delay Line Stage Controller")
window.geometry("470x360")

# UPDATE ######################################################################################
coord_params1={'x_labels':20,
             'x_values':150,
             'y1':25,
             'y2':45,
             'y3':65             
             }
label0 = tk.Label(window, text="--CURRENT SETTINGS--")
label0.place(x=coord_params1['x_labels'], y=5) # showing the current position

label1 = tk.Label(window, text="Current position [mm]:")
label1.place(x=coord_params1['x_labels'], y=coord_params1['y1']) # showing the current position

label2 = tk.Label(window, text="Velocity [mm/s]:")
label2.place(x=coord_params1['x_labels'], y=coord_params1['y2']) # showing the current position

label3 = tk.Label(window, text="Acceleration [mm/s^2]:")
label3.place(x=coord_params1['x_labels'], y=coord_params1['y3']) # showing the current position

button1 = tk.Button(window, text="Update", command= lambda : update(window, coord_params1))
button1.place(x=coord_params1['x_labels'], y=90)


#CHANGE SETTINGS ######################################################################################
label4 = tk.Label(window, text="--CHANGE SETTINGS--")
label4.place(x=20,y=130) 

#TARGET POSITION
label5 = tk.Label(window, text="Target position x[mm]:")
label5.place(x=20,y=150) 

entry1 = tk.Entry(window, width=12)
entry1.place(x = 20, y = 175)

button2 = tk.Button(window, text="Move to x", command= lambda : move_stage(entry1))
button2.place(x=105,y=170) # change, but no update

#CHANGE VELOCITY
label6 = tk.Label(window, text="Velocity v [mm/s]:")
label6.place(x=20,y=205) 

entry2 = tk.Entry(window, width=12) 
entry2.place(x = 20, y = 230)

button3 = tk.Button(window, text="Change v", command= lambda : [change_velocity(entry2), update(window, coord_params1)])
button3.place(x=105,y=225) # change and update

#CHANGE ACCELERATION
label7 = tk.Label(window, text="Acceleration a [mm/s^2]:")
label7.place(x=20,y=260)
 
entry3 = tk.Entry(window, width=12) 
entry3.place(x = 20, y = 285)

button4 = tk.Button(window, text="Change a", command= lambda : [change_acceleration(entry3), update(window, coord_params1)])
button4.place(x=105,y=280) # change and update

#BUTTON FOR UPDATING ALL VALUES
button5 = tk.Button(window, text="Change x, v, and a at once", command= lambda: change_everything(entry1,entry2,entry3,window,coord_params1))
button5.place(x=20,y=320)


#DELAY SCAN  ##################################################################
label8 = tk.Label(window, text="--DELAY SCAN--")
label8.place(x=240,y=5) 

#INITAL POSITION
label9 = tk.Label(window, text="Initial position [mm]:")
label9.place(x=240,y=30) 

entry4 = tk.Entry(window, width=12) 
entry4.place(x = 360, y = 32)

#FINAL POSITION
label10 = tk.Label(window, text="Final position [mm]:")
label10.place(x=240,y=60) 

entry5 = tk.Entry(window, width=12) 
entry5.place(x = 360, y = 62)

#NUMBER OF STEPS
label11 = tk.Label(window, text="Number of steps:")
label11.place(x=240,y=90) 

entry6 = tk.Entry(window, width=12) 
entry6.place(x = 360, y = 92)

#NUMBER OF SCANS
label12 = tk.Label(window, text="Number of scans:")
label12.place(x=240,y=120) 

entry7 = tk.Entry(window, width=12) 
entry7.place(x = 360, y = 122)

#BUTTON FOR CALCULATING TIME STEP AND SCAN RANGE
coord_params2={'x_values':305,
             'y1':145,
             'y2':165
             }
label13 = tk.Label(window, text="scan step:")
label13.place(x=240,y=145)  

label14 = tk.Label(window, text="scan range:")
label14.place(x=240,y=165) 

button6 = tk.Button(window, text="Calculate time settings", command= lambda: calc_time_setting(entry4, entry5, entry6, window, coord_params2))
button6.place(x=240,y=190)

#BUTTON FOR STARTING THE SCANN
button7 = tk.Button(window, text="Start scanning", command= lambda: delay_scan(entry4, entry5, entry6, entry7))
button7.place(x=380,y=190)

#REFERENCE ####################################################################

label15 = tk.Label(window, text="--REFERENCE--")
label15.place(x=240,y=235) 
label16 = tk.Label(window, text="1 um => 6.671 fs")
label16.place(x=240,y=250) 

window.mainloop()