classdef svg < svg_reader.element
    %
    %   Class:
    %   svg_reader.element.svg
    %
    %   See Also
    %   --------
    %   svg_reader.read
    %   svg_reader.element
    %   svg_reader.read_options
    %   svg_reader.render_options
    %
    %   Elements
    %   --------
    %   See running list in: svg_reader.element
    %
    %   Examples
    %   --------
    %   svg_reader.loadExample('invader')
    %   svg_reader.loadExample('starbucks')

    properties
        file_path

        %cell
        children

        %table
        %.index
        %.class_name
        %.id (if present)
        t
    end

    methods
        function obj = svg(item,file_path,read_options)
            %
            %   Inputs
            %   ------
            %   item
            %   file_path
            %   read_options : svg_reader.read_options

            obj.file_path = file_path;

            obj.getAttributes(item);
            s = svg_reader.utils.getAttributes(item);
            obj.attributes = s;

            %Parse children
            %--------------
            obj.children = svg_reader.utils.getChildren(item,obj,read_options);

            %Build table
            %-----------
            %.index
            %.class_name
            %.id (if present)

            fh = @svg_reader.utils.getPartialClassName;
            class_name = cellfun(fh,obj.children,'un',0)';

            fh = @svg_reader.utils.getIDifPresent;
            id = cellfun(fh,obj.children,'un',0)';

            index = (1:length(class_name))';
            obj.t = table(index,class_name,id);

            %Viewbox handling
            %----------------
            if isfield(obj.attributes,'viewBox')
                temp = obj.attributes.viewBox;
                obj.attributes.viewBox = str2double(strsplit(temp,' '));
            end
        end
        function out = getElementsOfType(obj,element_type)
            %
            %   out = getElementsOfType(obj,element_type)
            %
            %   Example
            %   -------
            %   out = obj.getElementsOfType('image')

            out = {};
            for i = 1:length(obj.children)
                child = obj.children{i};
                temp = child.getElementsOfType(element_type);
                out = [out temp]; %#ok<AGROW>
            end
            out = [out{:}];
        end
        function t = getElementsSummary(obj)
            %
            %   Wasn't sure how to best format this ...
            %
            %   Commented out a version where each field got its own
            %   column. Could go back and add the option to see both views
            %   
            %   Current approach just uses 1st column for prop 1, 2nd for
            %   2, etc. with the name of the prop, along with the value
            %   in the cell.
            %
            %   Improvements
            %   ------------
            %   1) Allow multiple versions of info to be returned
            %   2) Move to utils and optionally allow the 'g' element
            %      version to be called directly and return something
            %      useful (right now it only returns the list of objects)

            class_names = obj.t.class_name;
            out = {};
            for i = 1:length(obj.children)
                child = obj.children{i};
                name_path = ['svg.' class_names{i}];
                out = [out {child name_path}]; %#ok<AGROW>
                if isa(child,'svg_reader.element.g')
                    out = [out child.getElementsSummary('svg')]; %#ok<AGROW>
                end
            end

            %fields = {};
            n_objects = length(out)/2;
            n_per = zeros(n_objects,1);
            for i = 1:2:length(out)
                temp = fieldnames(out{i}.attributes);
                %fields = [fields; temp]; %#ok<AGROW>
                n_per(i) = length(temp);
            end
            %unique_names = unique(fields);

            max_n_per = max(n_per);


            s = struct();
            s.('path') = out(2:2:end)';
            for j = 1:max_n_per
                prop_name = sprintf('p%d',j);
                s.(prop_name) = cell(n_objects,1);
                s.(prop_name)(:) = {''};
            end

            

            for i = 1:2:length(out)
                cur_element = out{i}.attributes;
                fn = fieldnames(cur_element);
                for j = 1:length(fn)
                    cur_name = fn{j};
                    prop_name = sprintf('p%d',j);
                    temp = cur_element.(cur_name);
                    if ischar(temp)
                        if length(temp) > 10
                            temp = [temp(1:10) '...'];
                        end
                    else
                        temp = class(temp);
                    end
                    s.(prop_name){(i+1)/2} = [cur_name ':' temp];
                end
            end


        %{
            for i = 1:2:length(out)
                cur_element = out{i}.attributes;
                fn = fieldnames(cur_element);
                for j = 1:length(unique_names)
                    cur_name = unique_names{j};
                    if isfield(cur_element,cur_name)
                        temp = cur_element.(cur_name);
                        if ischar(temp) && length(temp) > 10
                            temp = [temp(1:10) '...'];
                        end

                        s.(cur_name){(i+1)/2} = temp;
                    end
                end
            end

            
        %}

        t = struct2table(s);
    end
    function render(obj,varargin)
        %x Renders the scene
        %
        %   render(obj,varargin)
        %
        %   Note not all rendering is supported
        %
        %   Examples
        %   --------
        %   TODO
        %

        if nargin == 1
            ro = svg_reader.render_options;
        elseif isobject(varargin{1})
            ro = varargin{1};
        else
            ro = svg_reader.render_options;
            ro = svg_reader.utils.processVarargin(ro,varargin);
        end

        if isempty(ro.ax)
            h_axes = gca;
        else
            h_axes = ro.ax;
        end

        hold_flag = ishold(h_axes);
        axes(h_axes)
        hold(h_axes,'on')
        axis equal
        set(h_axes,'YDir','reverse')
        for i = 1:length(obj.children)
            child = obj.children{i};
            child.render(ro);
        end

        %ViewBox
        if isfield(obj.attributes,'viewBox') && ro.apply_viewbox
            value = obj.attributes.viewBox;
            xlim = [value(1) value(1) + value(3)];
            ylim = [value(2) value(2) + value(4)];
            set(h_axes,'XLim',xlim,'YLim',ylim)
        end

        if ~hold_flag
            hold(h_axes,'off')
        end

        set(h_axes,'XTick',[],'YTick',[])
    end
end
end