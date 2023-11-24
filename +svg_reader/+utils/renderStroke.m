function p = renderStroke(elem,x,y,render_options)
%
%   
%   svg_reader.utils.renderStroke(elem,x,y)
%
%   Wrapper for (TODO: rename called function)
%   
%   Inputs
%   ------
%   elem
%   x,y :
%       Note, these may have NaN to indicate a discontinuity
%
%   See Also
%   --------
%   svg_reader.element.path
%   svg_reader.element.polygon
%   svg_reader.utils.strokeToPolyshape

%https://developer.mozilla.org/en-US/docs/Web/SVG/Attribute/stroke
%
%
%https://developer.mozilla.org/en-US/docs/Web/SVG/Attribute/stroke-dasharray
%   default: none
%
%https://developer.mozilla.org/en-US/docs/Web/SVG/Attribute/stroke-dashoffset
%   default: 0
%
%https://developer.mozilla.org/en-US/docs/Web/SVG/Attribute/stroke-linecap
%   butt | round | square
%   default: butt
%
%https://developer.mozilla.org/en-US/docs/Web/SVG/Attribute/stroke-linejoin
%   arcs | bevel |miter | miter-clip | round
%   default: miter
%
%https://developer.mozilla.org/en-US/docs/Web/SVG/Attribute/stroke-miterlimit
%   default: 4
%   = miter_length/stroke_width = 1/sin(theta/2) ???
%
%https://developer.mozilla.org/en-US/docs/Web/SVG/Attribute/stroke-opacity
%
%   Handled in getColor
%
%https://developer.mozilla.org/en-US/docs/Web/SVG/Attribute/stroke-width
%   
%   default 1 (px
%   Note, could be % like 2% - this is relative to the viewbox size, yikes!

c = svg_reader.utils.getColor(elem.attributes,'stroke',elem);

if isempty(c) || c(1) == -1
    p = [];
    return
end

I = find(isnan(x));
if ~isempty(I)
    starts = [1 I+1];
    stops = [I-1 length(x)];
else
    starts = 1;
    stops = length(x);
end


%Get relevant attributes
%-------------------------------
attr = elem.attributes;
if isfield(attr,'stroke_linecap')
    line_cap = attr.stroke_linecap;
else
    line_cap = 'butt';
end
if isfield(attr,'stroke_linejoin')
    line_join = attr.stroke_linejoin;
else
    line_join = 'miter';
end
if isfield(attr,'stroke_width')
    temp = attr.stroke_width;
    if temp(end) == '%'
        error('unhandled case')
        %Would need to get viewbox from parent or parent's parent
    else
        stroke_width = str2double(temp);
    end
else
    stroke_width = 1;
end

x_orig = x;
y_orig = y;
n_starts = length(starts);
p_all = cell(1,n_starts);
for i = 1:n_starts
    x = x_orig(starts(i):stops(i));
    y = y_orig(starts(i):stops(i));
    if render_options.strokes_as_fills
        p = svg_reader.utils.strokeToPolyshape(x,y,stroke_width,line_join,line_cap);
        %p_root
        %'MATLAB:polyshape:repairedBySimplify'
        h = plot(p);
        h.FaceColor = c(1:3);
        h.FaceAlpha = c(4);
    else
        p = plot(x,y,'LineWidth',render_options.line_width);
        p.Color = c(1:3);
    end
    p_all{i} = p;
end

p = [p_all{:}];

end