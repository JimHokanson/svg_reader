function p = strokeToPolyshape(x,y,stroke_width,line_join,line_cap)
%
%   p = svg_reader.utils.strokeToPolyshape(x,y,stroke_width,line_join,line_cap)
%
%   ********* THIS IS A WORK IN PROGRESS *********
%
%   MATLAB lines are pixel based, not coordinate based. Zooming in on lines
%   doesn't increase the size of the lines because they are always a set
%   # of pixels.
%
%   Thus this function creates a patch/polygon/polyshape that gives lines
%   width that when you zoom in the line gets bigger. 
%
%   This customization also allows some following of the 
%
%   Inputs
%   ------
%   x,y
%   stroke_width
%   line_join
%       arcs - NYI
%       bevel - straight line between extents
%       miter - lines join at point
%       miter-clip - NYI
%       round - rounded edge
%   line_cap
%       butt
%       round
%       square
%
%   Outputs
%   -------
%   p : polyshape
%
%   See Also
%   --------
%   svg_reader.utils.renderStroke
%
%   Limitations
%   -----------
%   - doesn't support dashes yet (no plans to)
%   - might not support single points (haven't tested)
%
%   Examples
%   --------
%   rng(2)
%   x = randi(40,1,8);
%   y = randi(40,1,8);
%     
%   line_join = 'round';
%   line_cap = 'round';
%   stroke_width = 1;
%   p = svg_reader.utils.strokeToPolyshape(x,y,stroke_width,line_join,line_cap)
%   plot(p)

%stroke-dasharray
%stroke-dashoffset

mask = (diff(x) == 0) & (diff(y) == 0);
x(mask) = [];
y(mask) = [];

%https://developer.mozilla.org/en-US/docs/Web/SVG/Attribute/stroke-linecap
% stroke-linecap
% butt | round | square
% default: butt
%
%   single point????

%https://developer.mozilla.org/en-US/docs/Web/SVG/Attribute/stroke-linejoin
% stroke-linejoin
% arcs | bevel |miter | miter-clip | round
% default: miter
%
%   arcs :
%   bevel :

%https://developer.mozilla.org/en-US/docs/Web/SVG/Attribute/stroke-miterlimit

if nargin == 0
%     %testing
%     x = [1 4 6 10]';
%     y = [1 4 1 5]';
%     
%     x = [1 4 6 3]';
%     y = [1 4 1 -5]';
%     
%     x = [3 6 4 1];
%     y = [-5 1 4 1];
%     
%     rng(2)
%     x = randi(200,1,20);
%     y = randi(200,1,20);
%     
%     line_join = 'bevel';
%     
%     line_join = 'miter';
%     line_join = 'round';
%     line_join = 'miter';
%     line_join = 'bevel';
%     line_join = 'round';
%     %butt, round, square
%     line_cap = 'butt';
%     line_cap = 'square';
%     %line_cap = 'round';
%     stroke_width = 1;
end


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

p = polyshape;

if x(1) == x(end) && y(1) == y(end)
    closed = true;
    n_runs = length(x)-2;
else
    closed = false;
    n_runs = length(x)-2;
end

%plot(x,y,'g')
%hold on

for i = 1:n_runs
    
    %diff vector
    %dv1 = dv2;
    dv2 = [x(i+2)-x(i+1),y(i+2)-y(i+1)];
    %unit vector
    uv1 = uv2;
    uv2 = dv2/norm(dv2);

    x2 = x(i+1);
    y2 = y(i+1);
    x3 = x(i+2);
    y3 = y(i+2);

    pu1 = UL(uli,:);
    pl1 = LL(lli,:);

    [new_ll,new_ul,pu4,pl4] = getNewPoints(uv1,uv2,pu1,pl1,x2,y2,x3,y3,radius,line_join,i);

    %{
    %Rendering code
    ---------------
    figure()
    plot(x(i:i+2),y(i:i+2),'r-o')
    hold on
    %plot(uv1(1),uv1(2),'ks')
    %plot(uv2(1),uv2(2),'gs')
    plot(pu1(1),pu1(2),'ms')
    plot(pl1(1),pl1(2),'bs')
    hold off


    %}


    %Note, we can make this an error instead of a warning
    %
    %
    %warning('error', 'mycomponent:myMessageID')
    %https://stackoverflow.com/questions/35827109/how-to-catch-warning-in-matlab
    %
    %   warning_ID
    % 'MATLAB:polyshape:repairedBySimplify'
    lastwarn('');
    xy = [new_ul; new_ll(end:-1:1,:)];
    p2 = polyshape(xy);
    [msgstr, msgid] = lastwarn;
    if ~isempty(msgid)
        %{
        figure
        plot(p)
        hold on
        plot(x(i:i+2),y(i:i+2),'g-o')
        plot(xy(:,1),xy(:,2),'ro-')
        hold off
        %}

        %This seems to happen for small steps (small deltas relative to the
        %radius)

        xy = [new_ul; new_ll];
        p2 = polyshape(xy);
        %keyboard
    end
    %disp(i)
    p = union(p,p2);
    %plot(p)
    %pause

    n = length(new_ul);
    UL(uli+1:uli+n,:) = new_ul;
    uli = uli+n;
    n = length(new_ll);
    LL(lli+1:lli+n,:) = new_ll;
    lli = lli+n;
end


%TODO: Handle a closed loop path - currently only handling open
if closed
    %TODO: Can we do by modifying the loop?


    dv1 = [x(end)-x(end-1),y(end)-y(end-1)];
    uv1 = dv1/norm(dv1);
    dv2 = [x(2)-x(1),y(2)-y(1)];
    uv2 = dv2/norm(dv2);

    x2 = x(end); %or equivalently x(1)
    y2 = y(end);
    x3 = x(2);
    y3 = y(2);

    pu1 = UL(uli,:);
    pl1 = LL(lli,:);
    
    [new_ll,new_ul] = getNewPoints(uv1,uv2,pu1,pl1,x2,y2,x3,y3,radius,line_join,0);
   
    p2 = polyshape([new_ul; new_ll(end:-1:1,:)]);
    p = union(p,p2);
    n = length(new_ul);
    UL(uli+1:uli+n,:) = new_ul;
    uli = uli+n;
    n = length(new_ll);
    LL(lli+1:lli+n,:) = new_ll;
    lli = lli+n;

    %Note, we should update either LL(1) or UL(1) to match
    %new_ul(end) or new_ll(end)
    
    if all(fpSame(new_ul(end,:),UL(uli,:)))
        LL(2,:) = new_ll(end,:);
    else
        UL(2,:) = new_ul(end,:);
    end
else

    p2 = polyshape([UL(uli,:); pu4; pl4; LL(lli,:)]);
    p = union(p,p2);
    
    
    %Add on last line
    UL(uli+1,:) = pu4;
    LL(lli+1,:) = pl4;

    switch line_cap
        case 'butt'
            %Nothing needed
        case 'square'
            %Note, reusing last unit vector
            xy_end2 = getHalfSquare(pu4,pl4,uv2,radius);
            p2 = polyshape(xy_end2);
            p = union(p,p2);
    
            %Recalculate unit vector
            dv = [x(1)-x(2),y(1)-y(2)];
            uv = dv/norm(dv);
            xy_end2 = getHalfSquare(UL(1,:),LL(1,:),uv,radius);
            p2 = polyshape(xy_end2);
            p = union(p,p2);
    
        case 'round'
            %get centers
            %pu4
            %pl4
            xc = 0.5*(pu4(1)+pl4(1));
            yc = 0.5*(pu4(2)+pl4(2));
            xy_end2 = getFullCircle([xc,yc],radius);
            p2 = polyshape(xy_end2);
            p = union(p,p2);
    
            xc = 0.5*(UL(1,1)+LL(1,1));
            yc = 0.5*(UL(1,2)+LL(1,2));
            xy_end2 = getFullCircle([xc,yc],radius);
            p2 = polyshape(xy_end2);
            p = union(p,p2);
        otherwise
            error('Unrecognized line-join option')
    end
end

%Due to loop initialization
%point 2 is same as 1
%
%:/ - HACK, looks terrible but works
UL = UL(2:uli+1,:);
LL = LL(2:lli+1,:);

if nargin == 0
    figure(1)
    clf
    plot(x,y,'b','LineWidth',3);
    hold on
    plot(UL(:,1),UL(:,2),'r','LineWidth',3)
    plot(LL(:,1),LL(:,2),'g','LineWidth',3)
    h = plot(p);
    h.FaceColor = [0 0 0];
    h.FaceAlpha = 0.2;
    hold off
    axis equal
end

end

function [new_ll,new_ul,pu4,pl4] = getNewPoints(uv1,uv2,pu1,pl1,x2,y2,x3,y3,radius,line_join,i)
    
    %     2/    \3
    %     / /23\ \
    %    / /    \ \
    %  1/ /1    4\ \4
    pu2 = [x2, y2] + radius * [uv1(2), -uv1(1)];
    pl2 = [x2, y2] - radius * [uv1(2), -uv1(1)];

    pu3 = [x2, y2] + radius * [uv2(2), -uv2(1)];
    pl3 = [x2, y2] - radius * [uv2(2), -uv2(1)];

    pu4 = [x3, y3] + radius * [uv2(2), -uv2(1)];
    pl4 = [x3, y3] - radius * [uv2(2), -uv2(1)];


    if false
    hold on
    plot([x2 x3],[y2 y3],'co-')
    plot(pu1(1),pu1(2),'ro')
    plot(pu2(1),pu2(2),'r*')
    plot([pu1(1) pu2(1)],[pu1(2) pu2(2)],'r')
    plot(pu3(1),pu3(2),'ko')
    plot(pu4(1),pu4(2),'k*')
    plot([pu3(1) pu4(1)],[pu3(2) pu4(2)],'k')

    plot(pl1(1),pl1(2),'bo')
    plot(pl2(1),pl2(2),'b*')
    plot([pl1(1) pl2(1)],[pl1(2) pl2(2)],'b')
    plot(pl3(1),pl3(2),'mo')
    plot(pl4(1),pl4(2),'m*')
    plot([pl3(1) pl4(1)],[pl3(2) pl4(2)],'m')
    title('c:xy, r:pu12, k:pu34, b:pl12, m:pl34')
    end

    %keyboard

    %If intersection point is further away from 
    %

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
        temp = h__getIntersectionPoint(pl1,pl2,pl3,pl4);
        
        %Check if temp is betweeen pu1 and pu2
        minx = min(pl1(1),pl2(1));
        maxx = max(pl1(1),pl2(1));
        miny = min(pl1(2),pl2(2));
        maxy = max(pl1(2),pl2(2));
        if temp(1) < minx || temp(1) > maxx || temp(2) < miny || temp(2) > maxy
            %pu2 = pu2;
        else

            minx = min(pl3(1),pl4(1));
            maxx = max(pl3(1),pl4(1));
            miny = min(pl3(2),pl4(2));
            maxy = max(pl3(2),pl4(2));

            if temp(1) < minx || temp(1) > maxx || temp(2) < miny || temp(2) > maxy
                %pu2 = pu2;
            else
                pl2 = temp;
            end
        end

        %temp needs to be between
        new_ll = [pl1; pl2];

        switch line_join
            case 'bevel'
                xy = [pu2; pu3];
            case 'miter'
                xy = h__getIntersectionPoint(pu1,pu2,pu3,pu4);
            case 'round'
                xy = getHalfCircle([x2,y2],pu2,pu3,radius);
            otherwise
                error('Unrecognized line-join option')
        end

        new_ul = [pu1; xy];
    else
        %merge pu2 and pu3 at intersection

        %Does pu1,pu2 intersect
        %with 

        temp = h__getIntersectionPoint(pu1,pu2,pu3,pu4);

        %Check if temp is betweeen pu1 and pu2
        minx = min(pu1(1),pu2(1));
        maxx = max(pu1(1),pu2(1));
        miny = min(pu1(2),pu2(2));
        maxy = max(pu1(2),pu2(2));

        if temp(1) < minx || temp(1) > maxx || temp(2) < miny || temp(2) > maxy
            %pu2 = pu2;
        else

            minx = min(pu3(1),pu4(1));
            maxx = max(pu3(1),pu4(1));
            miny = min(pu3(2),pu4(2));
            maxy = max(pu3(2),pu4(2));

            if temp(1) < minx || temp(1) > maxx || temp(2) < miny || temp(2) > maxy
                %pu2 = pu2;
            else
                pu2 = temp;
            end
        end

        new_ul = [pu1; pu2];

        switch line_join
            case 'bevel'
                xy = [pl2; pl3];
            case 'miter'
                xy = h__getIntersectionPoint(pl1,pl2,pl3,pl4);
            case 'round'
                xy = getHalfCircle([x2,y2],pl2,pl3,radius);
            otherwise
                error('Unrecognized line-join option')
        end


        new_ll = [pl1; xy];
    end

end

function flag = fpSame(a,b)
%Ugh, damn floating point
flag = abs(a - b) <= max(abs(a), abs(b)) * 0.00005;
end

function xy = h__getIntersectionPoint(xy1,xy2,xy3,xy4)

MIN_DIFF = 0.0001;

%Not sure how to handle
if sum(abs(xy2 - xy3)) < MIN_DIFF
    xy = xy2;
    return
end

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

function xy = getHalfCircle(xyc,xy1,xy2,radius)
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

angle_diff = abs(start_angle-end_angle);
other_angle_diff = 2*pi - angle_diff;

%fprintf('%0.3f, %0.3f\n',angle_diff,other_angle_diff)

if angle_diff > other_angle_diff
    if start_angle < 0
        end_angle = start_angle - other_angle_diff;
    else
        end_angle = start_angle + other_angle_diff;
    end
end

% if flip
%     %difference is either:
%     % - the difference
%     % - 2pi - difference
%     %
%     %easier to think about in degrees (for me)
%     %   20%
%     %   340%
% 
%     end_angle = start_angle + other_angle_diff;
% end

% Generate a range of angles from startAngle to endAngle
theta = linspace(start_angle, end_angle, 100)'; % 100 points for a smooth curve

% Calculate the x and y coordinates of the half-circle
x = centerX + radius * cos(theta);
y = centerY + radius * sin(theta);

xy = [x,y];


end

function xy = getHalfSquare(xy1,xy2,uv1,radius)

    temp1 = xy1 + radius * uv1;
    temp2 = xy2 + radius * uv1;
    xy = [xy1; temp1; temp2; xy2];
end

function xy = getFullCircle(xyc,radius)

% Define the center and radius of the half-circle
centerX = xyc(1);
centerY = xyc(2); % Center y-coordinate

% Generate a range of angles from startAngle to endAngle
theta = linspace(0, 2*pi, 200)'; % 100 points for a smooth curve

% Calculate the x and y coordinates of the half-circle
x = centerX + radius * cos(theta);
y = centerY + radius * sin(theta);

xy = [x,y];


end