function varargout = gui_stage_camera(varargin)
% GUI_STAGE_CAMERA MATLAB code for gui_stage_camera.fig
% Made by Dr Sonoda.
% With this GUI, you can do the following things:
% - Controlling Newport Linear Stage
% - Opening and closing a Thorlabs optical shutter
% - Showing a live view of Thorlabs camera
% - Getting images as a function of the stage coordinate
% 

% Last Modified by GUIDE v2.5 12-Aug-2020 13:19:54

% Begin initialization code - DO NOT EDIT
gui_Singleton = 1;
gui_State = struct('gui_Name',       mfilename, ...
                   'gui_Singleton',  gui_Singleton, ...
                   'gui_OpeningFcn', @gui_stage_camera_OpeningFcn, ...
                   'gui_OutputFcn',  @gui_stage_camera_OutputFcn, ...
                   'gui_LayoutFcn',  [] , ...
                   'gui_Callback',   []);
if nargin && ischar(varargin{1})
    gui_State.gui_Callback = str2func(varargin{1});
end

if nargout
    [varargout{1:nargout}] = gui_mainfcn(gui_State, varargin{:});
else
    gui_mainfcn(gui_State, varargin{:});
end
% End initialization code - DO NOT EDIT


% --- Executes just before gui_stage_camera is made visible.
function gui_stage_camera_OpeningFcn(hObject, eventdata, handles, varargin)
handles.output = hObject;
guidata(hObject, handles);


% --- Outputs from this function are returned to the command line.
function varargout = gui_stage_camera_OutputFcn(hObject, eventdata, handles) 
varargout{1} = handles.output;


%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% My GUI

% Get images with a Thorlabs camera
function pushbutton1_Callback(hObject, eventdata, handles)
% hObject    handle to pushbutton1 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

warning('off','all'); %ignore warning
handles.stop_now = 0; 
guidata(hObject,handles);  %Update the GUI data

if evalin( 'base', 'exist(''exposure_time'',''var'') == 1' ) == 1 % check if exposure_time is already defined.
    exposure_time = evalin('base','exposure_time');
else 
    exposure_time = 60;
end

if evalin( 'base', 'exist(''color_option'',''var'') == 1' ) == 1 % check if color_option is already defined.
    color_option = evalin('base','color_option');
else 
    color_option = 1; % color
end
    
NET.addAssembly([pwd,'\uc480DotNet.dll']);  % Add NET assembly
cam=uc480.Camera;% Create camera object handle
cam.Init(0); % Open the 1st available camera
cam.Display.Mode.Set(uc480.Defines.DisplayMode.DiB); % Set display mode to bitmap (DiB)
cam.PixelFormat.Set(uc480.Defines.ColorMode.RGBA8Packed); % Set color mode to 8-bit RGB
cam.Trigger.Set(uc480.Defines.TriggerMode.Software); % Set trigger mode to software (signal image acquisition)
cam.Timing.Exposure.Set(exposure_time); % setting exposure time

while ~(handles.stop_now) % Show images until the stop button is clicked.
    [~,MemId]=cam.Memory.Allocate(true); % Allocate image memory
    [~, Width, Height, Bits,~] = cam.Memory.Inquire(MemId); % Obtain image information
    cam.Acquisition.Freeze(uc480.Defines.DeviceParameter.Wait); % Acquire image
    [~,tmp]=cam.Memory.CopyToArray(MemId); % Copy image from memory


    % Reshape image
    Data=reshape(uint8(tmp),[Bits/8, Width,Height]);
    Data = Data(1:3, 1:Width, 1:Height);
    Data = permute(Data, [3,2,1]);

    if color_option == 0 % gray scale
        num_levels=150; %  adjustable parameter for better visibility
        imshow(rgb2gray(Data),jet(num_levels));% Display Image
    else % color
        imshow(Data); % display image
    end

    message= sprintf('Maximum intensity (greyscale) = %d',max(rgb2gray(Data),[],'all')); % get the maximum value
    set(handles.text11, 'string', message); % show the maximum value

    drawnow %Update figures and processees
    handles = guidata(hObject); %Get the newest GUI data    
end
    
cam.Exit; % Close camera


%Text box for exposure time.
function edit1_Callback(hObject, eventdata, handles)

