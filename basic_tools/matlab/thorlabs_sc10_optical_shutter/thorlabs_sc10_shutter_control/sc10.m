s=serial('COM1'); % serial port object
s.Baudrate = 9600; % baud rate 
s.Terminator='CR'; 
fopen(s);
fprintf(s,'rep=5');
fprintf(s,'open=50'); % ms
fprintf(s,'shut=50'); % ms
fprintf(s,'ens');
fclose(s);