function [ima_stack,errorCode] = pco_sdk_example_read(imacount,segment,exposure_time,triggermode)
% set variables and grab images to internal memory and readout afterwards to a Matlab array
%
%   [ima_stackerrorCode] = pco_sdk_example_read(imacount,segment,exposure_time,triggermode)
%
% * Input parameters :
%    imacount                number of images to grab
%    segment                 segment to use for readout (default=1)   
%    exposure_time           camera exposure time (default=10ms)
%    triggermode             camera trigger mode (default=AUTO)
%
% * Output parameters :
%    ima_stack               stack with grabbed images
%    errorCode               ErrorCode returned from pco.camera SDK-functions  
%
%grab images into internal camera memory 
%and read the images to an image stack
%
%function workflow
%open camera
%set variables 
%setup internal memory
%start camera
%grab images
%stop camera
%read images from internal memory to image stack
%close camera
%

glvar=struct('do_libunload',0,'do_close',0,'camera_open',0,'out_ptr',[]);

if(~exist('imacount','var'))
 imacount = 10;   
end

if(~exist('exposure_time','var'))
 exposure_time = 10;   
end

if(~exist('triggermode','var'))
 triggermode = 0;   
end

if(~exist('segment','var'))
 segment = uint16(1);   
else 
 if((segment<1)||(segment>4))
  segment=1;
 end 
end


pco_camera_load_defines();

[errorCode,glvar]=pco_camera_open_close(glvar);
pco_errdisp('pco_camera_setup',errorCode); 
disp(['camera_open should be 1 is ',int2str(glvar.camera_open)]);
if(errorCode~=PCO_NOERROR)
 commandwindow;
 return;
end 

out_ptr=glvar.out_ptr;

subfunc=pco_camera_subfunction();

subfunc.fh_stop_camera(out_ptr);

cam_desc=libstruct('PCO_Description');
set(cam_desc,'wSize',cam_desc.structsize);
[errorCode,~,cam_desc] = calllib('PCO_CAM_SDK', 'PCO_GetCameraDescription', out_ptr,cam_desc);
pco_errdisp('PCO_GetCameraDescription',errorCode);   

if(bitand(cam_desc.dwGeneralCapsDESC1,GENERALCAPS1_NO_TIMESTAMP)==0)
 subfunc.fh_enable_timestamp(out_ptr,TIMESTAMP_MODE_BINARYANDASCII);
end 

subfunc.fh_set_exposure_times(out_ptr,exposure_time,2,0,2)
subfunc.fh_set_triggermode(out_ptr,triggermode);

errorCode = calllib('PCO_CAM_SDK', 'PCO_ArmCamera', out_ptr);
pco_errdisp('PCO_ArmCamera',errorCode);   

%if PCO_ArmCamera does fail no images can be grabbed
if(errorCode~=PCO_NOERROR)
 commandwindow;
 return;
end 

subfunc.fh_get_triggermode(out_ptr);

subfunc.fh_set_transferparameter(out_ptr);

subfunc.fh_show_frametime(out_ptr);

ima_stack=[];
%get images
[errorCode,imacount,glvar]=pco_camera_recmem(glvar,imacount,segment);
if(errorCode==0)
 [errorCode,ima_stack,glvar]=pco_camera_readmem(glvar,imacount,1,segment);
 if(errorCode==0)
  [~,~,count]=size(ima_stack);   
  if(count==1)
   m=max(max(ima_stack(10:end-10,10:end-10)));
   disp(['image done maxvalue: ',int2str(m)]);   
   if(bitand(cam_desc.dwGeneralCapsDESC1,GENERALCAPS1_NO_TIMESTAMP)==0)
    txt=subfunc.fh_print_timestamp_t(ima_stack,1,16);
    disp(['Timestamp data of image: ',txt]);
   end
  else
   disp([int2str(count),' images done']);   
   if(bitand(cam_desc.dwGeneralCapsDESC1,GENERALCAPS1_NO_TIMESTAMP)==0)
    reply = input('Show timestamps? Y/N [Y]: ', 's');
    if((isempty(reply))||(reply(1)== 'Y'))
     for n=1:count
      txt=subfunc.fh_print_timestamp_t(ima_stack(:,:,n),1,16);
      disp(['Timestamp data of image ',num2str(n,'%04d'),': ',txt]);
     end   
    end
   end
  end 
 end 
end 

subfunc.fh_stop_camera(out_ptr);
pco_camera_resetmem(glvar);

if(glvar.camera_open==1)
 glvar.do_close=1;
 glvar.do_libunload=1;
 pco_camera_open_close(glvar);
end   

clear glvar;
commandwindow;
end

