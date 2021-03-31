# PCO_delay_scan
GUI for controlling optical devices and getting images from PCO edge sCMOS camera (Matlab)

## 1. Description
This repository provides a GUI tool for controlling the [Newport delay line stage](https://www.newport.com/f/delay-line-stages), [optical shutters](https://www.thorlabs.com/newgrouppage9.cfm?objectgroup_id=927), and [picomotors](https://www.newport.com/f/picomotor-piezo-linear-actuators) and getting images from [PCO edge camera](https://www.pco.de/). This GUI works under the following condisionts:
- Windows 10
- Matlab R2018b

## 2. Control Window
<img src="https://github.com/ksonod/PCO_delay_scan/blob/master/gui1.PNG" width="700px">  
  
If you run the myPCO_stage.m, a new window displayed above will show up. The window consists of 4 main sections:
- Image: Settings for a [sCMOS](https://en.wikipedia.org/wiki/SCMOS) camera and window for visualizing an image
- Delay Stage Scan: Settings for the delay line stage.
- Shutter: Open and close the shutter
- Picomotor: Motion control with motors connected to optical mirror mount 

### 2.1 Image
In this section, an image obtained by a camera is displayed. There are 3 adjustable parameters:
- Exposure time: This is exposure time in ms.
- Average number: The average number, n_ave, allows us to get an image averaged over n_ave images. 
- Number of Images: This is the number of images that you want to get. This should be specified before clicking Save-Multiple-Images button.
There are 3 buttons here:
- Get an Imgage: If you click it, the current image will be shown on the window.
- Save an Image: If you click it, you can save the image in the current folder. 
- Save Multiple Images: You can save multiple images in a new folder. The number of images can be specified. 

### 2.2 Delay Stage Control 
#### (1) Current Settings
After clicking the show button, the current position, velocity, and acceleration are shown. 

#### (2) Change Settings
You can change the position, velocity, and acceleration.

#### (3) Move the Stage 
You can move the stage. Once you specify the initial and final positions and the number of steps, you can click the Calculate-Time-Settings button and get the time step and time range of the scan. The Start button initiates the movement of the delay stage. 

#### (4) Move the Stage and Get Images 
You can move the stage. At each position, you can get an image from the camera. The exposure time and average number should be specified in the Image section. The Start button initiates the movement of the delay stage and the image data acquisition. All of the images acquired during the scan are saved in a new folder.

#### (5) Move the Stage, Activate the Shutter, and Get Images 
You can move the stage. At each position, you can get 2 images from the camera. One is recorded when the shutter is closed, the other is obtained when it is opened. The difference of the 2 images is calculated by Image(shutter opened) - Image(shutter closed) and saved in a new folder. The exposure time and average number should be specified in the Image section. The Start button initiates the movement of the delay stage and the image data acquisition. 

### 2.3 Shutter
The button "Open/Close" triggers the motion of the optical shutter.

### 2.4 Picomotor
You can move 2 picomotors (axis 1 and axis 2). The number of the cursor corresponds to the amount of movement. The movement of the picomotor allows us to do the fine tuning of optomechanics.

## 3. My main contribution
Image data acquisition from the sCMOS camera is achieved by utilizing an official package provided by a company ([link](https://www.pco.de/software/third-party-software/)). The Matlab codes whose name start with "my" are modified version of the provided codes. The modifications that I made can be roughly summarized as follows.
- <strong>Saving Images</strong>: I adjusted the timing of closing the camera in order to acquire multiple images after taking average. Images can be saved in a new folder.
- <strong>Integration</strong>: I integrated the provided code with the motion control of the delay line stage and optical shutter.
- <strong>Image Processing</strong>: It is now possible to take average of images. Moreover, the difference of images obtained with a closed and opened shutter can be obtained during the process of the image data aquisition. 
I did not use all tools in the package. However, I did not delete the ones that were not used because of future possible extension.

## 4. Useful References
- Official document of the Newport Delay Line Stage: https://www.newport.com/mam/celum/celum_assets/resources/DL_Controller_-_Command_Interface_Manual.pdf?1
- PCO manual: https://www.pco.de/software/third-party-software/matlab/
- My repository 1 (moving the delay stage with GUI): https://github.com/ksonod/newport_delay_stage_gui_matlab 
- My repository 2 (getting images from PCO sCMOS camera): https://github.com/ksonod/pco_simple_gui
- My repository 3 (controlling picomotor): https://github.com/ksonod/picomotor_controller
