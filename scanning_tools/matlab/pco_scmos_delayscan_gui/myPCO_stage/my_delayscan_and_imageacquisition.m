function [my_ave_img,errorCode] = my_delayscan_and_imageacquisition(exposure_time,triggermode, shutter)
% * Input parameters :
%    exposure_time           camera exposure time (default=10ms)
%    triggermode             camera trigger mode (default=AUTO)
%    shutter                 activate (2) or deactivate (1) the shutter
% * Output parameters :
%    my_ave_img              Averaged images  
%    errorCode               ErrorCode returned from pco.camera SDK-functions  
%
%
%function workflow
%1. open camera
%2. set variables 
%3. start camera
%4. grab images for num_ave times and get an averaged image. If the shutter
% is activated, the difference of images recorded when the shutter is
% closed and opened is obtained.
%5. Move the stage and repeat 4.
%6. stop camera and stage
%7. close camera and stage
%


%%%%%%DELAY STAGE%%%%%%%%%
acc_val = 0.00015; % acceptance value for the delay stage

warning('off','all'); %ignore warning
if evalin( 'base', 'exist(''x_init'',''var'') == 1' ) == 1 % check if x_init is already defined.
    x_init = evalin('base','x_init');
else 
    x_init = 0;
    assignin('base','x_init',x_init);
end

if evalin( 'base', 'exist(''x_fin'',''var'') == 1' ) == 1 % check if x_fin is already defined.
    x_fin=evalin('base','x_fin');
else 
    x_fin = 60;
    assignin('base','x_fin',x_fin);
end

if evalin( 'base', 'exist(''n_step'',''var'') == 1' ) == 1 % check if n_step is already defined.
    n_step=evalin('base','n_step');
else 
    n_step=10;
    assignin('base', 'n_step', n_step);
end

dx=(x_fin-x_init)/n_step; %step size

asmInfo = NET.addAssembly('C:\Windows\Microsoft.NET\assembly\GAC_64\Newport.DLS.CommandInterface\v4.0_1.0.0.4__90ac4f829985d2bf\Newport.DLS.CommandInterface.dll'); % Make the assembly visible from Matlab
mydls = CommandInterfaceDLS.DLS(); % Make the instantiation
code=mydls.OpenInstrument('COM3'); % Open DLS connection

%%%%%%DELAY STAGE%%%%%%%%%




glvar=struct('do_libunload',0,'do_close',0,'camera_open',0,'out_ptr',[]);


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
datpath=[pwd, '\scan_images']; 
if exist(datpath, 'dir') % if a folder already exists, 
    rmdir scan_images s; % delete it
end
mkdir(datpath); % make a new folder


%%% Shutter %%%
s=serial('COM1'); % serial port object
s.Baudrate = 9600; % baud rate 
s.Terminator='CR'; 
fopen(s);
fprintf(s,'mode=1'); % manual mode

fprintf(s,'closed?'); % check whether the shutter is closed
for i=1:2
    fscanf(s);
end

shut=fscanf(s); 
shut=str2num(shut(1)); % 0 or 1

if shut == 1 % if the shutter is closed
    fprintf(s,'ens'); % open the shutter
end
%%% Shutter %%%


if evalin( 'base', 'exist(''num_ave'',''var'') == 1' ) == 1 % check if x_init is already defined.
    num_ave = evalin('base','num_ave');
else 
    num_ave = 2;
    assignin('base','num_ave',num_ave);
end



disp('..............');
disp('START SCANNING (IMAGE ACQUISITION)');
temp=['FROM ', num2str(x_init), ' mm TO ', num2str(x_fin), ' mm WITH ', num2str(n_step), ' STEPS.'];
disp(temp);


my_scan_end=0;

i=1; % initialization
for x = x_init:dx:x_fin % start scanning
    
    disp([num2str(i) , '/', num2str(n_step+1)]); % Show a progress

    code = mydls.PA_Set(x);
    diff=1000; % arbitrary large value

    while diff>acc_val % wait until the stage moves to the target position
        [code, x_current] = mydls.TP; % get current position
        diff=abs(x-x_current); % difference between the current and initial target position
        pause(0.5);
    end
    
    
    
    my_ave_img=0; % initialization
    
    %get images
    for j=1:num_ave
        for k=1:shutter % open - close
            
            if (j == num_ave) && (x == x_fin) && (k==shutter)  % the last acquisition
                my_scan_end=1; % 1 for closing the camera
            end

            [errorCode, ima_stack, glvar] = pco_camera_stack(1, glvar, my_scan_end);
            
            if shutter==1
                my_ave_img = my_ave_img + ima_stack/num_ave;
            else % shutter = 2
                if k==1 % shutter is opened
                    my_ave_img = my_ave_img + ima_stack/num_ave;
                else % shutter is closed
                    my_ave_img = my_ave_img - ima_stack/num_ave;                    
                end
               
                % If you want to get all images before averaging, you can
                % activate the following two lines of codes.
                %temp=[datpath,'\im_stagepos', num2str(i), '-ave', num2str(j), '-shutter', num2str(k),'.png']; %%
                %imwrite(ima_stack,temp) %%
                
                fprintf(s,'ens'); % open or close the shutter
                pause(0.1);
            end        
            
            if(errorCode==0)
            %  m=max(max(ima_stack(10:end-10,10:end-10)));
            %  disp(['image done maxvalue: ',int2str(m)]);   
                if(bitand(cam_desc.dwGeneralCapsDESC1,GENERALCAPS1_NO_TIMESTAMP)==0)
                    txt=subfunc.fh_print_timestamp_t(ima_stack,1,16); % timestamp
                    
                    if shutter==2 % shutter is used
                        if k==1 % shutter opened
                            disp(['Shutter opened. Image',num2str(j), ': ',txt]);
                        else % shutter closed
                            disp(['Shutter closed. Image',num2str(j), ': ',txt]);                            
                        end
                    else % shutter is not used
                        disp(['Image',num2str(j), ': ',txt]);
                    end
                end 
            end 

        end % end of the shutter 
        
    end % end of image averaging
    
    name_img= [datpath,'\ave_im', num2str(i), '.png'];
    imwrite(my_ave_img,name_img);
    
    i=i+1;
    
end % end of the delay scan

% Close DLS connection
code=mydls.CloseInstrument;


imshow(my_ave_img); % show the final image

fclose(s); % Close the shutter

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

