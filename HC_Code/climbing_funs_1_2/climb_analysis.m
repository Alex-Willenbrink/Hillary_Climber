% Uses pixel information fron trx cell (from simple_diagnostics) to analyze
% video

p_data_x = {trx(1:end).x}; % X Pixel Data
p_data_y = {trx(1:end).y}; % Y Pixel Data
time_stamps = {trx(1:end).timestamps}; % Timestamp Data
global real_max pix_2_mm frame_1

% Establish movie name with path for future access

% Temporary Fix for weird matlab path problem
% movie
ho = trx(1).moviename;
ko = strfind(ho,'\');
MN = ho(ko(end)+1:end);
[moviepath, ~] = strtok(MN,'.');
MNR = strcat(moviepath,'.avi');

movie = strcat(matpath,MNR);
moviepath = matpath;

%movie = trx(1).moviename;

mov = VideoReader(movie);
f_1 = read(mov, 1);
info = get(mov);
real_max_time = info.NumberOfFrames/info.FrameRate;


%% Fixerrors Tool Compatible

imshow(f_1);
temp = rec_1_ques; % Question to continue when drawing outlining rectangle 
k = imrect;

point = getPosition(k);
delete(k);
close(temp);

fly_num = fly_num_ques; % Question to ask number of flies in experiment
waitfor(fly_num);
recs_width = round(point(3)/fly_num)-1;
recs_height = point(4);
recs_y = point(2);
recs_x = point(1):recs_width:point(3);

for i = 1:fly_num;
    rec_curr = sprintf('rec_%d',i);
    recs.(rec_curr) = imrect(gca,[recs_x(i),recs_y,recs_width,recs_height]);
end

temp = recs_all_ques; % Question to continue after rectangles wrap ROI's
while ishandle(temp) == 1
    pause(0.5);
end


for i = 1:fly_num;
    rec_curr = sprintf('rec_%d',i);
    recs.(rec_curr) = getPosition(recs.(rec_curr));
end

close(gcf);
candidates_x = {};
candidates_y = {};
candidates_timestamps = {};
p_data_x_trim = {};
p_data_y_trim = {};
timestamps_trim = {};

real_max = point(2)+recs_height; % Needed for zeroing out climbs
pix_2_mm = 1/trx(1).pxpermm;
frame_1 = f_1;

% Get rid of pixel data above our threshold
global threshold threshold_mm high_mm
high_mm = floor(point(4)*pix_2_mm);
find_finish;
waitfor(find_finish);


for i = 1:fly_num; % Will do this for loop for all x flies
    for j = 1:length(p_data_x) % Loop through all pixel data values cells each time (not necessarily most efficient but works)
        for k = 1:length(p_data_x{j}); % Loop through each value in each cell
            if ((p_data_x{j}(k) > recs.(sprintf('rec_%d',i))(1))  &&... % Greater than least x value 
               (p_data_x{j}(k) < recs.(sprintf('rec_%d',i))(1) + recs.(sprintf('rec_%d',i))(3)) &&... % Less than Greatest x value in rectangle
               (p_data_y{j}(k) > recs.(sprintf('rec_%d',i))(2))  &&... % Greater than least y value 
               (p_data_y{j}(k) < recs.(sprintf('rec_%d',i))(2) + recs.(sprintf('rec_%d',i))(4))); % Less than Greatest y value in rectangle
                
                % Record candidate values for later filtering
                candidates_x{length(candidates_x)+1} = p_data_x{j}(k:end);
                candidates_y{length(candidates_y)+1} = p_data_y{j}(k:end);
                candidates_timestamps{length(candidates_timestamps)+1} = time_stamps{j}(k:end);
                break; % Exit current cell if candidate value is found
            end
        end
    end
    
    % At this point, candidates start within rectangular region
    
    if isempty(candidates_x) == 0;
        for j = 1:length(candidates_x)
            for k = 1:length(candidates_x{j})
                if (candidates_y{j}(k) < threshold) && (k+3 < length(candidates_x{j}));
                    candidates_x{j} = candidates_x{j}(1:k+3);
                    candidates_y{j} = candidates_y{j}(1:k+3);
                    candidates_timestamps{j} = candidates_timestamps{j}(1:k+3);
                    break;
                end
            end
        end
        
        % At this point the candidates are trimmed to 3 frames past threshold mm
        loc_mat = [];
        for j = 1:length(candidates_x)
            for k = 1:length(candidates_x{j})
                if ((candidates_x{j}(k) > recs.(sprintf('rec_%d',i))(1))  &&... % Greater than least x value 
                    (candidates_x{j}(k) < recs.(sprintf('rec_%d',i))(1) + recs_width) &&... % Less than Greatest x value in rectangle
                    (candidates_y{j}(k) > recs.(sprintf('rec_%d',i))(2))  &&... % Greater than least y value 
                    (candidates_y{j}(k) < recs.(sprintf('rec_%d',i))(2) + recs_height)); % Less than Greatest y value in rectangle
                else
                    loc_mat(length(loc_mat)+1) = j; % Store cell information locations that go off limits
                    break;
                end
            end
        end
        
        count = 0;
        for j = 1:length(loc_mat);
            candidates_x(loc_mat(j-count)) = [];
            candidates_y(loc_mat(j-count)) = [];
            candidates_timestamps(loc_mat(j-count)) = [];
            count = count + 1;
        end
        % At this point all candidates that go out of bounds are eliminated
    end

    if isempty(candidates_x) == 0;
        min_mat = zeros(1,length(candidates_timestamps));
        % Load lowest timestamp values into min_mat
        for j = 1:length(candidates_timestamps)
            value = min(candidates_timestamps{j});
            min_mat(j) = value;
        end
        [~, ev] = min(min_mat); % Find Lowest Time stamp value index
        
        p_data_x_trim(length(p_data_x_trim)+1) = candidates_x(ev);
        p_data_y_trim(length(p_data_y_trim)+1) = candidates_y(ev);
        timestamps_trim(length(timestamps_trim)+1) = candidates_timestamps(ev);
        
    end
    
    % If no one fits any criteria, we assume no flies made it and make a
    % corresponding "dead_fly" cell
    if isempty(candidates_x);
        % Add dead_fly x points
        mid_x = (2*recs.(sprintf('rec_%d',i))(1) + recs.(sprintf('rec_%d',i))(3))/2;
        p_data_x_trim(length(p_data_x_trim)+1) = {[mid_x , mid_x]};
        
        % Add dead_fly y points
        rec_y = recs.(sprintf('rec_%d',i))(2);
        rec_h = recs.(sprintf('rec_%d',i))(4);
        p_data_y_trim(length(p_data_y_trim)+1) = {[rec_y+rec_h, rec_y+rec_h]};
        
        % Add deadfly timestamps
        timestamps_trim(length(timestamps_trim)+1) = {[0, real_max_time]};
    end 
    
    candidates_x = {};
    candidates_y = {};
    candidates_timestamps = {};
    
end



%% Establish colors for each fly and convert data to mm

color_mat = zeros(1,3,length(p_data_x_trim)); % Matrix will be used for colors

% Establish Colors First
for i = 1:length(p_data_x_trim);
    color_mat(1,1:3,i) = [rand, rand, rand];
end

dist_y = cell(1,length(p_data_x_trim)); % Establish cell for y distance plot


for i = 1:length(p_data_x_trim);
    dist_y{i} = p_data_y_trim{i}; % Transfer pixel info from p_data_y_trim to dist_y
end


% Convert pixel info to mm data (only doing vertical data cus horizontal
% data is lame... also not information we care much for)
for i = 1:length(p_data_x_trim);
    dist_y{i} = (dist_y{i}-real_max)*-1*pix_2_mm;
end


%% Figure for Y Position Plot

figure(1);

for i = 1:length(p_data_x_trim);
    hold on 
    plot(timestamps_trim{i},dist_y{i},'color',color_mat(1,1:3,i),'LineWidth',2);
end

title('Time vs Height');
xlabel('Time (sec)');
ylabel('Height (mm)');

% Find Storage Path
slashes = strfind(moviepath,'\');
stor_path = moviepath(1:slashes(end));

for i = 1:length(p_data_x_trim);
    % Fly Number
    xlswrite(sprintf('%sFly_Data.xls',stor_path),{sprintf('Fly %d', i)}, 'Fly_Positions',sprintf('%c1',63+i*2)); 
    
    % Labels
    xlswrite(sprintf('%sFly_Data.xls',stor_path),{'Time Stamps', 'Position (cm)'}, 'Fly_Positions',sprintf('%c2',63+i*2)); 
    
    % Write Time Stamps and Positions
    xlswrite(sprintf('%sFly_Data.xls',stor_path),rot90(rot90(rot90(timestamps_trim{i}))), 'Fly_Positions',sprintf('%c3',63+i*2));
    xlswrite(sprintf('%sFly_Data.xls',stor_path),rot90(rot90(rot90(dist_y{i}))), 'Fly_Positions',sprintf('%c3',64+i*2));
end


hgsave(sprintf('%sPositions',stor_path)); % Save Position Plot Figure

%% Figure for Time taken to reach threshold mm mark

figure(2);
mid_threshold_mat = zeros(1,length(p_data_y_trim));

% Find time stamp at which flies reach threshold mm mark (each fly)
for i = 1:length(p_data_x_trim);
    fin = [];
    for j = 1:length(dist_y{i});
        if dist_y{i}(j) > threshold_mm;
            fin = timestamps_trim{i}(j);
            break;
        end
    end
    
    if isempty(fin);
        mid_threshold_mat(i) = real_max_time;
    else
        mid_threshold_mat(i) = fin;
    end
end

% Find number used for scouting at least half of flies
half = length(p_data_x_trim)/2;
if rem(half,1) ~= 0;
    half = half + 0.5;
end

% Finds Fly time Necessary for at least half of flies to reach threshold mm mark
count = 0;
time_for_half = real_max_time;
mid_threshold_mat_dis = mid_threshold_mat;
while (count < half)
    [value, index] = min(mid_threshold_mat_dis);
    if (value == real_max_time);
        time_for_half = value;
        break;
    else
        count = count + 1;
        mid_threshold_mat_dis(index) = [];
        time_for_half = value;
    end
end
        

% Plotting Time to reach threshold mm mark
for i = 1:length(p_data_x_trim);
    hold on
    if mid_threshold_mat(i) == real_max_time
        plot([i-0.1,i+0.1],[1,1],'*','color',color_mat(1,1:3,i));
    else
        bar(i,mid_threshold_mat(i),'FaceColor',color_mat(1,1:3,i));
    end
end

hold on
if time_for_half == real_max_time
        plot([length(p_data_x_trim)+1.9,length(p_data_x_trim)+2.1],[1,1],'*','color',[0 0 0]);
else
        bar(length(p_data_x_trim)+2, time_for_half, 'FaceColor', [1 1 1]);
end

xlim = get(gca,'xlim');
hold on 
plot(xlim,[real_max_time real_max_time],'Color', [1 0 0]);
title(sprintf('Time to reach %d mm',threshold_mm))
ylabel(sprintf('Time to reach %d mm (sec)',threshold_mm));
xlabel('Fly Number');

fifty_data_cell = {};

for i = 1:length(mid_threshold_mat)
    fifty_data_cell{1,i} = sprintf('Fly %d',i);
    fifty_data_cell{2,i} = mid_threshold_mat(i);
end

fifty_data_cell{1,end+1} = sprintf('Half Pop Time');
fifty_data_cell{2,end} = time_for_half;

xlswrite(sprintf('%sFly_Data.xls',stor_path),fifty_data_cell, 'Fifty_Fly_Times','A1');
hgsave(sprintf('%sFifty_Climb_Times',stor_path)); % Save 50 Climb Time Figure

%% Figure for Walking paths

figure(3);

imshow(f_1);
[~,x_pixels,~] = size(f_1);

% Plot Walking points
for i = 1:length(p_data_x_trim);
    hold on
    plot(p_data_x_trim{i}, p_data_y_trim{i},'color',color_mat(1,1:3,i),'LineWidth',2);
end


hold on
mark_50 = threshold;
plot(1:x_pixels,mark_50,'color',[0 0 0]);

hgsave(sprintf('%sPaths',stor_path)); % Save Paths Figure

%% Figure for Displaying Average Velocities

figure(4);

% Find Average Velocities for each fly (absolute velocities or speed)
avgvels = zeros(1,length(p_data_x_trim));
for i = 1:length(p_data_x_trim)
    vel_points = zeros(1,length(p_data_x_trim{i})-1);
    for j = 1:length(p_data_x_trim{i})-1;
        time = timestamps_trim{i}(j+1) - timestamps_trim{i}(j);
        distance_y = dist_y{i}(j+1) - dist_y{i}(j);
        if distance_y < 0;
            distance_y = 0;
        end
        vel_points(j) = distance_y/time; % Storing velocity between each set of points
    end
    avgvels(i) = mean(vel_points); % Storing mean velocity for each fly
    if isnan(avgvels(i)); avgvels(i) = 0; end
end

% Plotting Average Velocites on Bar Graph
for i = 1:length(p_data_x_trim);
    hold on
    bar(i,avgvels(i),'FaceColor',color_mat(1,1:3,i));
end
    
hold on
bar(length(p_data_x_trim)+2,mean(avgvels),'FaceColor',[1 1 1]);
title('Average Climbing Speeds');
ylabel('Average Speed (mm/s)');
xlabel('Fly Number');

vels_data_cell = {}; % Int vels_data_cell

for i = 1:length(avgvels)
    vels_data_cell{1,i} = sprintf('Fly %d',i);
    vels_data_cell{2,i} = avgvels(i);
end

vels_data_cell{1,end+1} = sprintf('Pop Avg Velocity');
vels_data_cell{2,end} = mean(avgvels);

xlswrite(sprintf('%sFly_Data.xls',stor_path),vels_data_cell, 'Fly_Velocities','A1');

hgsave(sprintf('%sAverage_Speeds',stor_path)); % Save Paths Figure
 