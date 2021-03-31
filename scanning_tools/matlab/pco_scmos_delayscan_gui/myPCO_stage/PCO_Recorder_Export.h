//-----------------------------------------------------------------//
// Name        | PCO_Recorder_Export.h       | Type: ( ) source    //
//-------------------------------------------|       (*) header    //
// Project     | PCO                         |       ( ) others    //
//-----------------------------------------------------------------//
// Platform    | PC                                                //
//-----------------------------------------------------------------//
// Environment | Visual 'C++'                                      //
//-----------------------------------------------------------------//
// Purpose     | PCO - Recorder DLL Functions                      //
//-----------------------------------------------------------------//
// Author      | DKI, PCO AG                                       //
//-----------------------------------------------------------------//
// Revision    | rev. 2.02                                         //
//-----------------------------------------------------------------//
// (c) 2019 PCO AG * Donaupark 11 *                                //
// D-93309      Kelheim / Germany * Phone: +49 (0)9441 / 2005-0 *  //
// Fax: +49 (0)9441 / 2005-20 * Email: info@pco.de                 //
//-----------------------------------------------------------------//

#ifdef __cplusplus
extern "C" {                           //  Assume C declarations for C++
#endif  //C++

/**
@brief Retrieve the version information from the recorder dll

@param iMajor Pointer to get the major version (can be set to NULL if not relevant)
@param iMinor Pointer to get the minor version (can be set to NULL if not relevant)
@param iPatch Pointer to get the patch version (can be set to NULL if not relevant)
@param iBuild Pointer to get the build number (can be set to NULL if not relevant)
*/
void WINAPI PCO_RecorderGetVersion(int* iMajor, int* iMinor, int* iPatch, int* iBuild);

/**
@brief Resets the recorder instance if one is active
       Stops all recorders if they are running (if user commits)

@param bSilent Flag to decide if the message box should be omitted when recorders are still running
@return Error code
*/
int WINAPI PCO_RecorderResetLib(bool bSilent);

/**
@brief Creates the recorder
       Measures the available memory (either RAM, Disk or active camera ram segment) and calculates the maximum available image count for every camera
       Creates a camRecorder object for every transferred camera handle

@param phRec Handle to the recorder that will be created (output, must be NULL on input)
@param phCamArr Array of handles to the cameras that should be used by the recorder
@param dwImgDistributionArr Distribution of images to the different cameras (can be set to NULL if every camera should get the same amount of images)
@param wArrLength Length of the transferred arrays and also length of the maxImgCountArray
@param wRecMode Recorder mode (possible Options are: record to file, record to memory , record to camera ram)
@param cDriveLetter Charakter that represents the letter of the required drive to save the images to, e.g 'C' for system drive (only for record to file, ignored otherwise)
@param dwMaxImgCountArr Array where the maximum available image count for each camera is saved in (must have arrayLength size)
@return Error code
*/

#ifndef MATLAB

int WINAPI PCO_RecorderCreate(HANDLE* phRec, HANDLE* phCamArr, const DWORD* dwImgDistributionArr, WORD wArrLength, WORD wRecMode, char cDriveLetter, DWORD* dwMaxImgCountArr);

#else

/*
Header changed for Matlab because Matlab cannot work correctly with 'HANDLE* phCamArr' declaration
For Matlab we introduce the structure PCO_cam_ptr_List, which can be filled with the Camera Handles
Then a pointer to this structure is used in the function call.
*/

typedef struct
{        
 void* cam_ptr1; 
 void* cam_ptr2; 
 void* cam_ptr3; 
 void* cam_ptr4; 
}PCO_cam_ptr_List;

int WINAPI PCO_RecorderCreate(HANDLE* phRec, PCO_cam_ptr_List* CamArr, const DWORD* dwImgDistributionArr, WORD wArrLength, WORD wRecMode, char cDriveLetter, DWORD* dwMaxImgCountArr);

#endif

/**
@brief Free all memory (if not already done) of the camRecorder objects and delete the objects
       Delete the recorder object
       Will be rejected with error, if at least one camRecorder is running

@param phRec Handle to previously created recorder
@return Error code
*/
int WINAPI PCO_RecorderDelete(HANDLE phRec);

/**
@brief For memory recorder : Allocate the required memory for each camRecorder object
       For file recorder : Create and initialize FileSaver for each camRecorder object
       For camram recorder : Activate the desired ram segment for each camRecorder object (if required)

@param phRec Handle to previously created recorder
@param dwImgCountArr Array of required images for every camera
@param wArrLength Length of the imgCountArr (must match with the number of cameras)
@param wType Type of the selected recorder mode (functionality depends on recorder modes)
@param wNoOverwrite Flag to decide whether existing files should be kept and renamed (files will be deleted if NOT SET) (only for record to file, ignored otherwise)
@param szFilePath Path (including filename) where the image files have to be saved (only for record to file, ignorde otherwise)
@param wRamSegmentArr Array containing the camera ram segments (must match with the number of cameras = wArrLength) to be used for acquisition and readout, can be set to NULL if no ram segment change is required (only for record mode camram, ignorde otherwise)
@return Error code
*/
int WINAPI PCO_RecorderInit(HANDLE phRec, DWORD* dwImgCountArr, WORD wArrLength, WORD wType, WORD wNoOverwrite, const char* szFilePath, WORD* wRamSegmentArr);

/**
@brief For memory recorder : Overwrite all data in the allocated buffers for the camera and reset processed image count
       For file recorder : Delete the created files for the camera and reset processed image count
       For camram recorder : Overwrite the internal buffers and reset processed image count
       Will be rejected with error, if the camRecorder is running

@param phRec Handle to previously created recorder
@param phCam Handle to particular camera (or NULL for all cameras)
@return Error code
*/
int WINAPI PCO_RecorderCleanup(HANDLE phRec, HANDLE phCam);

/**
@brief Get the current recorder and camera settings

@param phRec Handle to previously created recorder
@param phCam Handle to particular camera
@param dwRecMode Selected mode of the recorder (High Word is Mode : Memory / File / CamRam; Low Word is type), can be set to NULL if not relevant
@param dwMaxImgCount Number of maximal recordable images (for the selected camera), can be set to NULL if not relevant
@param dwReqImgCount Number of images that have to be recorded (for the selected camera), can be set to NULL if not relevant
@param wWidth Image width of the selected camera, can be set to NULL if not relevant
@param wHeight Image height of the selected camera, can be set to NULL if not relevant
@param wMetadataLines Pointer to hold the number of metadate lines added after image data (0 for Metadata Mode OFF), can be set to NULL if not relevant
@return Error code
*/
int WINAPI PCO_RecorderGetSettings(HANDLE phRec, HANDLE phCam, DWORD* dwRecMode, DWORD* dwMaxImgCount, DWORD* dwReqImgCount, WORD* wWidth, WORD* wHeight, WORD* wMetadataLines);

/**
@brief Start the record of images for the selected camera (= Start acquire loop in acquire thread)

@param phRec Handle to previously created recorder
@param phCam Handle to particular camera (or NULL for all cameras)
@return Error code
*/
int WINAPI PCO_RecorderStartRecord(HANDLE phRec, HANDLE phCam);

/**
@brief Stop the record of images for the selected camera (= Stop acquire loop in acquire thread)

@param phRec Handle to previously created recorder
@param phCam Handle to particular camera (or NULL for all cameras)
@return Error code
*/
int WINAPI PCO_RecorderStopRecord(HANDLE phRec, HANDLE phCam);

/**
@brief Activate or deactivate the auto exposure functionality for the selected camera (or all if Handle is NULL)
       Set the transferred smoothness for auto exposure adaption

@param phRec Handle to previously created recorder
@param phCam Handle to particular camera (or NULL for all cameras)
@param bAutoExpState Indicator if auto exposure should be set
@param wSmoothness Value defining how smooth the transition between exposure times should be (Valid 1 - 10)
@param dwMinExposure Min exposure time that can be used for auto exposure (in expBase units)
@param dwMaxExposure Max exposure time that can be used for auto exposure (in expBase units)
@param wExpBase Exposure unit of the transferred exposure time range (0:ns, 1:us, 2:ms)
@return Error code
*/
int WINAPI PCO_RecorderSetAutoExposure(HANDLE phRec, HANDLE phCam, bool bAutoExpState, WORD wSmoothness, DWORD dwMinExposure, DWORD dwMaxExposure, WORD wExpBase);

/**
@brief Set regions where the pixel values are analyzed to compute a current mean value for auto exposure for the selected camera (or all if Handle is NULL)
       It is possible to set three different regionTypes (0=balanced, 1=center based, 2=corner based, 4=full (equally distributed over whole image))
       Or it can be set custom region (regionType = 8),
       here up to 7 regions with FIXED size of 500x500 can be specified using the top left point for each region

@param phRec Handle to previously created recorder
@param phCam Handle to particular camera (or NULL for all cameras)
@param wRegionType Type of the region to be set (0=balanced, 1=center based, 2=corner based, 4=full, 8=custom,)
@param wRoiX0Arr Array of x0 values (starting with 1) defining the left position of the desired regions (only for custom region, set to NULL otherwise)
@param wRoiY0Arr Array of y0 values (starting with 1) defining the upper position of the desired regions (only for custom region, set to NULL otherwise)
@param wArrLength Length of the roi arrays (maximum 7) (only for custom region, set to 0 otherwise)
@return Error code
*/
int WINAPI PCO_RecorderSetAutoExpRegions(HANDLE phRec, HANDLE phCam, WORD wRegionType, WORD* wRoiX0Arr, WORD* wRoiY0Arr, WORD wArrLength);

/**
@brief Get the current recorder and acquisition status for the selected camera

@param phRec Handle to previously created recorder
@param phCam Handle to particular camera
@param bIsRunning Flag to indicate if image acquisition is running, can be set to NULL if not relevant
@param bAutoExpState Flag to indicate if the auto exposure for the camera is currently activated, can be set to NULL if not relevant
@param dwLastError Errorcode of the last error that occured during image acquisition (0 for no error), can be set to NULL if not relevant
@param dwProcImgCount Currently recorded number of images, can be set to NULL if not relevant (for camram this is only updated after record has finished)
@param dwReqImgCount Required number of images, can be set to NULL if not relevant (will be ignored in camram mode)
@param bBuffersFull Flag to indicate if the allocated buffers are all filled (only relevant for ring buffer, recorder started overwriting), can be set to NULL if not relevant
@param bFIFOOverflow Flag to indicate if the write index has lapped the read index and images will lost (only relevant for fifo mode in memory),can be set to NULL if not relevant
@param dwStartTime Time in ms when the image acquisition has started, can be set to NULL if not relevant
@param dwStopTime Time in ms when the image acquisition stopped, can be set to NULL if not relevant
@return Error code
*/
int WINAPI PCO_RecorderGetStatus(HANDLE phRec, HANDLE phCam, bool* bIsRunning, bool* bAutoExpState, DWORD* dwLastError, DWORD* dwProcImgCount, DWORD* dwReqImgCount, bool* bBuffersFull,
                                 bool* bFIFOOverflow, DWORD* dwStartTime, DWORD* dwStopTime);

/**
@brief Get the address of the selected image for the selected camera
       Not available in cam ram mode

@param phRec Handle to previously created recorder
@param phCam Handle to particular camera
@param dwImgIdx Index of the image that should be read
@param wImgBuf Pointer to the selected image data
@param wWidth Image width of the selected camera / image
@param wHeight Image height of the selected camer / image
@param dwImgNumber Actual image number of the recorded image (from latest start call), can be set to NULL if not relevant
@return Error code
*/
int WINAPI PCO_RecorderGetImageAddress(HANDLE phRec, HANDLE phCam, DWORD dwImgIdx, WORD** wImgBuf, WORD* wWidth, WORD* wHeight, DWORD* dwImgNumber);

/**
@brief Copy the selected image in the defined ROI for the selected camera to the previously allocated buffer

@param phRec Handle to previously created recorder
@param phCam Handle to particular camera
@param dwImgIdx Index of the image that should be read
@param wRoiX0 Left horizontal ROI (starting with 1)
@param wRoiY0 Upper vertical ROI (starting with 1)
@param wRoiX1 Right horizontal ROI (up to image width)
@param wRoiY1 Lower vertical ROI (up to image height)
@param wImgBuf Array to copy the image data to
@param dwImgNumber Actual image number of the recorded image (from latest start call) (can be set to NULL if not relevant)
@param strMetadata Pointer to retrieve the metadata if available (can be set to NULL if not required)
@param strTimestamp Pointer to retrieve the timestamp information if available (can be set to NULL if not required)
@return Error code
*/
int WINAPI PCO_RecorderCopyImage(HANDLE phRec, HANDLE phCam, DWORD dwImgIdx, WORD wRoiX0, WORD wRoiY0, WORD wRoiX1, WORD wRoiY1, WORD* wImgBuf, DWORD* dwImgNumber, 
                                 PCO_METADATA_STRUCT* strMetadata, PCO_TIMESTAMP_STRUCT* strTimestamp);

#ifdef __cplusplus
}       //  Assume C declarations for C++
#endif  //C++
