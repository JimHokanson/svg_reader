classdef text < handle
    %UNTITLED6 Summary of this class goes here
    %   Detailed explanation goes here

    properties
        parent
        attributes
        value
    end

    methods
        function obj = text(item,parent)
            obj.parent = parent;
            s = svg_reader.utils.getAttributes(item);
            obj.attributes = s;
            obj.value = char(item.getTextContent());
        end
    end
end