# image_delay_gui
January, 2020

## 1. Description
This repository provides a GUI tool for controlling the [Newport delay line stage](https://www.newport.com/f/delay-line-stages) and getting images from [Thorlabs camera](https://www.thorlabs.com/newgrouppage9.cfm?objectgroup_id=4024). This GUI works under the following condisionts:
- Windows 10
- Matlab R2018b
- [DL Series Optical Delay Line Linear Motor Linear Translation Stages](https://www.newport.com/f/delay-line-stages)
- [Thorlabs Compact USB 2.0 CMOS Cameras](https://www.thorlabs.com/newgrouppage9.cfm?objectgroup_id=4024)

## 2. Control Window
<img src="https://github.com/ksonod/image_delay_gui/blob/master/gui_matlab.PNG" width="500px">  
  
If you run the gui_stage_camera.m, a new window displayed above will show up. The window consists of 2 main sections:
- Image Acquisition
- Delay Stage Control
The Delay Stage Control section contains 3 subsections:
- Current Settings
- Change Settings
- Delay Scan

### 2.1 Image Acquisition
In this section, an image obtained by a camera is displayed. If you click the Get-an-Image button, the current image will be shown on the window. If you click the Scan-and-Get-Images button, you can see images obtained at different stage positions and save all images in a created folder "scanned images." 

### 2.2 Delay Stage Control
With the options in this section, you can control the delay stage. 
#### (1) Current Settings
After clicking the show button, the current position, velocity, and acceleration are shown. 

#### (2) Change Settings
You can change the position, velocity, and acceleration.

#### (3) Delay Scan 
You can move the stage automatically. Once you specify the initial and final positions and the number of steps, you can click the Calculate-Time-Settings button and get the time step and time range of the scan. The Start-Scanning button initiates the movement of the delay stage. The Scan-and-Get-Images button initiates the image acquisition while the delay stage is moving.

<img src="https://github.com/ksonod/newport_delay_stage_gui_matlab/blob/master/dls_matlab2.PNG" width="400px">

## 3. Useful References
- Official document of the Newport Delay Line Stage: https://www.newport.com/mam/celum/celum_assets/resources/DL_Controller_-_Command_Interface_Manual.pdf?1
- My repository 1 (moving the delay stage with GUI): https://github.com/ksonod/newport_delay_stage_gui_matlab 
- My repository 2 (getting images): https://github.com/ksonod/delayscan_images
- My repository 3 (same as the current repository, but no gui): https://github.com/ksonod/delayscan_images
- My repository 4 (basic usage of Matlab commands for controlling the delay stage): https://github.com/ksonod/newport_delay_stage_basic_matlab
