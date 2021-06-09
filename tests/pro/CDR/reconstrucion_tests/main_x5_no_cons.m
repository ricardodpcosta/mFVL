% july 2017 - main file
clear; clc;
addpath('../../../../mfvl_utils_mod/results_treatment');

xi=0;
xf=[1 0.5 0.25 0.125 0.0625];
d=[1 2 3 4 5];
% m=10;
func=@(x)x.^5;
func_der=@(x)5*(x.^4);

for j=1:numel(d)
    m=ceil(1.5*d(j));
    for i=1:numel(xf)
        xff=xf(i);
        alpha=0;
        hs(i,j)=(xff-xi)/m;
        R_0{j}(i,1)=no_conservation(xi,xff,d(j),m,func,func_der,alpha,xi);
        error{1}{j}(i,1)=R_0{j}(i,1).func;
        error_der{1}{j}(i,1)=R_0{j}(i,1).func_der;
    end
end


for i=1:numel(d)
    alpha_0_d(i)=format_errors_orders(error{1}{i},numel(hs(:,i)),hs(:,i));
end

for i=1:numel(d)
    alpha_0_der_d(i)=format_errors_orders(error_der{1}{i},numel(hs(:,i)),hs(:,i));
end
%%%%
write_table_0('results_alpha_0_E0O0_x5_no_conservation.tex','Results of the reconstruction without restriction; $\phi(x)=x^5$.',xf,...
    alpha_0_d(1).e,alpha_0_d(1).o,...
    alpha_0_d(2).e,alpha_0_d(2).o,...
    alpha_0_d(3).e,alpha_0_d(3).o,...
    alpha_0_d(4).e,alpha_0_d(4).o,...
    alpha_0_d(5).e,alpha_0_d(5).o);
write_table_1('results_alpha_0_E1O1_x5_no_conservation.tex','Results of the reconstruction without restriction; $\phi(x)=x^5$.',xf,...
    alpha_0_der_d(1).e,alpha_0_der_d(1).o,...
    alpha_0_der_d(2).e,alpha_0_der_d(2).o,...
    alpha_0_der_d(3).e,alpha_0_der_d(3).o,...
    alpha_0_der_d(4).e,alpha_0_der_d(4).o,...
    alpha_0_der_d(5).e,alpha_0_der_d(5).o);




% end of file