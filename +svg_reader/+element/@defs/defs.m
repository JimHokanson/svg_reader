classdef defs < svg_reader.element
    %UNTITLED10 Summary of this class goes here
    %   Detailed explanation goes here

    properties
        parent
        id
        children
        t
    end

    methods
        function obj = defs(item,parent,read_options)
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
            out = [out{:}];
        end
        function render(obj,render_options)
            %NOOP

            %
            % for i = 1:length(obj.children)
            %     child = obj.children{i};
            %     child.render(render_options);
            % end
        end
    end
end