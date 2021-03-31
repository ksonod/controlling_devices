%%% Adjustable parameters %%%%%%%
n_step = 10; % number of steps
x_init = 0;  % initial position
x_fin = 60; % final position
acc_val = 0.00015; % acceptance value 
show_im = 1; % 0: do not show an image. 1: show an image.
comport='COM3'; % for the delay line stage
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

warning('off','all') %ignore warning

% Make the assembly visible from Matlab
asmInfo = NET.addAssembly('C:\Windows\Microsoft.NET\assembly\GAC_64\Newport.DLS.CommandInterface\v4.0_1.0.0.4__90ac4f829985d2bf\Newport.DLS.CommandInterface.dll');
mydls = CommandInterfaceDLS.DLS(); % Make the instantiation
code = mydls.OpenInstrument(comport);% Open DLS connection

%%% CAMERA %%%%%%%
% Add NET assembly
asmInfo = NET.addAssembly('C:\Program Files\Thorlabs\Scientific Imaging\DCx Camera Support\Develop\DotNet\uc480DotNet.dll'); 

cam=uc480.Camera; % Create camera object handle
cam.Init(0); % Open the 1st available camera
cam.Display.Mode.Set(uc480.Defines.DisplayMode.DiB); % Set display mode to bitmap (DiB)
cam.PixelFormat.Set(uc480.Defines.ColorMode.RGBA8Packed); % Set color mode to 8-bit RGB
cam.Trigger.Set(uc480.Defines.TriggerMode.Software); % Set trigger mode to software (signal image acquisition)
%%% CAMERA %%%%%%%


%%% SCAN PART %%%%%%%
disp(['scan range: ', num2str(x_init) , ' to ', num2str(x_fin)]);

dx=(x_fin-x_init)/n_step; %step size

datpath=[pwd, '\scan_images']; 
if ~exist(datpath) % if a folder does not exist, 
    mkdir(datpath); % make it for saving images
end

i=1; % initialization
for x = x_init:dx:x_fin % start scanning
    code = mydls.PA_Set(x); % go to the target position
 
    diff = 1000; % arbitrary large value
    
    while diff>acc_val % wait until the stage moves to the target position
        [code x_current] = mydls.TP; % get current position
        diff=abs(x-x_current); % difference between the current and initial target position
        pause(0.5);
    end
        
    pause(0.1);
    
    [~,MemId]=cam.Memory.Allocate(true); % Allocate image memory
    [~, Width, Height, Bits,~] = cam.Memory.Inquire(MemId); % Obtain image information
    cam.Acquisition.Freeze(uc480.Defines.DeviceParameter.Wait);% Acquire image
    [~,tmp]=cam.Memory.CopyToArray(MemId);     % Copy image from memory

    % Reshape image
    Data=reshape(uint8(tmp),[Bits/8, Width,Height]);
    Data = Data(1:3, 1:Width, 1:Height);
    Data = permute(Data, [3,2,1]);
    
    if show_im==1
        himg = imshow(Data); % Show an image
    end
    
    disp([num2str(i) , '/', num2str(n_step+1)]); % Show a progress
        
    % Save an image
    name_img= [datpath,'\img', num2str(i), '.png'];
    imwrite(Data,name_img);
    
    i=i+1;
end

% Close camera
cam.Exit;

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

% Close DLS connection
code=mydls.CloseInstrument;