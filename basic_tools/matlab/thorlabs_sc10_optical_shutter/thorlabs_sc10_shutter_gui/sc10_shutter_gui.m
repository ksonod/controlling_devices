function varargout = sc10_shutter_gui(varargin)
% SC10_SHUTTER_GUI MATLAB code for sc10_shutter_gui.fig
%      SC10_SHUTTER_GUI, by itself, creates a new SC10_SHUTTER_GUI or raises the existing
%      singleton*.
%
%      H = SC10_SHUTTER_GUI returns the handle to a new SC10_SHUTTER_GUI or the handle to
%      the existing singleton*.
%
%      SC10_SHUTTER_GUI('CALLBACK',hObject,eventData,handles,...) calls the local
%      function named CALLBACK in SC10_SHUTTER_GUI.M with the given input arguments.
%
%      SC10_SHUTTER_GUI('Property','Value',...) creates a new SC10_SHUTTER_GUI or raises the
%      existing singleton*.  Starting from the left, property value pairs are
%      applied to the GUI before sc10_shutter_gui_OpeningFcn gets called.  An
%      unrecognized property name or invalid value makes property application
%      stop.  All inputs are passed to sc10_shutter_gui_OpeningFcn via varargin.
%
%      *See GUI Options on GUIDE's Tools menu.  Choose "GUI allows only one
%      instance to run (singleton)".
%
% See also: GUIDE, GUIDATA, GUIHANDLES

% Edit the above text to modify the response to help sc10_shutter_gui

% Last Modified by GUIDE v2.5 30-Jan-2020 11:26:10

% Begin initialization code - DO NOT EDIT
gui_Singleton = 1;
gui_State = struct('gui_Name',       mfilename, ...
                   'gui_Singleton',  gui_Singleton, ...
                   'gui_OpeningFcn', @sc10_shutter_gui_OpeningFcn, ...
                   'gui_OutputFcn',  @sc10_shutter_gui_OutputFcn, ...
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


% --- Executes just before sc10_shutter_gui is made visible.
function sc10_shutter_gui_OpeningFcn(hObject, eventdata, handles, varargin)
% This function has no output args, see OutputFcn.
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
% varargin   command line arguments to sc10_shutter_gui (see VARARGIN)

% Choose default command line output for sc10_shutter_gui
handles.output = hObject;

% Update handles structure
guidata(hObject, handles);

% UIWAIT makes sc10_shutter_gui wait for user response (see UIRESUME)
% uiwait(handles.figure1);


% --- Outputs from this function are returned to the command line.
function varargout = sc10_shutter_gui_OutputFcn(hObject, eventdata, handles) 
% varargout  cell array for returning output args (see VARARGOUT);
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Get default command line output from handles structure
varargout{1} = handles.output;



function edit1_Callback(hObject, eventdata, handles)
% hObject    handle to edit1 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

open_time=str2double(get(hObject,'String')) ;
assignin('base','open_time',open_time);


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

close_time=str2double(get(hObject,'String')) ;
assignin('base','close_time',close_time);


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

repeat_num =str2double(get(hObject,'String')) ;
if repeat_num>99 
    disp('Too larger repeat_num. Now, repeat_num = 99.')
    repeat_num=99;
end

assignin('base','repeat_num', repeat_num);



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


% --- Executes on button press in pushbutton1.
function pushbutton1_Callback(hObject, eventdata, handles)
% hObject    handle to pushbutton1 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

if evalin( 'base', 'exist(''open_time'',''var'') == 1' ) == 1 % check if open_time is already defined.
    open_time = evalin('base','open_time');
else 
    open_time = 100;
end

if evalin( 'base', 'exist(''close_time'',''var'') == 1' ) == 1 % check if close_time is already defined.
    close_time = evalin('base','close_time');
else 
    close_time = 100;
end

if evalin( 'base', 'exist(''repeat_num'',''var'') == 1' ) == 1 % check if repeat_num is already defined.
    repeat_num = evalin('base','repeat_num');
else 
    repeat_num = 5;
end


s=serial('COM1'); % serial port object
s.Baudrate = 9600; % baud rate 
s.Terminator='CR'; 
fopen(s);

fprintf(s, 'mode=4'); % repeat mode

temp=['rep=', num2str(repeat_num)];
fprintf(s, temp);
temp=['open=', num2str(open_time)];
fprintf(s,temp); 
temp=['shut=', num2str(close_time)];
fprintf(s,temp); 
fprintf(s,'ens');
fclose(s);


% --- Executes on button press in pushbutton2.
function pushbutton2_Callback(hObject, eventdata, handles)
% hObject    handle to pushbutton2 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

s=serial('COM1'); % serial port object
s.Baudrate = 9600; % baud rate 
s.Terminator='CR'; 
fopen(s);

fprintf(s,'mode=1'); % manual mode
fprintf(s,'ens');

%Ret=fscanf(s)
fclose(s);
