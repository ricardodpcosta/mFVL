% December, 2016
% script for post-processing for test 9
clc;
clear;
load('output\test9_results.mat');
func=@(x)exp(x); % attention
% errors
for j=1:numel(conv_term)
    for i=1:size(pat{j},1)
        CD_II(i,j)=max(abs(pat{j}{i,1}.u_approx'-m{i}.eval_mean_value_cells(func)));
        UW_II(i,j)=max(abs(pat{j}{i,2}.u_approx'-m{i}.eval_mean_value_cells(func)));
    end
end
CD_II_1=format_errors_orders(CD_II(:,1),numel(num_cells_intro),num_cells_intro);
UW_II_1=format_errors_orders(UW_II(:,1),numel(num_cells_intro),num_cells_intro);

CD_II_2=format_errors_orders(CD_II(:,2),numel(num_cells_intro),num_cells_intro);
UW_II_2=format_errors_orders(UW_II(:,2),numel(num_cells_intro),num_cells_intro);

CD_II_3=format_errors_orders(CD_II(:,3),numel(num_cells_intro),num_cells_intro);
UW_II_3=format_errors_orders(UW_II(:,3),numel(num_cells_intro),num_cells_intro);

CD_II_4=format_errors_orders(CD_II(:,4),numel(num_cells_intro),num_cells_intro);
UW_II_4=format_errors_orders(UW_II(:,4),numel(num_cells_intro),num_cells_intro);
% write tables
label='Table:Patankar:Test9';
directory1='..\..\..\..\Report\BIC_2017_report\tables\new_patankar_tables\test9.tex';
directory2='output\test9.tex';
caption='Numerical results of example~\ref{Example:Patankar:Test9}.';

write_results_v2(directory1,caption,label,...
    CD_II_1.e,CD_II_2.e,CD_II_3.e,CD_II_4.e,...
    CD_II_1.o,CD_II_2.o,CD_II_3.o,CD_II_4.o,...
    UW_II_1.e,UW_II_2.e,UW_II_3.e,UW_II_4.e,...
    UW_II_1.o,UW_II_2.o,UW_II_3.o,UW_II_4.o,...
    num_cells_intro);
write_results_v2(directory2,caption,label,...
    CD_II_1.e,CD_II_2.e,CD_II_3.e,CD_II_4.e,...
    CD_II_1.o,CD_II_2.o,CD_II_3.o,CD_II_4.o,...
    UW_II_1.e,UW_II_2.e,UW_II_3.e,UW_II_4.e,...
    UW_II_1.o,UW_II_2.o,UW_II_3.o,UW_II_4.o,...
    num_cells_intro);