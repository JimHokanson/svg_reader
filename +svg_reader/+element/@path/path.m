classdef path < svg_reader.element
    %
    %   Class
    %   svg_reader.elediteditement.path
    %
    %   https://developer.mozilla.org/en-US/docs/Web/SVG/Element/path

    %{
    svg = svg_reader.loadExample('starbucks');
    svg.render()
    %}

    properties
        parent

        %svg_reader.attr.d
        d svg_reader.attr.d

        h_fill
        h_stroke
    end

    methods
        function obj = path(item,parent,read_options)
            obj.parent = parent;
            obj.getAttributes(item);
            if isfield(obj.attributes,'style')
                temp = svg_reader.utils.getStyleAttributes(obj.attributes.style);
                fn = fieldnames(temp);
                for i = 1:length(fn)
                    name = fn{i};
                    obj.attributes.(name) = temp.(name);
                end
            end

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
            obj.d = svg_reader.attr.d(obj.attributes.d,obj);
        end
        function hide(obj)
            if ~isempty(obj.h_stroke) && isvalid(obj.h_stroke)
                obj.h_stroke.Visible = 'off';
            end
            if ~isempty(obj.h_fill) && isvalid(obj.h_fill)
                obj.h_fill.Visible = 'off';
            end
        end
        function show(obj)
            if ~isempty(obj.h_stroke) && isvalid(obj.h_stroke)
                obj.h_stroke.Visible = 'on';
            end
            if ~isempty(obj.h_fill) && isvalid(obj.h_fill)
                obj.h_fill.Visible = 'on';
            end
        end
        function render(obj,render_options)
            %
            %   Inputs
            %   ------
            %   render_options : svg_reader.render_options

            n_points_per_step = render_options.getNPointsPerPath(obj);
            [x,y] = obj.getXY(n_points_per_step);

            if isempty(x)
                %This was seen in Illustrator file
                %Are the pen commands saved between path calls?
                %e.g., is MX,Y useful if only thing present?
                %can next pen call take off from X,Y??
                %
                %Unclear, was last point that was relative
                %
                %followed by a line, polyline, and text objects
                %
                %TODO: Should verify there is no holdover ...
                return
            end

            %TODO: Check for transform

            %Might see duplicate points
            mask = (diff(x) == 0) & (diff(y) == 0);
            x(mask) = [];
            y(mask) = [];

            I = find(isnan(x));
            if ~isempty(I)
                starts = [1 I+1];
                stops = [I-1 length(x)];
            else
                starts = 1;
                stops = length(x);
            end

            x_orig = x;
            y_orig = y;
            n_starts = length(starts);
            cell_x = cell(1,n_starts);
            cell_y = cell(1,n_starts);
            h_all = cell(1,n_starts);
            for i = 1:n_starts
                x = x_orig(starts(i):stops(i));
                y = y_orig(starts(i):stops(i));
                if isempty(x)
                    keyboard
                end
                if fpSame(x(1),x(end)) && fpSame(y(1),y(end))
                    cell_x{i} = x(2:end);
                    cell_y{i} = y(2:end);
                else
                    cell_x{i} = x;
                    cell_y{i} = y;
                end
                %h_all{i} = svg_reader.utils.renderFill(obj,cell_x{i},cell_y{i});
                %keyboard
            end
           
            %JAH: Not sure why these need to be done all at once but
            %they do. See Starbucks example ...
            %
            %   Basically this allows the creation of holes
            %
            %   Should we move this code to inside the function????

            %either present or none (-1)
            c = svg_reader.utils.getColor(obj.attributes,'fill',obj);
            if c ~= -1

                %'MATLAB:polyshape:repairedBySimplify'
                s = warning;
                warning('off','MATLAB:polyshape:repairedBySimplify');
                warning('off','MATLAB:polyshape:boundary3Points');
                p = polyshape(cell_x,cell_y,'KeepCollinearPoints',true);
                warning(s);

                %disp(wtf)
                obj.h_fill = plot(p,'FaceColor',c(1:3),'FaceAlpha',c(4));
                %Why not edge color instead of boundary line?
                %
                %How do we control width
            else
                obj.h_fill = [];
            end

            obj.h_stroke = svg_reader.utils.renderStroke(obj,x,y,render_options);


        end
        function [x,y] = getXY(obj,n_points_per_step)
            %
            %   [x,y] = getXY(obj,n_points_per_step)
            %
            %   Inputs
            %   ------
            %   
            %   See Also
            %   --------
            %   svg_reader.attr.d.getXY

            %See: svg_reader.attr.d.getXY
            [x,y] = obj.d.getXY(n_points_per_step);
        end
    end
end

function flag = fpSame(a,b)
%Ugh, damn floating point
flag = abs(a - b) <= max(abs(a), abs(b)) * 0.00005;
end

%From ChatGPT
function orientation = checkOrientation(x, y)
% Check if the set of x-y points is ordered in a CW or CCW manner.

% Ensure the input vectors have the same length and contain at least 3 points.
if numel(x) ~= numel(y) || numel(x) < 3
    error('Input vectors must have the same length and contain at least 3 points.');
end

% Calculate the total signed area by summing the cross-products of consecutive points.
signedArea = 0;
numPoints = numel(x);

for i = 1:numPoints
    % Indices for the current and next points (wrap around at the end).
    j = mod(i, numPoints) + 1;

    % Calculate the cross-product of vectors from the current point to the next point.
    signedArea = signedArea + (x(i) * y(j) - x(j) * y(i));
end

% If the signed area is positive, the points are in a counterclockwise (CCW) order.
% If the signed area is negative, the points are in a clockwise (CW) order.
if signedArea > 0
    orientation = 'CCW';
else
    orientation = 'CW';
end
end

