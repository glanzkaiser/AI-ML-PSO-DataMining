function varargout = pso_customGUI(varargin)

% Begin initialization code - DO NOT EDIT
gui_Singleton = 1;
gui_State = struct('gui_Name',       mfilename, ...
                   'gui_Singleton',  gui_Singleton, ...
                   'gui_OpeningFcn', @pso_customGUI_OpeningFcn, ...
                   'gui_OutputFcn',  @pso_customGUI_OutputFcn, ...
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


% --- Executes just before pso_customGUI is made visible.
function pso_customGUI_OpeningFcn(hObject, eventdata, handles, varargin)
% This function has no output args, see OutputFcn.
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
% varargin   command line arguments to pso_customGUI (see VARARGIN)

% Choose default command line output for pso_customGUI
handles.output = hObject;

% Update handles structure
guidata(hObject, handles);

% UIWAIT makes pso_customGUI wait for user response (see UIRESUME)
% uiwait(handles.figure1);


% --- Outputs from this function are returned to the command line.
function varargout = pso_customGUI_OutputFcn(hObject, eventdata, handles) 
% varargout  cell array for returning output args (see VARARGOUT);
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Get default command line output from handles structure
varargout{1} = handles.output;



function expression_Callback(hObject, eventdata, handles)
% hObject    handle to expression (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of expression as text
%        str2double(get(hObject,'String')) returns contents of expression as a double


% --- Executes during object creation, after setting all properties.
function expression_CreateFcn(hObject, eventdata, handles)
% hObject    handle to expression (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function var_Callback(hObject, eventdata, handles)
% hObject    handle to var (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of var as text
%        str2double(get(hObject,'String')) returns contents of var as a double


% --- Executes during object creation, after setting all properties.
function var_CreateFcn(hObject, eventdata, handles)
% hObject    handle to var (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function ROI_lim2_Callback(hObject, eventdata, handles)
% hObject    handle to ROI_lim2 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of ROI_lim2 as text
%        str2double(get(hObject,'String')) returns contents of ROI_lim2 as a double


% --- Executes during object creation, after setting all properties.
function ROI_lim2_CreateFcn(hObject, eventdata, handles)
% hObject    handle to ROI_lim2 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function ROI_lim1_Callback(hObject, eventdata, handles)
% hObject    handle to ROI_lim1 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of ROI_lim1 as text
%        str2double(get(hObject,'String')) returns contents of ROI_lim1 as a double


% --- Executes during object creation, after setting all properties.
function ROI_lim1_CreateFcn(hObject, eventdata, handles)
% hObject    handle to ROI_lim1 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function n_Callback(hObject, eventdata, handles)
% hObject    handle to n (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of n as text
%        str2double(get(hObject,'String')) returns contents of n as a double


% --- Executes during object creation, after setting all properties.
function n_CreateFcn(hObject, eventdata, handles)
% hObject    handle to n (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes on button press in previewButton.
function previewButton_Callback(hObject, eventdata, handles)
% hObject    handle to previewButton (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Storing the parameters
lim1 = str2num(get(handles.ROI_lim1,'String')); 
lim2 = str2num(get(handles.ROI_lim2,'String')); 
n    = str2num(get(handles.n,'String'));
fun  = str2func([get(handles.var,'String') '(' get(handles.expression,'String') ')']);
xy_lim = [lim1, lim2];

% Previewing the function
ezmesh(handles.previewGraph, fun, xy_lim, n);
xlabel(handles.previewGraph, 'x');
ylabel(handles.previewGraph, 'y');
zlabel(handles.previewGraph, 'z');
hold(handles.previewGraph,'on');

ezcontour(handles.previewGraph, fun, xy_lim, n);
axis(handles.previewGraph, 'square');
title(handles.previewGraph, '');
hold(handles.previewGraph,'off');

% --- Executes on button press in select.
function select_Callback(hObject, eventdata, handles)
% hObject    handle to select (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

global FUN;

% Storing the parameters
lim1 = str2num(get(handles.ROI_lim1,'String')); 
lim2 = str2num(get(handles.ROI_lim2,'String')); 
n    = str2num(get(handles.n,'String'));
fun  = str2func([get(handles.var,'String') '(' get(handles.expression,'String') ')']);
xy_lim = [lim1, lim2];

% Previewing the function
ezmesh(handles.previewGraph, fun, xy_lim, n);
xlabel(handles.previewGraph, 'x');
ylabel(handles.previewGraph, 'y');
zlabel(handles.previewGraph, 'z');
hold(handles.previewGraph,'on');

ezcontour(handles.previewGraph, fun, xy_lim, n);
axis(handles.previewGraph, 'square');
title(handles.previewGraph, '');
hold(handles.previewGraph,'off');
rotate3d(handles.previewGraph);

% If correct, store it into global FUN variable
FUN.z       = fun;
FUN.xy_lim  = xy_lim;
FUN.n       = n;

close(pso_customGUI);
