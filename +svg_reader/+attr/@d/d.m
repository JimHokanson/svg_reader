classdef d < handle
    %
    %   svg_reader.attr.d

    properties
        parent
        raw
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
            command_chars = 'MmLlHhVvCcSsQqTtAaZz';
            command_pattern = sprintf('[%s][^%s]*',command_chars,command_chars);

            matches = regexp(input_string,command_pattern,'match');

            number_pattern = '-?\d+\.?\d*';

            n_matches = length(matches);
            commands = cell(1,n_matches);
            inputs = cell(1,n_matches);
            for i = 1:n_matches
                temp = matches{i};
                commands{i} = temp(1);
                remainder = temp(2:end);
                %c-0.11,0.22-0.22,0.43-0.32,0.65'
                %inputs{i} = str2double(strsplit(remainder,','));
                temp = regexp(remainder,number_pattern,'match');
                inputs{i} = str2double(temp);
            end
            obj.commands = commands;
            obj.command_inputs = inputs;
        end
        function [x,y] = getXY(obj,n_points_per_step)

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
                        if i ~= 1
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
                            %implicit Ls
                            error('Not yet implemented')
                        end
                    case 'm'
                        keyboard

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
                        keyboard
                    case 'a'
                        keyboard
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