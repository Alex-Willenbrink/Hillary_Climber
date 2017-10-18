%Plots the heights versus time for your flies

colors = {[1,1,1], [1,1,0], [1,0,1], [0,1,1], [1,0,0],[0,1,0], [0,0,1]};


height = trx(1).y;
times = trx(1).timestamps;
plot(times, height,'Color',colors{1});
xlabel('Time (seconds)');
ylabel('Position (mm)');
title('Climbing Position of Height of Flies Over Time');

for i = 2:length(trx);
    height = trx(i).y;
    times = trx(i).timestamps;
    
    count = 1;
    for j = 1:length(height);
        if height(j) < 150;
            count = count + 1;
        end
    end
    height = height(count:end);
    times = times(count:end);
        
    hold on
    plot(times, height,'Color',colors{i},'LineWidth',2.5);
end