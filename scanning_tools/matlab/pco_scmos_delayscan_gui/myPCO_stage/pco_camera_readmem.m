function [errorCode,image_stack,glvar] = pco_camera_readmem(glvar,imacount,start,segment)
%read grabbed image from Camera memory to image_stack 
%
%   [errorCode,image_stack,glvar] = pco_camera_readmem(glvar,imacount,start,segment)
%
% * Input parameters :
%    glvar                   structure to hold status info
%    imacount                number of images to grab
%    start                   first image to read 
%    segment                 segment to use for readout  
% * Output parameters :
%    errorCode               ErrorCode returned from pco.camera SDK-functions  
%    image_stack uint16(,,)  grabbed images
%    glvar                   structure to hold status info
%
%read 'imacount' images from internal camera memory
%start with image number start
%
%
%structure glvar is used to set different modes for
%load/unload library
%open/close camera SDK
%
%glvar.do_libunload: 1 unload lib at end
%glvar.do_close:     1 close camera SDK at end
%glvar.camera_open:  open status of camera SDK
%glvar.out_ptr:      libpointer to camera SDK handle
%
%if glvar does not exist,
%the library is loaded at begin and unloaded at end
%the SDK is opened at begin and closed at end
%
%if imacount does not exist, it is set to '1'
%
%function workflow
%parameters are checked
%Alignment for the image data is set to LSB
%the size of the images is readout from the camera
%labview array is build
%allocate buffer(s) in camera SDK 
%to readout single images PCO_GetImageEx function is used
%to readout multiple images
%PCO_AddBufferEx and PCO_WaitforBuffer functions are used in a loop
%free previously allocated buffer(s) in camera SDK 
%errorCode, if available glvar, and the image_stack with uint16 image data is returned
%

% Test if library is loaded
if (~libisloaded('PCO_CAM_SDK'))
    % make sure the dll and h file specified below resides in your current
    % folder
	loadlibrary('SC2_Cam','SC2_CamMatlab.h' ...
                ,'addheader','SC2_CamExport.h' ...
                ,'alias','PCO_CAM_SDK');
	disp('PCO_CAM_SDK library is loaded!');
end

% Declaration of internal variables
if(~exist('imacount','var'))
 imacount = uint16(1);   
end

if(~exist('start','var'))
 start = 1;   
end

if(~exist('segment','var'))
 segment = uint16(1);   
end

if((exist('glvar','var'))&& ...
   (isfield(glvar,'do_libunload'))&& ...
   (isfield(glvar,'do_close'))&& ...
   (isfield(glvar,'camera_open'))&& ...
   (isfield(glvar,'out_ptr')))
 unload=glvar.do_libunload;    
 cam_open=glvar.camera_open;
 do_close=glvar.do_close;
else
 unload=1;   
 cam_open=0;
 do_close=1;
end


ph_ptr = libpointer('voidPtrPtr');

%libcall PCO_OpenCamera
if(cam_open==0)
 [errorCode,out_ptr] = calllib('PCO_CAM_SDK', 'PCO_OpenCamera', ph_ptr, 0);
 if(errorCode == 0)
  disp('PCO_OpenCamera done');
  cam_open=1;
  if((exist('glvar','var'))&& ...
     (isfield(glvar,'camera_open'))&& ...
     (isfield(glvar,'out_ptr')))
   glvar.camera_open=1;
   glvar.out_ptr=out_ptr;
  end 
 else
   pco_errdisp('PCO_OpenCamera',errorCode);   
  if(unload)
   unloadlibrary('PCO_CAM_SDK');
   disp('PCO_CAM_SDK unloadlibrary done');
  end 
  return ;   
 end
else
 if(isfield(glvar,'out_ptr'))
  out_ptr=glvar.out_ptr;   
 end
end

%subfunc=pco_camera_subfunction();
pco_camera_load_defines();

%get Camera Description
cam_desc=libstruct('PCO_Description');
set(cam_desc,'wSize',cam_desc.structsize);
[errorCode,~,cam_desc] = calllib('PCO_CAM_SDK', 'PCO_GetCameraDescription', out_ptr,cam_desc);
pco_errdisp('PCO_GetCameraDescription',errorCode);   

if(bitand(cam_desc.dwGeneralCapsDESC1,GENERALCAPS1_NO_RECORDER)~=0)
 errorCode=PCO_ERROR_APPLICATION_FUNCTIONNOTSUPPORTED;
 disp('this function is not supported because the selected camera does not have internal memory');
 return;
end    

