function s = processVarargin(s,varargin)

for i = 1:2:length(varargin)
    name = varargin{1};
    try %#ok<TRYNC> 
        s.(name) = varargin{2};
    end
end

end