exposure_time = str2double(get(hObject,'String'));
assignin('base','exposure_time',exposure_time);

function edit1_CreateFcn(hObject, eventdata, handles)

if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% Check box for choosing color or gray
function checkbox1_Callback(hObject, eventdata, handles)

color_option=get(hObject,'Value');
assignin('base','color_option',color_option);
% 0 = not clicked (gray scale). 
% 1 = clicked (color)


% Current settings for the delay stage and camera
function pushbutton2_Callback(hObject, eventdata, handles)

warning('off','all'); %ignore warning

%asmInfo = NET.addAssembly('C:\Windows\Microsoft.NET\assembly\GAC_64\Newport.DLS.CommandInterface\v4.0_1.0.0.4__90ac4f829985d2bf\Newport.DLS.CommandInterface.dll'); % Make the assembly visible from Matlab
asmInfo = NET.addAssembly([pwd,'\Newport.DLS.CommandInterface.dll']); % Make the assembly visible from Matlab
mydls = CommandInterfaceDLS.DLS(); % Make the instantiation
code=mydls.OpenInstrument('COM3'); % Open DLS connection


[code x_current] = mydls.TP; % get current position
[code v_current] = mydls.VA_Get; % get current velocity
[code a_current] = mydls.AC_Get; % get current acceleration

disp('--CURRENT SETTINGS OF THE DELAY STAGE--')
disp(['x = ',num2str(x_current), ' mm, v = ', num2str(v_current), ' mm/s, a = ',num2str(a_current), ' mm/s^2']);

code=mydls.CloseInstrument; % Close DLS connection


% Changing the position of the delaty stage
function edit2_Callback(hObject, eventdata, handles)
warning('off','all'); %ignore warning
asmInfo = NET.addAssembly([pwd,'\Newport.DLS.CommandInterface.dll']); % Make the assembly visible from Matlab
mydls = CommandInterfaceDLS.DLS(); % Make the instantiation
code=mydls.OpenInstrument('COM3'); % Open DLS connection
code = mydls.PA_Set(str2double(get(hObject,'String')));
code=mydls.CloseInstrument;

% --- Executes during object creation, after setting all properties.
function edit2_CreateFcn(hObject, eventdata, handles)
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% Changing the velocity of the delay stage
function edit3_Callback(hObject, eventdata, handles)
warning('off','all'); %ignore warning
asmInfo = NET.addAssembly([pwd,'\Newport.DLS.CommandInterface.dll']); % Make the assembly visible from Matlab
mydls = CommandInterfaceDLS.DLS(); % Make the instantiation
code=mydls.OpenInstrument('COM3'); % Open DLS connection
code = mydls.VA_Set(str2double(get(hObject,'String')));
code=mydls.CloseInstrument;

% --- Executes during object creation, after setting all properties.
function edit3_CreateFcn(hObject, eventdata, handles)
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% Changing the acceleration of the delay stage
function edit4_Callback(hObject, eventdata, handles)
warning('off','all'); %ignore warning
asmInfo = NET.addAssembly([pwd,'\Newport.DLS.CommandInterface.dll']); % Make the assembly visible from Matlab
mydls = CommandInterfaceDLS.DLS(); % Make the instantiation
code=mydls.OpenInstrument('COM3'); % Open DLS connection
code = mydls.AC_Set(str2double(get(hObject,'String')));
code=mydls.CloseInstrument;

% --- Executes during object creation, after setting all properties.
function edit4_CreateFcn(hObject, eventdata, handles)
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% Setting the initial position of the scan
function edit5_Callback(hObject, eventdata, handles)
warning('off','all'); %ignore warning
x_init= str2double(get(hObject,'String'));
assignin('base','x_init',x_init);

% --- Executes during object creation, after setting all properties.
function edit5_CreateFcn(hObject, eventdata, handles)
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% Setting the final position of the scan
function edit6_Callback(hObject, eventdata, handles)
warning('off','all'); %ignore warning
x_fin= str2double(get(hObject,'String'));
assignin('base','x_fin',x_fin);

% --- Executes during object creation, after setting all properties.
function edit6_CreateFcn(hObject, eventdata, handles)
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end

% Setting number of steps
function edit7_Callback(hObject, eventdata, handles)
warning('off','all'); %ignore warning
n_step= str2num(get(hObject,'String'));
assignin('base','n_step',n_step);

