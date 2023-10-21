classdef desc < svg_reader.element
    %
    %   Class:
    %   svg_reader.element.desc

    properties
        value
    end

    methods
        function obj = desc(item,parent)
            obj.value = char(item.getTextContent());
        end
        function render(obj)
            %NOOP
        end
    end
end