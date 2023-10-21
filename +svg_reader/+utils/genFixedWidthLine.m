function p = genFixedWidthLine(x,y)
%
%   svg_reader.utils.genFixedWidthLine
%
%   TODO: rename as strokeToPolyshape
%
%   THIS IS A WORK IN PROGRESS


%stroke-dasharray
%stroke-dashoffset


%https://developer.mozilla.org/en-US/docs/Web/SVG/Attribute/stroke-linecap
% stroke-linecap
% butt | round | square
% default: butt

%https://developer.mozilla.org/en-US/docs/Web/SVG/Attribute/stroke-linejoin
% stroke-linejoin
% arcs | bevel |miter | miter-clip | round
% default: miter
%
%   arcs :
%   bevel :

%https://developer.mozilla.org/en-US/docs/Web/SVG/Attribute/stroke-miterlimit

x = [1 4 6 10]';
y = [1 4 1 5]';

x = [1 4 6 3]';
y = [1 4 1 -5]';

x = [3 6 4 1];
y = [-5 1 4 1];

line_join = 'bevel';
line_join = 'round';
line_join = 'miter';
stroke_width = 0.4;
radius = stroke_width/2;

UL = NaN(1e6,2);
LL = NaN(1e6,2);
uli = 1;
lli = 1;

%2 lines
%3 points
%4 points on each side

%      2/\3  6/
%      /  \  /
%    1/   4\/5
%
%   2/\    /4  points on main line
%   /  \  /
% 1/   3\/
% 
%
%   loop 1, lock in 1,2,3
%   loop 2, lock in 4,5
%   loop 3, lock in 6,7


dv1 = [x(2)-x(1),y(2)-y(1)];
%unit vector
uv1 = dv1/norm(dv1);

x1 = x(1);
y1 = y(1);
UL(1,:) = [x1, y1] + radius * [uv1(2), -uv1(1)];
LL(1,:) = [x1, y1] - radius * [uv1(2), -uv1(1)];

dv2 = dv1;
uv2 = uv1;

for i = 1:length(x)-2
    
    

    %diff vector
    dv1 = dv2;
    dv2 = [x(i+2)-x(i+1),y(i+2)-y(i+1)];
    %unit vector
    uv1 = uv2;
    uv2 = dv2/norm(dv2);

    x1 = x(i);
    y1 = y(i);
    x2 = x(i+1);
    y2 = y(i+1);
    x3 = x(i+2);
    y3 = y(i+2);

    %pu1 = [x1, y1] + distance * [uv1(2), -uv1(1)];
    %pl1 = [x1, y1] - distance * [uv1(2), -uv1(1)];

    pu1 = UL(uli,:);
    pl1 = LL(lli,:);

    pu2 = [x2, y2] + radius * [uv1(2), -uv1(1)];
    pl2 = [x2, y2] - radius * [uv1(2), -uv1(1)];

    pu3 = [x2, y2] + radius * [uv2(2), -uv2(1)];
    pl3 = [x2, y2] - radius * [uv2(2), -uv2(1)];

    pu4 = [x3, y3] + radius * [uv2(2), -uv2(1)];
    pl4 = [x3, y3] - radius * [uv2(2), -uv2(1)];

    %2D cross (dim 3 = 0)
    angle = uv1(1)*uv2(2) - uv1(2)*uv2(1);
    %angle = acos(dot(uv2,uv1));
    %disp(angle)
    if angle == 0
        %keep 
        new_ul = [pu1; pu3];
        new_ll = [pl1; pl3];
        
    elseif angle > 0
        %merge pu2 and pu3 at intersection
        %based on tip conect 

        %Only keep intersection point
        pl2 = h__getIntersectionPoint(pl1,pl2,pl3,pl4);
        new_ll = [pl1; pl2];

        switch line_join
            case 'bevel'
                xy = [pu2; pu3];
            case 'miter'
                xy = h__getIntersectionPoint(pu1,pu2,pu3,pu4);
            case 'round'
                xy = getHalfCircle([x2,y2],pu2,pu3,radius,false);
            otherwise
                error('Unrecognized line-join option')
        end

        new_ul = [pu1; xy];
    else
        %merge pu2 and pu3 at intersection

        pu2 = h__getIntersectionPoint(pu1,pu2,pu3,pu4);
        new_ul = [pu1; pu2];


        %Only keep intersection point, remove pu3
        

        %TODO: calculate how to join
        %miter
        %round
        %bevel
        %etc.
        switch line_join
            case 'bevel'
                xy = [pl2; pl3];
            case 'miter'
                xy = h__getIntersectionPoint(pl1,pl2,pl3,pl4);
            case 'round'
                xy = getHalfCircle([x2,y2],pl2,pl3,radius,true);
            otherwise
                error('Unrecognized line-join option')
        end


        new_ll = [pl1; xy];
    end


    n = length(new_ul);
    UL(uli+1:uli+n,:) = new_ul;
    uli = uli+n;
    n = length(new_ll);
    LL(lli+1:lli+n,:) = new_ll;
    lli = lli+n;
end

UL(uli+1,:) = pu4;
LL(lli+1,:) = pl4;

%Now we need to do the ends ...

%OPTIONS:
%1) end is start, need to merge (no ends)
%2) ends, respect

%-----------------------------
%- stroke-linecap
% butt | round | square
% default: butt

%butt - just connect
%round - half circle, radius = 1/2 width
%   - zero length - show circle
%square - 
%   - half square
%   - zero length - show square - oriented in x y, no rotation

%trim
UL = UL(1:uli+1,:);
LL = LL(1:lli+1,:);

points = [UL; LL(end:-1:1,:)];

p = polyshape(points);

figure(1)
clf
axis equal
plot(x,y,'b','LineWidth',3);
hold on
plot(UL(:,1),UL(:,2),'r','LineWidth',3)
plot(LL(:,1),LL(:,2),'g','LineWidth',3)
h = plot(p);
h.FaceColor = [0 0 0];
h.FaceAlpha = 1;
hold off

keyboard

end

function xy = h__getIntersectionPoint(xy1,xy2,xy3,xy4)

x1 = xy1(1);
y1 = xy1(2);
x2 = xy2(1);
y2 = xy2(2);
x3 = xy3(1);
y3 = xy3(2);
x4 = xy4(1);
y4 = xy4(2);
det = (x1 - x2) * (y3 - y4) - (y1 - y2) * (x3 - x4);
x = ((x1 * y2 - y1 * x2) * (x3 - x4) - (x1 - x2) * (x3 * y4 - y3 * x4)) / det;
y = ((x1 * y2 - y1 * x2) * (y3 - y4) - (y1 - y2) * (x3 * y4 - y3 * x4)) / det;

xy = [x y];

end

function xy = getHalfCircle(xyc,xy1,xy2,radius,flip)
x1 = xy1(1);
y1 = xy1(2);
x2 = xy2(1);
y2 = xy2(2);

% Define the center and radius of the half-circle
centerX = xyc(1);
centerY = xyc(2); % Center y-coordinate

% Calculate the angle range for the half-circle
start_angle = atan2(y1 - centerY, x1 - centerX);
end_angle = atan2(y2 - centerY, x2 - centerX);

% if flip
%     end_angle = end_angle + 2*pi;
%     keyboard
% end

% Generate a range of angles from startAngle to endAngle
theta = linspace(start_angle, end_angle, 100)'; % 100 points for a smooth curve

% Calculate the x and y coordinates of the half-circle
x = centerX + radius * cos(theta);
y = centerY + radius * sin(theta);

xy = [x,y];


end