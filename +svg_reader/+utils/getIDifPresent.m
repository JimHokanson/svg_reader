function id = getIDifPresent(obj)
%
%   id = svg_reader.utils.getIDifPresent(obj)

    if isfield(obj.attributes,'id')
        id = obj.attributes.id;
    else
        id = '';
    end

end