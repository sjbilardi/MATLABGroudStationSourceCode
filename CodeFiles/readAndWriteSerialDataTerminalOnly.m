serialPortNumb= 'COM3';
baudRate = 4800;

serialPortInitErr = false;
delete(instrfindall);

try
    serialPort = serial(serialPortNumb);
    set(serialPort,'BaudRate',baudRate);
%     serialPort.BytesAvailableFcnCount = 30;
%     serialPort.BytesAvailableFcnMode = 'byte';
%     serialport.BytesAvailableFcn = @instrcallback;
catch
    serialPortInitErr = true;
    disp('Error initializing serial port.');
    delete(instrfindall);
end

if(serialPortInitErr == false)
    % grab current date & time
    count = 0;
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
    fid=fopen(file,'a');
    fprintf(fid,'%s\n',header);
    fclose(fid);

    % start stopwatch
    tic;

    % open serial port
    fopen(serialPort);

    % expected number of values in received array
    expectedValNumb = 7;

    while(1)
%         %serialPort.bytesAvailable
%         if(count > 25)
%             count = 0; 
%             try
%                 fclose(serialPort);
%                 serialPort = serial(serialPortNumb);
%                 set(serialPort,'BaudRate',baudRate);
%                 fopen(serialport);
%             catch
%                 serialPortInitErr = true;
%                 disp('Error initializing serial port.');
%                 delete(instrfindall);
%             end
%         end
        
        try
            %fopen(serialPort);
            %data = fscanf(serialPort, '%f');
            dataString = fscanf(serialPort, '%s');
            dataString2 = strsplit(dataString, ',');
            data = zeros(length(dataString2),1);
            for counter=1:length(data)
                data(counter) = str2num(dataString2{counter}); 
            end
        
            count = count + 1;
        catch
        end

        if((size(data,1) == expectedValNumb) && ~isempty(data))% && ...
            %(serialPort.bytesAvailable > 20))
            % increase counter by one, grab current stopwatch time
            time = toc;

            % write serial data, time, to .csv file
            dlmwrite(file,[time data(1:5).'],'-append');

            % extract information from string
            Temp1 = double(data(1));
            Temp2 = double(data(2));
            BattV = double(data(3));
            BattC = double(data(4));
            SunAngle = double(data(5));
            StatusCode = int8(data(6));
            ProximityCode = int8(data(7));

            % generate status messages based off StatusCode
            switch StatusCode
                case 0
                    Status = 'Sun detected to right. Moving clockwise.';
                case 1
                    Status = 'Sun detected on left. Moving counterclockwise.';
                case 2
                    Status = 'Satellite oriented towards sun. Idling orientation.';
                case 3
                    Status = 'Battery Low.';
                case 4
                    Status = 'Searching for sun.';
            end
            
            %ProximityWarning = 'CLEAR';
            % generate proximity warning based off ProximityCode
            switch ProximityCode
                case 5
                    ProximityWarning = 'OBJECT DETECTED WITHIN 90 CM';
                case 6
                    ProximityWarning = 'CLEAR';
            end

            % print info to terminal
            clc; % clear terminal window
            fprintf('%s\n', dataString);
            fprintf('Mission Duration : %.2f s\n', time);
            fprintf('Temperature 1: %.2f °C\n', Temp1);
            fprintf('Temperature 2: %.2f °C\n', Temp2);
            fprintf('Battery Voltage: %.2f V\n', BattV);
            fprintf('Battery Current: %.2f A\n', BattC);
            fprintf('Sun Angle: %.2f°\n', SunAngle);
            fprintf('Current Status: %s\n', Status);
            fprintf('Proximity Warning: %s\n', ProximityWarning);
        else
            disp('Received string does not contain expected number of values');
        end
        pause(0.05);
        %fclose(serialPort);
    end
end

fclose(serialPort);
delete(instrfindall);
