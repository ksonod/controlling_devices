% MODIFIED

function [my_ave_img,errorCode] = my_multiple_images(imacount,exposure_time,triggermode)
% set variables and grab images to a Matlab array
%
%   [ima_stack] = pco_sdk_example_stack(imacount,exposure_time,triggermode)
%
% * Input parameters :
%    imacount                number of images to grab
%    exposure_time           camera exposure time (default=10ms)
%    triggermode             camera trigger mode (default=AUTO)
%
% * Output parameters :
%    ima_stack               stack with grabbed images  
%    errorCode               ErrorCode returned from pco.camera SDK-functions  
%
%grab images from a recording pco.dimax camera 
%using functions PCO_AddBufferEx and PCO_WaitforBuffer
%
%function workflow
%open camera
%set variables 
%start camera
%grab images
%stop camera
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


pco_camera_load_defines();

[errorCode,glvar]=pco_camera_open_close(glvar);
pco_errdisp('pco_camera_setup',errorCode); 
%disp(['camera_open should be 1 is ',int2str(glvar.camera_open)]);
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

subfunc.fh_set_exposure_times(out_ptr,exposure_time,2,0,2);

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
%subfunc.fh_show_frametime(out_ptr);


% Create a folder for saving images
datpath=[pwd, '\multiple_images']; 
if exist(datpath, 'dir') % if a folder already exists, 
    rmdir multiple_images s; % delete it
end
mkdir(datpath); % make a new folder




if evalin( 'base', 'exist(''num_ave'',''var'') == 1' ) == 1 % check if x_init is already defined.
    num_ave = evalin('base','num_ave');
else 
    num_ave = 2;
    assignin('base','num_ave',num_ave);
end

if evalin( 'base', 'exist(''n_acq_images'',''var'') == 1' ) == 1 % check if exposure_time is already defined.
    n_acq_images = evalin('base','n_acq_images');
else 
    n_acq_images = 3;
end


disp('START GETTING MULTIPLE IMAGES')

my_scan_end=0;

%get images
for i=1:n_acq_images
    temp=[num2str(i), '/' ,num2str(n_acq_images)];
    disp(temp);
    
    my_ave_img=0; % initialization
    
    for j=1:num_ave

        if i == n_acq_images && j == num_ave % the last acquisition
            my_scan_end=1; % 1 for closing the camera
        end

        [errorCode,ima_stack,glvar]=pco_camera_stack(imacount,glvar, my_scan_end);

        my_ave_img=my_ave_img+ima_stack/num_ave;

        if(errorCode==0)
         [~,~,count]=size(ima_stack);   
         if(count==1)
          m=max(max(ima_stack(10:end-10,10:end-10)));
        %  disp(['image done maxvalue: ',int2str(m)]);   
          if(bitand(cam_desc.dwGeneralCapsDESC1,GENERALCAPS1_NO_TIMESTAMP)==0)
           txt=subfunc.fh_print_timestamp_t(ima_stack,1,16);
           disp(['Image',num2str(j), ': ',txt]);
          end 
         else
          disp([int2str(count),' images done']);  
          if(bitand(cam_desc.dwGeneralCapsDESC1,GENERALCAPS1_NO_TIMESTAMP)==0)
           %reply = input('Show timestamps? Y/N [Y]: ', 's');
           reply(1)='Y'; %%%KS
           if((isempty(reply))||(reply(1)== 'Y')||(reply(1)== 'y'))
            for n=1:count
             txt=subfunc.fh_print_timestamp_t(ima_stack(:,:,n),1,16);
             disp(['Timestamp data of image ',num2str(n,'%04d'),': ',txt]);
            end
           end   
          end
         end 
        end 
    end
    
    temp=[datpath,'\im',num2str(i),'.png'];
    imwrite(my_ave_img, temp);
end

imshow(my_ave_img);

disp('FINISHED...')

subfunc.fh_stop_camera(out_ptr);

if(glvar.camera_open==1)
 glvar.do_close=1;
 glvar.do_libunload=1;
 pco_camera_open_close(glvar);
end   

clear glvar;
commandwindow;

end

