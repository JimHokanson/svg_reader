function color = getColor(s,type,obj)
%
%   This function retrieves the color based on the attributes
%   structure. It handles my understanding of defaults
%
%   color = svg_reader.utils.getColor(s,type,obj)
%
%   Inputs
%   ------
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
        if isfield(s,'stroke_opacity')
            error('Unhandled case')
        end
    case 'fill'
        if isfield(s,'fill')
            color_string = s.fill;
        end
        if isfield(s,'fill_opacity')
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
    cs = color_string;
    if length(color_string) == 4
       color_string = ['#' cs(2) cs(2) cs(3) cs(3) cs(4) cs(4)];
    end
    r=hex2dec(color_string(2:3))/255;
    g=hex2dec(color_string(4:5))/255;
    b=hex2dec(color_string(6:7))/255;
    color =[r,g,b,opacity];
    return
end


color = color_name_to_rgb_full(color_string);


end

function RGB = color_name_to_rgb_full(color_string)
%
%
%   Written using ChatGPT pointed at:
%   https://developer.mozilla.org/en-US/docs/Web/CSS/named-color
%
%   A few colors spot checked but not all checked ...

    % This function takes a color name as input and returns the MATLAB RGB array
    % corresponding to the named CSS colors.

    % Convert color names to lowercase for consistency
    color_string = lower(color_string);

    % Switch statement for color name conversion
    switch color_string
        case 'aliceblue',           RGB = [240, 248, 255]/255;
        case 'antiquewhite',        RGB = [250, 235, 215]/255;
        case 'aqua',                RGB = [0, 255, 255]/255;
        case 'aquamarine',          RGB = [127, 255, 212]/255;
        case 'azure',               RGB = [240, 255, 255]/255;
        case 'beige',               RGB = [245, 245, 220]/255;
        case 'bisque',              RGB = [255, 228, 196]/255;
        case 'black',               RGB = [0, 0, 0]/255;
        case 'blanchedalmond',      RGB = [255, 235, 205]/255;
        case 'blue',                RGB = [0, 0, 255]/255;
        case 'blueviolet',          RGB = [138, 43, 226]/255;
        case 'brown',               RGB = [165, 42, 42]/255;
        case 'burlywood',           RGB = [222, 184, 135]/255;
        case 'cadetblue',           RGB = [95, 158, 160]/255;
        case 'chartreuse',          RGB = [127, 255, 0]/255;
        case 'chocolate',           RGB = [210, 105, 30]/255;
        case 'coral',               RGB = [255, 127, 80]/255;
        case 'cornflowerblue',      RGB = [100, 149, 237]/255;
        case 'cornsilk',            RGB = [255, 248, 220]/255;
        case 'crimson',             RGB = [220, 20, 60]/255;
        case 'cyan',                RGB = [0, 255, 255]/255;
        case 'darkblue',            RGB = [0, 0, 139]/255;
        case 'darkcyan',            RGB = [0, 139, 139]/255;
        case 'darkgoldenrod',       RGB = [184, 134, 11]/255;
        case 'darkgray',            RGB = [169, 169, 169]/255;
        case 'darkgreen',           RGB = [0, 100, 0]/255;
        case 'darkkhaki',           RGB = [189, 183, 107]/255;
        case 'darkmagenta',         RGB = [139, 0, 139]/255;
        case 'darkolivegreen',      RGB = [85, 107, 47]/255;
        case 'darkorange',          RGB = [255, 140, 0]/255;
        case 'darkorchid',          RGB = [153, 50, 204]/255;
        case 'darkred',             RGB = [139, 0, 0]/255;
        case 'darksalmon',          RGB = [233, 150, 122]/255;
        case 'darkseagreen',        RGB = [143, 188, 143]/255;
        case 'darkslateblue',       RGB = [72, 61, 139]/255;
        case 'darkslategray',       RGB = [47, 79, 79]/255;
        case 'darkturquoise',       RGB = [0, 206, 209]/255;
        case 'darkviolet',          RGB = [148, 0, 211]/255;
        case 'deeppink',            RGB = [255, 20, 147]/255;
        case 'deepskyblue',         RGB = [0, 191, 255]/255;
        case 'dimgray',             RGB = [105, 105, 105]/255;
        case 'dodgerblue',          RGB = [30, 144, 255]/255;
        case 'firebrick',           RGB = [178, 34, 34]/255;
        case 'floralwhite',         RGB = [255, 250, 240]/255;
        case 'forestgreen',         RGB = [34, 139, 34]/255;
        case 'fuchsia',             RGB = [255, 0, 255]/255;
        case 'gainsboro',           RGB = [220, 220, 220]/255;
        case 'ghostwhite',          RGB = [248, 248, 255]/255;
        case 'gold',                RGB = [255, 215, 0]/255;
        case 'goldenrod',           RGB = [218, 165, 32]/255;
        case 'gray',                RGB = [128, 128, 128]/255;
        case 'green',               RGB = [0, 128, 0]/255;
        case 'greenyellow',         RGB = [173, 255, 47]/255;
        case 'honeydew',            RGB = [240, 255, 240]/255;
        case 'hotpink',             RGB = [255, 105, 180]/255;
        case 'indianred',           RGB = [205, 92, 92]/255;
        case 'indigo',              RGB = [75, 0, 130]/255;
        case 'ivory',               RGB = [255, 255, 240]/255;
        case 'khaki',               RGB = [240, 230, 140]/255;
        case 'lavender',            RGB = [230, 230, 250]/255;
        case 'lavenderblush',       RGB = [255, 240, 245]/255;
        case 'lawngreen',           RGB = [124, 252, 0]/255;
        case 'lemonchiffon',        RGB = [255, 250, 205]/255;
        case 'lightblue',           RGB = [173, 216, 230]/255;
        case 'lightcoral',          RGB = [240, 128, 128]/255;
        case 'lightcyan',           RGB = [224, 255, 255]/255;
        case 'lightgoldenrodyellow',RGB = [250, 250, 210]/255;
        case 'lightgray',           RGB = [211, 211, 211]/255;
        case 'lightgreen',          RGB = [144, 238, 144]/255;
        case 'lightpink',           RGB = [255, 182, 193]/255;
        case 'lightsalmon',         RGB = [255, 160, 122]/255;
        case 'lightseagreen',       RGB = [32, 178, 170]/255;
        case 'lightskyblue',        RGB = [135, 206, 250]/255;
        case 'lightslategray',      RGB = [119, 136, 153]/255;
        case 'lightsteelblue',      RGB = [176, 196, 222]/255;
        case 'lightyellow',         RGB = [255, 255, 224]/255;
        case 'lime',                RGB = [0, 255, 0]/255;
        case 'limegreen',           RGB = [50, 205, 50]/255;
        case 'linen',               RGB = [250, 240, 230]/255;
        case 'magenta',             RGB = [255, 0, 255]/255;
        case 'maroon',              RGB = [128, 0, 0]/255;
        case 'mediumaquamarine',    RGB = [102, 205, 170]/255;
        case 'mediumblue',          RGB = [0, 0, 205]/255;
        case 'mediumorchid',        RGB = [186, 85, 211]/255;
        case 'mediumpurple',        RGB = [147, 112, 219]/255;
        case 'mediumseagreen',      RGB = [60, 179, 113]/255;
        case 'mediumslateblue',     RGB = [123, 104, 238]/255;
        case 'mediumspringgreen',   RGB = [0, 250, 154]/255;
        case 'mediumturquoise',     RGB = [72, 209, 204]/255;
        case 'mediumvioletred',     RGB = [199, 21, 133]/255;
        case 'midnightblue',        RGB = [25, 25, 112]/255;
        case 'mintcream',           RGB = [245, 255, 250]/255;
        case 'mistyrose',           RGB = [255, 228, 225]/255;
        case 'moccasin',            RGB = [255, 228, 181]/255;
        case 'navajowhite',         RGB = [255, 222, 173]/255;
        case 'navy',                RGB = [0, 0, 128]/255;
        case 'oldlace',             RGB = [253, 245, 230]/255;
        case 'olive',               RGB = [128, 128, 0]/255;
        case 'olivedrab',           RGB = [107, 142, 35]/255;
        case 'orange',              RGB = [255, 165, 0]/255;
        case 'orangered',           RGB = [255, 69, 0]/255;
        case 'orchid',              RGB = [218, 112, 214]/255;
        case 'palegoldenrod',       RGB = [238, 232, 170]/255;
        case 'palegreen',           RGB = [152, 251, 152]/255;
        case 'paleturquoise',       RGB = [175, 238, 238]/255;
        case 'palevioletred',       RGB = [219, 112, 147]/255;
        case 'papayawhip',          RGB = [255, 239, 213]/255;
        case 'peachpuff',           RGB = [255, 218, 185]/255;
        case 'peru',                RGB = [205, 133, 63]/255;
        case 'pink',                RGB = [255, 192, 203]/255;
        case 'plum',                RGB = [221, 160, 221]/255;
        case 'powderblue',          RGB = [176, 224, 230]/255;
        case 'purple',              RGB = [128, 0, 128]/255;
        case 'rebeccapurple',       RGB = [102, 51, 153]/255;
        case 'red',                 RGB = [255, 0, 0]/255;
        case 'rosybrown',           RGB = [188, 143, 143]/255;
        case 'royalblue',           RGB = [65, 105, 225]/255;
        case 'saddlebrown',         RGB = [139, 69, 19]/255;
        case 'salmon',              RGB = [250, 128, 114]/255;
        case 'sandybrown',          RGB = [244, 164, 96]/255;
        case 'seagreen',            RGB = [46, 139, 87]/255;
        case 'seashell',            RGB = [255, 245, 238]/255;
        case 'sienna',              RGB = [160, 82, 45]/255;
        case 'silver',              RGB = [192, 192, 192]/255;
        case 'skyblue',             RGB = [135, 206, 235]/255;
        case 'slateblue',           RGB = [106, 90, 205]/255;
        case 'slategray',           RGB = [112, 128, 144]/255;
        case 'snow',                RGB = [255, 250, 250]/255;
        case 'springgreen',         RGB = [0, 255, 127]/255;
        case 'steelblue',           RGB = [70, 130, 180]/255;
        case 'tan',                 RGB = [210, 180, 140]/255;
        case 'teal',                RGB = [0, 128, 128]/255;
        case 'thistle',             RGB = [216, 191, 216]/255;
        case 'tomato',              RGB = [255, 99, 71]/255;
        case 'turquoise',           RGB = [64, 224, 208]/255;
        case 'violet',              RGB = [238, 130, 238]/255;
        case 'wheat',               RGB = [245, 222, 179]/255;
        case 'white',               RGB = [255, 255, 255]/255;
        case 'whitesmoke',          RGB = [245, 245, 245]/255;
        case 'yellow',              RGB = [255, 255, 0]/255;
        case 'yellowgreen',         RGB = [154, 205, 50]/255;
        otherwise
            error('Unknown color name: %s', color_string);
    end

    %Add on opaque
    RGB = [RGB 1];
end
