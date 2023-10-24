classdef script < svg_reader.element
    %
    %   Class:
    %   svg_reader.element.script

    properties
        parent
        value
    end

    methods
        function obj = script(item,parent)
            obj.parent = parent;
            obj.getAttributes(item);
            obj.value = char(item.getTextContent());
        end
        function render(obj)
            %do nothing
        end
    end
end