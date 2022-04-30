function varargout = main(varargin)

% Begin initialization code - DO NOT EDIT
gui_Singleton = 1;
gui_State = struct('gui_Name',       mfilename, ...
                   'gui_Singleton',  gui_Singleton, ...
                   'gui_OpeningFcn', @main_OpeningFcn, ...
                   'gui_OutputFcn',  @main_OutputFcn, ...
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


% --- Executes just before main is made visible.
function main_OpeningFcn(hObject, eventdata, handles, varargin)
% This function has no output args, see OutputFcn.
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
% varargin   command line arguments to main (see VARARGIN)

% Choose default command line output for main
handles.output = hObject;

% Update handles structure
guidata(hObject, handles);

% UIWAIT makes main wait for user response (see UIRESUME)
% uiwait(handles.figure1);


% --- Outputs from this function are returned to the command line.
function varargout = main_OutputFcn(hObject, eventdata, handles) 
% varargout  cell array for returning output args (see VARARGOUT);
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Get default command line output from handles structure
varargout{1} = handles.output;


% --- Executes on button press in about_button.
function about_button_Callback(hObject, eventdata, handles)
% hObject    handle to about_button (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
about;

% --- Executes on button press in close_button.
function close_button_Callback(hObject, eventdata, handles)
% hObject    handle to close_button (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

clearvars -global;
clear all;
close all;

% --- Executes on selection change in fun_selector.
function fun_selector_Callback(hObject, eventdata, handles)
% hObject    handle to fun_selector (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: contents = cellstr(get(hObject,'String')) returns fun_selector contents as cell array
%        contents{get(hObject,'Value')} returns selected item from fun_selector


% --- Executes during object creation, after setting all properties.
function fun_selector_CreateFcn(hObject, eventdata, handles)
% hObject    handle to fun_selector (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

global FUN;

% Hint: popupmenu controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end

% --- Executes on button press in plot_button.
function plot_button_Callback(hObject, eventdata, handles)
% hObject    handle to plot_button (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

global FUN;

% Searching for the selected function
fun_val = get(handles.fun_selector,'Value');
if(fun_val <= 12), [FUN.z, FUN.xy_lim, FUN.n] = pso_eval(fun_val);
else    % Custom
    pso_customGUI;
    uiwait(pso_customGUI);
end

% Updating the ROI info
set(handles.ROI_lim1,'String',num2str(FUN.xy_lim(1)));
set(handles.ROI_lim2,'String',num2str(FUN.xy_lim(2)));

% Plotting the graphs
ezmesh(handles.function_graph, FUN.z, FUN.xy_lim, FUN.n);
axis(handles.function_graph, 'square');
xlabel(handles.function_graph, 'x');
ylabel(handles.function_graph, 'y');
zlabel(handles.function_graph, 'z');
title(handles.function_graph, '');
rotate3d(handles.function_graph);

ezcontour(handles.contour_graph, FUN.z, FUN.xy_lim, FUN.n);
axis(handles.contour_graph, 'square');
xlabel(handles.contour_graph, 'x');
ylabel(handles.contour_graph, 'y');
title(handles.contour_graph, '');

function pop_size_Callback(hObject, eventdata, handles)
% hObject    handle to pop_size (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of pop_size as text
%        str2double(get(hObject,'String')) returns contents of pop_size as a double


% --- Executes during object creation, after setting all properties.
function pop_size_CreateFcn(hObject, eventdata, handles)
% hObject    handle to pop_size (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes on button press in run_button.
function run_button_Callback(hObject, eventdata, handles)
% hObject    handle to run_button (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

global FUN;

% Getting the parameters
param.pop_s   = str2num(get(handles.pop_size,'String'));
param.w       = str2num(get(handles.inertia,'String'));
param.C1      = str2num(get(handles.ind_con,'String'));
param.C2      = str2num(get(handles.swa_con,'String'));
param.max_gen = str2num(get(handles.gen_lim,'String'));
param.type    = get(handles.opt_selector,'Value');
param.xy_lim  = FUN.xy_lim;
param.n       = FUN.n;
param.err     = str2num(get(handles.err,'String'));

% Refreshing the graph
ezcontour(handles.contour_graph, FUN.z, FUN.xy_lim, FUN.n);
axis(handles.contour_graph, 'square');
xlabel(handles.contour_graph, 'x');
ylabel(handles.contour_graph, 'y');
title(handles.contour_graph, '');

ezmesh(handles.function_graph, FUN.z, FUN.xy_lim, FUN.n);
axis(handles.function_graph, 'square');
xlabel(handles.function_graph, 'x');
ylabel(handles.function_graph, 'y');
zlabel(handles.function_graph, 'z');
title(handles.function_graph, '');
rotate3d(handles.function_graph);

% Refresh the previous results
set(handles.conv_gen, 'String', '');
set(handles.conv_pos, 'String', '');
set(handles.conv_fit, 'String', '');

% Running the PSO function
[pos, f, g] = pso(FUN.z, param, handles.contour_graph, handles.gen_graph);

% Displaying the convergence results
set(handles.conv_gen, 'String', num2str(g));
set(handles.conv_pos, 'String', ['(' num2str(pos(1)) ', ' num2str(pos(2)) ')']);
set(handles.conv_fit, 'String', num2str(f));

hold(handles.function_graph,'on');
plot3(handles.function_graph, pos(1), pos(2), f,'+r'); 
hold(handles.function_graph,'off');

% --- Executes on button press in stop_button.
function stop_button_Callback(hObject, eventdata, handles)
% hObject    handle to stop_button (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)


% --- Executes on selection change in opt_selector.
function opt_selector_Callback(hObject, eventdata, handles)
% hObject    handle to opt_selector (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: contents = cellstr(get(hObject,'String')) returns opt_selector contents as cell array
%        contents{get(hObject,'Value')} returns selected item from opt_selector


% --- Executes during object creation, after setting all properties.
function opt_selector_CreateFcn(hObject, eventdata, handles)
% hObject    handle to opt_selector (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: popupmenu controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function ind_con_Callback(hObject, eventdata, handles)
% hObject    handle to ind_con (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of ind_con as text
%        str2double(get(hObject,'String')) returns contents of ind_con as a double


% --- Executes during object creation, after setting all properties.
function ind_con_CreateFcn(hObject, eventdata, handles)
% hObject    handle to ind_con (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function swa_con_Callback(hObject, eventdata, handles)
% hObject    handle to swa_con (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of swa_con as text
%        str2double(get(hObject,'String')) returns contents of swa_con as a double


% --- Executes during object creation, after setting all properties.
function swa_con_CreateFcn(hObject, eventdata, handles)
% hObject    handle to swa_con (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function inertia_Callback(hObject, eventdata, handles)
% hObject    handle to inertia (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of inertia as text
%        str2double(get(hObject,'String')) returns contents of inertia as a double


% --- Executes during object creation, after setting all properties.
function inertia_CreateFcn(hObject, eventdata, handles)
% hObject    handle to inertia (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function gen_lim_Callback(hObject, eventdata, handles)
% hObject    handle to gen_lim (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of gen_lim as text
%        str2double(get(hObject,'String')) returns contents of gen_lim as a double


% --- Executes during object creation, after setting all properties.
function gen_lim_CreateFcn(hObject, eventdata, handles)
% hObject    handle to gen_lim (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function err_Callback(hObject, eventdata, handles)
% hObject    handle to err (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of err as text
%        str2double(get(hObject,'String')) returns contents of err as a double


% --- Executes during object creation, after setting all properties.
function err_CreateFcn(hObject, eventdata, handles)
% hObject    handle to err (see GCBO)
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



function conv_gen_Callback(hObject, eventdata, handles)
% hObject    handle to conv_gen (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of conv_gen as text
%        str2double(get(hObject,'String')) returns contents of conv_gen as a double


% --- Executes during object creation, after setting all properties.
function conv_gen_CreateFcn(hObject, eventdata, handles)
% hObject    handle to conv_gen (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function conv_pos_Callback(hObject, eventdata, handles)
% hObject    handle to conv_pos (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of conv_pos as text
%        str2double(get(hObject,'String')) returns contents of conv_pos as a double


% --- Executes during object creation, after setting all properties.
function conv_pos_CreateFcn(hObject, eventdata, handles)
% hObject    handle to conv_pos (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function conv_fit_Callback(hObject, eventdata, handles)
% hObject    handle to conv_fit (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of conv_fit as text
%        str2double(get(hObject,'String')) returns contents of conv_fit as a double


% --- Executes during object creation, after setting all properties.
function conv_fit_CreateFcn(hObject, eventdata, handles)
% hObject    handle to conv_fit (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function edit13_Callback(hObject, eventdata, handles)
% hObject    handle to conv_pos (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of conv_pos as text
%        str2double(get(hObject,'String')) returns contents of conv_pos as a double


% --- Executes during object creation, after setting all properties.
function edit13_CreateFcn(hObject, eventdata, handles)
% hObject    handle to conv_pos (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end
