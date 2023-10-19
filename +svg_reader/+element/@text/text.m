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
        function render(obj)
            x = 0;
            y = 0;
            if isfield(obj.attributes,'transform')
                [x,y] = obj.attributes.transform.applyTransform(0,0);
            end
            %TODO: Font size, color, how to place
            %   SVG font model position vs MATLAB?
            text(x,y,obj.value)
        end
    end
end