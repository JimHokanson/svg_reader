function children = getChildren(item,parent_obj)
%
%   children = svg_reader.utils.getChildren(item)

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
        case 'g'
            child_obj = svg_reader.element.g(item,parent);
        case 'image'
            child_obj = svg_reader.image(item,parent);
        case 'line'
            child_obj = svg_reader.element.line(item,parent);
        case 'path'
            child_obj = svg_reader.element.path(item,parent);
        case 'polyline'
            child_obj = svg_reader.element.polyline(item,parent);
        case 'text'
            child_obj = svg_reader.element.text(item,parent);
        case '#text'
            child_obj = [];
            keep_mask(i) = false;
        case 'style'
            %Note sure why no #
            child_obj = svg_reader.element.style(item,parent);
        otherwise
            keyboard
    end
    children{i} = child_obj;
end
children = children(keep_mask);
end