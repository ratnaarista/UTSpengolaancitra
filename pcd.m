function varargout = pcd(varargin)
% PCD MATLAB code for pcd.fig
%      PCD, by itself, creates a new PCD or raises the existing
%      singleton*.
%
%      H = PCD returns the handle to a new PCD or the handle to
%      the existing singleton*.
%
%      PCD('CALLBACK',hObject,eventData,handles,...) calls the local
%      function named CALLBACK in PCD.M with the given input arguments.
%
%      PCD('Property','Value',...) creates a new PCD or raises the
%      existing singleton*.  Starting from the left, property value pairs are
%      applied to the GUI before pcd_OpeningFcn gets called.  An
%      unrecognized property name or invalid value makes property application
%      stop.  All inputs are passed to pcd_OpeningFcn via varargin.
%
%      *See GUI Options on GUIDE's Tools menu.  Choose "GUI allows only one
%      instance to run (singleton)".
%
% See also: GUIDE, GUIDATA, GUIHANDLES

% Edit the above text to modify the response to help pcd

% Last Modified by GUIDE v2.5 28-Apr-2021 11:25:17

% Begin initialization code - DO NOT EDIT
gui_Singleton = 1;
gui_State = struct('gui_Name',       mfilename, ...
                   'gui_Singleton',  gui_Singleton, ...
                   'gui_OpeningFcn', @pcd_OpeningFcn, ...
                   'gui_OutputFcn',  @pcd_OutputFcn, ...
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


% --- Executes just before pcd is made visible.
function pcd_OpeningFcn(hObject, eventdata, handles, varargin)
% This function has no output args, see OutputFcn.
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
% varargin   command line arguments to pcd (see VARARGIN)

% Choose default command line output for pcd
handles.output = hObject;

% Update handles structure
guidata(hObject, handles);

% UIWAIT makes pcd wait for user response (see UIRESUME)
% uiwait(handles.figure1);


% --- Outputs from this function are returned to the command line.
function varargout = pcd_OutputFcn(hObject, eventdata, handles) 
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
[FileName,PathName]=uigetfile({'*.png*'; '*.jpg*'; '*.jpeg*'});
im = imread(fullfile(PathName,FileName));
handles.im=im;
guidata(hObject,handles);
axes(handles.axes1);
imshow(im);title('Tampilan Citra Asli');


% --- Executes on button press in pushbutton2.
function pushbutton2_Callback(hObject, eventdata, handles)
% hObject    handle to pushbutton2 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
im=handles.im;
GRAY = rgb2gray(im);
handles.Data = GRAY;
guidata(hObject,handles);
axes(handles.axes2);
imshow(GRAY);title('Tampilan Citra Hasil');
axes(handles.axes4);
imhist(GRAY);title('Histogram Hasil')

% --- Executes on button press in pushbutton3.
function pushbutton3_Callback(hObject, eventdata, handles)
% hObject    handle to pushbutton3 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
im=handles.im;
axes(handles.axes2);
Kontras = im*2.5;
imshow(Kontras);title('Tampilan Citra Hasil');
axes(handles.axes4);
imhist(Kontras);title('Histogram Hasil');


% --- Executes on button press in pushbutton4.
function pushbutton4_Callback(hObject, eventdata, handles)
% hObject    handle to pushbutton4 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
im=handles.im;
gray = rgb2gray(im);
F = imnoise(gray,'salt & pepper', 0.3);
axes(handles.axes2);
[tinggi ,  lebar] = size(F);


F2 = double(F);
for baris=2 : tinggi-1
    for kolom=2 : tinggi-1
        jum = F2(baris-1, kolom-1)+ ...
              F2(baris-1, kolom) + ...
              F2(baris-1, kolom-1)+ ...
              F2(baris, kolom-1) + ...
              F2(baris, kolom) + ...
              F2(baris, kolom+1) + ...
              F2(baris+1, kolom-1) + ...
              F2(baris+1, kolom) + ...
              F2(baris+1, kolom+1);
          
          G(baris, kolom) = uint8(1/9 * jum);
    end
end

imshow(G);title('Tampilan Citra Hasil');
axes(handles.axes4);
imhist(G);title('Histogram Hasil');

% --- Executes on button press in pushbutton5.
function pushbutton5_Callback(hObject, eventdata, handles)
% hObject    handle to pushbutton5 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
im = handles.im;
abu = rgb2gray(im);
H=[-1 0 -1; 0 4 0; -1 0 -1];

[tinggi_f, lebar_f] = size(abu);
[tinggi_h, lebar_h] = size(H);

m2 = floor(tinggi_h/2);
n2 = floor(lebar_h/2);

F2=double(abu);
for y=m2+1 : tinggi_f-m2
    for x=n2+1 : lebar_f-n2
        jum = 0;
        for p=-m2 : n2
            for q=-n2 : n2
                jum = jum + H(p+m2+1,q+n2+1) * ...
                    F2(y-p, x-q);
            end
        end
        
        G(y-m2, x-n2) = jum;
    end
end
G = uint8(G);
axes(handles.axes2);
imshow(G);title('Tampilan Citra Hasil');
axes(handles.axes4);
imhist(G);title('Histogram Hasil');

% --- Executes on button press in pushbutton6.
function pushbutton6_Callback(hObject, eventdata, handles)
% hObject    handle to pushbutton6 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
im = handles.im;
abu = rgb2gray(im);
[tinggi, lebar] = size(abu);
sx = 50;
sy = -50;
F2 = double(abu);
G=zeros(size(F2));

for y=1 : tinggi
    for x=1 : lebar
        xlama = x - sx;
        ylama = y - sy;
        
        if (xlama>=1) && (xlama<=lebar) && ...
           (ylama>=1) && (ylama<=tinggi)
           G(y, x) = F2(ylama, xlama);
        else
           G(y, x) = 0;
        end
    end
end
 G = uint8(G);
 axes(handles.axes2);
 imshow(G);title('Tampilan Citra Hasil');
 axes(handles.axes4);
 imhist(G);title('Histogram Hasil');
