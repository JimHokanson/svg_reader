classdef d < handle
    %
    %   svg_reader.attr.d

    properties
        parent
        raw
        matches
        commands
        command_inputs
    end

    %M - move to X,Y (x,y)
    %m - add to X,Y  (dx,dy)
    %L - draw a line to X,Y (x,y) - interesting so possible to do multiple
    %lines with gaps
    %l (dx,dy)
    %H (x)
    %h (dx)
    %V (y)
    %v (dy)
    %C
    %c
    %S
    %s
    %Q
    %q
    %T
    %t
    %A
    %a
    %Z
    %z

    methods
        function obj = d(input_string,parent)
            %{

            MoveTo: M, m
            LineTo: L, l, H, h, V, v
            Cubic Bézier Curve: C, c, S, s
            Quadratic Bézier Curve: Q, q, T, t
            Elliptical Arc Curve: A, a
            ClosePath: Z, z
            %}

            obj.raw = input_string;

            

            command_chars = 'MmLlHhVvCcSsQqTtAaZz';
            command_pattern = sprintf('[%s][^%s]*',command_chars,command_chars);

            matches = regexp(input_string,command_pattern,'match');

            obj.matches = matches;
            n_matches = length(matches);
            commands = cell(1,n_matches);
            inputs = cell(1,n_matches);
            for i = 1:n_matches
                temp = matches{i};
                commands{i} = temp(1);
                remainder = temp(2:end);
                numbers = svg_reader.utils.extractListofNumbers(remainder);
                inputs{i} = numbers;
            end
            obj.commands = commands;
            obj.command_inputs = inputs;
        end
        function [x,y] = getXY(obj,n_points_per_step)


            %TODO: Working on populating n_points
            %

            n_points = 0;
            ny = 0;
            %TODO: Optimization, estimate # of points (or calculate)
            %and preinitialize
            n_commands = length(obj.commands);
            for i = 1:n_commands
                inputs = obj.command_inputs{i};
                switch obj.commands{i}
                    case 'M'
                        %(x, y)+
                        if i ~= 1
                            n_points = n_points + 1;
                        end
                        n_points = n_points + (length(inputs)-2)/2;
                    case 'm'
                        %(dx, dy)+
                        if i ~= 1
                            n_points = n_points + 1;
                        end
                        n_points = n_points + (length(inputs)-2)/2;
                    case 'L'
                        n_points = n_points + length(inputs)/2;
                    case 'l'
                        n_points = n_points + length(inputs)/2;
                    case 'H'
                        n_points = n_points + length(inputs);
                    case 'h'
                        n_points = n_points + length(inputs);
                    case 'V'
                        n_points = n_points + length(inputs);
                    case 'v'
                        %dy+
                        n_points = n_points + length(inputs);
                    case 'C'
                        n_points = n_points + length(inputs)/6 * n_points_per_step;
                    case 'c'
                        n_points = n_points + length(inputs)/6 * n_points_per_step;
                    case 'S'
                        n_points = n_points + length(inputs)/4 * n_points_per_step;
                    case 's'
                        n_points = n_points + length(inputs)/4 * n_points_per_step;
                    case 'Q'
                        keyboard
                    case 'q'
                        keyboard
                    case 'T'
                        keyboard
                    case 't'
                        keyboard
                    case 'A'
                        n_points = n_points + length(inputs)/7 * n_points_per_step;
                    case 'a'
                        n_points = n_points + length(inputs)/7 * n_points_per_step;
                    case {'Z','z'}
                        n_points = n_points + 1;
                    otherwise
                        error('Unrecognized command: %s',obj.commands{i})
                end
            end

            
            %x = zeros(1,n_points);
            %y = zeros(1,n_points);
            ip = 0;
            %n_points

            %keyboard
            rootx = 0;
            rooty = 0;
            cx = 0;
            cy = 0;
            x = [];
            y = [];
            %TODO: Optimization, estimate # of points (or calculate)
            %and preinitialize
            n_commands = length(obj.commands);
            for i = 1:n_commands
                inputs = obj.command_inputs{i};
                switch obj.commands{i}
                    case 'M'
                        %(x, y)+
                        if i ~= 1
                            ip = ip + 1;
                            %Need NaNs to break up
                            x = [x NaN]; %#ok<AGROW>
                            y = [y NaN]; %#ok<AGROW>
                        end
                        %TODO: check length
                        %(x, y)+
                        cx = inputs(1);
                        cy = inputs(2);
                        rootx = cx;
                        rooty = cy;

                        for j = 3:2:length(inputs)
                            X = inputs(j);
                            Y = inputs(j+1);
                            cx = X;
                            cy = Y;
                            x = [x X]; %#ok<AGROW>
                            y = [y Y]; %#ok<AGROW>
                        end
                    case 'm'
                        %(dx, dy)+
                        if i ~= 1
                            %Need NaNs to break up
                            x = [x NaN]; %#ok<AGROW>
                            y = [y NaN]; %#ok<AGROW>
                        end
                        %TODO: check length
                        %(x, y)+
                        cx = cx + inputs(1);
                        cy = cy + inputs(2);
                        rootx = cx;
                        rooty = cy;

                        for j = 3:2:length(inputs)
                            %L or l? - answer: l
                            X = cx + inputs(j);
                            Y = cy + inputs(j+1);
                            cx = X;
                            cy = Y;
                            x = [x X]; %#ok<AGROW>
                            y = [y Y]; %#ok<AGROW>
                        end

                    case 'L'
                        %(x,y)+
                        for j = 1:2:length(inputs)
                            X = inputs(j);
                            Y = inputs(j+1);
                            cx = X;
                            cy = Y;
                            x = [x X]; %#ok<AGROW>
                            y = [y Y]; %#ok<AGROW>
                        end
                    case 'l'
                        %(dx, dy)+
                        for j = 1:2:length(inputs)
                            X = cx + inputs(j);
                            Y = cy + inputs(j+1);
                            cx = X;
                            cy = Y;
                            x = [x X]; %#ok<AGROW>
                            y = [y Y]; %#ok<AGROW>
                        end
                    case 'H'
                        %y+
                        for j = 1:length(inputs)
                            y = [y cy]; %#ok<AGROW>
                            cx = inputs(j);
                            x = [x cx]; %#ok<AGROW>
                        end
                    case 'h'
                        %dy+
                        for j = 1:length(inputs)
                            y = [y cy]; %#ok<AGROW>
                            cx = cx + inputs(j);
                            x = [x cx]; %#ok<AGROW>
                        end
                    case 'V'
                        %y+
                        for j = 1:length(inputs)
                            x = [x cx]; %#ok<AGROW>
                            cy = inputs(j);
                            y = [y cy]; %#ok<AGROW>
                        end
                    case 'v'
                        %dy+
                        for j = 1:length(inputs)
                            x = [x cx]; %#ok<AGROW>
                            cy = cy + inputs(j);
                            y = [y cy]; %#ok<AGROW>
                        end
                    case 'C'
                        %(x1,y1, x2,y2, x,y)+
                        %Po′ = Pn = {x, y} ;
                        %Pcs = {x1, y1} ;
                        %Pce = {x2, y2}
                        t = linspace(0, 1, n_points_per_step);
                        for j = 1:6:length(inputs)
                            P0x = cx;
                            P0y = cy;
                            P1x = inputs(j);
                            P1y = inputs(j+1);
                            P2x = inputs(j+2);
                            P2y = inputs(j+3);
                            P3x = inputs(j+4);
                            P3y = inputs(j+5);
                            X = (1 - t).^3 * P0x + 3*(1 - t).^2 .*t .* P1x + 3 * (1 - t) .* t.^2 * P2x + t.^3 * P3x;
                            Y = (1 - t).^3 * P0y + 3*(1 - t).^2 .*t .* P1y + 3 * (1 - t) .* t.^2 * P2y + t.^3 * P3y;
                            x = [x X]; %#ok<AGROW>
                            y = [y Y]; %#ok<AGROW>
                            cx = P3x;
                            cy = P3y;
                        end
                    case 'c'
                        %TODO: check that length is 6
                        %(dx1,dy1, dx2,dy2, dx,dy)+
                        %Po′ = Pn = {xo + dx, yo + dy} ;
                        %Pcs = {xo + dx1, yo + dy1} ;
                        %Pce = {xo + dx2, yo + dy2}

                        %Po - start
                        %Pn - end
                        %Pcs - P1
                        %Pce - P2
                        t = linspace(0, 1, n_points_per_step);
                        for j = 1:6:length(inputs)
                            P0x = cx;
                            P0y = cy;
                            P1x = cx + inputs(j);
                            P1y = cy + inputs(j+1);
                            P2x = cx + inputs(j+2);
                            P2y = cy + inputs(j+3);
                            P3x = cx + inputs(j+4);
                            P3y = cy + inputs(j+5);
                            X = (1 - t).^3 * P0x + 3*(1 - t).^2 .*t .* P1x + 3 * (1 - t) .* t.^2 * P2x + t.^3 * P3x;
                            Y = (1 - t).^3 * P0y + 3*(1 - t).^2 .*t .* P1y + 3 * (1 - t) .* t.^2 * P2y + t.^3 * P3y;
                            x = [x X]; %#ok<AGROW>
                            y = [y Y]; %#ok<AGROW>
                            cx = P3x;
                            cy = P3y;
                        end
                    case 'S'
                        %The start control point is the reflection of the
                        %end control point of the previous curve command
                        %about the current point. If the previous command
                        %wasn't a cubic Bézier curve, the start control
                        %point is the same as the curve starting point
                        %(current point).


                        %(x2,y2, x,y)+
                        t = linspace(0, 1, n_points_per_step);
                        for j = 1:4:length(inputs)
                            P0x = cx;
                            P0y = cy;
                            if (j > 1) || (i > 1 && any(obj.commands{i-1} == 'cCSs'))
                                %reflect P2x and P2y abut the current point
                                %
                                %Not sure why it isn't
                                %2*(P0x-P2x)
                                P1x = 2*P0x - P2x;
                                P1y = 2*P0y - P2y;
                            else
                                P1x = cx;
                                P1y = cy;
                            end

                            P2x = inputs(j);
                            P2y = inputs(j+1);
                            P3x = inputs(j+2);
                            P3y = inputs(j+3);

                            X = (1 - t).^3 * P0x + 3*(1 - t).^2 .*t .* P1x + 3 * (1 - t) .* t.^2 * P2x + t.^3 * P3x;
                            Y = (1 - t).^3 * P0y + 3*(1 - t).^2 .*t .* P1y + 3 * (1 - t) .* t.^2 * P2y + t.^3 * P3y;
                            x = [x X]; %#ok<AGROW>
                            y = [y Y]; %#ok<AGROW>
                            cx = P3x;
                            cy = P3y;
                        end
                    case 's'
                        %(dx2,dy2, dx,dy)+
                        t = linspace(0, 1, n_points_per_step);
                        for j = 1:4:length(inputs)
                            P0x = cx;
                            P0y = cy;
                            if (j > 1) || (i > 1 && any(obj.commands{i-1} == 'cCSs'))
                                %reflect P2x and P2y abut the current point
                                %
                                %Simply take difference and double
                                %
                                %   Example online was 220,220
                                %   with previous P2 being 200,200
                                %   result should be 240,240
                                P1x = 2*P0x - P2x;
                                P1y = 2*P0y - P2y;
                            else
                                P1x = cx;
                                P1y = cy;
                            end

                            P2x = cx + inputs(j);
                            P2y = cy + inputs(j+1);
                            P3x = cx + inputs(j+2);
                            P3y = cy + inputs(j+3);

                            X = (1 - t).^3 * P0x + 3*(1 - t).^2 .*t .* P1x + 3 * (1 - t) .* t.^2 * P2x + t.^3 * P3x;
                            Y = (1 - t).^3 * P0y + 3*(1 - t).^2 .*t .* P1y + 3 * (1 - t) .* t.^2 * P2y + t.^3 * P3y;
                            x = [x X]; %#ok<AGROW>
                            y = [y Y]; %#ok<AGROW>
                            cx = P3x;
                            cy = P3y;
                        end
                    case 'Q'
                        keyboard
                    case 'q'
                        keyboard
                    case 'T'
                        keyboard
                    case 't'
                        keyboard
                    case 'A'
                        for j = 1:7:length(inputs)
                            %(rx ry angle large-arc-flag sweep-flag x y)+
                            rx = inputs(j);
                            ry = inputs(j+1);
                            angle = inputs(j+2);
                            large_arc_flag = inputs(j+3);
                            %large-arc-flag allows to chose one of the large arc (1) or small arc (0),
                            sweep_flag = inputs(j+4);
                            %sweep-flag allows to chose one of the clockwise turning arc (1) or counterclockwise turning arc (0)
                            x2 = inputs(j+5);
                            y2 = inputs(j+6);
    
                            xy1 = [cx,cy];
                            xy2 = [x2,y2];
                            t = linspace(0,1,n_points_per_step);
                            [X,Y] = arc(xy1, rx,ry, angle, large_arc_flag, sweep_flag, xy2, t);
                            %tempx = x;
                            %tempy = y;
                            x = [x X]; %#ok<AGROW>
                            y = [y Y]; %#ok<AGROW>
    
                            cx = x2;
                            cy = y2;
                        end
                    case 'a'
                        for j = 1:7:length(inputs)
                            %(rx ry angle large-arc-flag sweep-flag dx dy)+
                            rx = inputs(j);
                            ry = inputs(j+1);
                            angle = inputs(j+2);
                            large_arc_flag = inputs(j+3);
                            %large-arc-flag allows to chose one of the large arc (1) or small arc (0),
                            sweep_flag = inputs(j+4);
                            %sweep-flag allows to chose one of the clockwise turning arc (1) or counterclockwise turning arc (0)
                            x2 = cx + inputs(j+5);
                            y2 = cy + inputs(j+6);
    
                            xy1 = [cx,cy];
                            xy2 = [x2,y2];
                            t = linspace(0,1,n_points_per_step);
                            [X,Y] = arc(xy1, rx,ry, angle, large_arc_flag, sweep_flag, xy2, t);
                            x = [x X]; %#ok<AGROW>
                            y = [y Y]; %#ok<AGROW>
    
                            cx = x2;
                            cy = y2;
                        end
                    case {'Z','z'}
                        x = [x rootx]; %#ok<AGROW>
                        y = [y rooty]; %#ok<AGROW>
                        cx = rootx;
                        cy = rooty;
                    otherwise
                        error('Unrecognized command: %s',obj.commands{i})
                end
            end
        end
    end
