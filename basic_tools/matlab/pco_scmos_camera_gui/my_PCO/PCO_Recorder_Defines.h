#ifndef PCO_RECORDER_DEFINES_H
#define PCO_RECORDER_DEFINES_H

//Recorder Mode
#define PCO_RECORDER_MODE_FILE                  0x0001
#define PCO_RECORDER_MODE_MEMORY                0x0002
#define PCO_RECORDER_MODE_CAMRAM                0x0003

//Memory Type
#define PCO_RECORDER_MEMORY_SEQUENCE            0x0001
#define PCO_RECORDER_MEMORY_RINGBUF             0x0002
#define PCO_RECORDER_MEMORY_FIFO                0x0003

//File Type
#define PCO_RECORDER_FILE_TIF                   0x0001
#define PCO_RECORDER_FILE_MULTITIF              0x0002
#define PCO_RECORDER_FILE_PCORAW                0x0003
#define PCO_RECORDER_FILE_B16                   0x0004

//CamRam Type
#define PCO_RECORDER_CAMRAM_SEQUENTIAL          0x0001
#define PCO_RECORDER_CAMRAM_SINGLE_IMAGE        0x0002

//Image Readout
#define PCO_RECORDER_LATEST_IMAGE               0xFFFFFFFF

//Auto Exposure Regions
#define REGION_TYPE_BALANCED                    0x0000
#define REGION_TYPE_CENTER_BASED                0x0001
#define REGION_TYPE_CORNER_BASED                0x0002
#define REGION_TYPE_FULL                        0x0003
#define REGION_TYPE_CUSTOM                      0x0004

#endif // PCO_RECORDER_DEFINES_H
