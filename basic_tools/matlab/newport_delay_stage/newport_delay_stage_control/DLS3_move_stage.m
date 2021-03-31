% Make the assembly visible from Matlab
asmInfo = NET.addAssembly('C:\Windows\Microsoft.NET\assembly\GAC_64\Newport.DLS.CommandInterface\v4.0_1.0.0.4__90ac4f829985d2bf\Newport.DLS.CommandInterface.dll');

% Make the instantiation
mydls = CommandInterfaceDLS.DLS();

% Open DLS connection
code=mydls.OpenInstrument('COM3');

% Call DLS Functions
[code current_pos]=mydls.TP;

% Show the current position of the stage
disp(current_pos);

% Call DLS Functions
code = mydls.PA_Set(10) ;

if code==0 % success
    disp("Moved");
end

% Close DLS connection
code=mydls.CloseInstrument;