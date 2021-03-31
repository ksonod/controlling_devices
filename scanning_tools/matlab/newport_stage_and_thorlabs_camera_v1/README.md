# delayscan_images
Jan. 2020
## Introduction
This Matlab code allows you to get images as a function of the coordinate of the Newport delay line stage. This program is tested under the following conditions:
- Windows 10
- Matlab R2018b
- [Newport Delay Line Stage](https://www.newport.com/f/delay-line-stages)
- [Thorlabs Compact USB 2.0 CMOS Cameras](https://www.thorlabs.com/newgrouppage9.cfm?objectgroup_id=4024)

## Description
### Adjustable parameters
Adjustable parameters can be found at the top of the code.
- n_step: number of steps
- x_init: initial position
- x_fin: final position
- acc_val: acceptance value
- show_im: choose whether you want to show an image during the scan
- comport: COM port of the delay line stage

### Scan
While scanning, you can see the progress of the scan in the command window. If you set show_im = 1, an image at the current position will be displayed.  
<img src="https://github.com/ksonod/delayscan_images/blob/master/pic1.PNG" width="900px">  

### Images
The obtained images are stored in the scan_images folder which is created in the current folder.

### Sample images
In this repository, sample images are stored in the scan_images folder.

## References
- Simple Matlab codes for controlling the delay stage: https://github.com/ksonod/newport_delay_stage_basic_matlab
- Simple Matlab codes for getting an image from a camera: https://github.com/ksonod/thorlabs_camera_simple_matlab
