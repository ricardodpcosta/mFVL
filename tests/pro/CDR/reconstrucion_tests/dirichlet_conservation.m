function error=dirichlet_conservation(xi,xf,d,m,func,func_der,alpha,x)
% m points

h=(xf-xi)/m;
vertices=xi:h:xf;
for j=1:(numel(vertices)-1)
    centroids(j)=vertices(j)+(vertices(j+1)-vertices(j))/2;
end
data=func(centroids);

xe=xi-h*alpha;
f_xe=func(xe);
%f_xe_der=func_der(xe);
% A matrix
for i=1:m
    for j=1:(d+1)
        A(i,j)=(centroids(i)-xi)^(j-1);
    end
end

% b vector
b=data';
% C
for i=1:d+1
    C(i)=(xe-xi)^(i-1);
end
% d
D=f_xe;
% least squares
R=lsqlin(A,b,[],[],C,D);
% func evaluation
phi=0;
for i=1:d+1
    phi=phi+R(i)*(x-xi)^(i-1);
end
% func_der evaluation
phi_der=0;
for i=2:d+1
        phi_der=phi_der+R(i)*(i-1)*(x-xi)^(i-2);
end
% error
error.func=abs(phi-func(x));
error.func_der=abs(phi_der-func_der(x));
end
% end of function