# newport_delay_stage_gui
January, 2020

## 1. Description
This repository provides a GUI tool for controlling the [Newport delay line stage](https://www.newport.com/f/delay-line-stages). In order to control the stage, .NET Framework is used. This GUI works under the following condisionts:
- Windows 10
- Python3 (Anaconda)
- [DL Series Optical Delay Line Linear Motor Linear Translation Stages](https://www.newport.com/f/delay-line-stages)

## 2. Codes
This tool consists of 2 files. 
- [DLS_GUI_control.py](https://github.com/ksonod/newport_delay_stage_gui/blob/master/DLS_GUI_control.py): This is mainly responsible for GUI.
- [myfunc.py](https://github.com/ksonod/newport_delay_stage_gui/blob/master/myfunc.py): This code includes various functions for communicating with the delay line stage.

## 3. Control Window
<img src="https://github.com/ksonod/newport_delay_stage_gui/blob/master/dls_gui.PNG" width="500px">  
  
If you run the DLS_GUI_control.py, a new window displayed above will show up. The window consists of 3 sections:
- CURRENT SETTINGS
- CHANGE SETTINGS
- DELAY SCAN

### 3.1 CURRENT SETTINGS
The section of the Current Settings shows the current values of the position, velocity, and acceleration. You can get the latest value by clicking the Update button. If you click it multiple times, you can see that the delay stage position slightly changes.

### 3.2 CHANGE SETTINGS
The Change Settings section allows you to change the position, velocity, and acceleration. You can type values and click the button placed right to the entry box. Move-to-x button initiates the movement of the stage to the target position. The value in the Current Settings is not automatically updated. In order to know the current stage position, you can click the Update button in the Current Settings section. Change-v and Change-a buttons allow us to change values and automatically update the Current Settings section. If you want to change all values and update the Current Settings, you can click Change-x,v,and-a-at-once button. 

### 3.3 DELAY SCAN
This section allows you to do the automatic scan for several times. Once you specify the initial and final positions and number of steps, you can calculate scan step (s/step) and scan range (s) by clicking the Calculate-time-settings button.  
  
Once you start scanning, you can see the progress of the scan.

<img src="https://github.com/ksonod/newport_delay_stage_gui/blob/master/dls_gui_2.PNG" width="200px">

## 4. Avoiding Expected Errors at the Beginning
- Check whether you have [pythonnet](https://pypi.org/project/pythonnet/).
- Check whether you are importing correct clr library.
- Check the COM port. If you are not sure whether your computer communicates with your delay stage, you can use the official software as a first step.
- Put the DLS_GUI_control.py and myfunc.py in the same directory.

## 5. Useful References
- Official document: https://www.newport.com/mam/celum/celum_assets/resources/DL_Controller_-_Command_Interface_Manual.pdf?1
- My another repository: https://github.com/ksonod/newport_delay_stage_basic_python
