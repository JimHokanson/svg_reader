classdef path < svg_reader.element
    %
    %   Class
    %   svg_reader.element.path
    %
    %   https://developer.mozilla.org/en-US/docs/Web/SVG/Element/path

    properties
        parent

        %svg_reader.attr.d
        d svg_reader.attr.d
    end

    methods
        function obj = path(item,parent)
            obj.parent = parent;
            obj.getAttributes(item);
            s = obj.attributes;

            %{

            SVG defines 6 types of path commands, 
            for a total of 20 commands:
            
            MoveTo: M, m
            LineTo: L, l, H, h, V, v
            Cubic Bézier Curve: C, c, S, s
            Quadratic Bézier Curve: Q, q, T, t
            Elliptical Arc Curve: A, a
            ClosePath: Z, z
            %}
            obj.d = svg_reader.attr.d(s.d,obj);
        end
        function render(obj)
            %TODO: Expose this ...
            n_points_per_step = 10;
            [x,y] = obj.getXY(n_points_per_step);
            
            %TODO: Make this more generic
            s = obj.attributes;
            if isfield(s,'stroke')
                c = svg_reader.utils.getColor(s.stroke);
            end
            keyboard
        end
        function [x,y] = getXY(obj,n_points_per_step)
            %
            %

            %See: svg_reader.attr.d.getXY
            [x,y] = obj.d.getXY(n_points_per_step);
        end
    end
end

