function setup_project()
%SETUP_PROJECT Add project folders to the MATLAB path and create output folders.

projectRoot = fileparts(fileparts(mfilename('fullpath')));

addpath(fullfile(projectRoot, "config"));
addpath(fullfile(projectRoot, "core"));
addpath(fullfile(projectRoot, "studies"));
addpath(fullfile(projectRoot, "validation"));
addpath(fullfile(projectRoot, "post"));

outputFolders = [
    fullfile(projectRoot, "results")
    fullfile(projectRoot, "results", "data")
    fullfile(projectRoot, "results", "figures")
];

for folder = outputFolders'
    if ~exist(folder, "dir")
        mkdir(folder);
    end
end
end
