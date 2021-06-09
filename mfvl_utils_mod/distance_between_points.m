% November, 2016
% distance_between_points
function Distance = distance_between_points(Points)
if size(Points,1)==1
    for i=1:size(Points,2)-1
        Distance(i)=abs(Points(:,i)-Points(:,i+1));
    end
end
if size(Points,1)~=1
    for i=1:size(Points,2)-1
        Distance(i)=sqrt(sum((Points(:,i)-Points(:,i+1)).^2));
    end
end
end
% end of file