classdef filter < svg_reader.element
    %
    %   Class:
    %   svg_reader.element.filter
    %
    %   https://developer.mozilla.org/en-US/docs/Web/SVG/Element/filter

    properties
        parent
    end

    methods
        function obj = filter(item,parent,read_options)
            obj.parent = parent;
            obj.getAttributes(item);
        end
        function render(obj)
            %NOT YET IMPLEMENTED

        end
    end
end