if((segment<1)||(segment>4))
 errorCode=PCO_ERROR_APPLICATION|PCO_ERROR_WRONGVALUE;
 disp('value of segment must be in the range from 1 to 4');
 return;
end 


bitalign=uint16(BIT_ALIGNMENT_LSB);
errorCode = calllib('PCO_CAM_SDK', 'PCO_SetBitAlignment', out_ptr,bitalign);
pco_errdisp('PCO_SetBitAlignment',errorCode);   

cam_type=libstruct('PCO_CameraType');
set(cam_type,'wSize',cam_type.structsize);
[errorCode,~,cam_type] = calllib('PCO_CAM_SDK', 'PCO_GetCameraType', out_ptr,cam_type);
pco_errdisp('PCO_GetCameraType',errorCode);   

interface=uint16(cam_type.wInterfaceType);
bitpix=uint16(cam_desc.wDynResDESC);

act_recstate = uint16(10); 
[errorCode,~,act_recstate] = calllib('PCO_CAM_SDK', 'PCO_GetRecordingState',out_ptr,act_recstate);
pco_errdisp('PCO_GetRecordingState',errorCode);   

if(act_recstate~=0)
 errorCode=PCO_ERROR_APPLICATION_FUNCTIONNOTSUPPORTED;
 disp('function is not supported while camera is in recording state ON');
 return;
end 

dwValidImageCnt=uint32(0);
dwMaxImageCnt=uint32(0);
if(errorCode==PCO_NOERROR)
 [errorCode,~,dwValidImageCnt]=calllib('PCO_CAM_SDK', 'PCO_GetNumberOfImagesInSegment',out_ptr,segment,dwValidImageCnt,dwMaxImageCnt);
 pco_errdisp('PCO_GetNumberOfImagesInSegment',errorCode);   
end

if(imacount>dwValidImageCnt)
 imacount=dwValidImageCnt;   
 disp(['only ',int2str(dwValidImageCnt),' images found in camera memory reduce imacount to',int2str(imacount)]);
end

if(start>dwValidImageCnt)
 start=1;   
 disp(['start exceeds valid image count ',int2str(dwValidImageCnt),' start is set to ',int2str(start)]);
end

if(start+imacount>dwValidImageCnt+1)
 imacount=dwValidImageCnt-start;   
 disp(['start + imacount exceeds valid image count ',int2str(dwValidImageCnt),' reduce imacount to',int2str(imacount)]);
end


wXRes=uint16(0);
wYRes=uint16(0);
wBinHorz=uint16(0);
wBinVert=uint16(0);
wRoiX0=uint16(0);
wRoiY0=uint16(0);
wRoiX1=uint16(0);
wRoiY1=uint16(0);
[errorCode,~,wXRes,wYRes]  = calllib('PCO_CAM_SDK','PCO_GetSegmentImageSettings',out_ptr,segment,wXRes,wYRes,wBinHorz,wBinVert,wRoiX0,wRoiY0,wRoiX1,wRoiY1);
pco_errdisp('PCO_GetSegmentImageSettings',errorCode);   

% act_xsize=uint16(0);
% act_ysize=uint16(0);
% max_xsize=uint16(0);
% max_ysize=uint16(0);
% [errorCode,~,act_xsize,act_ysize]  = calllib('PCO_CAM_SDK', 'PCO_GetSizes', out_ptr,act_xsize,act_ysize,max_xsize,max_ysize);
% pco_errdisp('PCO_GetSizes',errorCode);   

errorCode = calllib('PCO_CAM_SDK', 'PCO_CamLinkSetImageParameters', out_ptr,wXRes,wYRes);
if(errorCode)
 pco_errdisp('PCO_CamLinkSetImageParameters',errorCode);   
 return;
end

if(errorCode==PCO_NOERROR)
 [errorCode,~]=calllib('PCO_CAM_SDK', 'PCO_SetActiveRamSegment',out_ptr,segment);
 pco_errdisp('PCO_SetActiveRamSegment',errorCode);   
end

if(errorCode==PCO_NOERROR)
 [errorCode,~]=calllib('PCO_CAM_SDK', 'PCO_ArmCamera',out_ptr);
 pco_errdisp('PCO_ArmCamera',errorCode);   
end

%limit allocation of memory to 2GByte
%if(double(imacount)*double(act_xsize)*double(act_ysize)*bytepix>2000*1024*1024)     
% imacount=uint16(double(2000*1024*1024)/(double(act_xsize)*double(act_ysize)*bytepix));
%end

if(imacount == 1)
 [errorCode,image_stack] = pco_read_image_single(out_ptr,start,wXRes,wYRes,bitpix,interface);
