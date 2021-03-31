function [errorCode] = pco_sdk_example_live_getima(looptime,exposure_time,triggermode)
% grab and display images in a loop using simple image function
%
%   [errorCode] =  pco_sdk_example_live_getima(looptime,triggermode)
%
% * Input parameters :
%    looptime                time the loop is running (default=10 seconds)
%    triggermode             camera trigger mode (default=AUTO)
%    exposure_time           camera exposure time (default=10ms)
%
% * Output parameters :
%    errorCode               ErrorCode returned from pco.camera SDK-functions  
%
%
%grab images from a recording pco.edge camera 
%using function PCO_GetImageEx 
%display the grabbed images
%
%
%break loop either after waittime or nr_of_images images are done
%

glvar=struct('do_libunload',1,'do_close',0,'camera_open',0,'out_ptr',[]);

if(~exist('looptime','var'))
 looptime = 10;   
end

if(~exist('exposure_time','var'))
 exposure_time = 10;   
end

if(~exist('triggermode','var'))
 triggermode = 0;   
end

if(triggermode==1)
 disp('sorry this example does not run with triggermode=1 (SW-Trigger)');
 disp('triggermode is set to 0 (Auto-Trigger)');
 triggermode=0;
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

act_recstate = uint16(10); 
[errorCode,~,act_recstate] = calllib('PCO_CAM_SDK', 'PCO_GetRecordingState',out_ptr,act_recstate);
if(errorCode)
  pco_errdisp('PCO_GetRecordingState',errorCode);   
else
 disp(['actual recording state is ',int2str(act_recstate)]);   
end

%stop camera
subfunc.fh_stop_camera(out_ptr);

cam_desc=libstruct('PCO_Description');
set(cam_desc,'wSize',cam_desc.structsize);
[errorCode,~,cam_desc] = calllib('PCO_CAM_SDK', 'PCO_GetCameraDescription', out_ptr,cam_desc);
if(errorCode)
 pco_errdisp('PCO_GetCameraDescription',errorCode);   
end
bitpix=uint16(cam_desc.wDynResDESC);

%set bitalignment LSB
bitalign=uint16(BIT_ALIGNMENT_LSB);
errorCode = calllib('PCO_CAM_SDK', 'PCO_SetBitAlignment', out_ptr,bitalign);
if(errorCode)
 pco_errdisp('PCO_SetBitAlignment',errorCode);   
end

errorCode = calllib('PCO_CAM_SDK', 'PCO_SetRecorderSubmode',out_ptr,RECORDER_SUBMODE_RINGBUFFER);
pco_errdisp('PCO_SetRecorderSubmode',errorCode);   

%enable ASCII and binary timestamp
if(bitand(cam_desc.dwGeneralCapsDESC1,GENERALCAPS1_NO_TIMESTAMP)==0)
 subfunc.fh_enable_timestamp(out_ptr,TIMESTAMP_MODE_BINARYANDASCII);
end

%set default Pixelrate
subfunc.fh_set_pixelrate(out_ptr,1);

%set triggermode
subfunc.fh_set_triggermode(out_ptr,triggermode);

subfunc.fh_set_exposure_times(out_ptr,exposure_time,2,0,2);


errorCode = calllib('PCO_CAM_SDK', 'PCO_ArmCamera', out_ptr);
pco_errdisp('PCO_ArmCamera',errorCode);   

%if PCO_ArmCamera does fail no images can be grabbed
if(errorCode~=PCO_NOERROR)
 commandwindow;
 return;
end 

%adjust transfer parameter if necessary
subfunc.fh_set_transferparameter(out_ptr);

triggermode=subfunc.fh_get_triggermode(out_ptr);
imatime=subfunc.fh_show_frametime(out_ptr);

%calculate images to grab
nr_of_images=uint32(fix(looptime/imatime)+1);
disp(['maximal ',num2str(nr_of_images),' images will be grabbed in ',num2str(looptime),' seconds' ]);   

act_xsize=uint16(0);
act_ysize=uint16(0);
ccd_xsize=uint16(0);
ccd_ysize=uint16(0);

%use PCO_GetSizes because this always returns accurat image size for next recording
[errorCode,~,act_xsize,act_ysize]  = calllib('PCO_CAM_SDK', 'PCO_GetSizes', out_ptr,act_xsize,act_ysize,ccd_xsize,ccd_ysize);
if(errorCode)
 pco_errdisp('PCO_GetSizes',errorCode);   
end

disp(['sizes: horizontal ',int2str(act_xsize),' vertical ',int2str(act_ysize)]);

%allocate memory for display, a single buffer is used 
imas=uint32(fix((double(bitpix)+7)/8));
imas= imas*uint32(act_xsize)* uint32(act_ysize); 
imasize=imas;
lineadd=0;   

image_stack=zeros(act_xsize,(act_ysize+lineadd),'uint16');

%Allocate single SDK buffer and set address of this buffer from image_stack
sBufNr=int16(-1);
ev_ptr = libpointer('voidPtr');
im_ptr = libpointer('uint16Ptr',image_stack(:,:));
 
[errorCode,~,sBufNr]  = calllib('PCO_CAM_SDK','PCO_AllocateBuffer', out_ptr,sBufNr,imasize,im_ptr,ev_ptr);
if(errorCode)
 pco_errdisp('PCO_AllocateBuffer',errorCode);   
 clear image_stack;
 commandwindow;
 return;
end  
 
errorCode = calllib('PCO_CAM_SDK', 'PCO_CamLinkSetImageParameters', out_ptr,act_xsize,act_ysize);
if(errorCode)
 pco_errdisp('PCO_CamLinkSetImageParameters',errorCode);   
