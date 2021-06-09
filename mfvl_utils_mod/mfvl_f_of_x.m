function f = mfvl_f_of_x(x0,x1,y0,y1,x)
%RETA Summary of this function goes here
%   Detailed explanation goes here
%b=x2-((y2-x2)/(y1-x1))*(x1);
%f=((y2-x2)/(y1-x1)).*x+b;
%m=(y2-y1)/(x2-x1);
%f=m.*x+b;
for i=1:numel(x)
	f(i)=y0+((y1-y0)*(x(i)-x0))/(x1-x0);
end
end

