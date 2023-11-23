function h = renderFill(elem,x,y)
%
%   h = svg_reader.utils.renderFill(elem,x,y)
%
%   See Also
%   --------
%   svg_reader.element.ellipse
%   svg_reader.element.polygon
%   

%   UNSUPPORTED
%   https://developer.mozilla.org/en-US/docs/Web/SVG/Attribute/fill-rule


mask = (diff(x) == 0) & (diff(y) == 0);
x(mask) = [];
y(mask) = [];

%TODO: What about 1 point polygon? error?

%either present or none (-1)
c = svg_reader.utils.getColor(elem.attributes,'fill',elem);
if c ~= -1

    %'MATLAB:polyshape:repairedBySimplify'
    s = warning;
    warning('off','MATLAB:polyshape:repairedBySimplify');
    p = polyshape(x,y,'KeepCollinearPoints',true);
    warning(s);

    %disp(wtf)
    h = plot(p,'FaceColor',c(1:3),'FaceAlpha',c(4));
    %Why not edge color instead of boundary line?
    %
    %How do we control width
else
    h = [];
end

end