end

%show figure
ima=image_stack(:,:);
if(reduce_display_size~=0)
 [xs,ys]=size(ima);
 xmax=800;
 ymax=600;
 if((xs>xmax)&&(ys>ymax))
  ima=ima(1:xmax,1:ymax);
 elseif(xs>xmax)
  ima=ima(1:xmax,:);
 elseif(ys>ymax)
  ima=ima(:,1:ymax);
 end        
end 
ima=ima';
imah=draw_image(ima,[0 100]);
axish=gca;
set(axish,'CLim',[0 1000]);

pause(0.5);

%grab preimage to get actual image value range and set limits
subfunc.fh_start_camera(out_ptr);
if(triggermode>=2)
 disp('send external trigger pulse within 3 seconds');   
 pause(0.0001); 
end 

errorCode = calllib('PCO_CAM_SDK','PCO_GetImageEx',out_ptr,1,0,0,sBufNr,act_xsize,act_ysize,bitpix);
if(errorCode)
 pco_errdisp('PCO_GetImageEx',errorCode);   
else
 disp('GetImageEx done');
%get data and show image   
 ima=im_ptr.Value;
 if(bitand(cam_desc.dwGeneralCapsDESC1,GENERALCAPS1_NO_TIMESTAMP)==0)
  subfunc.fh_print_timestamp(ima,bitalign,bitpix);
 end 
 if(reduce_display_size~=0)
  [xs,ys]=size(ima);
  xmax=800;
  ymax=600;
  if((xs>xmax)&&(ys>ymax))
   ima=ima(1:xmax,1:ymax);
  elseif(xs>xmax)
   ima=ima(1:xmax,:);
  elseif(ys>ymax)
   ima=ima(:,1:ymax);
  end        
 end 
 ima=ima';
 m=max(max(ima(10:end-10,10:end-10)));
 set(axish,'CLim',[0 m+100]);
 disp(['pre image done maxvalue: ',int2str(m)]);   
 set(imah,'CData',ima,'CDataMapping','scaled'); 
 pause(0.0001);
end

subfunc.fh_stop_camera(out_ptr);

%variable to reduce amount of messages
 d=10;
 if(nr_of_images>100)
  if(nr_of_images<500)
   d=50;
  else
   d=100;
  end 
 end 
 
subfunc.fh_start_camera(out_ptr);

if(triggermode>=2)
 disp('send external trigger pulses within 3 seconds');   
 pause(0.0001); 
end 

[errorCode,~,act_recstate] = calllib('PCO_CAM_SDK', 'PCO_GetRecordingState',glvar.out_ptr,act_recstate);
if(errorCode)
  pco_errdisp('PCO_GetRecordingState',errorCode);   
else
 disp(['Actual recording state is ',int2str(act_recstate)]);   
end

if(act_recstate==1)
 disp('get images');
 tic;

 for i=1:nr_of_images   
  errorCode = calllib('PCO_CAM_SDK','PCO_GetImageEx',out_ptr,1,0,0,sBufNr,act_xsize,act_ysize,bitpix);
  if(errorCode)
   pco_errdisp('PCO_GetImageEx',errorCode);   
  else
%get data and show image   
   ima=get(im_ptr,'Value');
   if(rem(i,d)==0)
    disp(['GetImageEx ',int2str(i),' done']);
    if(bitand(cam_desc.dwGeneralCapsDESC1,GENERALCAPS1_NO_TIMESTAMP)==0)
     subfunc.fh_print_timestamp(ima,bitalign,bitpix);
    end 
   end 
   if(reduce_display_size~=0)
    [xs,ys]=size(ima);
    xmax=800;
    ymax=600;
    if((xs>xmax)&&(ys>ymax))
     ima=ima(1:xmax,1:ymax);
    elseif(xs>xmax)
     ima=ima(1:xmax,:);
    elseif(ys>ymax)
     ima=ima(:,1:ymax);
    end        
   end 
   ima=ima';
   set(imah,'CData',ima,'CDataMapping','scaled'); 
   pause(0.0001);
  end
  t=toc;
  if(t>looptime)
   break;
  end 
 end

 ima_nr=i;
 disp(['Last image ',int2str(ima_nr),' done ']);
 if(bitand(cam_desc.dwGeneralCapsDESC1,GENERALCAPS1_NO_TIMESTAMP)==0)
  subfunc.fh_print_timestamp_t(ima,bitalign,bitpix);
 end
 disp([int2str(ima_nr),' images done in ',num2str(t),' seconds. time per image is ',num2str(t/double(ima_nr),'%.3f'),'s']);  
 
%this will remove all pending buffers in the queue
 errorCode = calllib('PCO_CAM_SDK', 'PCO_CancelImages', out_ptr);
 if(errorCode)
  pco_errdisp('PCO_CancelImages',errorCode);   
 end
 
 disp('Press "Enter" to close window and proceed')
 pause();
 close();
 pause(1);
end

subfunc.fh_stop_camera(out_ptr);
 
errorCode = calllib('PCO_CAM_SDK','PCO_FreeBuffer',out_ptr,sBufNr);
if(errorCode)
 pco_errdisp('PCO_FreeBuffer',errorCode);   
else 
 disp('PCO_FreeBuffer done ');   
end    

if(glvar.camera_open==1)
 glvar.do_close=1;
 glvar.do_libunload=1;
 pco_camera_open_close(glvar);
end   

clear ima_stack;
clear glvar;
clear ima;
commandwindow;

end
   
