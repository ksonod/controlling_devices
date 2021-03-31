function [subfunc]=pco_camera_subfunction()
%creating function handles to functions and return handles in structure
%subfunc

 fh_start_camera=@start_camera;
 fh_stop_camera =@stop_camera;
 fh_reset_settings_to_default=@reset_settings_to_default;
 fh_set_exposure_times=@set_exposure_times;
 fh_set_pixelrate=@set_pixelrate;
 fh_set_triggermode=@set_triggermode;
 fh_get_triggermode=@get_triggermode;
 fh_set_transferparameter=@set_transferparameter;
 fh_set_bitalignment=@set_bitalignment;
 fh_get_bitalignment=@get_bitalignment;
 fh_show_frametime=@show_frametime; 
 fh_get_frametime=@get_frametime; 
 fh_enable_timestamp=@enable_timestamp;
 fh_set_metadata_mode=@set_metadata_mode;
 fh_print_timestamp=@print_timestamp;
 fh_print_timestamp_t=@print_timestamp_t;
 subfunc=struct('fh_start_camera',fh_start_camera,...
                'fh_stop_camera',fh_stop_camera,...
                'fh_reset_settings_to_default',fh_reset_settings_to_default,...
                'fh_set_exposure_times',fh_set_exposure_times,...
                'fh_set_pixelrate',fh_set_pixelrate,...
                'fh_set_triggermode',fh_set_triggermode,...
                'fh_get_triggermode',fh_get_triggermode,...
                'fh_set_transferparameter',fh_set_transferparameter,...
                'fh_set_bitalignment',fh_set_bitalignment,...
                'fh_get_bitalignment',fh_get_bitalignment,...
                'fh_show_frametime',fh_show_frametime,...
                'fh_get_frametime',fh_get_frametime,...
                'fh_enable_timestamp',fh_enable_timestamp,...
                'fh_set_metadata_mode',fh_set_metadata_mode,...
                'fh_print_timestamp',fh_print_timestamp,...
                'fh_print_timestamp_t',fh_print_timestamp_t);
end

function start_camera(out_ptr)

act_recstate = uint16(0); 
[errorCode,~,act_recstate] = calllib('PCO_CAM_SDK', 'PCO_GetRecordingState', out_ptr,act_recstate);
pco_errdisp('PCO_GetRecordingState',errorCode);   

if(act_recstate~=1)
 errorCode = calllib('PCO_CAM_SDK', 'PCO_SetRecordingState', out_ptr, 1);
 pco_errdisp('PCO_SetRecordingState',errorCode);   
end

end


function stop_camera(out_ptr)

act_recstate = uint16(0); 
[errorCode,~,act_recstate] = calllib('PCO_CAM_SDK', 'PCO_GetRecordingState', out_ptr,act_recstate);
pco_errdisp('PCO_GetRecordingState',errorCode);   

if(act_recstate~=0)
 errorCode = calllib('PCO_CAM_SDK', 'PCO_SetRecordingState', out_ptr, 0);
 pco_errdisp('PCO_SetRecordingState',errorCode);   
end

end


function reset_settings_to_default(out_ptr)

errorCode = calllib('PCO_CAM_SDK', 'PCO_ResetSettingsToDefault',out_ptr);
pco_errdisp('PCO_ResetSettingsToDefault',errorCode);   

end

function set_exposure_times(out_ptr,exptime,expbase,deltime,delbase)

del_time=uint32(0);
exp_time=uint32(0);
del_base=uint16(0);
exp_base=uint16(0);

[errorCode,~,del_time,exp_time,del_base,exp_base] = calllib('PCO_CAM_SDK', 'PCO_GetDelayExposureTime', out_ptr,del_time,exp_time,del_base,exp_base);
pco_errdisp('PCO_GetDelayExposureTime',errorCode);   

if(exist('exptime','var'))
 exp_time=uint32(exptime);
end

if(exist('expbase','var'))
 exp_base=uint32(expbase);
end

if(exist('deltime','var'))
 del_time=uint32(deltime);
