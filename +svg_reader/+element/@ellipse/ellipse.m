classdef ellipse < svg_reader.element
    %
    %   Class:
    %   svg_reader.element.ellipse
    %
    %   https://developer.mozilla.org/en-US/docs/Web/SVG/Element/ellipse
    %
    %   Note, may be common to transform to rotate ...
    %
    %   Example
    %   -------
    %   svg = svg_reader.loadExample('kiwi');
    %   svg.render()

    properties
       parent 
       cx
       cy
       rx
       ry
    end

    methods
        function obj = ellipse(item,parent)
            obj.parent = parent;
            obj.getAttributes(item);
            s = obj.attributes;
            obj.cx = str2double(s.cx);
            obj.cy = str2double(s.cy);
            obj.rx = str2double(s.rx);
            obj.ry = str2double(s.ry);
        end
        function render(obj,render_options)
            %
            %   Inputs
            %   ------
            %   render_options :

            n_points = render_options.getNPointsPerPath(obj);
            theta = linspace(0, 2*pi, n_points);
            x = obj.cx + obj.rx * cos(theta);
            y = obj.cy + obj.ry * sin(theta);

            svg_reader.utils.renderFill(obj,x,y);

            
        end
    end
end