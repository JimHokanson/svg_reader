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
        element_names
        element_styles
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

            %Need to remove comments
            %/* */  <- seen in wild
            %// too?

            style_value = obj.raw_value;
            %TODO: Not sure if this works for anything complicated
            style_value = regexprep(style_value,'/\*.*?\*/','');


            results = regexp(style_value,'([^{]+){([^}]+)}','tokens');
            n_results = length(results);
            names = cell(1,n_results);
            type = zeros(1,n_results);
            %0 - id
            %1 - class
            %2 - element
            is_class = false(1,n_results);
            styles = cell(1,n_results);
            for i = 1:n_results
                result = results{i};
                %1: name
                %2: attributes
                temp = strtrim(result{1});
                if temp(1) == '.'
                    %class
                    type(i) = 1;
                    names{i} = temp(2:end);
                elseif temp(1) == '#'
                    %ID
                    names{i} = temp(2:end);
                else
                    %element
                    if any(temp == ' ')
                        error('Unhandled case')
                    else
                        names{i} = temp;
                        type(i) = 2;
                    end
                end

                styles{i} = svg_reader.utils.getStyleAttributes(result{2});
            end

            obj.id_names = names(type == 0);
            obj.id_styles = styles(type == 0);
            obj.class_names = names(type == 1);
            obj.class_styles = styles(type == 1);
            obj.element_names = names(type == 2);
            obj.element_styles = styles(type == 2);
        end
        function [s,changed_fields] = mergeStyles(obj,s,elem)
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
                        changed_fields{end+1} = name; %#ok<AGROW>
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
                        changed_fields{end+1} = name; %#ok<AGROW>
                    end
                end
            end

            %TODO:
            if ~isempty(obj.element_names)
                temp = class(elem);
                %class seems to always return fully resolved
                % 'svg_reader.element.svg'
                %   want just 'svg' (last bit)
                I = find(temp == '.',1,'last');
                if ~isempty(I)
                    class_simple_name = temp(I+1:end);
                else
                    class_simple_name = temp;
                end
                mask = strcmp(class_simple_name,obj.element_names);
                if any(mask)
                    style_data = obj.element_styles{mask};
                    fn = fieldnames(style_data);
                    for i = 1:length(fn)
                        name = fn{i};
                        s.(name) = style_data.(name);
                        changed_fields{end+1} = name; %#ok<AGROW>
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