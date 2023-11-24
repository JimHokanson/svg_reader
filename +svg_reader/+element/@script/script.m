classdef script < svg_reader.element
    %
    %   Class:
    %   svg_reader.element.script

    properties
        parent
        value
    end

    methods
        function obj = script(item,parent,read_options)
            obj.parent = parent;
            obj.getAttributes(item);
            obj.value = char(item.getTextContent());
        end
        function render(obj,render_options)
            %do nothing
        end
        function hide(obj)
            keyboard
        end
        function show(obj)
            keyboard
        end
    end
end