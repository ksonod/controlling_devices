function varargout = gui_stage_camera(varargin)
% GUI_STAGE_CAMERA MATLAB code for gui_stage_camera.fig
%      GUI_STAGE_CAMERA, by itself, creates a new GUI_STAGE_CAMERA or raises the existing
%      singleton*.
%
%      H = GUI_STAGE_CAMERA returns the handle to a new GUI_STAGE_CAMERA or the handle to
%      the existing singleton*.
%
%      GUI_STAGE_CAMERA('CALLBACK',hObject,eventData,handles,...) calls the local
%      function named CALLBACK in GUI_STAGE_CAMERA.M with the given input arguments.
%
%      GUI_STAGE_CAMERA('Property','Value',...) creates a new GUI_STAGE_CAMERA or raises the
%      existing singleton*.  Starting from the left, property value pairs are
%      applied to the GUI before gui_stage_camera_OpeningFcn gets called.  An
%      unrecognized property name or invalid value makes property application
%      stop.  All inputs are passed to gui_stage_camera_OpeningFcn via varargin.
%
%      *See GUI Options on GUIDE's Tools menu.  Choose "GUI allows only one
%      instance to run (singleton)".
%
% See also: GUIDE, GUIDATA, GUIHANDLES

% Edit the above text to modify the response to help gui_stage_camera

% Last Modified by GUIDE v2.5 22-Jan-2020 14:02:10

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
% This function has no output args, see OutputFcn.
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
% varargin   command line arguments to gui_stage_camera (see VARARGIN)

% Choose default command line output for gui_stage_camera
handles.output = hObject;

% Update handles structure
guidata(hObject, handles);

% UIWAIT makes gui_stage_camera wait for user response (see UIRESUME)
% uiwait(handles.figure1);


% --- Outputs from this function are returned to the command line.
function varargout = gui_stage_camera_OutputFcn(hObject, eventdata, handles) 
% varargout  cell array for returning output args (see VARARGOUT);
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Get default command line output from handles structure
varargout{1} = handles.output;


% --- Executes on button press in pushbutton1.
function pushbutton1_Callback(hObject, eventdata, handles)
% hObject    handle to pushbutton1 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

warning('off','all'); %ignore warning

asmInfo = NET.addAssembly('C:\Windows\Microsoft.NET\assembly\GAC_64\Newport.DLS.CommandInterface\v4.0_1.0.0.4__90ac4f829985d2bf\Newport.DLS.CommandInterface.dll'); % Make the assembly visible from Matlab
mydls = CommandInterfaceDLS.DLS(); % Make the instantiation
code=mydls.OpenInstrument('COM3'); % Open DLS connection


[code x_current] = mydls.TP; % get current position
[code v_current] = mydls.VA_Get; % get current velocity
[code a_current] = mydls.AC_Get; % get current acceleration

disp('--CURRENT SETTINGS--')
disp(['x = ',num2str(x_current), ' mm, v = ', num2str(v_current), ' mm/s, a = ',num2str(a_current), ' mm/s^2']);

% Close DLS connection
code=mydls.CloseInstrument;


% --- Executes on button press in pushbutton2.
function pushbutton2_Callback(hObject, eventdata, handles)
% hObject    handle to pushbutton2 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

NET.addAssembly('C:\Program Files\Thorlabs\Scientific Imaging\DCx Camera Support\Develop\DotNet\uc480DotNet.dll');  % Add NET assembly
cam=uc480.Camera;% Create camera object handle
cam.Init(0); % Open the 1st available camera
cam.Display.Mode.Set(uc480.Defines.DisplayMode.DiB); % Set display mode to bitmap (DiB)
cam.PixelFormat.Set(uc480.Defines.ColorMode.RGBA8Packed); % Set color mode to 8-bit RGB
cam.Trigger.Set(uc480.Defines.TriggerMode.Software); % Set trigger mode to software (signal image acquisition)
[~,MemId]=cam.Memory.Allocate(true); % Allocate image memory
[~, Width, Height, Bits,~] = cam.Memory.Inquire(MemId); % Obtain image information
cam.Acquisition.Freeze(uc480.Defines.DeviceParameter.Wait); % Acquire image
[~,tmp]=cam.Memory.CopyToArray(MemId); % Copy image from memory

