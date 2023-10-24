function svg = read(file_path,varargin)
%
%   svg_reader.read(file_path,varargin)
%
%   Inputs
%   ------
%   file_path
%
%   Improvements
%   ------------
%   1. empty file path, prompt for file

xml_doc = xmlread(file_path);

if nargin == 1
    read_options = svg_reader.read_options();
elseif isobject(varargin{1})
    read_options = varargin{1};
else
    error('unsupported case')
end

%TODO: handle options here

%should be SVG
root_node = xml_doc.getDocumentElement();
svg = svg_reader.element.svg(root_node,file_path,read_options);

%propogate style?
svg.applyStyle([]);

end