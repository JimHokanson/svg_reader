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

            
            [data,x,y] = obj.getImageData('apply_transform',...
                render_options.apply_transforms);
            
            %MATLAB defines pixel centers, not their starting edge
            %whereas SVG appears to use starting edges
            %
            %   If we don't add 0.5 then the images don't align
            %   with paths

            obj.h_image = image(x+0.5,y+0.5,data);
            %Change XData and YData
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
        function [data,x,y] = getImageData(obj,varargin)
            %
            %   [data,x,y] = getImageData(obj,varargin)
            %
            %   Optional Inputs
            %   ---------------
            %   apply_transform : default true
            %       If false the raw image is returned. 
            %       If true, the image is returned after being transformed,
            %       if a transform exists.

            in.apply_transform = true;
            in = svg_reader.utils.processVarargin(in,varargin);
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

            %svg_reader.attr.transform
            %
            %Both are required:
            %https://developer.mozilla.org/en-US/docs/Web/SVG/Element/image
            h1 = str2double(obj.attributes.height);
            w1 = str2double(obj.attributes.width);

            h2 = size(data,1);
            w2 = size(data,2);

            if h1 ~= h2 || w1 ~= w2
                scale_x = h1/h2;
                scale_y = w1/w2;
                trans_string = sprintf('scale(%0.6f %0.6f)',scale_x,scale_y);
                %TODO: Could have option to load commands directly
                %rather than parsing a string
                trans_obj = svg_reader.attr.transform(trans_string);
                data = trans_obj.applyImageTransform(data);
            end




            if in.apply_transform
                ny = size(data,1);
                nx = size(data,2);

                %?? don't transform the image, just the x and y?
                data = obj.attributes.transform.applyImageTransform(data);

                xin = 0:(nx-1);
                yin = 0:(ny-1);

                [x,y] = obj.attributes.transform.applyTransform(0,0); 


                    
                %1680
                %1298
                %[x,~] = obj.attributes.transform.applyTransform(xin,0); 
                %[~,y] = obj.attributes.transform.applyTransform(0,yin); 


            else
                %x = 0:(size(data,2)-1);
                %y = 0:(size(data,1)-1);
                x = 0;
                y = 0;
            end

        end
    end
end