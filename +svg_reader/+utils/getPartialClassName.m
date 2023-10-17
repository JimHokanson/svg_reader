function class_name = getPartialClassName(obj)

full_name = class(obj);

% Extract the class name without the package
parts = strsplit(full_name, '.');
class_name = parts{end};

end