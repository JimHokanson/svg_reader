classdef desc < svg_reader.element
    %
    %   Class:
    %   svg_reader.element.desc
    %
    %   https://developer.mozilla.org/en-US/docs/Web/SVG/Element/desc

    properties
        value
    end

    methods
        function obj = desc(item,parent,read_options)
            obj.value = char(item.getTextContent());
        end
        function render(obj)
            %NOOP
        end
    end
end