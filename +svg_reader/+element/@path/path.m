classdef path < handle
    %
    %   Class
    %   svg_reader.element.path
    %
    %   https://developer.mozilla.org/en-US/docs/Web/SVG/Element/path

    properties
        parent
        attributes
        d
    end

    methods
        function obj = path(item,parent)
            obj.parent = parent;
            s = svg_reader.utils.getAttributes(item);
            obj.attributes = s;
    
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
        function [x,y] = getXY(obj,n_points_per_step)
            %
            %
            
        end
    end
end

