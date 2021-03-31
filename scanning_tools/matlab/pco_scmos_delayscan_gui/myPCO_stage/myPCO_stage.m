function varargout = myPCO_stage(varargin)
% Last Modified by GUIDE v2.5 03-Feb-2020 15:44:25

% Begin initialization code - DO NOT EDIT
gui_Singleton = 1;
gui_State = struct('gui_Name',       mfilename, ...
                   'gui_Singleton',  gui_Singleton, ...
                   'gui_OpeningFcn', @myPCO_stage_OpeningFcn, ...
                   'gui_OutputFcn',  @myPCO_stage_OutputFcn, ...
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


% --- Executes just before myPCO_stage is made visible.
function myPCO_stage_OpeningFcn(hObject, eventdata, handles, varargin)
handles.output = hObject;
guidata(hObject, handles);

% --- Outputs from this function are returned to the command line.
function varargout = myPCO_stage_OutputFcn(hObject, eventdata, handles) 
varargout{1} = handles.output;


% Get a single image.
function pushbutton1_Callback(hObject, eventdata, handles)
if evalin( 'base', 'exist(''exposure_time'',''var'') == 1' ) == 1 % check if exposure_time is already defined.
    exposure_time = evalin('base','exposure_time');
else 
    exposure_time = 700;
end

[img, errorCode]=pco_sdk_example_stack(1, exposure_time, 0);
%imshow(img);
assignin('base','averaged_image',img); % save in workspace


% Exposure time
function edit1_Callback(hObject, eventdata, handles)
exposure_time=str2double(get(hObject,'String')) ;
assignin('base','exposure_time',exposure_time);  % save in workspace


function edit1_CreateFcn(hObject, eventdata, handles)
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Get current settings for the delay stage
function pushbutton2_Callback(hObject, eventdata, handles)
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


% Change the stage position
function edit2_Callback(hObject, eventdata, handles)
warning('off','all'); %ignore warning
asmInfo = NET.addAssembly('C:\Windows\Microsoft.NET\assembly\GAC_64\Newport.DLS.CommandInterface\v4.0_1.0.0.4__90ac4f829985d2bf\Newport.DLS.CommandInterface.dll'); % Make the assembly visible from Matlab
mydls = CommandInterfaceDLS.DLS(); % Make the instantiation
code = mydls.OpenInstrument('COM3'); % Open DLS connection
code = mydls.PA_Set(str2double(get(hObject,'String')));
assignin('base','x_set',str2double(get(hObject,'String')));
code=mydls.CloseInstrument;



% --- Executes during object creation, after setting all properties.
function edit2_CreateFcn(hObject, eventdata, handles)
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% Change the velocity
function edit3_Callback(hObject, eventdata, handles)
warning('off','all'); %ignore warning
asmInfo = NET.addAssembly('C:\Windows\Microsoft.NET\assembly\GAC_64\Newport.DLS.CommandInterface\v4.0_1.0.0.4__90ac4f829985d2bf\Newport.DLS.CommandInterface.dll'); % Make the assembly visible from Matlab
mydls = CommandInterfaceDLS.DLS(); % Make the instantiation
code = mydls.OpenInstrument('COM3'); % Open DLS connection
code = mydls.VA_Set(str2double(get(hObject,'String')));
assignin('base','v_set',str2double(get(hObject,'String')));
code=mydls.CloseInstrument;

% --- Executes during object creation, after setting all properties.
function edit3_CreateFcn(hObject, eventdata, handles)
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% Change the acceleration
function edit4_Callback(hObject, eventdata, handles)
warning('off','all'); %ignore warning
asmInfo = NET.addAssembly('C:\Windows\Microsoft.NET\assembly\GAC_64\Newport.DLS.CommandInterface\v4.0_1.0.0.4__90ac4f829985d2bf\Newport.DLS.CommandInterface.dll'); % Make the assembly visible from Matlab
mydls = CommandInterfaceDLS.DLS(); % Make the instantiation
code=mydls.OpenInstrument('COM3'); % Open DLS connection
code = mydls.AC_Set(str2double(get(hObject,'String')));
assignin('base','a_set',str2double(get(hObject,'String')));
code=mydls.CloseInstrument;


% --- Executes during object creation, after setting all properties.
function edit4_CreateFcn(hObject, eventdata, handles)
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end

% Set the initial position for the delay scan
function edit5_Callback(hObject, eventdata, handles)
x_init= str2double(get(hObject,'String'));
assignin('base','x_init',x_init);

% --- Executes during object creation, after setting all properties.
function edit5_CreateFcn(hObject, eventdata, handles)
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end

% Set the final position for the delay scan
function edit6_Callback(hObject, eventdata, handles)
x_fin= str2double(get(hObject,'String'));
assignin('base','x_fin',x_fin);

% --- Executes during object creation, after setting all properties.
function edit6_CreateFcn(hObject, eventdata, handles)
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% Set the number of steps for the delay scan
function edit7_Callback(hObject, eventdata, handles)
n_step= str2num(get(hObject,'String'));
assignin('base','n_step',n_step);


% --- Executes during object creation, after setting all properties.
function edit7_CreateFcn(hObject, eventdata, handles)
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



% Move the stage. No data acquisition
function pushbutton3_Callback(hObject, eventdata, handles)

warning('off','all'); %ignore warning
acc_val = 0.00015; % acceptance value 

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

disp('..............');
disp('START SCANNING');
temp=['FROM ', num2str(x_init), ' mm TO ', num2str(x_fin), ' mm WITH ', num2str(n_step), ' STEPS.'];
disp(temp);

i=1; % initialization
for x = x_init:dx:x_fin % start scanning
    code = mydls.PA_Set(x); % move the stage
    diff=1000; % arbitrary large value

    while diff>acc_val % wait until the stage moves to the target position
        [code, x_current] = mydls.TP; % get current position
        diff=abs(x-x_current); % difference between the current and initial target position
        pause(0.5);
    end

%    [code x_current] = mydls.TP; % get current position
%    disp(['current position: ',num2str(x_current)]);
    disp([num2str(i) , '/', num2str(n_step+1)]); % Show a progress
    
    i=i+1;    
end

code=mydls.CloseInstrument; % Close DLS connection

%evalin( 'base', 'clear x_init x_fin n_step' )
disp('FINISH...')


% Open/close shutter
function pushbutton4_Callback(hObject, eventdata, handles)
s=serial('COM1'); % serial port object
s.Baudrate = 9600; % baud rate 
s.Terminator='CR'; 
fopen(s);
fprintf(s,'mode=1'); % manual mode
fprintf(s,'ens'); % send a command to the shutter

pause(0.1); % wait

fprintf(s,'closed?');
for i=1:3
    fscanf(s);
end

shut=fscanf(s); 
shut=str2num(shut(1)); % 0 (opened) or 1 (closed)

if shut == 0 % shutter is opened
    disp('Shutter opened.');
else % shutter is closed
    disp('Shutter closed.');
end

fclose(s);


% Number of images to average data 
function edit9_Callback(hObject, eventdata, handles)
num_ave= str2double(get(hObject,'String'));
assignin('base', 'num_ave', num_ave);

% --- Executes during object creation, after setting all properties.
function edit9_CreateFcn(hObject, eventdata, handles)
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% Save a single image
function pushbutton5_Callback(hObject, eventdata, handles)

if evalin( 'base', 'exist(''averaged_image'',''var'') == 1' ) == 1 % check if averaged_image exists.
    averaged_image = evalin('base','averaged_image');
    imwrite(averaged_image,'averaged_image.png');
    disp('Saved.')
end


% Move the stage and get images. The shutter is not activated.
function pushbutton7_Callback(hObject, eventdata, handles)
if evalin( 'base', 'exist(''exposure_time'',''var'') == 1' ) == 1 % check if exposure_time is already defined.
    exposure_time = evalin('base','exposure_time');
else 
    exposure_time = 700;
end

[my_ave_img,errorCode] = my_delayscan_and_imageacquisition(exposure_time,0,1);


% Calculate the time settings
function pushbutton9_Callback(hObject, eventdata, handles)
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


% Delay scan and image acquisition. The shutter is activated.
function pushbutton10_Callback(hObject, eventdata, handles)
if evalin( 'base', 'exist(''exposure_time'',''var'') == 1' ) == 1 % check if exposure_time is already defined.
    exposure_time = evalin('base','exposure_time');
else 
    exposure_time = 700;
end

[my_ave_img,errorCode] = my_delayscan_and_imageacquisition(exposure_time,0, 2); % shutter 


% Picomotor
function pushbutton11_Callback(hObject, eventdata, handles)
    asmInfo = NET.addAssembly('C:\Program Files\New Focus\New Focus Picomotor Application\Samples\UsbDllWrap.dll'); %load UsbDllWrap.dll library
    asm_type = asmInfo.AssemblyHandle.GetType('Newport.USBComm.USB');
    NP_USB = System.Activator.CreateInstance(asm_type); 
    NP_USB.OpenDevices();  %Open the USB device

    querydata = System.Text.StringBuilder(64);
    NP_USB.Query(1, '*IDN?', querydata);    
    NP_USB.Write(1,['1PR-2000']); %relative move
    NP_USB.CloseDevices();  %Close


% Picomotor
function pushbutton12_Callback(hObject, eventdata, handles)
    asmInfo = NET.addAssembly('C:\Program Files\New Focus\New Focus Picomotor Application\Samples\UsbDllWrap.dll'); %load UsbDllWrap.dll library
    asm_type = asmInfo.AssemblyHandle.GetType('Newport.USBComm.USB');
    NP_USB = System.Activator.CreateInstance(asm_type); 
    NP_USB.OpenDevices();  %Open the USB device

    querydata = System.Text.StringBuilder(64);
    NP_USB.Query(1, '*IDN?', querydata);    
    
    NP_USB.Write(1,['1PR2000']); %relative move
    
    NP_USB.CloseDevices();  %Close


% Picomotor
function pushbutton14_Callback(hObject, eventdata, handles)
    asmInfo = NET.addAssembly('C:\Program Files\New Focus\New Focus Picomotor Application\Samples\UsbDllWrap.dll'); %load UsbDllWrap.dll library
    asm_type = asmInfo.AssemblyHandle.GetType('Newport.USBComm.USB');
    NP_USB = System.Activator.CreateInstance(asm_type); 
    NP_USB.OpenDevices();  %Open the USB device

    querydata = System.Text.StringBuilder(64);
    NP_USB.Query(1, '*IDN?', querydata);    
    
    NP_USB.Write(1,['1PR-1000']); %relative move
    
    NP_USB.CloseDevices();  %Close


% Picomotor
function pushbutton15_Callback(hObject, eventdata, handles)
    asmInfo = NET.addAssembly('C:\Program Files\New Focus\New Focus Picomotor Application\Samples\UsbDllWrap.dll'); %load UsbDllWrap.dll library
    asm_type = asmInfo.AssemblyHandle.GetType('Newport.USBComm.USB');
    NP_USB = System.Activator.CreateInstance(asm_type); 
    NP_USB.OpenDevices();  %Open the USB device

    querydata = System.Text.StringBuilder(64);
    NP_USB.Query(1, '*IDN?', querydata);    
    
    NP_USB.Write(1,['1PR1000']); %relative move
    
    NP_USB.CloseDevices();  %Close


% Picomotor
function pushbutton16_Callback(hObject, eventdata, handles)
    asmInfo = NET.addAssembly('C:\Program Files\New Focus\New Focus Picomotor Application\Samples\UsbDllWrap.dll'); %load UsbDllWrap.dll library
    asm_type = asmInfo.AssemblyHandle.GetType('Newport.USBComm.USB');
    NP_USB = System.Activator.CreateInstance(asm_type); 
    NP_USB.OpenDevices();  %Open the USB device

    querydata = System.Text.StringBuilder(64);
    NP_USB.Query(1, '*IDN?', querydata);    
    
    NP_USB.Write(1,['1PR-500']); %relative move
    
    NP_USB.CloseDevices();  %Close


% Picomotor
function pushbutton17_Callback(hObject, eventdata, handles)
    asmInfo = NET.addAssembly('C:\Program Files\New Focus\New Focus Picomotor Application\Samples\UsbDllWrap.dll'); %load UsbDllWrap.dll library
    asm_type = asmInfo.AssemblyHandle.GetType('Newport.USBComm.USB');
    NP_USB = System.Activator.CreateInstance(asm_type); 
    NP_USB.OpenDevices();  %Open the USB device

    querydata = System.Text.StringBuilder(64);
    NP_USB.Query(1, '*IDN?', querydata);    
    
    NP_USB.Write(1,['1PR500']); %relative move
    
    NP_USB.CloseDevices();  %Close


% Picomotor
function pushbutton18_Callback(hObject, eventdata, handles)
    asmInfo = NET.addAssembly('C:\Program Files\New Focus\New Focus Picomotor Application\Samples\UsbDllWrap.dll'); %load UsbDllWrap.dll library
    asm_type = asmInfo.AssemblyHandle.GetType('Newport.USBComm.USB');
    NP_USB = System.Activator.CreateInstance(asm_type); 
    NP_USB.OpenDevices();  %Open the USB device

    querydata = System.Text.StringBuilder(64);
    NP_USB.Query(1, '*IDN?', querydata);    
    
    NP_USB.Write(1,['1PR-250']); %relative move
    
    NP_USB.CloseDevices();  %Close


% Picomotor
function pushbutton19_Callback(hObject, eventdata, handles)
    asmInfo = NET.addAssembly('C:\Program Files\New Focus\New Focus Picomotor Application\Samples\UsbDllWrap.dll'); %load UsbDllWrap.dll library
    asm_type = asmInfo.AssemblyHandle.GetType('Newport.USBComm.USB');
    NP_USB = System.Activator.CreateInstance(asm_type); 
    NP_USB.OpenDevices();  %Open the USB device

    querydata = System.Text.StringBuilder(64);
    NP_USB.Query(1, '*IDN?', querydata);    
    
    NP_USB.Write(1,['1PR250']); %relative move
    
    NP_USB.CloseDevices();  %Close


% Picomotor
function pushbutton20_Callback(hObject, eventdata, handles)
    asmInfo = NET.addAssembly('C:\Program Files\New Focus\New Focus Picomotor Application\Samples\UsbDllWrap.dll'); %load UsbDllWrap.dll library
    asm_type = asmInfo.AssemblyHandle.GetType('Newport.USBComm.USB');
    NP_USB = System.Activator.CreateInstance(asm_type); 
    NP_USB.OpenDevices();  %Open the USB device

    querydata = System.Text.StringBuilder(64);
    NP_USB.Query(1, '*IDN?', querydata);    
    
    NP_USB.Write(1,['1PR-125']); %relative move
    
    NP_USB.CloseDevices();  %Close


% Picomotor
function pushbutton21_Callback(hObject, eventdata, handles)
    asmInfo = NET.addAssembly('C:\Program Files\New Focus\New Focus Picomotor Application\Samples\UsbDllWrap.dll'); %load UsbDllWrap.dll library
    asm_type = asmInfo.AssemblyHandle.GetType('Newport.USBComm.USB');
    NP_USB = System.Activator.CreateInstance(asm_type); 
    NP_USB.OpenDevices();  %Open the USB device

    querydata = System.Text.StringBuilder(64);
    NP_USB.Query(1, '*IDN?', querydata);    
    
    NP_USB.Write(1,['1PR125']); %relative move
    
    NP_USB.CloseDevices();  %Close


% Picomotor 2
function pushbutton22_Callback(hObject, eventdata, handles)
    asmInfo = NET.addAssembly('C:\Program Files\New Focus\New Focus Picomotor Application\Samples\UsbDllWrap.dll'); %load UsbDllWrap.dll library
    asm_type = asmInfo.AssemblyHandle.GetType('Newport.USBComm.USB');
    NP_USB = System.Activator.CreateInstance(asm_type); 
    NP_USB.OpenDevices();  %Open the USB device

    querydata = System.Text.StringBuilder(64);
    NP_USB.Query(1, '*IDN?', querydata);    
    
    NP_USB.Write(1,['2PR-2000']); %relative move
    
    NP_USB.CloseDevices();  %Close


% Picomotor 2
function pushbutton23_Callback(hObject, eventdata, handles)
    asmInfo = NET.addAssembly('C:\Program Files\New Focus\New Focus Picomotor Application\Samples\UsbDllWrap.dll'); %load UsbDllWrap.dll library
    asm_type = asmInfo.AssemblyHandle.GetType('Newport.USBComm.USB');
    NP_USB = System.Activator.CreateInstance(asm_type); 
    NP_USB.OpenDevices();  %Open the USB device

    querydata = System.Text.StringBuilder(64);
    NP_USB.Query(1, '*IDN?', querydata);    
    
    NP_USB.Write(1,['2PR2000']); %relative move
    
    NP_USB.CloseDevices();  %Close


% Picomotor 2
function pushbutton24_Callback(hObject, eventdata, handles)
    asmInfo = NET.addAssembly('C:\Program Files\New Focus\New Focus Picomotor Application\Samples\UsbDllWrap.dll'); %load UsbDllWrap.dll library
    asm_type = asmInfo.AssemblyHandle.GetType('Newport.USBComm.USB');
    NP_USB = System.Activator.CreateInstance(asm_type); 
    NP_USB.OpenDevices();  %Open the USB device

    querydata = System.Text.StringBuilder(64);
    NP_USB.Query(1, '*IDN?', querydata);    
    
    NP_USB.Write(1,['2PR-1000']); %relative move
    
    NP_USB.CloseDevices();  %Close


% Picomotor 2
function pushbutton25_Callback(hObject, eventdata, handles)
    asmInfo = NET.addAssembly('C:\Program Files\New Focus\New Focus Picomotor Application\Samples\UsbDllWrap.dll'); %load UsbDllWrap.dll library
    asm_type = asmInfo.AssemblyHandle.GetType('Newport.USBComm.USB');
    NP_USB = System.Activator.CreateInstance(asm_type); 
    NP_USB.OpenDevices();  %Open the USB device

    querydata = System.Text.StringBuilder(64);
    NP_USB.Query(1, '*IDN?', querydata);    
    
    NP_USB.Write(1,['2PR1000']); %relative move
    
    NP_USB.CloseDevices();  %Close


% Picomotor 2
function pushbutton26_Callback(hObject, eventdata, handles)
    asmInfo = NET.addAssembly('C:\Program Files\New Focus\New Focus Picomotor Application\Samples\UsbDllWrap.dll'); %load UsbDllWrap.dll library
    asm_type = asmInfo.AssemblyHandle.GetType('Newport.USBComm.USB');
    NP_USB = System.Activator.CreateInstance(asm_type); 
    NP_USB.OpenDevices();  %Open the USB device

    querydata = System.Text.StringBuilder(64);
    NP_USB.Query(1, '*IDN?', querydata);    
    
    NP_USB.Write(1,['2PR-500']); %relative move
    
    NP_USB.CloseDevices();  %Close


% Picomotor 2
function pushbutton27_Callback(hObject, eventdata, handles)
    asmInfo = NET.addAssembly('C:\Program Files\New Focus\New Focus Picomotor Application\Samples\UsbDllWrap.dll'); %load UsbDllWrap.dll library
    asm_type = asmInfo.AssemblyHandle.GetType('Newport.USBComm.USB');
    NP_USB = System.Activator.CreateInstance(asm_type); 
    NP_USB.OpenDevices();  %Open the USB device

    querydata = System.Text.StringBuilder(64);
    NP_USB.Query(1, '*IDN?', querydata);    
    
    NP_USB.Write(1,['2PR500']); %relative move
    
    NP_USB.CloseDevices();  %Close


% Picomotor 2
function pushbutton28_Callback(hObject, eventdata, handles)
    asmInfo = NET.addAssembly('C:\Program Files\New Focus\New Focus Picomotor Application\Samples\UsbDllWrap.dll'); %load UsbDllWrap.dll library
    asm_type = asmInfo.AssemblyHandle.GetType('Newport.USBComm.USB');
    NP_USB = System.Activator.CreateInstance(asm_type); 
    NP_USB.OpenDevices();  %Open the USB device

    querydata = System.Text.StringBuilder(64);
    NP_USB.Query(1, '*IDN?', querydata);    
    
    NP_USB.Write(1,['2PR-250']); %relative move
    
    NP_USB.CloseDevices();  %Close

% Picomotor 2
function pushbutton29_Callback(hObject, eventdata, handles)
    asmInfo = NET.addAssembly('C:\Program Files\New Focus\New Focus Picomotor Application\Samples\UsbDllWrap.dll'); %load UsbDllWrap.dll library
    asm_type = asmInfo.AssemblyHandle.GetType('Newport.USBComm.USB');
    NP_USB = System.Activator.CreateInstance(asm_type); 
    NP_USB.OpenDevices();  %Open the USB device

    querydata = System.Text.StringBuilder(64);
    NP_USB.Query(1, '*IDN?', querydata);    
    
    NP_USB.Write(1,['2PR250']); %relative move
    
    NP_USB.CloseDevices();  %Close

% Picomotor 2
function pushbutton30_Callback(hObject, eventdata, handles)
    asmInfo = NET.addAssembly('C:\Program Files\New Focus\New Focus Picomotor Application\Samples\UsbDllWrap.dll'); %load UsbDllWrap.dll library
    asm_type = asmInfo.AssemblyHandle.GetType('Newport.USBComm.USB');
    NP_USB = System.Activator.CreateInstance(asm_type); 
    NP_USB.OpenDevices();  %Open the USB device

    querydata = System.Text.StringBuilder(64);
    NP_USB.Query(1, '*IDN?', querydata);    
    
    NP_USB.Write(1,['2PR-125']); %relative move
    
    NP_USB.CloseDevices();  %Close


% Picomotor 2
function pushbutton31_Callback(hObject, eventdata, handles)
    asmInfo = NET.addAssembly('C:\Program Files\New Focus\New Focus Picomotor Application\Samples\UsbDllWrap.dll'); %load UsbDllWrap.dll library
    asm_type = asmInfo.AssemblyHandle.GetType('Newport.USBComm.USB');
    NP_USB = System.Activator.CreateInstance(asm_type); 
    NP_USB.OpenDevices();  %Open the USB device

    querydata = System.Text.StringBuilder(64);
    NP_USB.Query(1, '*IDN?', querydata);    
    
    NP_USB.Write(1,['2PR125']); %relative move
    
    NP_USB.CloseDevices();  %Close


% Multiple Images
function pushbutton32_Callback(hObject, eventdata, handles)
if evalin( 'base', 'exist(''exposure_time'',''var'') == 1' ) == 1 % check if exposure_time is already defined.
    exposure_time = evalin('base','exposure_time');
else 
    exposure_time = 700;
end

[img, errorCode] = my_multiple_images(1, exposure_time, 0);

% Number of images acquired during the continuous run
function edit10_Callback(hObject, eventdata, handles)
n_acq_images = str2num(get(hObject,'String'));
assignin('base','n_acq_images',n_acq_images);

function edit10_CreateFcn(hObject, eventdata, handles)
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end
