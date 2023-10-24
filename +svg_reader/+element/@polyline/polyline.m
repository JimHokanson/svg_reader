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
        function obj = polyline(item,parent)
            obj.parent = parent;
            obj.getAttributes(item);
            s = obj.attributes;
            
            numbers = svg_reader.utils.extractListofNumbers(input_str);
            %TODO: Check length, should be even
            obj.points = [numbers(1:2:end)' numbers(2:2:end)'];
        end
        function render(obj)
            x = obj.points(:,1);
            y = obj.points(:,2);
            svg_reader.utils.renderStroke(obj,x,y);
        end
    end
end