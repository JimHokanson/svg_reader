function svg = loadExample(file_name)
%x Returns an example SVG file
%
%   Forms
%   -----
%   %1) Returns list of options
%   svg_reader.loadExample
%
%   s = svg_reader.loadExample(example_name)
%
%   Example
%   -------
%   s = svg_reader.loadExample('yellow_star')
%   


temp = mfilename('fullpath');
root = fileparts(fileparts(temp));
example_root = fullfile(root,'examples');



%TODO: Load this dynamically from disk
example_list = {...
    'cirle'
    'yellow_star'
    'orange_sun'
    'invader'
    'fill_example_01_mdn'
    'fill_example_02_mdn'};

if nargin == 0
    disp(example_list);
    return
end



if length(file_name) > 4 && strcmp(file_name(end-2:end),'svg') 
    %do nothing
else
    file_name = [file_name '.svg'];
end

file_path = fullfile(example_root,file_name);

svg = svg_reader.read(file_path);

end