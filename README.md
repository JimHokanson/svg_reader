# SVG reader #

(perpetual?) work in progress

This code was written to help with extracting paths from traced Illustrator files. Overall it only implements what I needed BUT it is written to be quite general and over time should be easy to add on missing functionality.

Functionality
- loads (some) SVG files
- renders (some) elements
- tries to propagate style

Known Bugs
- poor general image support
- does not support all tags 
- poor attribute support

**Note, I have a lot of keyboard statements in place which will enter debug mode when encountering an instance that is incomplete**

# Setup #

This code uses packages and classes. The folder that contains the package folder (parent of "+svg\_reader" folder) needs to be your current directory or on the path.

# Requirements #

- image processing toolbox
- MATLAB version ???
	- TODO: I'm using a new affine transform (2022?) but should to switch to an older one
	
# Usage #

Basic usage is loading and rendering

```
svg = svg_reader.read(file_path);
svg.render();
```

It is also possible to navigate the structure and to render only certain objects or layers. 

```
%TODO: Create example loading support and use that instead
%Specific to my file, but hopefully makes sense
svg.children{2}.children{3}.render();
```

Additionally, one can ask for the x-y values of a given line/shape object.

```
n_steps_per_path = 40;
[x,y] = svg.children{2}.children{3}.getXY(n_steps_per_path);
```