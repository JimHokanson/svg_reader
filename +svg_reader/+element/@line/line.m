classdef line < svg_reader.element
    %
    %   Class:
    %   svg_reader.element.line
    %
    %   https://developer.mozilla.org/en-US/docs/Web/SVG/Element/line
    %
    %
    %   Example
    %   -------
    %   

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
        h_stroke
    end

    methods
        function obj = line(item,parent,read_options)
            obj.parent = parent;
            obj.getAttributes(item);
            s = obj.attributes;
            obj.x = str2double({s.x1 s.x2});
            obj.y = str2double({s.y1 s.y2});
        end
        function render(obj,render_options)
            obj.h_stroke = svg_reader.utils.renderStroke(obj,obj.x,obj.y,render_options);
        end
        function hide(obj)
            if ~isempty(obj.h_stroke) && isvalid(obj.h_stroke)
                obj.h_stroke.Visible = 'off';
            end
        end
        function show(obj)
            if ~isempty(obj.h_stroke) && isvalid(obj.h_stroke)
                obj.h_stroke.Visible = 'on';
            end
        end
    end
end