classdef polygon < svg_reader.element
    %
    %   Class:
    %   svg_reader.element.polygon
    %
    %   See Also
    %   --------
    %   svg_reader.element
    %
    %   Example
    %   -------
    %   svg = svg_reader.loadExample('yellow_star');
    %   svg.render()

    properties
        parent
        points
    end

    methods
        function obj = polygon(item,parent,read_options)
            obj.parent = parent;
            obj.getAttributes(item);

            input_str = obj.attributes.points;
            numbers = svg_reader.utils.extractListofNumbers(input_str);
            obj.points = [numbers(1:2:end)' numbers(2:2:end)'];
        end
        function render(obj,render_options)
            x = obj.points(:,1);
            y = obj.points(:,2);

            svg_reader.utils.renderFill(obj,x,y)

            %Add on explicit closing, or maybe pass in as parameter
            x = [x; x(1)];
            y = [y; y(1)];

            svg_reader.utils.renderStroke(obj,x,y,render_options);

        end
    end
end