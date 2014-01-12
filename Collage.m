function varargout = Collage(varargin)
% COLLAGE M-file for Collage.fig
%      COLLAGE, by itself, creates a new COLLAGE or raises the existing
%      singleton*.
%
%      H = COLLAGE returns the handle to a new COLLAGE or the handle to
%      the existing singleton*.
%
%      COLLAGE('CALLBACK',hObject,eventData,handles,...) calls the local
%      function named CALLBACK in COLLAGE.M with the given input arguments.
%
%      COLLAGE('Property','Value',...) creates a new COLLAGE or raises the
%      existing singleton*.  Starting from the left, property value pairs are
%      applied to the GUI before Collage_OpeningFcn gets called.  An
%      unrecognized property name or invalid value makes property application
%      stop.  All inputs are passed to Collage_OpeningFcn via varargin.
%
%      *See GUI Options on GUIDE's Tools menu.  Choose "GUI allows only one
%      instance to run (singleton)".
%
% See also: GUIDE, GUIDATA, GUIHANDLES

% Edit the above text to modify the response to help Collage

% Last Modified by GUIDE v2.5 25-May-2011 11:23:27

% Begin initialization code - DO NOT EDIT
gui_Singleton = 1;
gui_State = struct('gui_Name',       mfilename, ...
                   'gui_Singleton',  gui_Singleton, ...
                   'gui_OpeningFcn', @Collage_OpeningFcn, ...
                   'gui_OutputFcn',  @Collage_OutputFcn, ...
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


% --- Executes just before Collage is made visible.
function Collage_OpeningFcn(hObject, eventdata, handles, varargin)
% This function has no output args, see OutputFcn.
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
% varargin   command line arguments to Collage (see VARARGIN)

% Choose default command line output for Collage
handles.output = hObject;

% Update handles structure
guidata(hObject, handles);

set(handles.im_Dir,'String',pwd);
% UIWAIT makes Collage wait for user response (see UIRESUME)
% uiwait(handles.figure1);


% --- Outputs from this function are returned to the command line.
function varargout = Collage_OutputFcn(hObject, eventdata, handles) 
% varargout  cell array for returning output args (see VARARGOUT);
% Get default command line output from handles structure
varargout{1} = handles.output;


% --- Executes on slider movement.
function ResSlider_Callback(hObject, eventdata, handles)
SliderVal = get(handles.ResSlider,'Value');
set(handles.ResSliderValue,'String',num2str(SliderVal));
guidata(hObject, handles);


% --- Executes during object creation, after setting all properties.
function ResSlider_CreateFcn(hObject, eventdata, handles)
if isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor',[.9 .9 .9]);
end


% % --- Executes on button press in finished.
 function finished_Callback(hObject, eventdata, handles)
Resolution = round(((get(handles.ResSlider,'Value')+1)/100)*5);
Cycle = get(handles.Cycle,'Value');
Ratio = str2num(get(handles.im_ratio,'String'));
SmallImageSize = str2num(get(handles.text_small_size,'String'))/100+.01;
Images_Dir = get(handles.im_Dir,'String');
MainImage_Loc = strcat(get(handles.main_Im_Path,'String'),get(handles.main_Im_Name,'String'));
Tint = str2num(get(handles.text_tint,'String'))/100;
PixelPercentage = (str2num(get(handles.Pixel_Perc_Text,'String'))+1)/100;
ImageCollage = CollageCode(Resolution,Cycle,Ratio,SmallImageSize,Images_Dir,MainImage_Loc,Tint,PixelPercentage);
figure; imshow(ImageCollage);
 guidata(hObject, handles);


% --- Executes on button press in images_directory.
function images_directory_Callback(hObject, eventdata, handles)
ImagesDirectory = uigetdir;
set(handles.im_Dir,'String',ImagesDirectory);
guidata(hObject, handles);


% --- Executes on button press in main_Im_Loc.
function main_Im_Loc_Callback(hObject, eventdata, handles)
[FileName,PathName] = uigetfile('*.jpg');
set(handles.main_Im_Path,'String',PathName);
set(handles.main_Im_Name,'String',FileName);
handles.FileName = FileName;
axes_Im_CreateFcn(hObject, eventdata, handles);
D = dir(strcat(get(handles.main_Im_Path,'String'),'*.jpg'));
%set(handles.numel_Dir,'String',num2str(numel(D)));
set(handles.Next_Im,'Max',numel(D));
set(handles.Next_Im,'SliderStep',[1/numel(D) 1/numel(D)]);
E = {D.name};
F = strcmp(get(handles.main_Im_Name,'String'),E);
ImageNum = find(F == 1);
set(handles.Im_Num,'String',strcat(num2str(ImageNum),'/',num2str(numel(D))));
set(handles.Next_Im,'Value',ImageNum);
guidata(hObject, handles);


% --- Executes on slider movement.
function Cycle_Callback(hObject, eventdata, handles)
SliderVal = get(handles.Cycle,'Value');
set(handles.cycle_amount,'String',num2str(SliderVal));
guidata(hObject, handles);


% --- Executes during object creation, after setting all properties.
function Cycle_CreateFcn(hObject, eventdata, handles)
if isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor',[.9 .9 .9]);
end


% --- Executes on slider movement.
function size_small_Im_Callback(hObject, eventdata, handles)
SliderVal = get(handles.size_small_Im,'Value');
set(handles.text_small_size,'String',num2str(SliderVal));
guidata(hObject, handles);


% --- Executes during object creation, after setting all properties.
function size_small_Im_CreateFcn(hObject, eventdata, handles)
if isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor',[.9 .9 .9]);
end


% --- Executes on selection change in Ratio.
function Ratio_Callback(hObject, eventdata, handles)
%gets the selected option
switch get(handles.Ratio,'Value')   
    case 1
        Ratio = 1;
    case 2
        Ratio = 4/3;
    case 3
        Ratio = 3/2;
    case 4
        Ratio = 16/9;
    case 5
        Ratio = 1;
    otherwise
end
set(handles.im_ratio,'String',num2str(Ratio));
guidata(hObject, handles);


% --- Executes during object creation, after setting all properties.
function Ratio_CreateFcn(hObject, eventdata, handles)
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes on slider movement.
function Tint_Callback(hObject, eventdata, handles)
SliderVal = get(handles.Tint,'Value');
set(handles.text_tint,'String',num2str(SliderVal));
guidata(hObject, handles);


% --- Executes during object creation, after setting all properties.
function Tint_CreateFcn(hObject, eventdata, handles)
if isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor',[.9 .9 .9]);
end


% --- Executes on slider movement.
function Pixel_Perc_Slider_Callback(hObject, eventdata, handles)
SliderVal = get(handles.Pixel_Perc_Slider,'Value');
set(handles.Pixel_Perc_Text,'String',num2str(SliderVal));
guidata(hObject, handles);


% --- Executes during object creation, after setting all properties.
function Pixel_Perc_Slider_CreateFcn(hObject, eventdata, handles)
if isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor',[.9 .9 .9]);
end


% --- Executes during object creation, after setting all properties.
function axes_Im_CreateFcn(hObject, eventdata, handles)
imshow(strcat(get(handles.main_Im_Path,'String'),get(handles.main_Im_Name,'String')));




% --- Executes on slider movement.
function Next_Im_Callback(hObject, eventdata, handles)
SliderVal = round(get(handles.Next_Im,'Value'));
Path = get(handles.main_Im_Path,'String');
D = dir(strcat(Path,'*.jpg'));
set(handles.Im_Num,'String',strcat(num2str(SliderVal),'/',num2str(numel(D))));
E = {D.name};
set(handles.main_Im_Name,'String',E{SliderVal})
axes_Im_CreateFcn(hObject, eventdata, handles)
guidata(hObject, handles);


% --- Executes during object creation, after setting all properties.
function Next_Im_CreateFcn(hObject, eventdata, handles)
if isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor',[.9 .9 .9]);
end


% --- Executes on selection change in listbox2.
function listbox2_Callback(hObject, eventdata, handles)

% --- Executes during object creation, after setting all properties.
function listbox2_CreateFcn(hObject, eventdata, handles)
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes on selection change in listbox3.
function listbox3_Callback(hObject, eventdata, handles)


% --- Executes during object creation, after setting all properties.
function listbox3_CreateFcn(hObject, eventdata, handles)
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes on selection change in listbox4.
function listbox4_Callback(hObject, eventdata, handles)
% hObject    handle to listbox4 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: contents = get(hObject,'String') returns listbox4 contents as cell array
%        contents{get(hObject,'Value')} returns selected item from listbox4


% --- Executes during object creation, after setting all properties.
function listbox4_CreateFcn(hObject, eventdata, handles)
% hObject    handle to listbox4 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: listbox controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes on button press in save_Pushbutton.
    function save_Pushbutton_Callback(hObject, eventdata, handles)
        SaveDirectory = uigetdir;  
        if (SaveDirectory ~= 0)
            imwrite(ImageCollage,strcat(SaveDirectory,'Collage.jpg'),'Quality',100);
        end
        guidata(hObject, handles);


% --- Executes during object creation, after setting all properties.
function finished_CreateFcn(hObject, eventdata, handles)
% hObject    handle to finished (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called


