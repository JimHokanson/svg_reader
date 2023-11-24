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
            out = {};
            for i = 1:length(obj.children)
                child = obj.children{i};
                temp = child.getElementsOfType(element_type);
                out = [out temp]; %#ok<AGROW> 
            end
            out = [out{:}];
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
            if isfield(obj.attributes,'viewBox')
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