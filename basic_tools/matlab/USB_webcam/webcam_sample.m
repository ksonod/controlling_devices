disp('--Available cameras--')
disp(webcamlist) % shows available cameras

%cam = webcam(1); % connects to the single webcam

preview(cam); % displays live video data

pause(10) % show the video for 10 seconds

closePreview(cam); % ckises the webcam preview window for the webcam object.