end

if(exist('delbase','var'))
 del_base=uint32(delbase);
end

[errorCode] = calllib('PCO_CAM_SDK', 'PCO_SetDelayExposureTime', out_ptr,del_time,exp_time,del_base,exp_base);
pco_errdisp('PCO_SetDelayExposureTime',errorCode);   
end

function set_pixelrate(out_ptr,Rate)

cam_desc=libstruct('PCO_Description');
set(cam_desc,'wSize',cam_desc.structsize);

[errorCode,~,cam_desc] = calllib('PCO_CAM_SDK', 'PCO_GetCameraDescription', out_ptr,cam_desc);
pco_errdisp('PCO_GetCameraDescription',errorCode);   

if((Rate~=1)&&(Rate~=2))
 disp('Rate must be 1 or 2');
 return;
end 
 
%set PixelRate for Sensor
if(cam_desc.dwPixelRateDESC(Rate))
 errorCode = calllib('PCO_CAM_SDK', 'PCO_SetPixelRate', out_ptr,cam_desc.dwPixelRateDESC(Rate));
 pco_errdisp('PCO_SetPixelRate',errorCode);   
end

clear cam_desc;    

end

function set_triggermode(out_ptr,triggermode)

errorCode = calllib('PCO_CAM_SDK', 'PCO_SetTriggerMode', out_ptr,triggermode);
pco_errdisp('PCO_SetTriggerMode',errorCode);   

end


function triggermode = get_triggermode(out_ptr)

triggermode=uint16(0);
[errorCode,~,triggermode] = calllib('PCO_CAM_SDK', 'PCO_GetTriggerMode', out_ptr,triggermode);
pco_errdisp('PCO_SetTriggerMode',errorCode);   
disp(['actual triggermode is ',int2str(triggermode)]);

end


function set_transferparameter(out_ptr)

pco_camera_load_defines();


cam_type=libstruct('PCO_CameraType');
set(cam_type,'wSize',cam_type.structsize);
[errorCode,~,cam_type] = calllib('PCO_CAM_SDK', 'PCO_GetCameraType', out_ptr,cam_type);
pco_errdisp('PCO_GetCameraType',errorCode);   


if(uint16(cam_type.wInterfaceType)==INTERFACE_CAMERALINK)

 clpar=uint32(zeros(1,5));
%get size of variable clpar
%s=whos('clpar');
%len=s.bytes;
%clear s;
 len=5*4;

 [errorCode,~,clpar] = calllib('PCO_CAM_SDK', 'PCO_GetTransferParameter', out_ptr,clpar,len);
 pco_errdisp('PCO_GetTransferParameter',errorCode);   
% disp('Actual transfer parameter')
% disp(['baudrate:      ',num2str(clpar(1))]);
% disp(['ClockFrequency ',num2str(clpar(2))]);
% disp(['CCline         ',num2str(clpar(3))]);
% disp(['Dataformat     ',num2str(clpar(4),'%08X')]);
% disp(['Transmit       ',num2str(clpar(5),'%08X')]); 

 clpar(1)=115200;


 if(uint16(cam_type.wCamType)==CAMERATYPE_PCO_EDGE)

  pixelrate=uint32(0);
  [errorCode,~,pixelrate]  = calllib('PCO_CAM_SDK', 'PCO_GetPixelRate',out_ptr,pixelrate);
  pco_errdisp('PCO_GetPixelRate',errorCode);   


  act_xsize=uint16(0);
  act_ysize=uint16(0);
  max_xsize=uint16(0);
  max_ysize=uint16(0);
  [errorCode,out_ptr,act_xsize]  = calllib('PCO_CAM_SDK', 'PCO_GetSizes', out_ptr,act_xsize,act_ysize,max_xsize,max_ysize);
  pco_errdisp('PCO_GetSizes',errorCode);   


  lut=uint16(0);
  par=uint16(0);
  if((pixelrate<100000000)||(act_xsize<=1920))
