function svg = read(file_path,varargin)
%
%   svg = svg_reader.read(file_path,varargin)
%
%   Outputs
%   -------
%   svg : svg_reader.element.svg
%       
%
%   Inputs
%   ------
%   file_path : string
%
%   Example
%   -------
%   svg = svg_reader.read()
%

persistent p_root

if nargin == 0
    if isempty(p_root)
        [file_name, file_root] = uigetfile( ...
           {'*.svg';'*.*'}, ...
            'Pick a file');
    else
        [file_name, file_root] = uigetfile( ...
           {'*.svg';'*.*'}, ...
            'Pick a file',p_root);
    end
    
    if isnumeric(file_name)
        return
    end

    file_path = fullfile(file_root,file_name);

    read_options = svg_reader.read_options();
elseif nargin == 1
    read_options = svg_reader.read_options();
elseif isobject(varargin{1})
    read_options = varargin{1};
else
    %TODO: handle options here
    error('unsupported case')
end

xml_doc = xmlread(file_path);

p_root = fileparts(file_path);

%should be SVG
root_node = xml_doc.getDocumentElement();
svg = svg_reader.element.svg(root_node,file_path,read_options);

%propogates styles

%HACK: defs
defs = svg.getElementsOfType('defs');
if ~isempty(defs)
    style = defs.getElementsOfType('style');
else
    style = [];
end

svg.applyStyle(style);

end