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

            c = svg_reader.utils.getColor(obj.attributes,'stroke',obj);

            %TODO: what is default if not explicitly None?
            %[] - missing
            %-1 - none
            if ~isempty(c) && c(1) ~= -1
                %TODO: Handle linewidth
                %
                %Last point is connected to the first point
                line([x; x(1)],[y; y(1)],'Color',c,'LineWidth',3)
            end

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

        end
    end
end