end

%{
% Initialize variables to keep track of the current position
currentX = 0;
currentY = 0;

% Initialize a variable to store y-values
yValues = [];

% Iterate through the path commands
for i = 1:length(pathCommands)
    command = pathCommands{i};
    switch command.type
        case 'M'
            currentX = command.x;
            currentY = command.y;
        case 'L'
            currentX = command.x;
            currentY = command.y;
        case 'C'
            % Check if the desiredX is within the x-range of the cubic Bezier curve
            if currentX <= desiredX && desiredX <= command.x3
                % Interpolate the corresponding y-value
                t = (desiredX - currentX) / (command.x3 - currentX);
                yValue = (1 - t)^3 * currentY + 3 * (1 - t)^2 * t * command.y1 + 3 * (1 - t) * t^2 * command.y2 + t^3 * command.y3;
                yValues = [yValues, yValue];
            end
            currentX = command.x3;
            currentY = command.y3;
    end
end

%}

function [x,y] = arc(xy1, rx,ry, angle, large_arc_flag, sweep_flag, xy2, t)
%from: https://github.com/zHaytam/SvgPathProperties/blob/main/SvgPathProperties/ArcCommand.cs
% In accordance to: http://www.w3.org/TR/SVG/implnote.html#ArcOutOfRangeParameters