%normal use PCO_CL_DATAFORMAT_5x16    
   a=bitand(clpar(4),hex2dec('FF00'));   
   clpar(4)=a+5;   
  else
%fast and high resolution use PCO_CL_DATAFORMAT_5x12L 
   a=bitand(clpar(4),hex2dec('FF00'));   
   clpar(4)=a+9;   
   lut=hex2dec('1612');
  end 
  [errorCode] = calllib('PCO_CAM_SDK', 'PCO_SetActiveLookupTable', out_ptr,lut,par);
  pco_errdisp('SetActiveLookupTable',errorCode);

 else
  cam_desc=libstruct('PCO_Description');
  set(cam_desc,'wSize',cam_desc.structsize);
 
  [errorCode,~,cam_desc] = calllib('PCO_CAM_SDK', 'PCO_GetCameraDescription', out_ptr,cam_desc);
  pco_errdisp('PCO_GetCameraDescription',errorCode);   

  if((cam_desc.wDynResDESC<=12)&&(bitand(cam_desc.dwGeneralCapsDESC1,GENERALCAPS1_DATAFORMAT2X12)))
   clpar(4)=CL_FORMAT_2x12;
  end
 end    

 [errorCode] = calllib('PCO_CAM_SDK', 'PCO_SetTransferParameter', out_ptr,clpar,len);
 pco_errdisp('PCO_SetTransferParameter',errorCode);   

 [errorCode] = calllib('PCO_CAM_SDK', 'PCO_ArmCamera', out_ptr);
 pco_errdisp('PCO_ArmCamera',errorCode);   

% [errorCode,~,clpar] = calllib('PCO_CAM_SDK', 'PCO_GetTransferParameter', out_ptr,clpar,len);
% pco_errdisp('PCO_GetTransferParameter',errorCode);   
%  disp('Actual transfer parameter now')
%  disp(['baudrate:      ',num2str(clpar(1))]);
%  disp(['ClockFrequency ',num2str(clpar(2))]);
%  disp(['CCline         ',num2str(clpar(3))]);
%  disp(['Dataformat     ',num2str(clpar(4),'%08X')]);
%  disp(['Transmit       ',num2str(clpar(5),'%08X')]); 
%  disp(['pixelrate      ',num2str(pixelrate)]);
 end 
end

function set_bitalignment(out_ptr,bitalign)

errorCode = calllib('PCO_CAM_SDK', 'PCO_SetBitAlignment', out_ptr,bitalign);
pco_errdisp('PCO_SetBitAlignment',errorCode);   

end

function bitalign=get_bitalignment(out_ptr)

bitalign=uint16(0);
[errorCode,~,bitalign]= calllib('PCO_CAM_SDK', 'PCO_GetBitAlignment', out_ptr,bitalign);
pco_errdisp('PCO_GetBitAlignment',errorCode);   

end



function waittime_s=show_frametime(out_ptr)

%get time in ms, which is used for one image
dwSec=uint32(0);
dwNanoSec=uint32(0);
[errorCode,~,dwSec,dwNanoSec] = calllib('PCO_CAM_SDK', 'PCO_GetCOCRuntime', out_ptr,dwSec,dwNanoSec);
pco_errdisp('PCO_GetCOCRuntime',errorCode);   

waittime_s = double(dwNanoSec);
waittime_s = waittime_s / 1000000000;
waittime_s = waittime_s + double(dwSec);

fprintf(1,'one frame needs %6.6fs, maximal frequency %6.3fHz',waittime_s,1/waittime_s);
disp(' ');

end

function waittime_s=get_frametime(out_ptr)

%get time in ms, which is used for one image
dwSec=uint32(0);
dwNanoSec=uint32(0);
[errorCode,~,dwSec,dwNanoSec] = calllib('PCO_CAM_SDK', 'PCO_GetCOCRuntime', out_ptr,dwSec,dwNanoSec);
pco_errdisp('PCO_GetCOCRuntime',errorCode);   

waittime_s = double(dwNanoSec);
waittime_s = waittime_s / 1000000000;
waittime_s = waittime_s + double(dwSec);

