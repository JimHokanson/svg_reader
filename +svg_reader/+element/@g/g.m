classdef g < svg_reader.element
    %
    %   Class:
    %   svg_reader.element.g
    %
    %   Group element. This is used by Illustrator to indicate a layer
    %
    %   See Also
    %   --------
    %   svg_reader.element.svg

    properties
        parent
        id
        children
        t
    end

    methods
        function obj = g(item,parent)
            obj.parent = parent;
            obj.getAttributes(item)
            s = obj.attributes;
            if isfield(s,'id')
                obj.id = s.id;
            end
            obj.children = svg_reader.utils.getChildren(item,obj);
            
            %Build table
            %-------------------------
            %index, class_name, id
            
            fh = @svg_reader.utils.getPartialClassName;
            class_name = cellfun(fh,obj.children,'un',0)';
            fh = @svg_reader.utils.getIDifPresent;
            id = cellfun(fh,obj.children,'un',0)';
            index = (1:length(class_name))';
            obj.t = table(index,class_name,id);
        end
        function render(obj)
            for i = 1:length(obj.children)
                child = obj.children{i};
                child.render();
            end
        end
    end
end