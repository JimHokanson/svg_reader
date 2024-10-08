classdef text < svg_reader.element
    %
    %   Class:
    %   svg_reader.element.text
    %
    %   https://developer.mozilla.org/en-US/docs/Web/SVG/Element/text

    properties
        parent
        value
        h_text
    end

    methods
        function obj = text(item,parent,read_options)
            obj.parent = parent;
            obj.getAttributes(item);
            obj.value = char(item.getTextContent());
        end
        function render(obj,render_options)
            arguments
                obj svg_reader.element.text
                render_options svg_reader.render_options
            end
            x = 0;
            y = 0;
            if isfield(obj.attributes,'transform') && render_options.apply_transforms
                [x,y] = obj.attributes.transform.applyTransform(0,0);
            end
            %TODO: Font size, color, how to place
            %   SVG font model position vs MATLAB?
            obj.h_text = text(x,y,obj.value,'Clipping','on');
        end
        function hide(obj)
            if ~isempty(obj.h_text) && isvalid(obj.h_text)
                obj.h_text.Visible = 'on';
            end
        end
        function show(obj)
            if ~isempty(obj.h_text) && isvalid(obj.h_text)
                obj.h_text.Visible = 'on';
            end
        end
    end
end