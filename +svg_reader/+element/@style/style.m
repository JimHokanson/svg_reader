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
        attributes
        class_names
        class_styles
        id_names
        id_styles
        raw_value
    end

    methods
        function obj = style(item,parent)
            obj.parent = parent;
            s = svg_reader.utils.getAttributes(item);
            obj.attributes = s;
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
        function s = mergeStyles(obj,s)
            %
            %   See Also
            %   --------
            %   svg_reader.element.applyStyle
            if isfield(s,'id')
                s = style_use.mergeStyles(s);
            end
            if isfield(s,'class')
                s = style_use.mergeStyles(s);
            end
            keyboard
        end
        function applyStyle(obj,other_style)
            %NOOP
        end
    end
end