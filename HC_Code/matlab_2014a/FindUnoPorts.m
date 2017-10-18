function [ devs ] = FindUnoPorts
%Function is used to find available ports that you might use to connect to
%arduino to upload your program

Skey = 'HKEY_LOCAL_MACHINE\HARDWARE\DEVICEMAP\SERIALCOMM';

% Find connected serial devices and clean up the output
[~, list] = dos(['REG QUERY ' Skey]);
list = strread(list,'%s','delimiter',' ');
coms = 0;
for i = 1:numel(list)
  if strcmp(list{i}(1:3),'COM')
      if ~iscell(coms)
          coms = list(i);
      else
          coms{end+1} = list{i};
      end
  end
end
key = 'HKEY_LOCAL_MACHINE\SYSTEM\CurrentControlSet\Enum\USB\';

% Find all installed USB devices entries and clean up the output
[~, vals] = dos(['REG QUERY ' key ' /s /f "FriendlyName" /t "REG_SZ"']);
vals = textscan(vals,'%s','delimiter','\t');
vals = cat(1,vals{:});
out = 0;
% Find all friendly name property entries
for i = 1:numel(vals)
  if strcmp(vals{i}(1:min(12,end)),'FriendlyName')
      if ~iscell(out)
          out = vals(i);
      else
          out{end+1} = vals{i};
      end
  end
end

% Compare friendly name entries with connected ports and generate output
count = 1;
for i = 1:numel(coms)
  match = strfind(out,[coms{i},')']);
  ind = 0;
  for j = 1:numel(match)
      if ~isempty(match{j})
          ind = j;
      end
  end
  
  if ind ~= 0
      com = str2double(coms{i}(4:end));
      
% Trim the trailing ' (COM##)' from the friendly name - works on ports from 1 to 99
      if com > 9
          length = 8;
      else
          length = 7;
      end
      devs{count,1} = sprintf('%s %s',out{ind}(27:end-length),num2str(com));
      count = count+1;
  end
end

% Makes an empty matrix as the output if no Arduino COMs detected
if count == 1;
    devs = [];
end

end