else
 [errorCode,image_stack] = pco_read_image_multi(out_ptr,imacount,start,wXRes,wYRes,bitpix,interface);
end

pco_errdisp('pco_get_image_...',errorCode);   

if(exist('glvar','var'))
 glvar = close_camera(out_ptr,unload,do_close,cam_open,glvar);
else
 close_camera(out_ptr,unload,do_close,cam_open);   
end

if(errorCode==0)
 disp('transpose image(s)');
 if(imacount == 1)
% txt=subfunc.fh_print_timestamp(image_stack,act_align,bitpix);
% disp(['Timestamp data of image: ',txt]);
  image_stack=image_stack';
% m=max(max(image_stack(10:end-10,10:end-10)));
% disp(['Transpose image done maxvalue: ',int2str(m)]);   
 else 
  [~,~,count]=size(image_stack);
  if(count~=imacount)
   disp(['Only ',int2str(count),' images grabbed']);
  end 
  ima=zeros(wYRes,wXRes,count,'uint16');
  for n=1:count   
   ima(:,:,n)=image_stack(:,:,n)';
%  txt=subfunc.fh_print_timestamp_t(ima(:,:,n),act_align,bitpix);
%  disp(['Timestamp data of image ',int2str(n),' ',txt]);
  end
  image_stack=ima;
 end
end 

end

function [errorCode,image_stack] = pco_read_image_single(out_ptr,start,xsize,ysize,bitpix,interface)

act_xsize=uint32(xsize);
act_ysize=uint32(ysize);

%get the memory for the images
%need special code for firewire interface
imas=uint32(fix((double(bitpix)+7)/8));
imas= imas*act_xsize*act_ysize; 
imasize=imas;

%only for firewire add always some lines
%to ensure enough memory is allocated for the transfer
if(interface==1) %INTERFACE_FIREWIRE
  i=floor(double(imas)/4096);
  i=i+1;
  i=i*4096;
  imasize=i;
  i=i-double(imas);
  xs=uint32(fix((double(bitpix)+7)/8));
  xs=xs*act_xsize;
  i=floor(i/double(xs));
  i=i+1;
  lineadd=i;
 disp(['imasize is: ',int2str(imas),' aligned: ',int2str(imasize)]); 
 disp([int2str(lineadd),' additional lines must be allocated ']);   
else
 lineadd=0;   
end

image_stack=ones(act_xsize,act_ysize+lineadd,'uint16');

sBufNr=int16(-1);
im_ptr = libpointer('uint16Ptr',image_stack);
ev_ptr = libpointer('voidPtr');

[errorCode,~,sBufNr]  = calllib('PCO_CAM_SDK','PCO_AllocateBuffer', out_ptr,sBufNr,imasize,im_ptr,ev_ptr);
if(errorCode)
 pco_errdisp('PCO_AllocateBuffer',errorCode);   
 return;
end

ml_buflist.sBufNr=sBufNr;
buflist=libstruct('PCO_Buflist',ml_buflist);

errorCode = calllib('PCO_CAM_SDK','PCO_AddBufferEx', out_ptr,start,start,sBufNr,act_xsize,act_ysize,bitpix);
pco_errdisp('PCO_AddBufferEx',errorCode);   

image_error=0;   

[errorCode,~,buflist]  = calllib('PCO_CAM_SDK','PCO_WaitforBuffer',out_ptr,1,buflist,1000);
pco_errdisp('PCO_WaitforBuffer',errorCode);   
if((bitand(buflist.dwStatusDll,hex2dec('00008000')))&&(buflist.dwStatusDrv==0))
%this will copy our data to image_stack
 image_stack=get(im_ptr,'Value');
else
 disp(['Wait or Status error dwStatusDll ',num2str(buflist.dwStatusDll,'%08X'),' StatusDrv ',num2str(buflist.dwStatusDrv,'%08X')]);
 image_error=buflist.dwStatusDrv;   
end


%delete additional lines at end
if(lineadd>0)
 for n=1:lineadd
  image_stack(:,end)=[];
 end
end

errorCode  = calllib('PCO_CAM_SDK','PCO_FreeBuffer',out_ptr,sBufNr);
pco_errdisp('PCO_FreeBuffer',errorCode);   

if(image_error~=0)
 errorCode=image_error;
end 
end

function [errorCode,image_stack] = pco_read_image_multi(out_ptr,imacount,start,act_xsize,act_ysize,bitpix,interface)