%EQ: 6.1
rx = abs(rx);
ry = abs(ry);

%force to 0 to 360 and convert
phi = mod(angle, 360)/360*2*pi;
%If the endpoints are identical, then this is equivalent to omitting the elliptical arc segment entirely.
if (xy1(1) == xy2(1) && xy1(2) == xy2(2))
    x = xy1(1);
    y = xy1(2);
    return
    %return new Point(x: p0.X, y: p0.Y /*, ellipticalArcAngle: 0*/); // Check if angle is correct
end

%B.2.5
% If rx = 0 or ry = 0 then this arc is treated as a straight line segment joining the endpoints.
if (rx == 0 || ry == 0)
    x = [xy1(1) xy2(1)];
    y = [xy1(2) xy2(2)];
    return
    %return this.pointOnLine(p0, p1, t);
    %
    %return new Point(x: 0, y: 0 /*, ellipticalArcAngle: 0*/); // Check if angle is correct
end

%Following "Conversion from endpoint to center parameterization"
%http://www.w3.org/TR/SVG/implnote.html#ArcConversionEndpointToCenter

%Step #1: Compute transformedPoint
%---------------------------------
%EQ 5.1
dx = 0.5*(xy1(1) - xy2(1));
dy = 0.5*(xy1(2) - xy2(2));

