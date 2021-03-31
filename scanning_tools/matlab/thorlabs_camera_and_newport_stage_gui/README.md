# thorcam_NewportStage_GUI
August, 2020

## 1. Description
This repository provides a GUI tool for controlling the [Newport delay line stage](https://www.newport.com/f/delay-line-stages), getting images from [Thorlabs camera](https://www.thorlabs.com/newgrouppage9.cfm?objectgroup_id=4024), and opening/closing a [Thorlabs optical shutter](https://www.thorlabs.com/newgrouppage9.cfm?objectgroup_id=927). Live view is also available. This GUI works under the following condisionts:
- Windows 10
- Matlab R2018b
- [DL Series Optical Delay Line Linear Motor Linear Translation Stages](https://www.newport.com/f/delay-line-stages)
- [Thorlabs Compact USB 2.0 CMOS Cameras](https://www.thorlabs.com/newgrouppage9.cfm?objectgroup_id=4024)
- [Thorlabs Optical Shutter](https://www.thorlabs.com/newgrouppage9.cfm?objectgroup_id=927)

## 2. Control Window
<img src="https://github.com/ksonod/thorcam_NewportStage_GUI/blob/master/gui0.PNG" width="1000px">    
If you run the gui_stage_camera.m, a new window displayed above will show up. The second version "gui_stage_camera_v2.m" has an additional button "Start obtaining differences."

### 2.1 Image Acquisition
In this section, an image obtained by a camera is displayed. If you click the Start button after specifying the exposure time, the current image will be continuously shown on the window. Maximum intensity is also shown on the right side of the Start button so that you can check if signal is saturated. If you want to stop image acquisition, you can click the Stop button.

### 2.2 Shutter
By clicking a button in this section, you can open and close an optical shutter. The current status of the shutter is also shown.

### 2.3 Delay Stage Settings
You can change the current position, velocity, and acceleration. The current settings can be shown by clicking a button.

### 2.4 Delay Stage Scan 
You can get images as a function of the delay stage coordinate. Once you specify the initial and final positions and the number of steps, you can click the Calculate-Time-Settings button and get the time step and time range of the scan. The Start-Scanning button initiates the movement of the delay stage and image acquisition. The progress of the scan will be shown in a command window. If you click "Start obtaining differences" in the second version "gui_stage_camera_v2.m," images with shutter opened/closed are obtained. Their differences will be shown in the window.

## Resources
The following dll files are taken from official websites of Thorlabs and Newport:
- Newport.DLS.CommandInterface.dll
- uc480DotNet.dll

## 3. Useful References
- Official document of the Newport Delay Line Stage: https://www.newport.com/mam/celum/celum_assets/resources/DL_Controller_-_Command_Interface_Manual.pdf?1
- My repository 1 (moving the delay stage with GUI): https://github.com/ksonod/newport_delay_stage_gui_matlab 
- My repository 2 (getting images): https://github.com/ksonod/delayscan_images
- My repository 3 (similar to the current repository, but no gui): https://github.com/ksonod/delayscan_images
- My repository 4 (basic usage of Matlab commands for controlling the delay stage): https://github.com/ksonod/newport_delay_stage_basic_matlab
- My repository 5 (simpler version): https://github.com/ksonod/image_delay_gui
- Someone's code: https://git.yuyichao.com/nigrp/experiment-control/-/blob/daacb05256bed39ab557e5a38a9dd36cd9887830/matlab_new/thorcam/live_tof.m
- Matlab Answers: https://ch.mathworks.com/matlabcentral/answers/326549-how-to-create-a-stop-button-in-matlab