% --- Executes during object creation, after setting all properties.
function edit7_CreateFcn(hObject, eventdata, handles)
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Calculating time settings
function pushbutton3_Callback(hObject, eventdata, handles)

warning('off','all'); %ignore warning
c_light=299792458; %speed of light
x_init=evalin('base','x_init');
x_fin=evalin('base','x_fin');
n_step=evalin('base','n_step');

dx = abs(x_fin-x_init)/double(n_step);  %step
t_step= 2 * dx/c_light*1e12; % fs
t_range=2 * abs(x_fin-x_init)/c_light*1e12; % fs

unit_tim_step=' fs/step' ;
unit_tim_range=' fs' ;

if t_step>1000
    t_step = t_step/1000; % ps
    unit_tim_step = ' ps/step';
end

if t_range>1000
    t_range = t_range/1000; % ps
    unit_tim_range = ' ps';
end

disp('--TIME SETTINGS--')
disp(['time step = ', num2str(t_step), unit_tim_step, ' | scan range = ', num2str(t_range), unit_tim_range]);


% --- Start Scanning
function pushbutton4_Callback(hObject, eventdata, handles)
warning('off','all'); %ignore warning

handles.stop_now = 0; 
guidata(hObject,handles);  %Update the GUI data

if evalin( 'base', 'exist(''exposure_time'',''var'') == 1' ) == 1 % check if exposure_time is already defined.
    exposure_time = evalin('base','exposure_time');
else 
    exposure_time = 60;
end

if evalin( 'base', 'exist(''color_option'',''var'') == 1' ) == 1 % check if color_option is already defined.
    color_option = evalin('base','color_option');
else 
    color_option = 1; % color
end


acc_val = 0.00015; % acceptance value 

x_init=evalin('base','x_init');
x_fin=evalin('base','x_fin');
n_step=evalin('base','n_step');

dx=(x_fin-x_init)/n_step; %step size

%%% CAMERA %%%%
% Add NET assembly
asmInfo = NET.addAssembly([pwd,'\uc480DotNet.dll']); 
cam=uc480.Camera; % Create camera object handle
cam.Init(0); % Open the 1st available camera
cam.Display.Mode.Set(uc480.Defines.DisplayMode.DiB); % Set display mode to bitmap (DiB)
cam.PixelFormat.Set(uc480.Defines.ColorMode.RGBA8Packed); % Set color mode to 8-bit RGB
cam.Trigger.Set(uc480.Defines.TriggerMode.Software); % Set trigger mode to software (signal image acquisition)
cam.Timing.Exposure.Set(exposure_time); % setting exposure time
%%% CAMERA %%%%


%%% STAGE %%%
asmInfo = NET.addAssembly([pwd,'\Newport.DLS.CommandInterface.dll']); % Make the assembly visible from Matlab
mydls = CommandInterfaceDLS.DLS(); % Make the instantiation
code=mydls.OpenInstrument('COM3'); % Open DLS connection
%%% STAGE %%%

datpath=[pwd, '\scan_images']; 
if ~exist(datpath) % if a folder does not exist, 
    mkdir(datpath); % make it for saving images
end



[code v_current] = mydls.VA_Get; % get current velocity
[code a_current] = mydls.AC_Get; % get current acceleration

fileID = fopen([datpath,'\scan_info.txt'],'w'); % create a text file for writing scan information
fprintf(fileID, '**************************\r\n SCAN INFORMATION\r\n**************************\r\n ');
fprintf(fileID, '%s',datetime);
fprintf(fileID, '\r\n**************************\r\n');
fprintf(fileID, 'Exposure time (ms): %f \r\n', exposure_time);
fprintf(fileID, 'Velocity (mm/s): %f \r\n', v_current);
fprintf(fileID, 'Acceleration (mm/s/s): %f \r\n', a_current);
fprintf(fileID, 'Scan rage (mm): %f to %f \r\n',x_init, x_fin);
fprintf(fileID, 'Number of divisions: %d \r\n', n_step);
fprintf(fileID, 'Number of steps: %d \r\n',n_step+1);
fprintf(fileID, '**************************\r\n');
fprintf(fileID, 'Stage position\r\n');


disp('..............');
disp(['scan range: ', num2str(x_init) , ' to ', num2str(x_fin)]);
disp('START SCANNING');

