function start_experiment( camera,frame_rate, arduino, path, vid_name, r_rounds, r_rectime, training,t_rounds, t_rectime )

% IR Distance Equation: f(x) = [23.94 * x^(-1.937)] + 8.287
fun = @(x) 23.94*x.^-1.937+8.287;

%%
% Training Session
t_count = 0;

if training == 1;
   while t_count < t_rounds;
    writeDigitalPin(arduino,6,1);
    dis = fun(vol_avg(arduino,0));
        if dis > 21;
            t_count = t_count + 1;
            pause(4);
            writeDigitalPin(arduino,6,0);
            pause(t_rectime);
        end
   end
end

%%
% Experiment Session

% Finding Frame Number for Recording
frame_num = round(frame_rate*r_rectime);

r_count = 0;
vid_count = 1;

while r_count < r_rounds;
    writeDigitalPin(arduino,6,1);
    dis = fun(vol_avg(arduino,0));
        if dis > 21;
            r_count = r_count + 1;
            pause(4);
            writeDigitalPin(arduino,6,0);
            mkdir(sprintf('%s\\%s_%d',path,vid_name,vid_count)); % Make a folder to store video
            vid = VideoWriter(sprintf('%s\\%s_%d\\%s_%d',path,vid_name,vid_count,vid_name,vid_count));
            vid_count = vid_count + 1;
            open(vid);
            
            % Recording Video
                for i = 1:frame_num;
                    snap = snapshot(camera);
                    writeVideo(vid,snap); 
                end 
            close(vid);
        end
end

end

