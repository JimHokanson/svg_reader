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
%   svg_reader.loadExample()
%
%   s = svg_reader.loadExample('yellow_star')
%   


temp = mfilename('fullpath');
root = fileparts(fileparts(temp));
example_root = fullfile(root,'examples');

if nargin == 0
    d = dir(fullfile(example_root,'*.svg'));
    example_list = {d.name}';
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