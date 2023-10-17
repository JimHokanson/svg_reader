classdef svg < svg_reader.element
    %
    %   Class:
    %   svg_reader.element.svg

    properties
        attributes
        children
        t
    end

    methods
        function obj = svg(item)
            s = svg_reader.utils.getAttributes(item);
            obj.attributes = s;
            obj.children = svg_reader.utils.getChildren(item,obj);
            
            %Build table
            %-----------
            %index, class_names
            
            fh = @svg_reader.utils.getPartialClassName;
            class_name = cellfun(fh,obj.children,'un',0)';
            fh = @svg_reader.utils.getIDifPresent;
            id = cellfun(fh,obj.children,'un',0)';
            index = (1:length(class_name))';
            obj.t = table(index,class_name,id);
        end
    end
end