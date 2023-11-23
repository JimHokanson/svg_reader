classdef polyline < svg_reader.element
    %
    %   Class:
    %   svg_reader.element.polyline
    %
    %   https://developer.mozilla.org/en-US/docs/Web/SVG/Element/polyline
    
    %{
    points This attribute defines the list of points (pairs of x,y absolute
    coordinates) required to draw the polyline Value type: <number>+ ;
    Default value: ""; Animatable: yes
    
    pathLength This attribute lets specify the total length for the path,
    in user units. Value type: <number> ; Default value: none; Animatable:
    yes
    %}

    %??? What is the point of pathLength? - I think this allows you
    %to verify your numerical accuracy


    %{

    %}

    properties
        parent

        % [x1 y1;
        %  x2 y2;
        %  etc. ]
        points
    end

    methods
        function obj = polyline(item,parent,read_options)
            obj.parent = parent;
            obj.getAttributes(item);
            s = obj.attributes;
            
            numbers = svg_reader.utils.extractListofNumbers(s.points);
            if mod(length(numbers),2) ~= 0
                error('Length of numbers for a polyline must be even')
            end
            obj.points = [numbers(1:2:end)' numbers(2:2:end)'];
        end
        function render(obj,render_options)
            x = obj.points(:,1);
            y = obj.points(:,2);
            svg_reader.utils.renderStroke(obj,x,y,render_options);
        end
    end
end