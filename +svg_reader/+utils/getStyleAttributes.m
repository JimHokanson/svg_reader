function s = getStyleAttributes(str)
%
%   s = svg_reader.utils.getStyleAttributes(str)
%
%fill:none;stroke:#FF0000;stroke-miterlimit:10;
%
%   
%
%
%   TODO: Need to support line comments
%   e.g.,
%   // stroke: #909;
%
%   See Also
%   --------
%   svg_reader.element.style


s = struct();
prop_value_pairs = regexp(str,'([^:]+):([^;]+);','tokens');
for i = 1:length(prop_value_pairs)
    name = strtrim(prop_value_pairs{i}{1});
    value = strtrim(prop_value_pairs{i}{2});
    try
    s.(name) = value;
    catch
        name = regexprep(name, '[ :-]', '_');
        s.(name) = value;
    end
end

end