function [ v_avg ] = vol_avg( ard, ir_an )
%UNTITLED3 Summary of this function goes here
%   Detailed explanation goes here


vol_mat = zeros(1,5);

for i = 1:5;
    vol_mat(i) = readVoltage(ard,ir_an);
    pause(0.03);
end

v_avg = sum(vol_mat)/length(vol_mat);

end

