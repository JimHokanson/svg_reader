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

    %??? What is the point of pathLength?

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
            
            number_pattern = '-?\d+.?\d+';
            temp = regexp(s.points,number_pattern,'match');
            temp2 = str2double(temp);
            obj.points = [temp2(1:2:end)' temp2(2:2:end)'];
        end
        function render(obj)
            keyboard
        end
    end
end