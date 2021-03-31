# controlling_devices
The automation of device control and data aquisition is strongly desired to efficiently conduct scientific and industrial research. Here, I have built some GUI tools, codes, and softwares for achieving the automated research. They allow you to control optical devices, such as a motorized linear stage, optical shutter, and optomechanics equiped with fine motors, and to get images from different types of cameras. 

# [PCO_delay_scan](https://github.com/ksonod/controlling_devices/tree/master/scanning_tools/matlab/pco_scmos_delayscan_gui)
<img src="https://github.com/ksonod/controlling_devices/blob/master/scanning_tools/matlab/pco_scmos_delayscan_gui/gui1.PNG" width="500px">    

- Description: This repository provides a GUI tool for getting images from [PCO sCMOS camera](https://www.pco.de/) and controlling the [Newport delay line stage](https://www.newport.com/f/delay-line-stages), [optical shutters](https://www.thorlabs.com/newgrouppage9.cfm?objectgroup_id=927), and [picomotors](https://www.newport.com/f/picomotor-piezo-linear-actuators). You can get images as a function of the delay stage position and investigate the effect of the additional light by opening and closing the shutter. Moreover, you can precisely adjust optomechanics equiped with picomotors.
- Programming Language: Matlab
- Application: Focussing profile of laser beam, interferometry, time-resolved measurement

# [thorcam_NewportStage_GUI](https://github.com/ksonod/controlling_devices/tree/master/scanning_tools/matlab/thorlabs_camera_and_newport_stage_gui)  
<img src="https://github.com/ksonod/controlling_devices/blob/master/scanning_tools/matlab/thorlabs_camera_and_newport_stage_gui/gui0.PNG" width="1000px">    
  
- Description: This repository provides a GUI tool for controlling the [Newport delay line stage](https://www.newport.com/f/delay-line-stages), getting images from [Thorlabs CMOS camera](https://www.thorlabs.com/newgrouppage9.cfm?objectgroup_id=4024), and opening/closing a [Thorlabs optical shutter](https://www.thorlabs.com/newgrouppage9.cfm?objectgroup_id=927). You can get images as a function of the delay stage coordinate. Live view is available.
- Programming Language: Matlab
- Application: Focussing profile of laser beam, interferometry, time-resolved measurement

# Simple Tools for Advanced Development
## [picomotor_controller](https://github.com/ksonod/controlling_devices/tree/master/basic_tools/matlab/picomotor_gui)
<img src="https://github.com/ksonod/controlling_devices/blob/master/basic_tools/matlab/picomotor_gui/pico_gui.PNG" width="300px">      

- Description: This is a GUI tool for controlling the [Newport Picomotor](https://www.newport.com/f/picomotor-piezo-linear-actuators). This tool allows us to do fine tuning of optomechanics.  
- Programming Language: Matlab

## [sc10_optical_shutter_gui](https://github.com/ksonod/controlling_devices/tree/master/basic_tools/matlab/thorlabs_sc10_optical_shutter/thorlabs_sc10_shutter_gui)
<img src="https://github.com/ksonod/controlling_devices/blob/master/basic_tools/matlab/thorlabs_sc10_optical_shutter/thorlabs_sc10_shutter_gui/sc10_gui.PNG" width="350px">    
  
- Description: This is a GUI tool for controlling the [Thorlabs optical shutter](https://www.thorlabs.com/newgrouppage9.cfm?objectgroup_id=927).  
- Programming Language: Matlab

## [newport_delay_stage_gui](https://github.com/ksonod/controlling_devices/tree/master/basic_tools/python/newport_delay_stage_gui)
<img src="https://github.com/ksonod/controlling_devices/blob/master/basic_tools/python/newport_delay_stage_gui/dls_gui.PNG" width="300px">      

- Description: This is a simple GUI tool for controlling the [Newport delay line stage](https://www.newport.com/f/delay-line-stages). This tool allows us to move the delay stage in a set range with a specified speed.  
- Programming Language: python

## Other Tools
### Matlab
https://github.com/ksonod/controlling_devices/tree/master/basic_tools/matlab
- USB webcam control
- Newport delay stage control
- PCO sCMOS camera control
- Picomotor control
- Thorlabs camera control
- Thorlabs optical shutter control

### Python
https://github.com/ksonod/controlling_devices/tree/master/basic_tools/python
- Newport delay stage control
