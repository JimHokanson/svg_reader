function color = getColor(s,type,obj)
%
%   s : struct
%   type
%       - stroke
%       - fill
%   obj :
%       This may be needed if no color is specified and we need
%       to somehow inherit color
%
%   Outputs
%   -------
%   color : RGBA or [] or -1
%       [] - missing
%       -1 :


%Forms
%#RRGGBB
%named - red, green

%fill-opacity
%

color_string = '';
opacity = 1;
switch type
    case 'stroke'
        if isfield(s,'stroke')
            color_string = s.stroke;
        end
    case 'fill'
        if isfield(s,'fill')
            color_string = s.fill;
        end
        if isfield(s,'fill-opacity')
            error('Unhandled case')
        end
end

%TODO: This needs to be cleaned up
if isempty(color_string)
    %default fill is black
    if strcmp(type,'fill')
        color = [0 0 0 1];
    else
        color = [];
    end
    return
end

if strcmp(color_string,'none')
    color = -1;
    return
end

if color_string(1) == '#'
    r=hex2dec(color_string(2:3))/255;
    g=hex2dec(color_string(4:5))/255;
    b=hex2dec(color_string(6:7))/255;
    color =[r,g,b,opacity];
    return
end

error('Unhandled case')




end