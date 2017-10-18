%This script makes the paths for the flies look presentable

h = findobj(fig1,'Type','line');
h1 = findobj(fig1,'Type','axes');
h2 = get(h1);

%Aquire Data points from paths 
for i = 1:length(h)
    xdata{i} = get(h(i), 'XData');
    ydata{i} = get(h(i), 'YData');
end

%Setting Parameters for Axes
set(h2(length(h)).Title, 'string',sprintf('%s/%s - %s Paths',dr ,en ,day));
set(h1(length(h)), 'XTick',[],'YTick',[],'XLim', [10 93], 'YLim', [5 80], 'Position', [0.123, 0.0814, .7275, 0.87345]);

%Deletes all unnecessary graphs
for i = 1:length(h1)-1;
    delete(h1(i));
end

%Plots all data on one graph
for i = 1:length(h1)-1;
    hold on
    plot(xdata{i},ydata{i},'k');
end

