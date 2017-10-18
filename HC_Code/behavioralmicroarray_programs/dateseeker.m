function [ datepaths ] = dateseeker( pathname )
%Seeks out and records dategram paths for a specific genotype after a
%dategramspeed.fig is given 
%   Just insert a path for a dategramspeed.fig
datepaths = {};

pather = strfind(pathname,'\');
pather2 = [pather(end-1)];
pather3 = pathname(1:pather2);

dates = dir(pather3);
dates = dates(3:end);

for i = 1:length(dates);
    datepaths{i} = [pather3, dates(i).name];
end
end