i=1; % initialization
   
    
for x = x_init:dx:x_fin % start scanning

    fprintf(fileID, '%f\r\n',x);% write the current stage position

    code = mydls.PA_Set(x);
    diff=1000; % arbitrary large value

    while diff>acc_val % wait until the stage moves to the target position
        [code x_current] = mydls.TP; % get current position
        diff=abs(x-x_current); % difference between the current and initial target position
        pause(0.5);
    end

    [~,MemId]=cam.Memory.Allocate(true); % Allocate image memory
    [~, Width, Height, Bits,~] = cam.Memory.Inquire(MemId); % Obtain image information
    cam.Acquisition.Freeze(uc480.Defines.DeviceParameter.Wait);% Acquire image
    [~,tmp]=cam.Memory.CopyToArray(MemId);     % Copy image from memory

    % Reshape image  
    Data=reshape(uint8(tmp),[Bits/8, Width,Height]);  
    Data = Data(1:3, 1:Width, 1:Height);  
    Data = permute(Data, [3,2,1]);     


    disp([num2str(i) , '/', num2str(n_step+1)]); % Show a progress  

    % Save and show an image  
    name_img= [datpath,'\img', num2str(i), '.png'];

    if color_option == 0 % gray scale  
        imwrite(rgb2gray(Data),name_img);   
        imshow(rgb2gray(Data),jet(150));   
    else % color  
        imwrite(Data,name_img); 
        imshow(Data);    
    end
    
    message= sprintf('Maximum intensity (greyscale) = %d',max(rgb2gray(Data),[],'all')); % get the maximum value
    set(handles.text11, 'string', message); % show the maximum value

    i=i+1; %Update 

    drawnow %Give the button callback a chance to interrupt 
    handles = guidata(hObject); %Get the newest GUI data

    if handles.stop_now==1
        break;
    end
end
    

% Close camera
cam.Exit;

% Close DLS connection
code=mydls.CloseInstrument;

fclose(fileID); % close the file when finish writing.

disp('FINISH...')


% --- Stop button.
function pushbutton5_Callback(hObject, eventdata, handles)
% hObject    handle to pushbutton5 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
handles.stop_now = 1;
guidata(hObject, handles);


% --- Optical shutter button open/close.
function pushbutton7_Callback(hObject, eventdata, handles)
s=serial('COM1'); % serial port object
s.Baudrate = 9600; % baud rate 
s.Terminator='CR'; 
fopen(s);
fprintf(s,'mode=1'); % manual mode
fprintf(s,'ens'); % send a command to the shutter

pause(0.2); % wait

fprintf(s,'closed?');
for i=1:3
    fscanf(s);
end

shut=fscanf(s); 
shut=str2num(shut(1)); % 0 (opened) or 1 (closed)

if shut == 0 % shutter is opened
    message= sprintf('Shutter opened'); 
else % shutter is closed
    message= sprintf('Shutter closed'); 
end

set(handles.text12, 'string', message);


fclose(s);


% --- Scan and take difference of images with shutter on/off
function pushbutton8_Callback(hObject, eventdata, handles)
warning('off','all'); %ignore warning

handles.stop_now = 0; 
guidata(hObject,handles);  %Update the GUI data

if evalin( 'base', 'exist(''exposure_time'',''var'') == 1' ) == 1 % check if exposure_time is already defined.
    exposure_time = evalin('base','exposure_time');
else 
    exposure_time = 60;
end

if evalin( 'base', 'exist(''color_option'',''var'') == 1' ) == 1 % check if color_option is already defined.
    color_option = evalin('base','color_option');
else 
    color_option = 1; % color
end


acc_val = 0.00015; % acceptance value 

x_init=evalin('base','x_init');
x_fin=evalin('base','x_fin');
n_step=evalin('base','n_step');

dx=(x_fin-x_init)/n_step; %step size

%%% CAMERA %%%%
% Add NET assembly
asmInfo = NET.addAssembly([pwd,'\uc480DotNet.dll']); 
cam=uc480.Camera; % Create camera object handle
cam.Init(0); % Open the 1st available camera
cam.Display.Mode.Set(uc480.Defines.DisplayMode.DiB); % Set display mode to bitmap (DiB)
cam.PixelFormat.Set(uc480.Defines.ColorMode.RGBA8Packed); % Set color mode to 8-bit RGB
cam.Trigger.Set(uc480.Defines.TriggerMode.Software); % Set trigger mode to software (signal image acquisition)
cam.Timing.Exposure.Set(exposure_time); % setting exposure time
%%% CAMERA %%%%


