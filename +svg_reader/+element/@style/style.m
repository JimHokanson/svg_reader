classdef style < svg_reader.element
    %
    %   Class:
    %   svg_reader.element.style
    %
    %   https://developer.mozilla.org/en-US/docs/Web/SVG/Element/style
    %
    %   

    properties
        parent
        class_names
        class_styles
        id_names
        id_styles
        raw_value
    end

    methods
        function obj = style(item,parent)
            obj.parent = parent;
            obj.getAttributes(item);
            obj.raw_value = strtrim(char(item.getTextContent()));
            %{
                %class example
     	        .st0{fill:none;stroke:#00A99D;stroke-miterlimit:10;}
     	        .st1{fill:none;stroke:#FF0000;stroke-miterlimit:10;}
     	        .st2{fill:none;stroke:#FF00FF;stroke-miterlimit:10;}
     	        .st3{fill:none;stroke:#0000FF;stroke-miterlimit:10;}
     	        .st4{fill:#FFFFFF;stroke:#000000;stroke-miterlimit:10;}
     	        .st5{font-size:14px;}

                %ID example
                #para1 {
                  text-align: center;
                  color: red;
                }

                %Is this valid with SVG?
                #Element example
                circle {
                  fill: gold;
                  stroke: maroon;
                  stroke-width: 2px;
                }


            %}

            %Basically looking for: name {values}
            results = regexp(obj.raw_value,'([^{]+){([^}]+)}','tokens');
            n_results = length(results);
            names = cell(1,n_results);
            is_class = false(1,n_results);
            styles = cell(1,n_results);
            for i = 1:n_results
                result = results{i};
                %1: name
                %2: attributes
                temp = strtrim(result{1});
                if temp(1) == '.'
                    is_class(i) = true;
                elseif temp(1) == '#'
                    %fine
                else
                    error('Unrecognized style element: %s',temp)
                end
                names{i} = temp(2:end);
                styles{i} = svg_reader.utils.getStyleAttributes(result{2});
            end

            obj.class_names = names(is_class);
            obj.class_styles = styles(is_class);
            obj.id_names = names(~is_class);
            obj.id_styles = styles(~is_class);
        end
        function [s,changed_fields] = mergeStyles(obj,s)
            %
            %
            %   Inputs
            %   ------
            %   s : struct
            %
            %   See Also
            %   --------
            %   svg_reader.element.applyStyle
            %
            

            changed_fields = {};

            %Note, if we add element type
            %support we'll need a check for that
            if isfield(s,'id')
                mask = strcmp(s.id,obj.id_names);
                %TODO: Check for single match
                if any(mask)
                    style_data = obj.id_styles{mask};
                    fn = fieldnames(style_data);
                    for i = 1:length(fn)
                        name = fn{i};
                        s.(name) = style_data.(name);
                        changed_fields{end+1} = name;
                    end
                end
            end
            if isfield(s,'class')
                mask = strcmp(s.class,obj.class_names);
                %TODO: Check for single match
                if any(mask)
                    style_data = obj.class_styles{mask};
                    fn = fieldnames(style_data);
                    for i = 1:length(fn)
                        name = fn{i};
                        s.(name) = style_data.(name);
                        changed_fields{end+1} = name;
                    end
                end
            end
            
        end
        function render(obj)
            %NOOP
        end
        function applyStyle(obj,other_style)
            %NOOP
            %
            %   See Also
            %   --------
            %   svg_reader.element.applyStyle
        end
    end
end