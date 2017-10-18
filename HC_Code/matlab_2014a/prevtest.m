function varargout = prevtest(varargin)
% PREVTEST MATLAB code for prevtest.fig
%      PREVTEST, by itself, creates a new PREVTEST or raises the existing
%      singleton*.
%
%      H = PREVTEST returns the handle to a new PREVTEST or the handle to
%      the existing singleton*.
%
%      PREVTEST('CALLBACK',hObject,eventData,handles,...) calls the local
%      function named CALLBACK in PREVTEST.M with the given input arguments.
%
%      PREVTEST('Property','Value',...) creates a new PREVTEST or raises the
%      existing singleton*.  Starting from the left, property value pairs are
%      applied to the GUI before prevtest_OpeningFcn gets called.  An
%      unrecognized property name or invalid value makes property application
%      stop.  All inputs are passed to prevtest_OpeningFcn via varargin.
%
%      *See GUI Options on GUIDE's Tools menu.  Choose "GUI allows only one
%      instance to run (singleton)".
%
% See also: GUIDE, GUIDATA, GUIHANDLES

% Edit the above text to modify the response to help prevtest

% Last Modified by GUIDE v2.5 15-Jun-2016 16:42:47

% Begin initialization code - DO NOT EDIT
gui_Singleton = 1;
gui_State = struct('gui_Name',       mfilename, ...
                   'gui_Singleton',  gui_Singleton, ...
                   'gui_OpeningFcn', @prevtest_OpeningFcn, ...
                   'gui_OutputFcn',  @prevtest_OutputFcn, ...
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


% --- Executes just before prevtest is made visible.
function prevtest_OpeningFcn(hObject, eventdata, handles, varargin)
% This function has no output args, see OutputFcn.
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
% varargin   command line arguments to prevtest (see VARARGIN)

% Choose default command line output for prevtest
handles.output = hObject;

% Update handles structure
guidata(hObject, handles);

% UIWAIT makes prevtest wait for user response (see UIRESUME)
% uiwait(handles.figure1);
handles = guidata(hObject);     %Starting Function
global cam_value
cam_value = 0;
camera_options = webcamlist;
set(handles.listbox_camera,'string',camera_options);

arduino_options = FindUnoPorts;
set(handles.listbox_arduino,'string',arduino_options);

%fly_image = imread('fly_climber.tif');
%imshow(fly_image);


guidata(hObject, handles);      %Ending Function

% --- Outputs from this function are returned to the command line.
function varargout = prevtest_OutputFcn(hObject, eventdata, handles) 
% varargout  cell array for returning output args (see VARARGOUT);
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Get default command line output from handles structure
varargout{1} = handles.output;



% --- Executes on button press in refresh_objectselections.
function refresh_objectselections_Callback(hObject, eventdata, handles)
% hObject    handle to refresh_objectselections (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
handles = guidata(hObject);     %Starting Function

global a cam cam_prev

if exist('cam_prev','var');
    delete(cam_prev);
end

clear a cam;

camera_options = webcamlist;
set(handles.listbox_camera,'string',camera_options);

arduino_options = FindUnoPorts;
set(handles.listbox_arduino,'string',arduino_options);
set(handles.cam_status,'string','Camera Status: Not Connected','ForegroundColor',[1 0 0]);
set(handles.ard_status,'string','Arduino Status: Not Connected','ForegroundColor',[1 0 0]);


guidata(hObject, handles);      %Ending Function


% --- Executes on selection change in listbox_camera.
function listbox_camera_Callback(hObject, eventdata, handles)
% hObject    handle to listbox_camera (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: contents = cellstr(get(hObject,'String')) returns listbox_camera contents as cell array
%        contents{get(hObject,'Value')} returns selected item from listbox_camera
handles = guidata(hObject);     %Starting Function
%disp(get(handles.listbox_camera,'Value'));
guidata(hObject, handles);      %Ending Function

% --- Executes during object creation, after setting all properties.
function listbox_camera_CreateFcn(hObject, eventdata, handles)
% hObject    handle to listbox_camera (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: listbox controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes on selection change in listbox_arduino.
function listbox_arduino_Callback(hObject, eventdata, handles)
% hObject    handle to listbox_arduino (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: contents = cellstr(get(hObject,'String')) returns listbox_arduino contents as cell array
%        contents{get(hObject,'Value')} returns selected item from listbox_arduino



% --- Executes during object creation, after setting all properties.
function listbox_arduino_CreateFcn(hObject, eventdata, handles)
% hObject    handle to listbox_arduino (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: listbox controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes on button press in yes_training.
function yes_training_Callback(hObject, eventdata, handles)
% hObject    handle to yes_training (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of yes_training
handles = guidata(hObject);     %Starting Function
if get(handles.yes_training,'Value') == 1;
    set(handles.no_training,'Value',0);
elseif get(handles.yes_training,'Value') == 0;
    set(handles.no_training,'Value',1);
end
    
guidata(hObject, handles);      %Ending Function

% --- Executes on button press in no_training.
function no_training_Callback(hObject, eventdata, handles)
% hObject    handle to no_training (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of no_training
handles = guidata(hObject);     %Starting Function

if get(handles.no_training,'Value') == 1;
    set(handles.yes_training,'Value',0);
elseif get(handles.no_training,'Value') == 0;
    set(handles.yes_training,'Value',1);
end

guidata(hObject, handles);      %Ending Function


function edit1_Callback(hObject, eventdata, handles)
% hObject    handle to edit1 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of edit1 as text
%        str2double(get(hObject,'String')) returns contents of edit1 as a double


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

% Hints: get(hObject,'String') returns contents of edit2 as text
%        str2double(get(hObject,'String')) returns contents of edit2 as a double


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


% --- Executes on button press in refresh_training_settings.
function refresh_training_settings_Callback(hObject, eventdata, handles)
% hObject    handle to refresh_training_settings (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
handles = guidata(hObject);     %Starting Function
set(handles.yes_training,'Value',0);
set(handles.no_training,'Value',1);
set(handles.edit1,'string','0');
set(handles.edit2,'string','0');
guidata(hObject, handles);      %Ending Function



function video_path_Callback(hObject, eventdata, handles)
% hObject    handle to video_path (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of video_path as text
%        str2double(get(hObject,'String')) returns contents of video_path as a double


% --- Executes during object creation, after setting all properties.
function video_path_CreateFcn(hObject, eventdata, handles)
% hObject    handle to video_path (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes on button press in search.
function search_Callback(hObject, eventdata, handles)
% hObject    handle to search (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
handles = guidata(hObject);     %Starting Function
folder = uigetdir;
set(handles.video_path,'string',folder);
guidata(hObject, handles);      %Ending Function


% --- Executes on button press in refresh_recording_settings.
function refresh_recording_settings_Callback(hObject, eventdata, handles)
% hObject    handle to refresh_recording_settings (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
handles = guidata(hObject);     %Starting Function
set(handles.video_path,'string','');
set(handles.edit6,'string','');
set(handles.edit4,'string','0');
set(handles.edit5,'string','0');

guidata(hObject, handles);      %Ending Function


function edit4_Callback(hObject, eventdata, handles)
% hObject    handle to edit4 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of edit4 as text
%        str2double(get(hObject,'String')) returns contents of edit4 as a double


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

% Hints: get(hObject,'String') returns contents of edit5 as text
%        str2double(get(hObject,'String')) returns contents of edit5 as a double


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

% Hints: get(hObject,'String') returns contents of edit6 as text
%        str2double(get(hObject,'String')) returns contents of edit6 as a double


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


% --- Executes on button press in record.
function record_Callback(hObject, eventdata, handles)
% hObject    handle to record (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
global cam a
handles = guidata(hObject);     %Starting Function

% Let's Double Check that you've hooked up everything for the Experiment
if strncmp('Connected',get(handles.cam_status,'string'),9) ~= 1;
    status = cam_status; waitfor(status);
    return;
elseif strncmp('Connected',get(handles.ard_status,'string'),9) ~= 1;
    status = ard_status; waitfor(status);
    return;
elseif exist(get(handles.video_path,'string'),'dir') == 0;
    status = path_status; waitfor(status);
    return;
elseif strcmp('',get(handles.edit6,'string')) == 1;
    status = movie_status; waitfor(status);
    return;
end


status = exp_question;
if strcmp(status, 'No'); return;
end



camera = cam;
frame_rate = round(str2num(get(handles.frame_rate,'string')));
arduino = a;
path = get(handles.video_path,'string');
vid_name = get(handles.edit6,'string');
r_rounds = round(str2num(get(handles.edit4,'string')));
r_rectime = round(str2num(get(handles.edit5,'string')));

% Training Session or Not
if get(handles.yes_training,'Value') == 1;
    training = 1;
else
    training = 0;
end

t_rounds = round(str2num(get(handles.edit1,'string')));            
t_rectime = round(str2num(get(handles.edit2,'string')));

% Experiment Function
start_experiment( camera,frame_rate, arduino, path, vid_name, r_rounds, r_rectime, training,t_rounds, t_rectime )
status = end_exp;
waitfor(status);
guidata(hObject, handles);      %Ending Function

                


% --- Executes on button press in con_camera.
function con_camera_Callback(hObject, eventdata, handles)
% hObject    handle to con_camera (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
global cam cam_value cam_prev
handles = guidata(hObject);     %Starting Function
if isempty(get(handles.listbox_camera,'string')) || cam_value == get(handles.listbox_camera,'value');
    return;
else
    
    
    %hImage = image(zeros(480,640, 3),'Parent',handles.axes4);
    %hImage = image(zeros(640,480, 3),'Parent',handles.axes4);
    cam_value = get(handles.listbox_camera,'Value');
    cams = get(handles.listbox_camera,'string');
    cam = webcam(cams{cam_value});
    cam_prev = preview(cam);
    set(handles.cam_status,'string',sprintf('Connected to %s',cams{cam_value}),'ForegroundColor',[0 0 1]);

end
%set(gcf, 'CloseRequestFcn', 'disp(''closing figure...''); closereq')

set(gcf, 'CloseRequestFcn', 'closereq')
guidata(hObject, handles);      %Ending Function



function frame_rate_Callback(hObject, eventdata, handles)
% hObject    handle to frame_rate (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of frame_rate as text
%        str2double(get(hObject,'String')) returns contents of frame_rate as a double


% --- Executes during object creation, after setting all properties.
function frame_rate_CreateFcn(hObject, eventdata, handles)
% hObject    handle to frame_rate (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes on button press in connect_arduino.
function connect_arduino_Callback(hObject, eventdata, handles)
% hObject    handle to connect_arduino (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
handles = guidata(hObject);     %Starting Function
global a
a = [];
if isempty(get(handles.listbox_arduino,'string'));
    return;
end

value = get(handles.listbox_arduino,'Value');
ards = get(handles.listbox_arduino,'string');
my_ard = ards{value};
spaces = strfind(my_ard,' ');
value1 = str2num(my_ard(spaces(end)+1:end));

if isstruct(a);
if strcmp(a.Port, sprintf('COM%d',value1));
    clear a;
end
end

a = arduino(sprintf('com%d',value1),'uno');
configureDigitalPin(a,6,'output');
set(handles.ard_status,'string',sprintf('Connected to %s',my_ard),'ForegroundColor',[0 0 1]);

guidata(hObject, handles);      %Ending Function
