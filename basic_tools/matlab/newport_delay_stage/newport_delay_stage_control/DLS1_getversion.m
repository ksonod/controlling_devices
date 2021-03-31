% Make the assembly visible from Matlab
asmInfo = NET.addAssembly('C:\Windows\Microsoft.NET\assembly\GAC_64\Newport.DLS.CommandInterface\v4.0_1.0.0.4__90ac4f829985d2bf\Newport.DLS.CommandInterface.dll');

% Make the instantiation
mydls = CommandInterfaceDLS.DLS();

% Open DLS connection
code=mydls.OpenInstrument('COM3');

% Call DLS Functions
[code Version]=mydls.VE;

% Show the version of the stage
disp(Version)

% Close DLS connection
code=mydls.CloseInstrument;