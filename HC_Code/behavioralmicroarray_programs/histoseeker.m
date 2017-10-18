function [ histopaths ] = histoseeker( pathname )
%Seeks out and records histogram paths for a specific genotype after a
%histogramspeed.fig is given 
%   Just insert a path for a histogramspeed.fig
rawpaths = {};
histopaths = {};

pather = strfind(pathname,'\');
pather2 = [pather(end-1)];
pather3 = pathname(1:pather2);

dates = dir(pather3);
dates = dates(3:end);

for i = 1:length(dates);
    rawpaths{i} = [pather3, dates(i).name];
end

for i = 1:length(rawpaths);
    if exist([rawpaths{i}, '\histogramspeed.fig']) ~= 0;
        histopaths{i} = [rawpaths{i}, '\histogramspeed.fig'];
    end
end
end