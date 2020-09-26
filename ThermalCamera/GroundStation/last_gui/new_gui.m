function varargout = new_gui(varargin)
% NEW_GUI MATLAB code for new_gui.fig
%      NEW_GUI, by itself, creates a new NEW_GUI or raises the existing
%      singleton*.
%
%      H = NEW_GUI returns the handle to a new NEW_GUI or the handle to
%      the existing singleton*.
%
%      NEW_GUI('CALLBACK',hObject,eventData,handles,...) calls the local
%      function named CALLBACK in NEW_GUI.M with the given input arguments.
%
%      NEW_GUI('Property','Value',...) creates a new NEW_GUI or raises the
%      existing singleton*.  Starting from the left, property value pairs are
%      applied to the GUI before new_gui_OpeningFcn gets called.  An
%      unrecognized property name or invalid value makes property application
%      stop.  All inputs are passed to new_gui_OpeningFcn via varargin.
%
%      *See GUI Options on GUIDE's Tools menu.  Choose "GUI allows only one
%      instance to run (singleton)".
%
% See also: GUIDE, GUIDATA, GUIHANDLES

% Edit the above text to modify the response to help new_gui

% Last Modified by GUIDE v2.5 13-Apr-2020 23:40:06

% Begin initialization code - DO NOT EDIT
gui_Singleton = 1;
gui_State = struct('gui_Name',       mfilename, ...
                   'gui_Singleton',  gui_Singleton, ...
                   'gui_OpeningFcn', @new_gui_OpeningFcn, ...
                   'gui_OutputFcn',  @new_gui_OutputFcn, ...
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


% --- Executes just before new_gui is made visible.
function new_gui_OpeningFcn(hObject, eventdata, handles, varargin)
% This function has no output args, see OutputFcn.
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
% varargin   command line arguments to new_gui (see VARARGIN)

% Choose default command line output for new_gui
handles.output = hObject;

% Update handles structure
guidata(hObject, handles);

% UIWAIT makes new_gui wait for user response (see UIRESUME)
% uiwait(handles.figure1);



% --- Outputs from this function are returned to the command line.
function varargout = new_gui_OutputFcn(hObject, eventdata, handles) 
% varargout  cell array for returning output args (see VARARGOUT);
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Get default command line output from handles structure
varargout{1} = handles.output;


% --- Executes on button press in show_iocation.
function show_iocation_Callback(hObject, eventdata, handles)
% hObject    handle to show_iocation (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
url='https://thingspeak.com/apps/matlab_visualizations/338647?size=iframe'
web(url)


% --- Executes on button press in Show_video.
function Show_video_Callback(hObject, eventdata, handles)
% hObject    handle to Show_video (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
Pi_IP='192.8.8';
PORT=1234;
 t = tcpip(Pi_IP, PORT,'NetworkRole','client','InputBufferSize',1000000,'TimeOut',.3);



length=200;
width=200;
fopen(t);
while 1
    data=fscanf(t);
    % Decode the text into a byte array...
    if data

        %disp(size(data()))
        result=matlab.net.base64decode(data);
        recv_length=size(result());
        %disp(recv_length);
        if recv_length(2)== length*width
            img=permute(reshape(uint8(result),length,width),[2 1]);
            map = colormap(jet(256)); % Get the current colormap
            IMG_rgb = ind2rgb(img,map);
            
%             figure(1);
             axes(handles.axes2);
            imshow(IMG_rgb,[]);
        else
            out='Frame Dropped'
        end

    end
   
end
fclose(t);
