classdef transform < handle
    %
    %   Class:
    %   svg_reader.attr.transform
    %
    %   https://developer.mozilla.org/en-US/docs/Web/SVG/Attribute/transform
    %
    %   matrix(<a> <b> <c> <d> <e> <f>)
    %   translate(<x> [<y>]) %if y not given, assumed to be 0
    %   scale(<x> [<y>])   %y is optional, if not given = x
    %   rotate(<a> [<x> <y>]) %if given, rotation is about the point x,y
    %   skewX(<a>)
    %   skewY(<a>)
    


    %{
    transform="rotate(-10 50 100)
               translate(-36 45.5)
               skewX(40)
               scale(1 0.5)">
    %}

    properties
        raw_string
        commands
        command_inputs
    end

    methods
        function obj = transform(input_str)
            obj.raw_string = input_str;
            %basically not (, then (, then not ), then )
            %literal ( and ) need to be escaped \(, \)
            %whereas the () and that are not escaped are captures
            matches = regexp(input_str,'([^\(]+)\(([^\)]+)\)','tokens');

            %Note #s after decimal are optional
            number_pattern = '-?\d+\.?\d*';

            n_matches = length(matches);
            commands = cell(1,n_matches);
            inputs = cell(1,n_matches);
            for i = 1:n_matches
                temp = matches{i};
                commands{i} = temp{1};
                remainder = temp{2};
                %'0.5082 0 0 0.5082 28.4118 0'
                %inputs{i} = str2double(strsplit(remainder,','));
                temp = regexp(remainder,number_pattern,'match');
                inputs{i} = str2double(temp);
            end
            obj.commands = commands;
            obj.command_inputs = inputs;
        end
        function data = applyImageTransform(obj,data)
            %   imwarp

            for i = 1:length(obj.commands)
                inputs = obj.command_inputs{i};
                switch obj.commands{i}
                    case 'matrix'
                        a = inputs(1);
                        b = inputs(2);
                        c = inputs(3);
                        d = inputs(4);
                        e = inputs(5);
                        f = inputs(6);
                        matrix = [a, c, e; b, d, f; 0, 0, 1];
                        %TODO: This is only 2022b
                        %affine2d? - old version
                        tform = affinetform2d(matrix);
                        data = imwarp(data, tform);
                    case 'rotate'
                        keyboard
                    case 'scale'
                        keyboard
                    case 'skewX'
                        keyboard
                    case 'skewY'
                        keyboard
                    case 'translate'
                        keyboard
                    otherwise
                        error('Unexpected case')
                end

                    %   matrix(<a> <b> <c> <d> <e> <f>)
                    %   translate(<x> [<y>]) %if y not given, assumed to be 0
                    %   scale(<x> [<y>])   %y is optional, if not given = x
                    %   rotate(<a> [<x> <y>]) %if given, rotation is about the point x,y
                    %   skewX(<a>)
                    %   skewY(<a>)
            end


        end
        function [x_new,y_new] = applyTransform(obj,x_old,y_old)

            %for images I think we need something different
            %
            



            x = x_old;
            y = y_old;
            for i = 1:length(obj.commands)
                inputs = obj.command_inputs{i};
                switch obj.commands{i}
                    case 'matrix'
                        [x,y] = obj.matrix(x,y,inputs);
                    case 'rotate'
                        keyboard
                    case 'scale'
                        keyboard
                    case 'skewX'
                        keyboard
                    case 'skewY'
                        keyboard
                    case 'translate'
                        keyboard
                    otherwise
                        error('Unexpected case')
                end

                    %   matrix(<a> <b> <c> <d> <e> <f>)
                    %   translate(<x> [<y>]) %if y not given, assumed to be 0
                    %   scale(<x> [<y>])   %y is optional, if not given = x
                    %   rotate(<a> [<x> <y>]) %if given, rotation is about the point x,y
                    %   skewX(<a>)
                    %   skewY(<a>)
            end
            x_new = x;
            y_new = y;

        end
        function [x_new,y_new] = matrix(obj,x_old,y_old,inputs)
            a = inputs(1);
            b = inputs(2);
            c = inputs(3);
            d = inputs(4);
            e = inputs(5);
            f = inputs(6);
            %
            %   a  c  e 
            %   b  d  f
            %   0  0  1

            %2 x 3
            %
            %

            %m1 = [x_old(:) y_old(:)];
            %m2 = [a c e; b d f];

            %wtf = m1*m2;

            x_new = a*x_old + c*y_old + e;
            y_new = b*x_old + d*y_old + f;
        end
    end
end