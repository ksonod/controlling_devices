//-----------------------------------------------------------------//
// Name        | SC2_CamMatlab.h             | Type: ( ) source    //
//-------------------------------------------|       (*) header    //
// Project     | PCO                         |       ( ) others    //
//-----------------------------------------------------------------//
// Platform    | PC                                                //
//-----------------------------------------------------------------//
// Environment | Matlab                                            //
//-----------------------------------------------------------------//
// Purpose     | PCO - Matlab                                      //
//-----------------------------------------------------------------//
// Author      | MBL, PCO AG                                       //
//-----------------------------------------------------------------//
// Revision    |  rev. 1.10 rel. 1.10                              //
//-----------------------------------------------------------------//
// Notes       | Does include all necessary header files           //
//             |                                                   //
//             |                                                   //
//-----------------------------------------------------------------//
// (c) 2011 PCO AG * Donaupark 11 *                                //
// D-93309      Kelheim / Germany * Phone: +49 (0)9441 / 2005-0 *  //
// Fax: +49 (0)9441 / 2005-20 * Email: info@pco.de                 //
//-----------------------------------------------------------------//

#pragma pack(push)            
#pragma pack(1)            

#define MATLAB

#include "pco_matlab.h"

#define PCO_SENSOR_CREATE_OBJECT

#include "SC2_SDKAddendum.h"
#include "SC2_ML_SDKStructures.h"
#include "SC2_defs.h"
#undef PCO_SENSOR_CREATE_OBJECT

#include "SC2_CamExport.h"

#include "SC2_common.h"
#include "PCO_Recorder_Export.h"

#pragma pack(pop)            