trans_xy = [cos(phi)*dx + sin(phi)*dy, -sin(phi)*dx + cos(phi)*dy];
x1p = trans_xy(1);
y1p = trans_xy(2);


%Not sure where this comes from ...
%
% Ensure radii are large enough
%radiiCheck = (transformedPoint.X, 2) / Math.Pow(rx, 2) +
%Math.Pow(transformedPoint.Y, 2) / Math.Pow(ry, 2);

%EQ 6.2
radii_check = x1p^2/rx^2 + y1p^2/ry^2;
if (radii_check > 1)
    rx = sqrt(radii_check) * rx;
    ry = sqrt(radii_check) * ry;
end

%EQ 5.2
c_square_numerator = rx^2*ry^2 - rx^2*y1p^2 - ry^2*x1p^2;
c_square_denom = rx^2*y1p^2 + ry^2*x1p^2;
c_radicand = c_square_numerator/c_square_denom;
if c_radicand < 0
    c_radicand = 0;
end

if large_arc_flag ~= sweep_flag
    temp = 1;
else
    temp = -1;
end

c_coef = temp * sqrt(c_radicand);

transformed_center = [c_coef*rx*y1p/ry,...
                      -c_coef*ry*x1p/rx];

cxp = transformed_center(1);
cyp = transformed_center(2);