if(imacount<2)
 pco_camera_load_defines();
 disp('Wrong image count, must be 2 or greater, return')    
 errorCode=PCO_ERROR_APPLICATION|PCO_ERROR_WRONGVALUE;
 return;
end

%get the memory for the images
%need special code for firewire interface
imas=uint32(fix((double(bitpix)+7)/8));
imas= imas*uint32(act_xsize)* uint32(act_ysize); 
imasize=imas;

%only for firewire
if(interface==1)
  i=floor(double(imas)/4096);
  i=i+1;
  i=i*4096;
  imasize=i;
  i=i-double(imas);
  xs=uint32(fix((double(bitpix)+7)/8));
  xs=xs*uint32(act_xsize);
  i=floor(i/double(xs));
  i=i+1;
  lineadd=i;
 disp(['imasize is: ',int2str(imas),' aligned: ',int2str(imasize)]); 
 disp([int2str(lineadd),' additional lines must be allocated ']);   
else
 lineadd=0;   
end

image_stack=ones(act_xsize,(act_ysize+lineadd),imacount,'uint16');
im_ptr(imacount)=libpointer;

allocmem=double(imasize*imacount);
if(allocmem<(1024*1024*1024))
 disp(['allocated memory is ',num2str(allocmem/double(1024*1024),'%.2f'),'MByte'])
else    
 disp(['allocated memory is ',num2str(allocmem/double(1024*1024*1024),'%.2f'),'GByte'])
end

for n=1:imacount
 im_ptr(n)=libpointer('uint16Ptr',image_stack(:,:,n));
 image_stack(:,:,n)=get(im_ptr(n),'Value');
end 
 
%Allocate 2 SDK buffer and set address to buffers in stack
sBufNr_1=int16(-1);
ev_ptr(1) = libpointer('voidPtr');

[errorCode,~,sBufNr_1]  = calllib('PCO_CAM_SDK','PCO_AllocateBuffer', out_ptr,sBufNr_1,imasize,im_ptr(1),ev_ptr(1));
if(errorCode)
 pco_errdisp('PCO_AllocateBuffer',errorCode);   
 return;
end

sBufNr_2=int16(-1);
ev_ptr(2) = libpointer('voidPtr');

[errorCode,~,sBufNr_2]  = calllib('PCO_CAM_SDK','PCO_AllocateBuffer', out_ptr,sBufNr_2,imasize,im_ptr(2),ev_ptr(2));
if(errorCode)
 pco_errdisp('PCO_AllocateBuffer',errorCode);   
 err  = calllib('PCO_CAM_SDK','PCO_FreeBuffer',out_ptr,sBufNr_1);
 pco_errdisp('PCO_FreeBuffer',err);   
 return;
end

buflist_1=libstruct('PCO_Buflist');
set(buflist_1,'sBufnr',int16(sBufNr_1));
buflist_2=libstruct('PCO_Buflist');
set(buflist_2,'sBufnr',int16(sBufNr_2));

ima_nr=start;
errorCode = calllib('PCO_CAM_SDK','PCO_AddBufferEx', out_ptr,ima_nr,ima_nr,sBufNr_1,act_xsize,act_ysize,bitpix);
pco_errdisp('PCO_AddBufferEx',errorCode);   
 
ima_nr=ima_nr+1;
errorCode = calllib('PCO_CAM_SDK','PCO_AddBufferEx', out_ptr,ima_nr,ima_nr,sBufNr_2,act_xsize,act_ysize,bitpix);
pco_errdisp('PCO_AddBufferEx',errorCode);   

image_error=0;

d=10;
if(imacount>100)
 if(imacount<500)
  d=50;
 else
  d=100;
 end 
end 

tic;

