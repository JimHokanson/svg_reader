classdef element < handle
    %
    %   Class:
    %   svg_reader.element
    %
    %
    %   Elements
    %   --------
    %   svg_reader.element.desc
    %   svg_reader.element.g
    %   svg_reader.image <- needs to be moved
    %   svg_reader.element.line
    %   svg_reader.element.path
    %   svg_reader.element.polyline
    %   svg_reader.element.style
    %   svg_reader.element.text
    %
    %   Paths and Shapes
    %   ----------------
    %   svg_reader.element.polyline

    

    %Note, I'm not great about inheriting from classes
    %
    %All elements should have:
    %   - attributes
    %   
    %Some elements may have:
    %   - children

    %svg_reader.element.applyStyle


    properties
        attributes
    end

    methods
        function getAttributes(obj,item)
            s = svg_reader.utils.getAttributes(item);
            obj.attributes = s;
            obj.updateAttributes();
        end
        function updateAttributes(obj,changed_fields)
            if nargin == 1
                changed_fields = fieldnames(obj.attributes);
            end
            if isfield(obj.attributes,'transform') && any(strcmp('transform',changed_fields))
                obj.attributes.transform = svg_reader.attr.transform(obj.attributes.transform);
            end
        end
        function applyStyle(obj,parent_style)
            if isprop(obj,'t')
                %TODO: This needs to be cleaned up
                I = find(strcmp(obj.t.class_name,'style'));
                if isempty(I)
                    style_use = parent_style;
                elseif length(I) == 1
                    local_style = obj.children{I};
                    %TODO: Do we need to merge with any svg style attribute?
                    if nargin == 2 && ~isempty(parent_style)
                        %Should merge here if this is the case
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
                %
                %   Note, this may not do anything if no relevant styles
                %   are passed down
                s = obj.attributes;
                %Call to svg_reader.element.style.mergeStyles
                [s,changed_fields] = style_use.mergeStyles(s,obj);
                obj.attributes = s;
                if ~isempty(changed_fields)
                    obj.updateAttributes(changed_fields);
                end
            end

            if isprop(obj,'children')
                for i = 1:length(obj.children)
                    obj.children{i}.applyStyle(style_use); 
                end
            end
        end
    end
end