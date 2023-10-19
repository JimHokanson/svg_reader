function svg = read(file_path,varargin)
%
%   svg_reader.read

xml_doc = xmlread(file_path);

%TODO: handle options here

%should be SVG
root_node = xml_doc.getDocumentElement();
svg = svg_reader.element.svg(root_node);

%propogate style?
svg.applyStyle([]);

end