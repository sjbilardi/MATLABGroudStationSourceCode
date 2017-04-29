function varargout = mctrst(varargin)
% MCTRST MATLAB code for mctrst.fig
%      MCTRST, by itself, creates a new MCTRST or raises the existing
%      singleton*.
%
%      H = MCTRST returns the handle to a new MCTRST or the handle to
%      the existing singleton*.
%
%      MCTRST('CALLBACK',hObject,eventData,handles,...) calls the local
%      function named CALLBACK in MCTRST.M with the given input arguments.
%
%      MCTRST('Property','Value',...) creates a new MCTRST or raises the
%      existing singleton*.  Starting from the left, property value pairs are
%      applied to the GUI before mctrst_OpeningFcn gets called.  An
%      unrecognized property name or invalid value makes property application
%      stop.  All inputs are passed to mctrst_OpeningFcn via varargin.
%
%      *See GUI Options on GUIDE's Tools menu.  Choose "GUI allows only one
%      instance to run (singleton)".
%
% See also: GUIDE, GUIDATA, GUIHANDLES

% Edit the above text to modify the response to help mctrst

% Last Modified by GUIDE v2.5 10-Apr-2017 10:55:44

% Begin initialization code - DO NOT EDIT
gui_Singleton = 1;
gui_State = struct('gui_Name',       mfilename, ...
                   'gui_Singleton',  gui_Singleton, ...
                   'gui_OpeningFcn', @mctrst_OpeningFcn, ...
                   'gui_OutputFcn',  @mctrst_OutputFcn, ...
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


% --- Executes just before mctrst is made visible.
function mctrst_OpeningFcn(hObject, eventdata, handles, varargin)
% This function has no output args, see OutputFcn.
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
% varargin   command line arguments to mctrst (see VARARGIN)

% Choose default command line output for mctrst
handles.output = hObject;

% Update handles structure
guidata(hObject, handles);

% UIWAIT makes mctrst wait for user response (see UIRESUME)
% uiwait(handles.figure1);


% --- Outputs from this function are returned to the command line.
function varargout = mctrst_OutputFcn(hObject, eventdata, handles) 
% varargout  cell array for returning output args (see VARARGOUT);
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Get default command line output from handles structure
varargout{1} = handles.output;

% --- Executes on button press in connectserial.
function connectserial_Callback(hObject, eventdata, handles)
% hObject    handle to connectserial (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% clears and opens all serial ports that are currently active for the
% computer

delete(instrfindall);

% grab serial port, baud rate, from respective callback functions. set baud
% rate equal to user defined baud rate

sp = get(handles.serialport, 'String');
br = str2double(get(handles.baudrate, 'String'));
s = serial(sp);
set(s,'BaudRate',br);

% close initial window
close(gcf);

% define labels, plot titles, and delay
xLab = 'Elapsed Time (s)';
delay = 0.1;

plotTitleT1 = 'Therm 1 Temp';
yLabT1 = 'Temperature (C)';

plotTitleT2 = 'Therm 2 Temp';
yLabT2 = 'Temperature (C)';

plotTitleV = 'Battery Voltage';
yLabV = 'Voltage (V)';

plotTitleC = 'Payload Current';
yLabC = 'Current (A)';

plotTitleSA = 'Sun Angle';

% define variables
time = 0;
data = 0; % dummy variable, used to create plots
count = 0;

figure('name', 'Ground Station', 'Position', [100, 100, 1249, 695]);

% create plots in one window
% therm 1 plot
subplot(2,3,1);
ax1 = subplot(2,3,1); % put axis into variable, used later
plotTemp1 = plot(time,data);
title(plotTitleT1);
xlabel(xLab);
ylabel(yLabT1);
axis([0 10 0 1]);

% therm 2 plot
subplot(2,3,2);
ax2 = subplot(2,3,2);
plotTemp2 = plot(time,data);
title(plotTitleT2);
xlabel(xLab);
ylabel(yLabT2);
axis([0 10 0 1]);

% voltage plot
subplot(2,3,3);
ax3 = subplot(2,3,3);
plotVolt = plot(time,data);
title(plotTitleV);
xlabel(xLab);
ylabel(yLabV);
axis([0 10 0 1]);

% current plot
subplot(2,3,4);
ax4 = subplot(2,3,4);
plotCurrent = plot(time,data);
title(plotTitleC);
xlabel(xLab);
ylabel(yLabC);
axis([0 10 0 1]);

% angle plot
subplot(2,3,5);
plotAngle = compass(cosd(0),sind(0));
t = title(plotTitleSA);
set(t,'Position',[1.15 0 0]);  % move up slightly
view(90, -90);
set(findall(gcf, 'String', '  1'),'String', ' ');
set(findall(gcf, 'String', '  0.8'),'String', ' ');
set(findall(gcf, 'String', '  0.6'),'String', ' ');
set(findall(gcf, 'String', '  0.5'),'String', ' ');
set(findall(gcf, 'String', '  0.4'),'String', ' ');
set(findall(gcf, 'String', '  0.2'),'String', ' ');

% grab position of last plot, change horizontal position for text values
h = get(subplot(2,3,5), 'Position');
h(1) = h(1) + 0.2808;

% create panel, displaying text values
hp = uipanel('Position',h);
hpp = uicontrol('Parent',hp,'Style','text',...
    'FontSize',12,'Position',[20 300 60 20]);

% define labels for text values
T1st = 'Therm 1 Temp: ';
T2st = 'Therm 2 Temp: ';
Vst = 'Voltage: ';
Cst = 'Current: ';
SAst = 'Angle: ';
MT = 'Mission Time: ';

% define variables
T1v = zeros(1,1000000); % Therm 1 Temp value
T2v = zeros(1,1000000); % Therm 2 Temp value
Vv = zeros(1,1000000); % Voltage value
Cv = zeros(1,1000000); % Current value
SAv = 0; % Sun Angle value
StatusCode = 0; % Error code value

% grab current date & time
t = datetime;
t = datestr(t, 'yyyy-mm-dd HH.MM.SS');

% create header for .csv file
header = ['Elapsed time (s),' 'Therm 1 Temp (C),' 'Therm 2 Temp (C),' ...
    'Battery Voltage (V),' 'Payload Current (mA),' 'Sun Angle (degrees)'];

% .csv filename, using current date and time. saves as
% "collected_data_(YYYY-MM-DD HH.MM.SS)"
file = ['collected_data_(' t ').csv'];

% create .csv file
dlmwrite(file,[]);

% write header to .csv file
fid=fopen(file,'w');
fprintf(fid,'%s\n',header);
fclose(fid);

% start stopwatch
tic;

% open serial port, read data (first read usually produces garbage, this
% reads the garbage here so it doesn't cause the code to crash later
fopen(s);
dat = fscanf(s, '%f');

% arraySizeLimit = 100; % max number of points held by all arrays

movePt = 10; % how long in seconds until plots move in time

% create text displaying recent data in window

% Therm 1 temp value
T1value = uicontrol('Parent',hp,'Style','text',...
            'FontSize',12,'Position',[10 300 200 20]);
set(T1value, 'HorizontalAlignment', 'left')
        
% Therm 2 temp value
T2value = uicontrol('Parent',hp,'Style','text',...
    'FontSize',12,'Position',[10 275 200 20]);
set(T2value, 'HorizontalAlignment', 'left')

% Voltage value
Vvalue = uicontrol('Parent',hp,'Style','text',...
       'FontSize',12,'Position',[10 250 200 20]);
set(Vvalue, 'HorizontalAlignment', 'left')

% Current value
Cvalue = uicontrol('Parent',hp,'Style','text',...
            'FontSize',12,'Position',[10 225 200 20]);
set(Cvalue, 'HorizontalAlignment', 'left')
   
% Sun angle value
SAvalue = uicontrol('Parent',hp,'Style','text',...
            'FontSize',12,'Position',[10 200 200 20]);
set(SAvalue, 'HorizontalAlignment', 'left')

% Status of sun tracker
StatusReport = uicontrol('Parent',hp,'Style','text',...
            'FontSize',12,...
            'Position',[10 150 500 20]);
set(StatusReport, 'HorizontalAlignment', 'left')

% Proximity warning
proximityReport = uicontrol('Parent',hp,'Style','text',...
            'FontSize',12,...
            'Position',[10 125 500 20]);
set(proximityReport, 'HorizontalAlignment', 'left')

% Elapsed time of current session
missionTime = uicontrol('Parent',hp,'Style','text',...
            'FontSize',12,...
            'Position',[10 50 500 20]);
set(missionTime, 'HorizontalAlignment', 'left')

% while the plots window is open...
while ishandle(plotTemp1)

    % read data from serial port.
    %dat = fscanf(s, '%f');
    
    dataString = fscanf(s, '%s');
    dataString2 = strsplit(dataString, ',');
    data = zeros(length(dataString2),1);
    for counter=1:length(data)
        data(counter) = str2num(dataString2{counter}); 
    end

    if(~isempty(data) && isfloat(data))

        % increase counter by one, grab current stopwatch time
        count = count + 1;
        time(count) = toc;
        
        % write serial data, time, to .csv file
        dlmwrite(file,[time(count) data(1:5).'],'-append');
        
        % create array of serial data values
        T1v(count) = double(data(1));
        T2v(count) = double(data(2));
        Vv(count) = double(data(3));
        Cv(count) = double(data(4));
        SAv = double(data(5));
        StatusCode = int8(data(6));
        proximityCode = int8(data(7));

        % set x-axis and y-axis data for each plot
        set(plotTemp1,'XData',time(1:count),'YData',T1v(1:count),'Marker','.',...
            'Color', 'red', 'MarkerEdgeColor','red',...
            'MarkerFaceColor', 'red');
        set(plotTemp2,'XData',time(1:count),'YData',T2v(1:count), 'Marker','.',...
            'Color', 'red', 'MarkerEdgeColor','red',...
            'MarkerFaceColor', 'red');
        set(plotVolt,'XData',time(1:count),'YData',Vv(1:count),'Marker','.',...
            'Color', 'blue', 'MarkerEdgeColor','blue',...
            'MarkerFaceColor', 'blue');
        set(plotCurrent,'XData',time(1:count),'YData',Cv(1:count),'Marker','.',...
            'Color', 'green', 'MarkerEdgeColor','green',...
            'MarkerFaceColor', 'green');
        
        % set angle for sun angle plot. set() commmands
        set(plotAngle, 'XData', [0 cosd(SAv(end))], 'YData', ...
                [0 sind(SAv(end))], 'Marker', '.');

        % turn serial data values into strings
        T1vs = num2str(T1v(count), 3);
        T2vs = num2str(T2v(count), 3);
        Vvs = num2str(Vv(count), 3);
        Cvs = num2str(Cv(count), 3);
        SAvs = num2str(SAv, 3);

        % write text values
        T1data = [T1st T1vs ' °C'];
        T2data = [T2st T2vs ' °C'];
        Vdata = [Vst Vvs ' V'];
        Cdata = [Cst Cvs ' A'];
        SAdata = [SAst SAvs ' °'];
        MTdata = [MT num2str(time(count)) ' s'];
        
        % update text values in window
        set(T1value,'String',T1data);
        set(T2value,'String',T2data);
        set(Vvalue,'String',Vdata);
        set(Cvalue,'String',Cdata);
        set(SAvalue,'String',SAdata);
    
        % Status report updates, depends on number recieved. 
        % 0 - Sun detected to right. Moving clockwise.
        % 1 - Sun detected on left. Moving counterclockwise.
        % 2 - Satellite oriented towards sun. Idling orientation.
        % 3 - Battery low.
        % 4 - Searching for Sun.
        if StatusCode == 0
            set(StatusReport,'String', ...
                'Sun detected to right. Moving clockwise.')
        elseif StatusCode == 1
            set(StatusReport,'String', ...
                'Sun detected on left. Moving counterclockwise.')
        elseif StatusCode == 2
             set(StatusReport,'String', ...
                 'Satellite oriented towards sun. Idling orientation.')
        elseif StatusCode == 3
             set(StatusReport,'String', 'Battery low.')
        elseif StatusCode == 4
             set(StatusReport,'String', 'Searching for Sun.')
        end

        % Proximity warning updates, depends on number recieved.
        % 5 - WARNING: Object detected within 1 meter distance.
        % 6 - CLEAR: No obstacles detected.
        % other - INVALID PROXIMITY CODE.
        if proximityCode == 5
             set(proximityReport,'String', ...
                 'WARNING: Object detected within 1 meter distance.')
        elseif proximityCode == 6
             set(proximityReport,'String', 'CLEAR: No obstacles detected.')
        else
             set(proximityReport,'String', 'INVALID PROXIMITY CODE.')
        end
        
        % update elapsed time in window
        set(missionTime, 'String', MTdata)
        
        % if the elapsed time is less than five seconds, axis is static, if
        % greater than five seconds, axis moves with data
        if time(count) < movePt
        axis([ax1], [0 movePt 0 100]);
        axis([ax2], [0 movePt 0 100]);
        axis([ax3], [0 movePt 0 10]);
        axis([ax4], [0 movePt 0 2]);
        else
            axis([ax1],[time(count)-movePt time(count) 0 100]);
            axis([ax2], [time(count)-movePt time(count) 0 100]);
            axis([ax3], [time(count)-movePt time(count) 0 10]);
            axis([ax4], [time(count)-movePt time(count) 0 2]);
        end
        
        % pause loop for delay amount, then continue
    end
    pause(delay);
    
    % closes serial ports when window with plots is closed
    if ~ishandle(plotTemp1)
          delete(instrfindall);
    end
end

% --- Executes on button press in pushbutton2.
function pushbutton2_Callback(hObject, eventdata, handles)
% hObject    handle to pushbutton2 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% close window when cancel button is pushed
close(gcf);


function serialport_Callback(hObject, eventdata, handles)
% hObject    handle to serialport (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% get serial port from user
serialp = get(hObject, 'String');
handles.serialport = serialp;
display(serialp);

% Hints: get(hObject,'String') returns contents of serialport as text
%        str2double(get(hObject,'String')) returns contents of serialport as a double


% --- Executes during object creation, after setting all properties.
function serialport_CreateFcn(hObject, eventdata, handles)
% hObject    handle to serialport (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), ...
            get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end

function baudrate_Callback(hObject, eventdata, handles)
% hObject    handle to baudrate (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% get baud rate from user
baudr = str2double(get(hObject, 'String'));
handles.baudrate = baudr;
display(baudr);

% Hints: get(hObject,'String') returns contents of baudrate as text
%        str2double(get(hObject,'String')) returns contents of baudrate as a double

% --- Executes during object creation, after setting all properties.

function baudrate_CreateFcn(hObject, eventdata, handles)
% hObject    handle to baudrate (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), ...
            get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end
