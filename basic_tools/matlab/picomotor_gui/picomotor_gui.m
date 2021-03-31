function varargout = picomotor_gui(varargin)
% PICOMOTOR_GUI MATLAB code for picomotor_gui.fig
%      PICOMOTOR_GUI, by itself, creates a new PICOMOTOR_GUI or raises the existing
%      singleton*.
%
%      H = PICOMOTOR_GUI returns the handle to a new PICOMOTOR_GUI or the handle to
%      the existing singleton*.
%
%      PICOMOTOR_GUI('CALLBACK',hObject,eventData,handles,...) calls the local
%      function named CALLBACK in PICOMOTOR_GUI.M with the given input arguments.
%
%      PICOMOTOR_GUI('Property','Value',...) creates a new PICOMOTOR_GUI or raises the
%      existing singleton*.  Starting from the left, property value pairs are
%      applied to the GUI before picomotor_gui_OpeningFcn gets called.  An
%      unrecognized property name or invalid value makes property application
%      stop.  All inputs are passed to picomotor_gui_OpeningFcn via varargin.
%
%      *See GUI Options on GUIDE's Tools menu.  Choose "GUI allows only one
%      instance to run (singleton)".
%
% See also: GUIDE, GUIDATA, GUIHANDLES

% Edit the above text to modify the response to help picomotor_gui

% Last Modified by GUIDE v2.5 24-Jan-2020 15:22:40