%%% STAGE %%%
asmInfo = NET.addAssembly([pwd,'\Newport.DLS.CommandInterface.dll']); % Make the assembly visible from Matlab
mydls = CommandInterfaceDLS.DLS(); % Make the instantiation
code=mydls.OpenInstrument('COM3'); % Open DLS connection
%%% STAGE %%%

%%% SHUTTER %%%
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
%%% SHUTTER %%%



datpath=[pwd, '\scan_images']; 
if ~exist(datpath) % if a folder does not exist, 
    mkdir(datpath); % make it for saving images
end



[code v_current] = mydls.VA_Get; % get current velocity
[code a_current] = mydls.AC_Get; % get current acceleration

fileID = fopen([datpath,'\scan_info.txt'],'w'); % create a text file for writing scan information
fprintf(fileID, '**************************\r\n DIFFERENCE SCAN INFORMATION\r\n**************************\r\n ');
fprintf(fileID, '%s',datetime);
fprintf(fileID, '\r\n**************************\r\n');
fprintf(fileID, 'Exposure time (ms): %f \r\n', exposure_time);
fprintf(fileID, 'Velocity (mm/s): %f \r\n', v_current);
fprintf(fileID, 'Acceleration (mm/s/s): %f \r\n', a_current);
fprintf(fileID, 'Scan rage (mm): %f to %f \r\n',x_init, x_fin);
fprintf(fileID, 'Number of divisions: %d \r\n', n_step);
fprintf(fileID, 'Number of steps: %d \r\n',n_step+1);
fprintf(fileID, '**************************\r\n');
fprintf(fileID, 'Stage position\r\n');


disp('..............');
disp(['scan range: ', num2str(x_init) , ' to ', num2str(x_fin)]);
disp('START SCANNING');

i=1; % initialization
   
    
for x = x_init:dx:x_fin % start scanning

    fprintf(fileID, '%f\r\n',x);% write the current stage position

    code = mydls.PA_Set(x);
    diff=1000; % arbitrary large value

    while diff>acc_val % wait until the stage moves to the target position
        [code x_current] = mydls.TP; % get current position
        diff=abs(x-x_current); % difference between the current and initial target position
        pause(0.5);
    end
    
    
    for j=1:2

        [~,MemId]=cam.Memory.Allocate(true); % Allocate image memory
        [~, Width, Height, Bits,~] = cam.Memory.Inquire(MemId); % Obtain image information
        cam.Acquisition.Freeze(uc480.Defines.DeviceParameter.Wait);% Acquire image
        [~,tmp]=cam.Memory.CopyToArray(MemId);     % Copy image from memory

        % Reshape image  
        Data=reshape(uint8(tmp),[Bits/8, Width,Height]);  
        Data = Data(1:3, 1:Width, 1:Height);  
        Data = permute(Data, [3,2,1]);     
        Data=rgb2gray(Data); % convert to grayscale
    
        if j==1 % when the shutter is opened
            Data_opened=Data; 
        end
        
        fprintf(s,'ens'); % open or close the shutter
        pause(0.2);
    end

    disp([num2str(i) , '/', num2str(n_step+1)]); % Show a progress  

    % Save and show an difference data  
    name_img= [datpath,'\img_diff', num2str(i), '.png'];
    imshow(Data_opened-Data, jet(15));   
    imwrite(Data_opened-Data, name_img);    
    
    message= sprintf('Maximum difference (greyscale) = %d',max(Data_opened-Data,[],'all')); % get the maximum value
    set(handles.text11, 'string', message); % show the maximum value

    i=i+1; %Update 

    drawnow %Give the button callback a chance to interrupt 
    handles = guidata(hObject); %Get the newest GUI data

    if handles.stop_now==1
        break;
    end
end
    

% Close camera
cam.Exit;

% Close DLS connection
code=mydls.CloseInstrument;

fclose(fileID); % close the file when finish writing.

fclose(s); % Close the shutter
disp('FINISH...')
