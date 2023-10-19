classdef line < svg_reader.element
    %
    %   Class:
    %   svg_reader.element.line
    %
    %   https://developer.mozilla.org/en-US/docs/Web/SVG/Element/line

    %{
    x1 Defines the x-axis coordinate of the line starting point. Value
    type: <length>|<percentage>|<number> ; Default value: 0; Animatable:
    yes
    
    x2 Defines the x-axis coordinate of the line ending point. Value type:
    <length>|<percentage>|<number> ; Default value: 0; Animatable: yes
    
    y1 Defines the y-axis coordinate of the line starting point. Value
    type: <length>|<percentage>|<number> ; Default value: 0; Animatable:
    yes
    
    y2 Defines the y-axis coordinate of the line ending point. Value type:
    <length>|<percentage>|<number> ; Default value: 0; Animatable: yes
    
    pathLength Defines the total path length in user units. Value type:
    <number> ; Default value: none; Animatable: yes
    %}

    %??? TODO: Need to handle percentage

    properties
        parent
        x
        y
    end

    methods
        function obj = line(item,parent)
            obj.parent = parent;
            obj.getAttributes(item);
            s = obj.attributes;
            obj.x = str2double({s.x1 s.x2});
            obj.y = str2double({s.y1 s.y2});
        end
        function render(obj)
            c = svg_reader.utils.getColor(obj.attributes,'stroke',obj);
            %TODO: figure out line width
            line(obj.x,obj.y,'Color',c,'LineWidth',3)
        end
    end
end