classdef text < svg_reader.element
    %
    %   Class:
    %   svg_reader.element.text

    properties
        parent
        value
    end

    methods
        function obj = text(item,parent)
            obj.parent = parent;
            obj.getAttributes(item);
            obj.value = char(item.getTextContent());
        end
    end
end