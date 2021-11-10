% Obtain the user's computer type
has_windows = ispc;
has_mac = ismac;
has_unix = inuix;

% Determine install type
if has_windows && ~has_mac && ~has_unix
    type_install = "windows";
end

if ~has_windows && ~has_mac && has_unix
    type_install = "unix";
end

if ~has_windows && has_mac 
    type_install = "mac";
end

% Obtain destination folder
destination_Folder = matlabroot;

% Initialize boolean statements for the toolboxes needed
has_computer_vision = false;
has_image_processing = false;
has_machine_learning = false;
agree_to_license = true;
mode silent;

% Get table of currently installed addons
current_addons = matlab.addons.installedAddons;

% Create indexes if we do have the correct addons installed
idx_computer_vision = find(contains(current_addons.Name, 'Computer Vision Toolbox'));
idx_image_processing = find(contains(current_addons.Name, 'Image Processing Toolbox'));
idx_machine_learning = find(contains(current_addons.Name, 'Statistics and Machine Learning Toolbox'));

% If the indexes are empty, then we do not have the toolboxes installed
if isempty(idx_computer_vision)
    disp('You do not have the Computer Vision Toolbox installed');
    disp('Currently installing the toolbox. . .');
end
    
