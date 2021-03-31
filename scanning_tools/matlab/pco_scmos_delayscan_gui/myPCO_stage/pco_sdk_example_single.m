function [errorCode] = pco_sdk_example_single(exposure_time,triggermode)
% set variables grab and display a single images
%
%   [errorCode] = pco_sdk_example_single(exposure_time,triggermode)
%
% * Input parameters :
%    exposure_time           camera exposure time (default=10ms)
%    triggermode             camera trigger mode (default=AUTO)
%
% * Output parameters :
%    errorCode               ErrorCode returned from pco.camera SDK-functions  
%
%grab images from a recording pco camera 
%using script function pco_camera_stack
%display the grabbed images
%
%function workflow
%open camera
%set variables 
%start camera
%grab image
%show image
%stop camera
%close camera
%

glvar=struct('do_libunload',0,'do_close',0,'camera_open',0,'out_ptr',[]);

if(~exist('exposure_time','var'))
 exposure_time = 10;   
end

if(~exist('triggermode','var'))
 triggermode = 0;   
end

%reduce_display_size=1: display only top-left corner 800x600Pixel
reduce_display_size=1;

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

%adjust transfer parameter if necessary
subfunc.fh_set_transferparameter(out_ptr);

subfunc.fh_get_triggermode(out_ptr);
subfunc.fh_show_frametime(out_ptr);

disp('get single image');
%subfunc.fh_start_camera(out_ptr);
[errorCode,ima,glvar]=pco_camera_stack(1,glvar);
if(errorCode==PCO_NOERROR)
 if(reduce_display_size~=0)
  [ys,xs]=size(ima);
  xmax=800;
  ymax=600;
  if((xs>xmax)&&(ys>ymax))
   ima=ima(1:ymax,1:xmax);
  elseif(xs>xmax)
   ima=ima(:,1:xmax);
  elseif(ys>ymax)
   ima=ima(1:ymax,:);
  end        
 end 
 m=max(max(ima(10:end-10,10:end-10)));
% imshow(ima',[0,m+100]);
 draw_image(ima,[0 m+100]);
 disp(['found max ',int2str(m)]);
 disp('Press "Enter" to proceed')
 pause();
 close()
end 

clear ima;
 
subfunc.fh_stop_camera(out_ptr);

if(glvar.camera_open==1)
 glvar.do_close=1;
 glvar.do_libunload=1;
 pco_camera_open_close(glvar);
end   

clear glvar;
commandwindow;
end

