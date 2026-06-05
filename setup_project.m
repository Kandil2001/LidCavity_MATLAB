function setup_project()
%SETUP_PROJECT Add project folders to the MATLAB path and create output folders.

addpath("core");
addpath("studies");
addpath("validation");
addpath("post");

outputFolders = [
    "results"
    fullfile("results", "data")
    fullfile("results", "figures")
];

for folder = outputFolders'
    if ~exist(folder, "dir")
        mkdir(folder);
    end
end
end