end



function enable_timestamp(out_ptr,Stamp)

if((Stamp~=0)&&(Stamp~=1)&&(Stamp~=2)&&(Stamp~=3))
 disp('Stamp must be 0 or 1 or 2 or 3');
 return;
end

errorCode = calllib('PCO_CAM_SDK', 'PCO_SetTimestampMode', out_ptr,Stamp);
pco_errdisp('PCO_SetTimestampMode',errorCode);   

end

function set_metadata_mode(out_ptr,on)

wMetaDataMode=uint16(0);
wMetaDataSize=uint16(0);
wMetaDataVersion=uint16(0);

errorCode = calllib('PCO_CAM_SDK', 'PCO_GetMetaDataMode',out_ptr,wMetaDataMode,wMetaDataSize,wMetaDataVersion);
pco_errdisp('PCO_GetMetaDataMode',errorCode);   

wMetaDataMode=on;
errorCode = calllib('PCO_CAM_SDK', 'PCO_SetMetaDataMode',out_ptr,wMetaDataMode,wMetaDataSize,wMetaDataVersion);
pco_errdisp('PCO_SetMetaDataMode',errorCode);   

end


function [txt,time]=print_timestamp(ima,act_align,bitpix)

 if(act_align==0)
  ts=fix(double(ima(1:14,1))/(2^(16-bitpix)));   
 else
  ts=double(ima(1:14,1));  
 end
 [time,b]=print_timestamp_s(ts);
 if(nargout<1)
  disp(b)
 else
  txt=b;   
 end 
end

function [txt,time]=print_timestamp_t(ima,act_align,bitpix)

 if(act_align==0)
  ts=fix(double(ima(1,1:14))/(2^(16-bitpix)));   
 else
  ts=double(ima(1,1:14));  
 end
 ts=ts';
 [time,b]=print_timestamp_s(ts);
 if(nargout<1)
  disp(b)
 else
  txt=b;   
 end 
end


function [time,b]=print_timestamp_s(ts)

b='';
b=[b,int2str(fix(ts(1,1)/16)),int2str(bitand(ts(1,1),15))];
b=[b,int2str(fix(ts(2,1)/16)),int2str(bitand(ts(2,1),15))];
b=[b,int2str(fix(ts(3,1)/16)),int2str(bitand(ts(3,1),15))];
b=[b,int2str(fix(ts(4,1)/16)),int2str(bitand(ts(4,1),15))];

b=[b,' '];
%year
b=[b,int2str(fix(ts(5,1)/16)),int2str(bitand(ts(5,1),15))];   
b=[b,int2str(fix(ts(6,1)/16)),int2str(bitand(ts(6,1),15))];   
b=[b,'-'];
%month
b=[b,int2str(fix(ts(7,1)/16)),int2str(bitand(ts(7,1),15))];   
b=[b,'-'];
%day
b=[b,int2str(fix(ts(8,1)/16)),int2str(bitand(ts(8,1),15))];   
b=[b,' '];

%hour   
c=[int2str(fix(ts(9,1)/16)),int2str(bitand(ts(9,1),15))];   
b=[b,c,':'];
time=str2double(c)*60*60;
%min   
c=[int2str(fix(ts(10,1)/16)),int2str(bitand(ts(10,1),15))];   
b=[b,c,':'];
time=time+(str2double(c)*60);
%sec   
c=[int2str(fix(ts(11,1)/16)),int2str(bitand(ts(11,1),15))];   
b=[b,c,'.'];
time=time+str2double(c);
%us   
c=[int2str(fix(ts(12,1)/16)),int2str(bitand(ts(12,1),15))];   
b=[b,c];
time=time+(str2double(c)/100);
c=[int2str(fix(ts(13,1)/16)),int2str(bitand(ts(13,1),15))];   
b=[b,c];
time=time+(str2double(c)/10000);
c=[int2str(fix(ts(14,1)/16)),int2str(bitand(ts(14,1),15))];   
b=[b,c];
time=time+(str2double(c)/1000000);
end
