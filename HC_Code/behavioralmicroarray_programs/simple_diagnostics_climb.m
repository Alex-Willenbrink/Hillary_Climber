%% simple_diagnostics

%Alex's Version

% this script inputs a mat file containing trajectories, and histograms
% various simple properties. 

%% set up path, if necessary

setuppath;

%% set all defaults

matname = '';
matpath = '';

%% load settings

pathtocomputeperframestats = which('simple_diagnostics');
savedsettingsfile = strrep(pathtocomputeperframestats,'simple_diagnostics.m','.simplediagnosticssrc.mat');
if exist(savedsettingsfile,'file')
  load(savedsettingsfile);
end

%% choose a mat file to analyze
helpmsg = 'Choose mat file for which to compute and plot a few simple statistics.';
matname = [matpath,matname];
[matname,matpath] = uigetfilehelp('*.mat','Choose mat file to analyze',matname,'helpmsg',helpmsg);
if isnumeric(matname) && matname == 0,
  return;
end
fprintf('Matfile: %s%s\n\n',matpath,matname);

if exist(savedsettingsfile,'file'),
  save('-append',savedsettingsfile,'matname','matpath');
else
  save(savedsettingsfile,'matname','matpath');
end
matnameonly = matname;

%% get conversion to mm, seconds

[convertunits_succeeded,matname] = convert_units_f('isautomatic',true,'matname',matnameonly,'matpath',matpath);

%% load in the data

[trx,matname,loadsucceeded] = load_tracks(matname);
if ~loadsucceeded,
  msgbox('Could not load trx from file %s\n',matname);
  return;
end

% remove flies with less than 2 frames of data
minnframes = 2;
trx = prune_short_trajectories(trx,minnframes);

climb_analysis;

restoredefaultpath
%rehash toolboxcache