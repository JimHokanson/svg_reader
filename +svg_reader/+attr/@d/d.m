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
            currentX = 0;
            currentY = 0;
            n_commands = length(obj.commands);
            for i = 1:length(n_commands)
                switch obj.commands{i}
                    case 'M'
                        keyboard
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
                        keyboard
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