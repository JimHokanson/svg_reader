classdef g < svg_reader.element
    %
    %   Class:
    %   svg_reader.element.g
    %
    %   Group element. This is used by Illustrator to indicate a layer.
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
        function obj = g(item,parent,read_options)
            obj.parent = parent;
            obj.getAttributes(item)
            s = obj.attributes;
            if isfield(s,'id')
                obj.id = s.id;
            end
            obj.children = svg_reader.utils.getChildren(item,obj,read_options);
            
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
        function out = getElementsOfType(obj,element_type)

            mask = strcmp(obj.t.class_name,element_type);
            out = obj.children(mask);

            mask = strcmp(obj.t.class_name,'g');
            g_indices = find(mask);
            for i = 1:length(g_indices)
                index = g_indices(i);
                child = obj.children{index};
                temp = child.getElementsOfType(element_type);
                out = [out temp]; %#ok<AGROW> 
            end
        end
        function render(obj,render_options)
            for i = 1:length(obj.children)
                child = obj.children{i};
                child.render(render_options);
            end
        end
        function hide(obj)
            for i = 1:length(obj.children)
                child = obj.children{i};
                child.hide();
            end            
        end
        function show(obj)
            for i = 1:length(obj.children)
                child = obj.children{i};
                child.show();
            end
        end
    end
end