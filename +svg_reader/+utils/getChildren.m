function children = getChildren(item,parent_obj,read_options)
%
%   children = svg_reader.utils.getChildren(item,parent_obj,read_options)
%
%   Inputs
%   ------
%   item
%   parent_obj
%   read_options : svg_reader.read_options

parent = parent_obj;
items = item.getChildNodes();
n = items.getLength;
children = cell(1,n);
keep_mask = true(1,n);
for i = 1:n
    item = items.item(i-1);
    node_name = char(item.getNodeName);
    %saw #text - not sure what that indicates vs just text
    switch node_name
        case '#comment'
            child_obj = [];
            keep_mask(i) = false;
        case 'defs'
            %[defs: null]
            child_obj = svg_reader.element.defs(item,parent,read_options);
        case 'desc'
            child_obj = svg_reader.element.desc(item,parent,read_options);
        case 'ellipse'
            child_obj = svg_reader.element.ellipse(item,parent,read_options);
        case 'filter'
            child_obj = svg_reader.element.filter(item,parent,read_options);
        case 'g'
            child_obj = svg_reader.element.g(item,parent,read_options);
        case 'image'
            child_obj = svg_reader.element.image(item,parent,read_options);
        case 'line'
            child_obj = svg_reader.element.line(item,parent,read_options);
        case 'path'
            child_obj = svg_reader.element.path(item,parent,read_options);
        case 'polygon'
            child_obj = svg_reader.element.polygon(item,parent,read_options);
        case 'polyline'
            child_obj = svg_reader.element.polyline(item,parent,read_options);
        case 'script'
            child_obj = svg_reader.element.script(item,parent,read_options);
        case 'text'
            child_obj = svg_reader.element.text(item,parent,read_options);
        case '#text'
            child_obj = [];
            keep_mask(i) = false;
        case 'style'
            %Note sure why no #
            child_obj = svg_reader.element.style(item,parent,read_options);
        otherwise
            keyboard
    end
    children{i} = child_obj;
end
children = children(keep_mask);
end