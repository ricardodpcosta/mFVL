% December, 2016
% script for post-processing for test 10
clc;
clear;
load('output\test10_results.mat');
% errors
for j=1:numel(conv_term)
    func=phi_matrix{j}; % attention
    for i=1:size(pat{j},1)
        CD_I(i,j)=max(abs(pat{j}{i,1}.u_approx'-m{i}.eval_mean_value_cells(func)));
        UW_I(i,j)=max(abs(pat{j}{i,2}.u_approx'-m{i}.eval_mean_value_cells(func)));
    end
end
CD_I_1=format_errors_orders(CD_I(:,1),numel(num_cells_intro),num_cells_intro);
UW_I_1=format_errors_orders(UW_I(:,1),numel(num_cells_intro),num_cells_intro);

CD_I_2=format_errors_orders(CD_I(:,2),numel(num_cells_intro),num_cells_intro);
UW_I_2=format_errors_orders(UW_I(:,2),numel(num_cells_intro),num_cells_intro);

% write tables
label='Table:Patankar:Test10';
directory1='..\..\..\..\Report\BIC_2017_report\tables\new_patankar_tables\test10.tex';
directory2='output\test10.tex';
caption='Numerical results of example~\ref{Example:Patankar:Test10}.';

write_results_v4(directory1,caption,label,...
    CD_I_1.e,CD_I_1.o,...
    UW_I_1.e,UW_I_1.o,...
    CD_I_2.e,CD_I_2.o,...
    UW_I_2.e,UW_I_2.o,...
    num_cells_intro);
write_results_v4(directory2,caption,label,...
    CD_I_1.e,CD_I_1.o,...
    UW_I_1.e,UW_I_1.o,...
    CD_I_2.e,CD_I_2.o,...
    UW_I_2.e,UW_I_2.o,...
    num_cells_intro);