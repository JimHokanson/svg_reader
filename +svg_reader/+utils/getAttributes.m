function s = getAttributes(item)

s = struct();
temp = item.getAttributes();
if ~isempty(temp)
for i = 0:temp.getLength - 1
    item = temp.item(i);
    name = char(item.getName);
    value = char(item.getValue);
    try
        s.(name) = value;
    catch
        name = regexprep(name, '[ :-]', '_');
        s.(name) = value;
    end
end
end