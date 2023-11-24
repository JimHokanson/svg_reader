classdef image < svg_reader.element
    %
    %   Class:
    %   svg_reader.element.image
    %
    %   https://developer.mozilla.org/en-US/docs/Web/SVG/Element/image
    %
    %   See Also
    %   --------
    %   svg_reader.element.g
    %   
    %
    %   The only image formats SVG software must support are JPEG, PNG, and 
    %   other SVG files. Animated GIF behavior is undefined.
    
    properties
        parent
        img_binary
        format
    end

    properties
        h_image
    end

    methods
        function obj = image(item,parent,read_options)
            obj.parent = parent;
            obj.getAttributes(item);
            s = obj.attributes;

            if isfield(s,'xlink_href')
                xlink = s.xlink_href;
                ref = 'data:image/png;base64,';
                n_ref = length(ref);
                if strncmp(ref,xlink,n_ref)
                    %Written in MATLAB, slow ...
                    %Try this: https://stackoverflow.com/questions/47964930/how-to-read-out-base64-image-in-matlab
                    import('org.apache.commons.codec.binary.Base64');
                    base64 = Base64();                    
                    obj.img_binary = base64.decode(xlink(n_ref+1:end));
                    
                    %temp2 = matlab.net.base64decode(xlink(n_ref+1:end));
                    %keyboard
                    obj.format = 'png';
                end
            end
            %data = obj.getImageData();
        end
        function render(obj,render_options)
            %What's the viewport???
            %
            %   Don't worry about for now

            
            data = obj.getImageData();

            if isfield(obj.attributes,'transform')
                data = obj.attributes.transform.applyImageTransform(data);
                [x,y] = obj.attributes.transform.applyTransform(0,0); 
            end

            %x = 0:(size(data,2)-1);
            %y = 0:(size(data,1)-1);
            obj.h_image = image(x,y,data);
        end
        function hide(obj)
            if ~isempty(obj.h_image) && isvalid(obj.h_image)
                obj.h_image.Visible = 'off';
            end
        end
        function show(obj)
            if ~isempty(obj.h_image) && isvalid(obj.h_image)
                obj.h_image.Visible = 'on';
            end
        end
        function data = getImageData(obj)
            %TODO: This should be cached locally
            %in hidden property
            switch obj.format
                case 'png'
                    file_path = [tempname '.png'];
                    fileID = fopen(file_path, 'w');
                    fwrite(fileID, obj.img_binary,'int8');
                    fclose(fileID);
                    data = imread(file_path,'png');
                    delete(file_path)
                otherwise
                    error('Not yet handled')
            end

        end
    end
end