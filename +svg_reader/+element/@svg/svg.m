classdef svg < svg_reader.element
    %
    %   Class:
    %   svg_reader.element.svg

    properties
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
        function render(obj)
            figure(1)
            clf
            hold on
            set(gca,'YDir','reverse')
            for i = 1:length(obj.children)
                child = obj.children{i};
                child.render();
            end
            %TODO: respect viewbox
        end
    end
end