% Begin initialization code - DO NOT EDIT
gui_Singleton = 1;
gui_State = struct('gui_Name',       mfilename, ...
                   'gui_Singleton',  gui_Singleton, ...
                   'gui_OpeningFcn', @picomotor_gui_OpeningFcn, ...
                   'gui_OutputFcn',  @picomotor_gui_OutputFcn, ...
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


% --- Executes just before picomotor_gui is made visible.
function picomotor_gui_OpeningFcn(hObject, eventdata, handles, varargin)
% This function has no output args, see OutputFcn.
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
% varargin   command line arguments to picomotor_gui (see VARARGIN)

% Choose default command line output for picomotor_gui
handles.output = hObject;

% Update handles structure
guidata(hObject, handles);

% UIWAIT makes picomotor_gui wait for user response (see UIRESUME)
% uiwait(handles.figure1);


% --- Outputs from this function are returned to the command line.
function varargout = picomotor_gui_OutputFcn(hObject, eventdata, handles) 
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
    
    asmInfo = NET.addAssembly('C:\Program Files\New Focus\New Focus Picomotor Application\Samples\UsbDllWrap.dll'); %load UsbDllWrap.dll library
    asm_type = asmInfo.AssemblyHandle.GetType('Newport.USBComm.USB');
    NP_USB = System.Activator.CreateInstance(asm_type); 
    NP_USB.OpenDevices();  %Open the USB device

    querydata = System.Text.StringBuilder(64);
    NP_USB.Query(1, '*IDN?', querydata);    
    
    NP_USB.Write(1,['1PR-2000']); %relative move
    
    disp('moved...')
    NP_USB.CloseDevices();  %Close


% --- Executes on button press in pushbutton2.
function pushbutton2_Callback(hObject, eventdata, handles)
% hObject    handle to pushbutton2 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

    asmInfo = NET.addAssembly('C:\Program Files\New Focus\New Focus Picomotor Application\Samples\UsbDllWrap.dll'); %load UsbDllWrap.dll library
    asm_type = asmInfo.AssemblyHandle.GetType('Newport.USBComm.USB');
    NP_USB = System.Activator.CreateInstance(asm_type); 
    NP_USB.OpenDevices();  %Open the USB device

    querydata = System.Text.StringBuilder(64);
    NP_USB.Query(1, '*IDN?', querydata);    
    
    NP_USB.Write(1,['1PR2000']); %relative move
    
    disp('moved...')
    NP_USB.CloseDevices();  %Close


% --- Executes on button press in pushbutton3.
function pushbutton3_Callback(hObject, eventdata, handles)
% hObject    handle to pushbutton3 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
    asmInfo = NET.addAssembly('C:\Program Files\New Focus\New Focus Picomotor Application\Samples\UsbDllWrap.dll'); %load UsbDllWrap.dll library
    asm_type = asmInfo.AssemblyHandle.GetType('Newport.USBComm.USB');
    NP_USB = System.Activator.CreateInstance(asm_type); 
    NP_USB.OpenDevices();  %Open the USB device

    querydata = System.Text.StringBuilder(64);
    NP_USB.Query(1, '*IDN?', querydata);    
    
    NP_USB.Write(1,['1PR-1000']); %relative move
    
    disp('moved...')
    NP_USB.CloseDevices();  %Close


% --- Executes on button press in pushbutton4.
function pushbutton4_Callback(hObject, eventdata, handles)
% hObject    handle to pushbutton4 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
    asmInfo = NET.addAssembly('C:\Program Files\New Focus\New Focus Picomotor Application\Samples\UsbDllWrap.dll'); %load UsbDllWrap.dll library
    asm_type = asmInfo.AssemblyHandle.GetType('Newport.USBComm.USB');
    NP_USB = System.Activator.CreateInstance(asm_type); 
    NP_USB.OpenDevices();  %Open the USB device

    querydata = System.Text.StringBuilder(64);
    NP_USB.Query(1, '*IDN?', querydata);    
    
    NP_USB.Write(1,['1PR1000']); %relative move
    
    disp('moved...')
    NP_USB.CloseDevices();  %Close


% --- Executes on button press in pushbutton5.
function pushbutton5_Callback(hObject, eventdata, handles)
% hObject    handle to pushbutton5 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
    asmInfo = NET.addAssembly('C:\Program Files\New Focus\New Focus Picomotor Application\Samples\UsbDllWrap.dll'); %load UsbDllWrap.dll library
    asm_type = asmInfo.AssemblyHandle.GetType('Newport.USBComm.USB');
    NP_USB = System.Activator.CreateInstance(asm_type); 
    NP_USB.OpenDevices();  %Open the USB device

    querydata = System.Text.StringBuilder(64);
    NP_USB.Query(1, '*IDN?', querydata);    
    
    NP_USB.Write(1,['1PR-500']); %relative move
    
    disp('moved...')
    NP_USB.CloseDevices();  %Close


% --- Executes on button press in pushbutton6.
function pushbutton6_Callback(hObject, eventdata, handles)
% hObject    handle to pushbutton6 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
    asmInfo = NET.addAssembly('C:\Program Files\New Focus\New Focus Picomotor Application\Samples\UsbDllWrap.dll'); %load UsbDllWrap.dll library
    asm_type = asmInfo.AssemblyHandle.GetType('Newport.USBComm.USB');
    NP_USB = System.Activator.CreateInstance(asm_type); 
    NP_USB.OpenDevices();  %Open the USB device

    querydata = System.Text.StringBuilder(64);
    NP_USB.Query(1, '*IDN?', querydata);    
    
    NP_USB.Write(1,['1PR500']); %relative move
    
    disp('moved...')
    NP_USB.CloseDevices();  %Close


% --- Executes on button press in pushbutton7.
function pushbutton7_Callback(hObject, eventdata, handles)
% hObject    handle to pushbutton7 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
    asmInfo = NET.addAssembly('C:\Program Files\New Focus\New Focus Picomotor Application\Samples\UsbDllWrap.dll'); %load UsbDllWrap.dll library
    asm_type = asmInfo.AssemblyHandle.GetType('Newport.USBComm.USB');
    NP_USB = System.Activator.CreateInstance(asm_type); 
    NP_USB.OpenDevices();  %Open the USB device

    querydata = System.Text.StringBuilder(64);
    NP_USB.Query(1, '*IDN?', querydata);    
    
    NP_USB.Write(1,['1PR-250']); %relative move
    
    disp('moved...')
    NP_USB.CloseDevices();  %Close


% --- Executes on button press in pushbutton8.
function pushbutton8_Callback(hObject, eventdata, handles)
% hObject    handle to pushbutton8 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
    asmInfo = NET.addAssembly('C:\Program Files\New Focus\New Focus Picomotor Application\Samples\UsbDllWrap.dll'); %load UsbDllWrap.dll library
    asm_type = asmInfo.AssemblyHandle.GetType('Newport.USBComm.USB');
    NP_USB = System.Activator.CreateInstance(asm_type); 
    NP_USB.OpenDevices();  %Open the USB device

    querydata = System.Text.StringBuilder(64);
    NP_USB.Query(1, '*IDN?', querydata);    
    
    NP_USB.Write(1,['1PR250']); %relative move
    
    disp('moved...')
    NP_USB.CloseDevices();  %Close


% --- Executes on button press in pushbutton9.
function pushbutton9_Callback(hObject, eventdata, handles)
% hObject    handle to pushbutton9 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
    asmInfo = NET.addAssembly('C:\Program Files\New Focus\New Focus Picomotor Application\Samples\UsbDllWrap.dll'); %load UsbDllWrap.dll library
    asm_type = asmInfo.AssemblyHandle.GetType('Newport.USBComm.USB');
    NP_USB = System.Activator.CreateInstance(asm_type); 
    NP_USB.OpenDevices();  %Open the USB device

    querydata = System.Text.StringBuilder(64);
    NP_USB.Query(1, '*IDN?', querydata);    
    
    NP_USB.Write(1,['2PR-2000']); %relative move
    
    disp('moved...')
    NP_USB.CloseDevices();  %Close


% --- Executes on button press in pushbutton10.
function pushbutton10_Callback(hObject, eventdata, handles)
% hObject    handle to pushbutton10 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
    asmInfo = NET.addAssembly('C:\Program Files\New Focus\New Focus Picomotor Application\Samples\UsbDllWrap.dll'); %load UsbDllWrap.dll library
    asm_type = asmInfo.AssemblyHandle.GetType('Newport.USBComm.USB');
    NP_USB = System.Activator.CreateInstance(asm_type); 
    NP_USB.OpenDevices();  %Open the USB device

    querydata = System.Text.StringBuilder(64);
    NP_USB.Query(1, '*IDN?', querydata);    
    
    NP_USB.Write(1,['2PR2000']); %relative move
    
    disp('moved...')
    NP_USB.CloseDevices();  %Close


% --- Executes on button press in pushbutton11.
function pushbutton11_Callback(hObject, eventdata, handles)
% hObject    handle to pushbutton11 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
    asmInfo = NET.addAssembly('C:\Program Files\New Focus\New Focus Picomotor Application\Samples\UsbDllWrap.dll'); %load UsbDllWrap.dll library
    asm_type = asmInfo.AssemblyHandle.GetType('Newport.USBComm.USB');
    NP_USB = System.Activator.CreateInstance(asm_type); 
    NP_USB.OpenDevices();  %Open the USB device

    querydata = System.Text.StringBuilder(64);
    NP_USB.Query(1, '*IDN?', querydata);    
    
    NP_USB.Write(1,['2PR-1000']); %relative move
    
    disp('moved...')
    NP_USB.CloseDevices();  %Close


% --- Executes on button press in pushbutton12.
function pushbutton12_Callback(hObject, eventdata, handles)
% hObject    handle to pushbutton12 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
    asmInfo = NET.addAssembly('C:\Program Files\New Focus\New Focus Picomotor Application\Samples\UsbDllWrap.dll'); %load UsbDllWrap.dll library
    asm_type = asmInfo.AssemblyHandle.GetType('Newport.USBComm.USB');
    NP_USB = System.Activator.CreateInstance(asm_type); 
    NP_USB.OpenDevices();  %Open the USB device

    querydata = System.Text.StringBuilder(64);
    NP_USB.Query(1, '*IDN?', querydata);    
    
    NP_USB.Write(1,['2PR1000']); %relative move
    
    disp('moved...')
    NP_USB.CloseDevices();  %Close


% --- Executes on button press in pushbutton13.
function pushbutton13_Callback(hObject, eventdata, handles)
% hObject    handle to pushbutton13 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
    asmInfo = NET.addAssembly('C:\Program Files\New Focus\New Focus Picomotor Application\Samples\UsbDllWrap.dll'); %load UsbDllWrap.dll library
    asm_type = asmInfo.AssemblyHandle.GetType('Newport.USBComm.USB');
    NP_USB = System.Activator.CreateInstance(asm_type); 
    NP_USB.OpenDevices();  %Open the USB device

    querydata = System.Text.StringBuilder(64);
    NP_USB.Query(1, '*IDN?', querydata);    
    
    NP_USB.Write(1,['2PR-500']); %relative move
    
    disp('moved...')
    NP_USB.CloseDevices();  %Close


% --- Executes on button press in pushbutton14.
function pushbutton14_Callback(hObject, eventdata, handles)
% hObject    handle to pushbutton14 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
    asmInfo = NET.addAssembly('C:\Program Files\New Focus\New Focus Picomotor Application\Samples\UsbDllWrap.dll'); %load UsbDllWrap.dll library
    asm_type = asmInfo.AssemblyHandle.GetType('Newport.USBComm.USB');
    NP_USB = System.Activator.CreateInstance(asm_type); 
    NP_USB.OpenDevices();  %Open the USB device

    querydata = System.Text.StringBuilder(64);
    NP_USB.Query(1, '*IDN?', querydata);    
    
    NP_USB.Write(1,['2PR500']); %relative move
    
    disp('moved...')
    NP_USB.CloseDevices();  %Close


% --- Executes on button press in pushbutton15.
function pushbutton15_Callback(hObject, eventdata, handles)
% hObject    handle to pushbutton15 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
    asmInfo = NET.addAssembly('C:\Program Files\New Focus\New Focus Picomotor Application\Samples\UsbDllWrap.dll'); %load UsbDllWrap.dll library
    asm_type = asmInfo.AssemblyHandle.GetType('Newport.USBComm.USB');
    NP_USB = System.Activator.CreateInstance(asm_type); 
    NP_USB.OpenDevices();  %Open the USB device

    querydata = System.Text.StringBuilder(64);
    NP_USB.Query(1, '*IDN?', querydata);    
    
    NP_USB.Write(1,['2PR-250']); %relative move
    
    disp('moved...')
    NP_USB.CloseDevices();  %Close


% --- Executes on button press in pushbutton16.
function pushbutton16_Callback(hObject, eventdata, handles)
% hObject    handle to pushbutton16 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
    asmInfo = NET.addAssembly('C:\Program Files\New Focus\New Focus Picomotor Application\Samples\UsbDllWrap.dll'); %load UsbDllWrap.dll library
    asm_type = asmInfo.AssemblyHandle.GetType('Newport.USBComm.USB');
    NP_USB = System.Activator.CreateInstance(asm_type); 
    NP_USB.OpenDevices();  %Open the USB device

    querydata = System.Text.StringBuilder(64);
    NP_USB.Query(1, '*IDN?', querydata);    
    
    NP_USB.Write(1,['2PR250']); %relative move
    
    disp('moved...')
    NP_USB.CloseDevices();  %Close
