classdef render_options
    %
    %   Class:
    %   svg_reader.render_options

    properties
        %NYI
        %
        %   We could have more complicated approaches ...
        %
        %   - something curve based???
        %   - object based ...
        %
        point_count_approach = 'per_path'
        n_points_per_path = 100

        %true - uses fills so that stroke width is tied to image width
        %false - use lines (much faster)
        strokes_as_fills = true;

        line_width = 2;
    end

    methods
        function obj = render_options()
        end
        function value = getNPointsPerPath(obj,path_obj,x,y)
            %
            %   value = getNPointsPerPath(obj,path_obj,x,y)
            %
            %   value = getNPointsPerPath(obj,path_obj)
            value = obj.n_points_per_path;
        end
    end
end