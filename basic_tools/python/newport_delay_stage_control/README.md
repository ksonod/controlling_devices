# newport_delay_stage_basic_python

## Description
This repository contains simple python codes for controlling [Newport delay line stage](https://www.newport.com/f/delay-line-stages). You can start from here and modify them. In order to control the stage, .NET is used. These codes work under the following condisionts:
- Windows 10
- Python3 (Anaconda)
- [DL Series Optical Delay Line Linear Motor Linear Translation Stages](https://www.newport.com/f/delay-line-stages)



## DLS_1_get_version
You can get the version of your delay line stage.  
<img src="https://github.com/ksonod/newport_delay_stage_basic_python/blob/master/dls1.PNG" width="750px">

## DLS_2_get_current_position
You can get the current position of your delay line stage.  
<img src="https://github.com/ksonod/newport_delay_stage_basic_python/blob/master/dls2.PNG" width="750px">

## DLS_3_move_stage
You can move your delay line stage.  
<img src="https://github.com/ksonod/newport_delay_stage_basic_python/blob/master/dls3.PNG" width="750px">

## Avoiding Expected Errors at the Beginning
- Please check whether you have [pythonnet](https://pypi.org/project/pythonnet/).
- Please check whether you are importing correct clr library.
- Please check the COM port.

## Useful References
- Official document: https://www.newport.com/mam/celum/celum_assets/resources/DL_Controller_-_Command_Interface_Manual.pdf?1
- Dummy arguments: https://stackoverflow.com/questions/54692267/python-net-call-c-sharp-method-which-has-a-return-value-and-an-out-parameter
