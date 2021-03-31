# newport_delay_stage_gui_matlab
January, 2020

## 1. Description
This repository provides a GUI tool for controlling the [Newport delay line stage](https://www.newport.com/f/delay-line-stages). In order to control the stage, .NET Framework is used. This GUI works under the following condisionts:
- Windows 10
- Matlab R2018b 
- [DL Series Optical Delay Line Linear Motor Linear Translation Stages](https://www.newport.com/f/delay-line-stages)

## 2. Control Window
<img src="https://github.com/ksonod/newport_delay_stage_gui_matlab/blob/master/dls_matlab1.PNG" width="300px">  
  
If you run gui_test.m, a small window displayed above will show up. The window consists of 3 sections:
- CURRENT SETTINGS
- CHANGE SETTINGS
- DELAY SCAN

### 3.1 CURRENT SETTINGS
This section consists of only 1 button named "Current settings." If you click this button, you can get the latest value. 

### 3.2 CHANGE SETTINGS
The Change Settings section allows you to change the position, velocity, and acceleration. 

### 3.3 DELAY SCAN
This section allows you to do the automatic scan. Once you specify the initial and final positions and the number of steps, you can calculate scan step (s/step) and scan range (s) by clicking the Calculate-time-settings button.  
  
Once you start scanning, you can see the progress of the scan in the command window.
<img src="https://github.com/ksonod/newport_delay_stage_gui_matlab/blob/master/dls_matlab2.PNG" width="300px">  

## 4. Useful References
- Official document: https://www.newport.com/mam/celum/celum_assets/resources/DL_Controller_-_Command_Interface_Manual.pdf?1
- My another repository: https://github.com/ksonod/newport_delay_stage_basic_matlab
