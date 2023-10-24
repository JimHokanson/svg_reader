function numbers = extractListofNumbers(input_str)
%
%   numbers = svg_reader.utils.extractListofNumbers(input_str)
%   
%   See Also
%   --------
%   svg_reader.attr.d

% I was using this approach:
% number_pattern = '-?\d+\.?\d+';
%   
% temp = regexp(s.points,number_pattern,'match');
% temp2 = str2double(temp);
%
%   However, this failed because of this example:
%   'l8.45,20.08.38.84,4.78-5.34'
%   also valid
%   'm0,.85'  
%
%   Starts indicated by:
%   -+
%   ,
%   . (if second . in a number)



%
%uh-oh, could have E sign as well
%
%so maybe 1.3E-3

%{
number:
    sign? integer-constant
    | sign? floating-point-constant
flag:
    "0" | "1"
comma-wsp:
    (wsp+ comma? wsp*) | (comma wsp*)
comma:
    ","
integer-constant:
    digit-sequence
floating-point-constant:
    fractional-constant exponent?
    | digit-sequence exponent
fractional-constant:
    digit-sequence? "." digit-sequence
    | digit-sequence "."
exponent:
    ( "e" | "E" ) sign? digit-sequence
sign:
    "+" | "-"
digit-sequence:
    digit
    | digit digit-sequence
digit:
    "0" | "1" | "2" | "3" | "4" | "5" | "6" | "7" | "8" | "9"
%}



remainder = input_str;
if isempty(strtrim(remainder))
    numbers = [];
    return
end

%c-0.11,0.22-0.22,0.43-0.32,0.65'
%inputs{i} = str2double(strsplit(remainder,','));

period_count = 0;

if any(remainder == 'e' | remainder == 'E')
    error('Unsupported case')
end
if any(remainder == '+')
    error('Unsupported case')
end

mask = remainder == ',';
mask = mask | remainder == '-';
mask = mask | remainder == '.';
is_start = false(1,length(mask));
is_start(1)=true;
I = find(mask);
for j = 1:length(I)
    cur_index = I(j);
    cur_char = remainder(I(j));
    if cur_char == ','
        is_start(cur_index+1) = true;
        period_count = 0;
    elseif cur_char == '-'
        is_start(cur_index) = true;
        period_count = 0;
    elseif period_count == 0

        period_count = 1;
    else
        %now 2
        is_start(cur_index) = true;
        %no need to update, any subsequent period
        %is the start of another number
        %
        %Don't reset until - or ,
        %period_count = 1;
    end
end

starts = find(is_start);
stops = [starts(2:end)-1 length(remainder)];


n_numbers = length(starts);
numbers = zeros(1,n_numbers);
for j = 1:n_numbers
    numbers(j) = str2double(remainder(starts(j):stops(j)));
end

if any(isnan(numbers))
    keyboard
end
end