function read(file_path)
%
%   svg_reader.read

xDoc = xmlread(file_path);

svg=struct();
imagesXml = xDoc.getElementsByTagName('image');
svg.images=cell(1,imagesXml.getLength);
for k=0:imagesXml.getLength - 1
    item=imagesXml.item(k);
    svg.images{k+1} = svg_reader.image(item);
    svg.images{k+1}=img;
end


end