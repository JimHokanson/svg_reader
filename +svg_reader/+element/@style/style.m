classdef style < svg_reader.element
    %
    %   Class:
    %   svg_reader.element.style
    %
    %   https://developer.mozilla.org/en-US/docs/Web/SVG/Element/style
    %
    %   See Also
    %   --------
    %   svg_reader.utils.getStyleAttributes

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
        function obj = style(item,parent,read_options)
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

            % Initialize containers for unique selectors
            id_map = containers.Map();
            class_map = containers.Map();
            element_map = containers.Map();

            % Clean up the style value
            style_value = obj.raw_value;

            % Remove comments
            style_value = regexprep(style_value, '/\*.*?\*/', ''); % Removes block comments /* */
            style_value = regexprep(style_value, '^\s*//.*?$', '', 'lineanchors'); % Removes line comments //

            % Extract the selectors and attributes
            results = regexp(style_value, '([^{}]+)\s*\{([^}]+)\}', 'tokens');
            n_results = length(results);

            for i = 1:n_results
                result = results{i};
                % Split multiple selectors by commas
                selectors = strtrim(split(result{1}, ','));
                attributes = result{2};

                % Get the style attributes for this rule
                new_style = svg_reader.utils.getStyleAttributes(attributes);

                for j = 1:length(selectors)
                    temp = strtrim(selectors{j});
                    if isempty(temp)
                        continue;
                    end

                    if temp(1) == '.'
                        % Class selector
                        class_name = temp(2:end); % Remove the leading '.'
                        if isKey(class_map, class_name)
                            % Merge with existing styles
                            class_map(class_name) = h__mergeStructures(class_map(class_name), new_style);
                        else
                            % Add new class style
                            class_map(class_name) = new_style;
                        end

                    elseif temp(1) == '#'
                        % ID selector
                        id_name = temp(2:end); % Remove the leading '#'
                        if isKey(id_map, id_name)
                            % Merge with existing styles
                            id_map(id_name) = h__mergeStructures(id_map(id_name), new_style);
                        else
                            % Add new ID style
                            id_map(id_name) = new_style;
                        end

                    else
                        % Element selector
                        if any(temp == ' ')
                            error('Unhandled case');
                        else
                            element_name = temp;
                            if isKey(element_map, element_name)
                                % Merge with existing styles
                                element_map(element_name) = h__mergeStructures(element_map(element_name), new_style);
                            else
                                % Add new element style
                                element_map(element_name) = new_style;
                            end
                        end
                    end
                end
            end

            % Convert maps to arrays
            obj.id_names = keys(id_map);
            obj.id_styles = values(id_map);

            obj.class_names = keys(class_map);
            obj.class_styles = values(class_map);

            obj.element_names = keys(element_map);
            obj.element_styles = values(element_map);

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
        function hide(obj)
            keyboard
        end
        function show(obj)
            keyboard
        end
        function render(obj,render_options)
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

% Helper function to merge two structures (style attributes)
function merged = h__mergeStructures(old_style, new_style)
fields_new = fieldnames(new_style);
merged = old_style;
for k = 1:length(fields_new)
    merged.(fields_new{k}) = new_style.(fields_new{k});
end
end