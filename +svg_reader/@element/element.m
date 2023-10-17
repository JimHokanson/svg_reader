classdef element < handle
    %
    %   Class:
    %   svg_reader.element

    %Note, I'm not great about inheriting from classes
    %
    %All elements should have:
    %   - attributes
    %   
    %Some elements may have:
    %   - children

    %svg_reader.element.applyStyle


    properties
        
    end

    methods
        function applyStyle(obj,parent_style)
            if isprop(obj,'t')
                %TODO: This needs to be cleaned up
                I = find(strcmp(obj.t.class_name,'style'));
                local_style = [];
                if isempty(I)
                    style_use = parent_style;
                elseif length(I) == 1
                    local_style = obj.children{I};
                    %TODO: Do we need to merge with any svg style attribute?
                    if nargin == 2 && ~isempty(parent_style)
                        error('unhandled case')
                    end
                    style_use = local_style;
                elseif length(I) > 1
                    error('Unexpected result')
                end
            else
                style_use = parent_style;
            end
            
            if ~isempty(style_use)
                %Apply locally ...
                s = obj.attributes;
                s = style_use.mergeStyles(s);
                obj.attributes = s;
            end

            if isprop(obj,'children')
                for i = 1:length(obj.children)
                    obj.children{i}.applyStyle(style_use); 
                end
            end
        end
    end
end