# controlling_devices
The automation of device control and data aquisition is strongly desired to efficiently conduct scientific and industrial research. Here, I have built some GUI tools, codes, and softwares for achieving the automated research. They allow you to control optical devices, such as a motorized linear stage, optical shutter, and optomechanics equiped with fine motors, and to get images from different types of cameras. 

# [PCO_delay_scan](https://github.com/ksonod/PCO_delay_scan)
<img src="https://github.com/ksonod/PCO_delay_scan/blob/master/gui1.PNG" width="500px">    

- Description: This repository provides a GUI tool for getting images from [PCO sCMOS camera](https://www.pco.de/) and controlling the [Newport delay line stage](https://www.newport.com/f/delay-line-stages), [optical shutters](https://www.thorlabs.com/newgrouppage9.cfm?objectgroup_id=927), and [picomotors](https://www.newport.com/f/picomotor-piezo-linear-actuators). You can get images as a function of the delay stage position and investigate the effect of the additional light by opening and closing the shutter. Moreover, you can precisely adjust optomechanics equiped with picomotors.
- Programming Language: Matlab
- Application: Focussing profile of laser beam, interferometry, time-resolved measurement

# [thorcam_NewportStage_GUI](https://github.com/ksonod/thorcam_NewportStage_GUI)  
<img src="https://github.com/ksonod/thorcam_NewportStage_GUI/blob/master/gui0.PNG" width="1000px">    
  
- Description: This repository provides a GUI tool for controlling the [Newport delay line stage](https://www.newport.com/f/delay-line-stages), getting images from [Thorlabs CMOS camera](https://www.thorlabs.com/newgrouppage9.cfm?objectgroup_id=4024), and opening/closing a [Thorlabs optical shutter](https://www.thorlabs.com/newgrouppage9.cfm?objectgroup_id=927). You can get images as a function of the delay stage coordinate. Live view is available.
- Programming Language: Matlab
- Application: Focussing profile of laser beam, interferometry, time-resolved measurement

# [newport_delay_stage_gui](https://github.com/ksonod/newport_delay_stage_gui)
<img src="https://github.com/ksonod/newport_delay_stage_gui/blob/master/dls_gui.PNG" width="500px">     

- Description: This repository provides a GUI tool for controlling the [Newport delay line stage](https://www.newport.com/f/delay-line-stages).  
- Programming Language: Python (Matlab version is [here](https://github.com/ksonod/newport_delay_stage_gui_matlab))

# [picomotor_controller](https://github.com/ksonod/picomotor_controller)
<img src="https://github.com/ksonod/picomotor_controller/blob/master/pico_gui.PNG" width="300px">      

- Description: This is a GUI tool for controlling the [Newport Picomotor](https://www.newport.com/f/picomotor-piezo-linear-actuators). This tool allows us to do fine tuning of optomechanics.  
- Programming Language: Matlab

# [sc10_optical_shutter_gui](https://github.com/ksonod/sc10_optical_shutter_gui)
<img src="https://github.com/ksonod/sc10_optical_shutter_gui/blob/master/sc10_gui.PNG" width="350px">    
  
- Description: This is a GUI tool for controlling the [Thorlabs optical shutter](https://www.thorlabs.com/newgrouppage9.cfm?objectgroup_id=927).  
- Programming Language: Matlab

# Other GUI, codes, and softwares
The following list includes other GUI, codes, and softwares for controlling devices and getting images from a camera. Some of them are very simple, so you can easilly modify them.

## Matlab
- [newport_delay_stage_gui_matlab](https://github.com/ksonod/newport_delay_stage_gui_matlab): Matlab version of [newport_delay_stage_gui](https://github.com/ksonod/newport_delay_stage_gui).
- [image_delay_gui](https://github.com/ksonod/image_delay_gui): This GUI tool is a simpler version of [thorcam_NewportStage_GUI](https://github.com/ksonod/thorcam_NewportStage_GUI). A different version with no GUI is also [available](https://github.com/ksonod/delayscan_images).
- [newport_delay_stage_basic_matlab](https://github.com/ksonod/newport_delay_stage_basic_matlab): This repository contains very simple Matlab codes for controlling the newport delay stage.
- [thorlabs_camera_simple_matlab](https://github.com/ksonod/thorlabs_camera_simple_matlab): This repository shows a simple way of how to get images from a [Thorlabs camera](https://www.thorlabs.com/newgrouppage9.cfm?objectgroup_id=4024) using Matlab.
- [pco_simple_gui](https://github.com/ksonod/pco_simple_gui): This simple GUI tool shows how to get images from a [PCO.edge camera](https://www.pco.de/)
- [sc10_optical_shutter_simple_matlab](https://github.com/ksonod/sc10_optical_shutter_simple_matlab): This is a simple Matlab code for controlling the [optical shutters](https://www.thorlabs.com/newgrouppage9.cfm?objectgroup_id=927) using sc10 controller.
- [webcam_video_image](https://github.com/ksonod/webcam_video_image): This is a simple Matlab code for displaying a video recorded by a USB camera.

## Python
- [newport_delay_stage_basic_python](https://github.com/ksonod/newport_delay_stage_basic_python): This repository shows a simple way of how to move the [Newport delay line stage](https://www.newport.com/f/delay-line-stages).
