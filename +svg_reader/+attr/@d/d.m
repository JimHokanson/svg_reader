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

            number_pattern = '-?\d+.?\d+';

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
                            error('not yet handled')
                        end
                        %TODO: check length
                        %(x, y)+
                        cx = inputs(1);
                        cy = inputs(2);
                        for j = 3:2:length(inputs)
                            %implicit Ls
                            error('Not yet implemented')
                        end
                    case 'm'
                        keyboard
                    case 'l'
                        keyboard
                    case 'L'
                        keyboard
                    case 'H'
                        keyboard
                    case 'h'
                        keyboard
                    case 'V'
                        keyboard
                    case 'v'
                        keyboard
                    case 'C'
                        keyboard
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
                            P3y = cx + inputs(j+5);
                            X = (1 - t).^3 * P0x + 3*(1 - t).^2 .*t .* P1x + 3 * (1 - t) .* t.^2 * P2x + t.^3 * P3x;
                            Y = (1 - t).^3 * P0y + 3*(1 - t).^2 .*t .* P1y + 3 * (1 - t) .* t.^2 * P2y + t.^3 * P3y;
                            x = [x X]; %#ok<AGROW> 
                            y = [y Y]; %#ok<AGROW> 
                            cx = P3x;
                            cy = P3y;
                        end
                    case 'S'
                        keyboard
                    case 's'
                        keyboard
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
                    case 'Z'
                        keyboard
                    case 'z'
                        keyboard
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