function varargout = find_finish(varargin)
% FIND_FINISH MATLAB code for find_finish.fig
%      FIND_FINISH, by itself, creates a new FIND_FINISH or raises the existing
%      singleton*.
%
%      H = FIND_FINISH returns the handle to a new FIND_FINISH or the handle to
%      the existing singleton*.
%
%      FIND_FINISH('CALLBACK',hObject,eventData,handles,...) calls the local
%      function named CALLBACK in FIND_FINISH.M with the given input arguments.
%
%      FIND_FINISH('Property','Value',...) creates a new FIND_FINISH or raises the
%      existing singleton*.  Starting from the left, property value pairs are
%      applied to the GUI before find_finish_OpeningFcn gets called.  An
%      unrecognized property name or invalid value makes property application
%      stop.  All inputs are passed to find_finish_OpeningFcn via varargin.
%
%      *See GUI Options on GUIDE's Tools menu.  Choose "GUI allows only one
%      instance to run (singleton)".
%
% See also: GUIDE, GUIDATA, GUIHANDLES

% Edit the above text to modify the response to help find_finish

% Last Modified by GUIDE v2.5 08-Jul-2016 09:52:23

% Begin initialization code - DO NOT EDIT
gui_Singleton = 1;
gui_State = struct('gui_Name',       mfilename, ...
                   'gui_Singleton',  gui_Singleton, ...
                   'gui_OpeningFcn', @find_finish_OpeningFcn, ...
                   'gui_OutputFcn',  @find_finish_OutputFcn, ...
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


% --- Executes just before find_finish is made visible.
function find_finish_OpeningFcn(hObject, eventdata, handles, varargin)
% This function has no output args, see OutputFcn.
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
% varargin   command line arguments to find_finish (see VARARGIN)

% Choose default command line output for find_finish
handles.output = hObject;

% Update handles structure
guidata(hObject, handles);

% UIWAIT makes find_finish wait for user response (see UIRESUME)
% uiwait(handles.figure1);

global frame_1 width pix_2_mm real_max threshold_mm threshold high_mm
imshow(frame_1,'Parent',gca);
[~,width,~] = size(frame_1);
threshold = ((50/pix_2_mm)-real_max)*-1;
threshold_mm = 50;
hold on
plot(1:width, threshold,'color',[0 0 0]);
set(handles.text1,'string',sprintf('Enter Finish Line Value Between 1 and %d',high_mm));


% --- Outputs from this function are returned to the command line.
function varargout = find_finish_OutputFcn(hObject, eventdata, handles) 
% varargout  cell array for returning output args (see VARARGOUT);
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Get default command line output from handles structure
varargout{1} = handles.output;


% --- Executes on button press in simulate.
function simulate_Callback(hObject, eventdata, handles)
% hObject    handle to simulate (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
global frame_1 threshold_mm real_max pix_2_mm width threshold high_mm
handles = guidata(hObject);     %Starting Function
value = str2num(get(handles.edit1,'string'));
if value < 1 || value > high_mm
    value  = 50;
end


threshold_mm = value;
imshow(frame_1,'Parent',gca);
hold on
threshold =((value/pix_2_mm)-real_max)*-1;
plot(1:width, threshold,'color',[0 0 0]);

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


% --- Executes on button press in con.
function con_Callback(hObject, eventdata, handles)
% hObject    handle to con (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
close(gcf);
