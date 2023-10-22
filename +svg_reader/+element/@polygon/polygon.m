classdef polygon < svg_reader.element
    %
    %   Class:
    %   svg_reader.element.polygon
    %
    %   See Also
    %   --------
    %   

    properties
        parent
        points
    end

    methods
        function obj = polygon(item,parent)
            obj.parent = parent;
            obj.getAttributes(item);
            s = obj.attributes;

            number_pattern = '-?\d+\.?\d+';
            temp = regexp(s.points,number_pattern,'match');
            temp2 = str2double(temp);
            obj.points = [temp2(1:2:end)' temp2(2:2:end)'];
        end
        function render(obj)
            x = obj.points(:,1);
            y = obj.points(:,2);

            mask = (diff(x) == 0) & (diff(y) == 0);
            x(mask) = [];
            y(mask) = [];

            

            %either present or none (-1)
            c = svg_reader.utils.getColor(obj.attributes,'fill',obj);
            if c ~= -1

                %'MATLAB:polyshape:repairedBySimplify'
                s = warning;
                warning('off','MATLAB:polyshape:repairedBySimplify');
                p = polyshape(x,y,'KeepCollinearPoints',true);
                warning(s);

                %disp(wtf)
                plot(p,'FaceColor',c(1:3),'FaceAlpha',c(4));
                %Why not edge color instead of boundary line?
                %
                %How do we control width
            end

            svg_reader.utils.renderStroke(obj,x,y);

        end
    end
end