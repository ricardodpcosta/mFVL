% july 2017 - main file
clear; clc;
addpath('../../../../mfvl_utils_mod/results_treatment');

 xi=0;
 xf=[1 0.5 0.25 0.125 0.0625];
 d=[1 2 3 4 5];
%m=10;
 func=@(x)exp(x);
 func_der=@(x)exp(x);

for j=1:numel(d)
    m=ceil(1.5*d(j));
    for i=1:numel(xf)
        xff=xf(i);
        alpha=0;
        R_0{j}(i,1)=neumann_conservation(xi,xff,d(j),m,func,func_der,alpha,xi);
        error{1}{j}(i,1)=R_0{j}(i,1).func;
        error_der{1}{j}(i,1)=R_0{j}(i,1).func_der;
    end
end
% alpha =h
for j=1:numel(d)
    m=ceil(1.5*d(j));
    for i=1:numel(xf)
        xff=xf(i);
        alpha=(xff-xi)/m;
        R_h{j}(i,1)=neumann_conservation(xi,xff,d(j),m,func,func_der,alpha,xi);
        error{2}{j}(i,1)=R_h{j}(i,1).func;
        error_der{2}{j}(i,1)=R_h{j}(i,1).func_der;
    end
end
% alpha =0.5
for j=1:numel(d)
    m=ceil(1.5*d(j));
    for i=1:numel(xf)
        xff=xf(i);
        hs(i,j)=(xff-xi)/m;
        alpha=0.5;
        R_05{j}(i,1)=neumann_conservation(xi,xff,d(j),m,func,func_der,alpha,xi);
        error{3}{j}(i,1)=R_05{j}(i,1).func;
        error_der{3}{j}(i,1)=R_05{j}(i,1).func_der;
    end
end


for i=1:numel(d)
    alpha_0_d(i)=format_errors_orders(error{1}{i},numel(hs(:,i)),hs(:,i));
end
for i=1:numel(d)
    alpha_h_d(i)=format_errors_orders(error{2}{i},numel(hs(:,i)),hs(:,i));
end
for i=1:numel(d)
    alpha_05_d(i)=format_errors_orders(error{3}{i},numel(hs(:,i)),hs(:,i));
end

for i=1:numel(d)
    alpha_0_der_d(i)=format_errors_orders(error_der{1}{i},numel(hs(:,i)),hs(:,i));
end
for i=1:numel(d)
    alpha_h_der_d(i)=format_errors_orders(error_der{2}{i},numel(hs(:,i)),hs(:,i));
end
for i=1:numel(d)
    alpha_05_der_d(i)=format_errors_orders(error_der{3}{i},numel(hs(:,i)),hs(:,i));
end
%%%%
write_table_0('results_alpha_0_E0O0_exp_neu.tex','Results of the reconstruction in the Neumann B. ($\alpha$=0); $\phi(x)=\exp(x)$.',xf,...
    alpha_0_d(1).e,alpha_0_d(1).o,...
    alpha_0_d(2).e,alpha_0_d(2).o,...
    alpha_0_d(3).e,alpha_0_d(3).o,...
    alpha_0_d(4).e,alpha_0_d(4).o,...
    alpha_0_d(5).e,alpha_0_d(5).o);
write_table_1('results_alpha_0_E1O1_exp_neu.tex','Results of the reconstruction in the Neumann B. - derivative ($\alpha$=0); $\phi(x)=\exp(x)$.',xf,...
    alpha_0_der_d(1).e,alpha_0_der_d(1).o,...
    alpha_0_der_d(2).e,alpha_0_der_d(2).o,...
    alpha_0_der_d(3).e,alpha_0_der_d(3).o,...
    alpha_0_der_d(4).e,alpha_0_der_d(4).o,...
    alpha_0_der_d(5).e,alpha_0_der_d(5).o);



%%%%
write_table_0('results_alpha_h_E0O0_exp_neu.tex','Results of the reconstruction in the Neumann B. ($\alpha=h$); $\phi(x)=\exp(x)$.',xf,...
    alpha_h_d(1).e,alpha_h_d(1).o,...
    alpha_h_d(2).e,alpha_h_d(2).o,...
    alpha_h_d(3).e,alpha_h_d(3).o,...
    alpha_h_d(4).e,alpha_h_d(4).o,...
    alpha_h_d(5).e,alpha_h_d(5).o);
write_table_1('results_alpha_h_E1O1_exp_neu.tex','Results of the reconstruction in the Neumann B. - derivative ($\alpha=h$); $\phi(x)=\exp(x)$.',xf,...
    alpha_h_der_d(1).e,alpha_h_der_d(1).o,...
    alpha_h_der_d(2).e,alpha_h_der_d(2).o,...
    alpha_h_der_d(3).e,alpha_h_der_d(3).o,...
    alpha_h_der_d(4).e,alpha_h_der_d(4).o,...
    alpha_h_der_d(5).e,alpha_h_der_d(5).o);



%%%%
write_table_0('results_alpha_05_E0O0_exp_neu.tex','Results of the reconstruction in the Neumann B. ($\alpha=0.5$); $\phi(x)=\exp(x)$.',xf,...
    alpha_05_d(1).e,alpha_05_d(1).o,...
    alpha_05_d(2).e,alpha_05_d(2).o,...
    alpha_05_d(3).e,alpha_05_d(3).o,...
    alpha_05_d(4).e,alpha_05_d(4).o,...
    alpha_05_d(5).e,alpha_05_d(5).o);
write_table_1('results_alpha_05_E1O1_exp_neu.tex','Results of the reconstruction in the Neumann B. - derivative ($\alpha=0.5$); $\phi(x)=\exp(x)$.',xf,...
    alpha_05_der_d(1).e,alpha_05_der_d(1).o,...
    alpha_05_der_d(2).e,alpha_05_der_d(2).o,...
    alpha_05_der_d(3).e,alpha_05_der_d(3).o,...
    alpha_05_der_d(4).e,alpha_05_der_d(4).o,...
    alpha_05_der_d(5).e,alpha_05_der_d(5).o);


% end of file