classdef image < svg_reader.element
    %
    %   

    %https://developer.mozilla.org/en-US/docs/Web/SVG/Element/image
    
    %The only image formats SVG software must support are JPEG, PNG, and 
    %other SVG files. Animated GIF behavior is undefined.
    
    properties
        parent
        img_binary
        format
    end

    methods
        function obj = image(item,parent)
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
        function render(obj)
            %What's the viewport???
            %
            %   Don't worry about for now

            

            if isfield(obj.attributes,'transform')
                %TODO: Apply transform
            end

            data = obj.getImageData();
            im = image(data);
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