%Step #3: Compute center
center = [cos(phi)*cxp - sin(phi)*cyp + (xy1(1)+xy2(1))/2,...
    sin(phi)*cxp + cos(phi)*cyp + (xy1(2)+xy2(2))/2];

cx = center(1);
cy = center(2);



%Step #4: Compute start/sweep angles
%-----------------------------------------------
%Start angle of the elliptical arc prior to the stretch and rotate operations.
%Difference between the start and end angles

start_vector = [(x1p-cxp)/rx, (y1p-cyp)/ry];
theta1 = angleBetween([1,0],start_vector);

end_vector = [(-x1p - cxp)/rx,(-y1p-cyp)/ry];

delta_theta = angleBetween(start_vector,end_vector);

%In other words, if fS = 0 and the right side of (eq. 5.6) is greater than
%0, then subtract 360°, whereas if fS = 1 and the right side of (eq. 5.6)
%is less than 0, then add 360°. In all other cases leave it as is.
if (~sweep_flag && delta_theta > 0)
    delta_theta = delta_theta - 2*pi;      
elseif (sweep_flag && delta_theta < 0)
    delta_theta = delta_theta + 2*pi;
end

%We use % instead of `mod(..)` because we want it to be -360deg to 360deg(but actually in radians)
delta_theta = rem(delta_theta,2*pi);

%The modulo operator, denoted by %, is an arithmetic operator. The modulo
%division operator produces the remainder of an integer division which is
%also called the modulus of the operation.

%From http://www.w3.org/TR/SVG/implnote.html#ArcParameterizationAlternatives
angle = theta1 + delta_theta*t;
temp_x = rx*cos(angle);
temp_y = ry*sin(angle);

%EQ 3.1
x = cos(phi)*temp_x - sin(phi)*temp_y + cx;
y = sin(phi)*temp_x + cos(phi)*temp_y + cy;

end

function angle = angleBetween(v0,v1)

    %acos(dot(v0,v1)/(norm(v0)*norm(v1)))

    %p = v0(1)*v1(1) + v0(2)*v1(2);
    %n = sqrt((v0(1)^2 + v0(2)^2)*(v1(1)^2 + v1(2)^2));
    if v0(1)*v1(2) - v0(2)*v1(1) < 0
        sign = -1;
    else
        sign = 1;
    end

    %Not sure how my example gave something with a small i
    %floating point issue ...
    %angle = sign*acos(p/n);
    angle = sign*acos(dot(v0,v1)/(norm(v0)*norm(v1)));
    %angle = real(angle);
end
%{
private static double AngleBetween(Point v0, Point v1)
{
    var p = v0.X * v1.X + v0.Y * v1.Y;
    var n = Math.Sqrt((Math.Pow(v0.X, 2) + Math.Pow(v0.Y, 2)) * (Math.Pow(v1.X, 2) + Math.Pow(v1.Y, 2)));
    var sign = v0.X * v1.Y - v0.Y * v1.X < 0 ? -1 : 1;
    return sign * Math.Acos(p / n);
}
%}
