%Step made to make sure analyzing data is easier in the future

set(0,'DefaultFigureWindowStyle','docked')
%% simple_diagnostics
% this script inputs a mat file containing trajectories, and histograms
% various simple properties. 

pathoriginal = cd;

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

%% plot all the trajectories

fig1 = figure(1);

nflies = length(trx);

% put all the flies on one figure
n1 = round(sqrt(nflies));
n2 = ceil(nflies/n1);
hax = createsubplots(n1,n2,[[.05,.01];[.05,.05]]);
hax = reshape(hax,[n1,n2])'; % column major
hax = hax(:)';
if n1*n2 > nflies,
  delete(hax(nflies+1:end));
  hax = hax(1:nflies);
end

% get bounds for all flies
x_mm = [trx.x_mm];
x_mm = x_mm(~isnan( x_mm ) & ~isinf( x_mm ));
y_mm = [trx.y_mm];
y_mm = y_mm(~isnan( y_mm ) & ~isinf( y_mm ));
minx = min( x_mm );
maxx = max( x_mm );
miny = min( y_mm );
maxy = max( y_mm );
dx = maxx - minx;
dy = maxy - miny;
%%
fly = 1:nflies;
  
  % plot just the trajectory
  axes(hax(fly));
  plot(trx(fly(1:end)).x_mm,trx(fly).y_mm,'k.-','markersize',3,'linewidth',.5);
  title(sprintf('Fly %d, frames %d to %d',fly,trx(fly).firstframe,trx(fly).endframe));
  axis equal;
  axis([minx-.025*dx,maxx+.025*dx,miny-.025*dy,maxy+.025*dy]);
  
  % onlt put an x-axis on the lowest plots
  [c,r] = ind2sub([n2,n1],fly);
  if r ~= n1 && r*n2+c <= nflies,
    set(hax(fly),'xticklabel',{});
  end
  if c ~= 1,
    set(hax(fly),'yticklabel',{});
  end
%%

linkaxes(hax);

%% histogram speed

fig2 = figure(2);
clf;
hax = createsubplots(1,2,[.1,.1]);

% compute speed for all flies
speed = [];
for fly = 1:nflies,
  speedcurr = sqrt(diff(trx(fly).x_mm).^2 + diff(trx(fly).y_mm).^2)*trx(fly).fps;
  speed = [speed,speedcurr];
end

% choose bins
nbins = max(1,min(100,round(length(speed)/20)));
prctlastbin = 1;
edges = [linspace(0,prctile(speed,100-prctlastbin),nbins),max(speed)];
centers = (edges(1:end-1)+edges(2:end))/2;

% histogram for all flies
counts = histc(speed,edges);
counts(end-1) = counts(end-1) + counts(end);
counts = counts(1:end-1);
freq_speed_allflies = counts / sum(counts);

% do each fly individually
freq_speed_perfly = zeros(nflies,nbins);
for fly = 1:nflies,
  speedcurr = sqrt(diff(trx(fly).x_mm).^2 + diff(trx(fly).y_mm).^2)*trx(fly).fps;
  counts = histc(speedcurr,edges);
  counts(end-1) = counts(end-1) + counts(end);
  counts = counts(1:end-1);
  freq_speed_perfly(fly,:) = counts / sum(counts);
end

axes(hax(1));
xplot = centers;
nskip = nbins/10;
xplot(end) = (1+nskip)*centers(end-1)-nskip*centers(end-2);
plot(xplot,freq_speed_perfly,'-','linewidth',.25);
hold on;
plot(xplot,freq_speed_allflies,'k.-','linewidth',5);
dx = xplot(end)-xplot(1);
dy = max(freq_speed_allflies);
ax = [-dx/20,xplot(end)+dx/20,0,dy+dy/20];
axis(ax);

% reset xticks
xtick = get(gca,'xtick');
xticklabel = cellstr(get(gca,'xticklabel'));
xticklabel(xtick > xplot(end-1)) = [];
xtick(xtick > xplot(end-1)) = [];
xtick(end+1) = xplot(end);
xticklabel{end+1} = sprintf('> %.1f',edges(end-1));
set(gca,'xtick',xtick,'xticklabel',xticklabel);
xlabel('speed (mm/s)');
ylabel('frequency');
title('histogram of speed for all flies');

%2nd Graph

axes(hax(2));
plot(xplot(1:end-1),freq_speed_allflies(1:end-1),'k.-','linewidth',2);


% reset xticks
xtick = get(gca,'xtick');
xticklabel = cellstr(get(gca,'xticklabel'));
xticklabel(xtick > xplot(end-1)) = [];
xtick(xtick > xplot(end-1)) = [];
xtick(end+1) = xplot(end);
xticklabel{end+1} = sprintf('> %.1f',edges(end-1));
set(gca,'xtick',xtick,'xticklabel',xticklabel);
xlabel('speed (mm/s)');
ylabel('frequency');
title('average histogram speed of all flies');

%legend

first = strfind(matpath,'\');
second = matpath(first(end-3)+1:first(end-2)-1);

if strcmp(second,'males') || strcmp(second,'females') == 1;
    second = matpath(first(end-4)+1:first(end-3)-1);
end

[~,gp] = strtok(second,'_');

legend(sprintf('TPR/%s - Day 15',gp(2:end)));

%%

%%IMPORTANT (RESETS PATHS -MATLAB DOES NOT LIKE LONG PATHS)- USE THIS OR
%%DIE

restoredefaultpath;
rehash toolboxcache;

%%
%Saves Figure variable options and goes back to original position

cd(matpath);

if exist('paths.fig','file') == 0;
savefig(fig1,'paths');
else
    disp('    paths.fig already exists.')
    quest = input('    Are you sure you want to save? choices (yes , no)','s');
    if strncmp(quest,'yes',3) == 1;
        savefig(fig1,'paths');
    end
end

if exist('histogramspeed.fig','file') == 0;
savefig(fig2,'histogramspeed');
else
    disp('    histogram.fig already exists.')
    quest = input('    Are you sure you want to save? choices (yes , no)','s');
    if strncmp(quest,'yes',3) == 1;
        savefig(fig2,'histogramspeed');
    end
end

cd(pathoriginal);