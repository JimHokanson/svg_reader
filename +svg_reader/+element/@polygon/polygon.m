classdef polygon < svg_reader.element
    %
    %   Class:
    %   svg_reader.element.polygon
    %
    %   See Also
    %   --------
    %   svg_reader.element

    %{
    Test with:
    ???
    %}

    properties
        parent
        points
    end

    methods
        function obj = polygon(item,parent)
            obj.parent = parent;
            obj.getAttributes(item);
            s = obj.attributes;

            numbers = svg_reader.utils.extractListofNumbers(input_str);
            obj.points = [numbers(1:2:end)' numbers(2:2:end)'];
        end
        function render(obj)
            x = obj.points(:,1);
            y = obj.points(:,2);

            mask = (diff(x) == 0) & (diff(y) == 0);
            x(mask) = [];
            y(mask) = [];

            %TODO: What about 1 point polygon? error?

            

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

            %Add on explicit closing, or maybe pass in as parameter
            x = [x; x(1)];
            y = [y; y(1)];

            svg_reader.utils.renderStroke(obj,x,y);

        end
    end
end