% Reshape image
Data=reshape(uint8(tmp),[Bits/8, Width,Height]);
Data = Data(1:3, 1:Width, 1:Height);
Data = permute(Data, [3,2,1]);

himg = imshow(Data);% Display Image

cam.Exit; % Close camera


% --- Executes during object creation, after setting all properties.
function axes1_CreateFcn(hObject, eventdata, handles)
% hObject    handle to axes1 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: place code in OpeningFcn to populate axes1



function edit1_Callback(hObject, eventdata, handles)
% hObject    handle to edit1 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
warning('off','all'); %ignore warning
x_init= str2double(get(hObject,'String'));
assignin('base','x_init',x_init);


% --- Executes during object creation, after setting all properties.
function edit1_CreateFcn(hObject, eventdata, handles)
% hObject    handle to edit1 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function edit2_Callback(hObject, eventdata, handles)
% hObject    handle to edit2 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

warning('off','all'); %ignore warning
x_fin= str2double(get(hObject,'String'));
assignin('base','x_fin',x_fin);


% --- Executes during object creation, after setting all properties.
function edit2_CreateFcn(hObject, eventdata, handles)
% hObject    handle to edit2 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function edit3_Callback(hObject, eventdata, handles)
% hObject    handle to edit3 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
warning('off','all'); %ignore warning
n_step= str2num(get(hObject,'String'));
assignin('base','n_step',n_step);

% --- Executes during object creation, after setting all properties.
function edit3_CreateFcn(hObject, eventdata, handles)
% hObject    handle to edit3 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes on button press in pushbutton3.
function pushbutton3_Callback(hObject, eventdata, handles)
% hObject    handle to pushbutton3 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

warning('off','all'); %ignore warning

acc_val = 0.00015; % acceptance value 

x_init=evalin('base','x_init');
x_fin=evalin('base','x_fin');
n_step=evalin('base','n_step');

dx=(x_fin-x_init)/n_step; %step size


asmInfo = NET.addAssembly('C:\Windows\Microsoft.NET\assembly\GAC_64\Newport.DLS.CommandInterface\v4.0_1.0.0.4__90ac4f829985d2bf\Newport.DLS.CommandInterface.dll'); % Make the assembly visible from Matlab
mydls = CommandInterfaceDLS.DLS(); % Make the instantiation
code=mydls.OpenInstrument('COM3'); % Open DLS connection

disp('..............');
disp('START SCANNING');

i=1; % initialization
for x = x_init:dx:x_fin % start scanning
    code = mydls.PA_Set(x);
    diff=1000; % arbitrary large value

    while diff>acc_val % wait until the stage moves to the target position
        [code x_current] = mydls.TP; % get current position
        diff=abs(x-x_current); % difference between the current and initial target position
        pause(0.5);
    end

%    [code x_current] = mydls.TP; % get current position
%    disp(['current position: ',num2str(x_current)]);
    disp([num2str(i) , '/', num2str(n_step+1)]); % Show a progress
    
    i=i+1;    
end

% Close DLS connection
code=mydls.CloseInstrument;

disp('FINISH...')


% --- Executes on button press in pushbutton4.
function pushbutton4_Callback(hObject, eventdata, handles)
% hObject    handle to pushbutton4 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
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



function edit4_Callback(hObject, eventdata, handles)
% hObject    handle to edit4 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of edit4 as text
%        str2double(get(hObject,'String')) returns contents of edit4 as a double

warning('off','all'); %ignore warning
asmInfo = NET.addAssembly('C:\Windows\Microsoft.NET\assembly\GAC_64\Newport.DLS.CommandInterface\v4.0_1.0.0.4__90ac4f829985d2bf\Newport.DLS.CommandInterface.dll'); % Make the assembly visible from Matlab
mydls = CommandInterfaceDLS.DLS(); % Make the instantiation
code=mydls.OpenInstrument('COM3'); % Open DLS connection
code = mydls.PA_Set(str2double(get(hObject,'String')));

assignin('base','x_set',str2double(get(hObject,'String')));

code=mydls.CloseInstrument;


