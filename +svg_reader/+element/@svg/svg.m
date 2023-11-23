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
        function render(obj,varargin)

            if nargin == 1
                render_options = svg_reader.render_options;
            elseif isobject(varargin{1})
                render_options = varargin{1};
            end

            %TODO: reset hold state after render
            hold on
            axis equal
            set(gca,'YDir','reverse')
            for i = 1:length(obj.children)
                child = obj.children{i};
                child.render(render_options);
            end

            %ViewBox
            if isfield(obj.attributes,'viewBox')
                value = obj.attributes.viewBox;
                xlim = [value(1) value(1) + value(3)];
                ylim = [value(2) value(2) + value(4)];
                set(gca,'XLim',xlim,'YLim',ylim)
            end

                    

        
        end
    end
end