for n=1:imacount
 if(rem(n,2)==1)
  [errorCode,~,buflist_1]  = calllib('PCO_CAM_SDK','PCO_WaitforBuffer', out_ptr,1,buflist_1,500);
  if(errorCode)
   pco_errdisp('PCO_WaitforBuffer 1',errorCode);   
   break;
  end 
 
  if((bitand(buflist_1.dwStatusDll,hex2dec('00008000')))&&(buflist_1.dwStatusDrv==0))
   buflist_1.dwStatusDll= bitand(buflist_1.dwStatusDll,hex2dec('FFFF7FFF'));
   if(n+2<=imacount)
    ima_nr=ima_nr+1;   
    [errorCode,~,sBufNr_1]  = calllib('PCO_CAM_SDK','PCO_AllocateBuffer', out_ptr,sBufNr_1,imasize,im_ptr(n+2),ev_ptr(1));
    if(errorCode)
     pco_errdisp('PCO_AllocateBuffer',errorCode);   
     break; 
    end
    [errorCode]  = calllib('PCO_CAM_SDK','PCO_AddBufferEx', out_ptr,ima_nr,ima_nr,sBufNr_1,act_xsize,act_ysize,bitpix);
    if(errorCode)
     pco_errdisp('PCO_AddBufferEx',errorCode);   
     break;
    end
   end
  else
   disp(['Wait or Status error image ',int2str(n),' dwStatusDll ',num2str(buflist_1.dwStatusDll,'%08X'),' StatusDrv ',num2str(buflist_1.dwStatusDrv,'%08X')]);
   image_error=buflist_1.dwStatusDrv;
   break; 
  end
 else 
  [errorCode,~,buflist_2]  = calllib('PCO_CAM_SDK','PCO_WaitforBuffer', out_ptr,1,buflist_2,5000);
  if(errorCode)
   pco_errdisp('PCO_WaitforBuffer 2',errorCode);   
   break;
  end 
  
  if(bitand(buflist_2.dwStatusDll,hex2dec('00008000'))&&(buflist_2.dwStatusDrv==0))
   buflist_2.dwStatusDll= bitand(buflist_2.dwStatusDll,hex2dec('FFFF7FFF'));
   if(n+2<=imacount)
    ima_nr=ima_nr+1;   
    [errorCode,~,sBufNr_2]  = calllib('PCO_CAM_SDK','PCO_AllocateBuffer', out_ptr,sBufNr_2,imasize,im_ptr(n+2),ev_ptr(2));
    if(errorCode)
     pco_errdisp('PCO_AllocateBuffer',errorCode);   
     break; 
    end
    [errorCode,out_ptr]  = calllib('PCO_CAM_SDK','PCO_AddBufferEx', out_ptr,ima_nr,ima_nr,sBufNr_2,act_xsize,act_xsize,bitpix);
    if(errorCode)
     pco_errdisp('PCO_AddBufferEx',errorCode);   
     break;
    end
   end 
  else
   disp(['Wait or Status error image ',int2str(n),' dwStatusDll ',num2str(buflist_2.dwStatusDll,'%08X'),' StatusDrv ',num2str(buflist_2.dwStatusDrv,'%08X')]);
   image_error=buflist_2.dwStatusDrv;
   break; 
  end
 end
 if(rem(n,d)==0)
  disp([int2str(n),'. image read from camera memory']);
 end
end

%this will remove all pending buffers in the queue
[errorCode,out_ptr] = calllib('PCO_CAM_SDK', 'PCO_CancelImages', out_ptr);
pco_errdisp('PCO_CancelImages',errorCode);   

t=toc;
disp([int2str(n),' images done in ',num2str(t),' seconds. time per image is ',num2str(t/double(n),'%.3f'),'s ',num2str((double(imasize)*n)/(t*1024*1024),'%.3f'),'MByte/sec']);  

%this will load all dat into workspace
for i=1:n
 image_stack(:,:,i)=get(im_ptr(i),'Value');
end 

if(lineadd>0)
 for m=1:lineadd
  image_stack(:,end,:)=[];
 end
end 

if(n~=imacount)
 image_stack=image_stack(:,:,1:n);
end

%free buffers
errorCode  = calllib('PCO_CAM_SDK','PCO_FreeBuffer',out_ptr,sBufNr_1);
pco_errdisp('PCO_FreeBuffer',errorCode);   
   
errorCode  = calllib('PCO_CAM_SDK','PCO_FreeBuffer',out_ptr,sBufNr_2);
pco_errdisp('PCO_FreeBuffer',errorCode);   

if(image_error~=0)
 errorCode=image_error;
end

end


function [glvar] = close_camera(out_ptr,unload,do_close,cam_open,glvar)
 if((do_close==1)&&(cam_open==1))
  errorCode = calllib('PCO_CAM_SDK', 'PCO_CloseCamera',out_ptr);
  if(errorCode)
   pco_errdisp('PCO_CloseCamera',errorCode);   
  else
   disp('PCO_CloseCamera done');
   cam_open=0;
   if((exist('glvar','var'))&& ...
      (isfield(glvar,'camera_open'))&& ...
      (isfield(glvar,'out_ptr')))
    glvar.out_ptr=[];
    glvar.camera_open=0;
   end
  end    
 end
 if((unload==1)&&(cam_open==0))
  unloadlibrary('PCO_CAM_SDK');
  disp('PCO_CAM_SDK unloadlibrary done');
  commandwindow;
 end 
end
