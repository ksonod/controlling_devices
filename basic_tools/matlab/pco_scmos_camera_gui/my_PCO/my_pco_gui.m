function varargout = my_pco_gui(varargin)
% MY_PCO_GUI MATLAB code for my_pco_gui.fig
%      MY_PCO_GUI, by itself, creates a new MY_PCO_GUI or raises the existing
%      singleton*.
%
%      H = MY_PCO_GUI returns the handle to a new MY_PCO_GUI or the handle to
%      the existing singleton*.
%
%      MY_PCO_GUI('CALLBACK',hObject,eventData,handles,...) calls the local
%      function named CALLBACK in MY_PCO_GUI.M with the given input arguments.
%
%      MY_PCO_GUI('Property','Value',...) creates a new MY_PCO_GUI or raises the
%      existing singleton*.  Starting from the left, property value pairs are
%      applied to the GUI before my_pco_gui_OpeningFcn gets called.  An
%      unrecognized property name or invalid value makes property application
%      stop.  All inputs are passed to my_pco_gui_OpeningFcn via varargin.
%
%      *See GUI Options on GUIDE's Tools menu.  Choose "GUI allows only one
%      instance to run (singleton)".
%
% See also: GUIDE, GUIDATA, GUIHANDLES

% Edit the above text to modify the response to help my_pco_gui

% Last Modified by GUIDE v2.5 24-Jan-2020 17:52:26

% Begin initialization code - DO NOT EDIT
gui_Singleton = 1;
gui_State = struct('gui_Name',       mfilename, ...
                   'gui_Singleton',  gui_Singleton, ...
                   'gui_OpeningFcn', @my_pco_gui_OpeningFcn, ...
                   'gui_OutputFcn',  @my_pco_gui_OutputFcn, ...
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


% --- Executes just before my_pco_gui is made visible.
function my_pco_gui_OpeningFcn(hObject, eventdata, handles, varargin)
% This function has no output args, see OutputFcn.
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
% varargin   command line arguments to my_pco_gui (see VARARGIN)

% Choose default command line output for my_pco_gui
handles.output = hObject;

% Update handles structure
guidata(hObject, handles);

% UIWAIT makes my_pco_gui wait for user response (see UIRESUME)
% uiwait(handles.figure1);


% --- Outputs from this function are returned to the command line.
function varargout = my_pco_gui_OutputFcn(hObject, eventdata, handles) 
% varargout  cell array for returning output args (see VARARGOUT);
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Get default command line output from handles structure
varargout{1} = handles.output;


% --- Executes on button press in pushbutton1.
function pushbutton1_Callback(hObject, eventdata, handles)
% Visualize a single image 

if evalin( 'base', 'exist(''exposure_time'',''var'') == 1' ) == 1 % check if exposure_time is already defined.
    exposure_time = evalin('base','exposure_time');
else 
    exposure_time = 10;
end

[img, errorCode]=pco_sdk_example_stack(1, exposure_time, 0);
imshow(img);
assignin('base','single_image',img);


function edit1_Callback(hObject, eventdata, handles)
% hObject    handle to edit1 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

exposure_time=str2double(get(hObject,'String')) ;
assignin('base','exposure_time',exposure_time);

% --- Executes during object creation, after setting all properties.
function edit1_CreateFcn(hObject, eventdata, handles)
% hObject    handle to edit1 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end
