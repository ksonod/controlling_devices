function [] = picomotor(channel, rel_move)
%Modified version of the following code:
%astange (2020). New Focus Picomotor 8742 example (https://www.mathworks.com/matlabcentral/fileexchange/66733-new-focus-picomotor-8742-example), MATLAB Central File Exchange. Retrieved January 24, 2020.    
    USBADDR = 1; %Set in the menu of the device, only relevant if multiple are attached
    asmInfo = NET.addAssembly('C:\Program Files\New Focus\New Focus Picomotor Application\Samples\UsbDllWrap.dll'); %load UsbDllWrap.dll library
    asm_type = asmInfo.AssemblyHandle.GetType('Newport.USBComm.USB');
    NP_USB = System.Activator.CreateInstance(asm_type); 
    NP_USB.OpenDevices();  %Open the USB device

    querydata = System.Text.StringBuilder(64);
    NP_USB.Query(USBADDR, '*IDN?', querydata);
    devInfo = char(ToString(querydata));
    fprintf(['Device attached is ' devInfo '\n']); %display device ID to make sure it's recognized OK
    
    command=[num2str(channel),'PR' ,num2str(rel_move)]; % command to the picomotor
    NP_USB.Write(USBADDR,[command]); %relative move
    
    NP_USB.CloseDevices();  %Close
end