% --- Executes during object creation, after setting all properties.
function edit4_CreateFcn(hObject, eventdata, handles)
% hObject    handle to edit4 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function edit5_Callback(hObject, eventdata, handles)
% hObject    handle to edit5 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
warning('off','all'); %ignore warning
asmInfo = NET.addAssembly('C:\Windows\Microsoft.NET\assembly\GAC_64\Newport.DLS.CommandInterface\v4.0_1.0.0.4__90ac4f829985d2bf\Newport.DLS.CommandInterface.dll'); % Make the assembly visible from Matlab
mydls = CommandInterfaceDLS.DLS(); % Make the instantiation
code=mydls.OpenInstrument('COM3'); % Open DLS connection
code = mydls.VA_Set(str2double(get(hObject,'String')));
assignin('base','v_set',str2double(get(hObject,'String')));

code=mydls.CloseInstrument;

% --- Executes during object creation, after setting all properties.
function edit5_CreateFcn(hObject, eventdata, handles)
% hObject    handle to edit5 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function edit6_Callback(hObject, eventdata, handles)
% hObject    handle to edit6 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
warning('off','all'); %ignore warning
asmInfo = NET.addAssembly('C:\Windows\Microsoft.NET\assembly\GAC_64\Newport.DLS.CommandInterface\v4.0_1.0.0.4__90ac4f829985d2bf\Newport.DLS.CommandInterface.dll'); % Make the assembly visible from Matlab
mydls = CommandInterfaceDLS.DLS(); % Make the instantiation
code=mydls.OpenInstrument('COM3'); % Open DLS connection
code = mydls.AC_Set(str2double(get(hObject,'String')));
assignin('base','a_set',str2double(get(hObject,'String')));
code=mydls.CloseInstrument;

% --- Executes during object creation, after setting all properties.
function edit6_CreateFcn(hObject, eventdata, handles)
% hObject    handle to edit6 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes on button press in pushbutton5.
function pushbutton5_Callback(hObject, eventdata, handles)
% hObject    handle to pushbutton5 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

warning('off','all'); %ignore warning

acc_val = 0.00015; % acceptance value 

x_init=evalin('base','x_init');
x_fin=evalin('base','x_fin');
n_step=evalin('base','n_step');

dx=(x_fin-x_init)/n_step; %step size

%%% CAMERA %%%%
% Add NET assembly
asmInfo = NET.addAssembly('C:\Program Files\Thorlabs\Scientific Imaging\DCx Camera Support\Develop\DotNet\uc480DotNet.dll'); 
cam=uc480.Camera; % Create camera object handle
cam.Init(0); % Open the 1st available camera
cam.Display.Mode.Set(uc480.Defines.DisplayMode.DiB); % Set display mode to bitmap (DiB)
cam.PixelFormat.Set(uc480.Defines.ColorMode.RGBA8Packed); % Set color mode to 8-bit RGB
cam.Trigger.Set(uc480.Defines.TriggerMode.Software); % Set trigger mode to software (signal image acquisition)
%%% CAMERA %%%%


%%% STAGE %%%
asmInfo = NET.addAssembly('C:\Windows\Microsoft.NET\assembly\GAC_64\Newport.DLS.CommandInterface\v4.0_1.0.0.4__90ac4f829985d2bf\Newport.DLS.CommandInterface.dll'); % Make the assembly visible from Matlab
mydls = CommandInterfaceDLS.DLS(); % Make the instantiation
code=mydls.OpenInstrument('COM3'); % Open DLS connection
%%% STAGE %%%

datpath=[pwd, '\scan_images']; 
if ~exist(datpath) % if a folder does not exist, 
    mkdir(datpath); % make it for saving images
end

disp('..............');
disp(['scan range: ', num2str(x_init) , ' to ', num2str(x_fin)]);
disp('START SCANNING');

i=1; % initialization
for x = x_init:dx:x_fin % start scanning
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
    
    himg = imshow(Data); % Show an image
    
    disp([num2str(i) , '/', num2str(n_step+1)]); % Show a progress

    % Save an image
    name_img= [datpath,'\img', num2str(i), '.png'];
    imwrite(Data,name_img);
     
    i=i+1;    
end

% Close camera
cam.Exit;

% Close DLS connection
code=mydls.CloseInstrument;

disp('FINISH...')
