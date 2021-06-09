% December, 2016
% script for post-processing for test 14
clc;
clear;
load('output\test14_results.mat');
func=@(x)exp(x); % attention
% errors
CD_I=zeros([1 size(pat,1)]);
CD_II=zeros([1 size(pat,1)]);
UW_I=zeros([1 size(pat,1)]);
UW_II=zeros([1 size(pat,1)]);
for i=1:size(pat,1)
    CD_I(i)=max(abs(pat{i,1}.u_approx'-m{i}.eval_mean_value_cells(func)));
    CD_II(i)=max(abs(pat{i,2}.u_approx'-m{i}.eval_mean_value_cells(func)));
    UW_I(i)=max(abs(pat{i,3}.u_approx'-m{i}.eval_mean_value_cells(func)));
    UW_II(i)=max(abs(pat{i,4}.u_approx'-m{i}.eval_mean_value_cells(func)));
end

CD_I=format_errors_orders(CD_I,numel(num_cells_intro),num_cells_intro);
CD_II=format_errors_orders(CD_II,numel(num_cells_intro),num_cells_intro);
UW_I=format_errors_orders(UW_I,numel(num_cells_intro),num_cells_intro);
UW_II=format_errors_orders(UW_II,numel(num_cells_intro),num_cells_intro);
% write tables
label='Table:Patankar:Test14';
directory1='..\..\..\..\Report\BIC_2017_report\tables\new_patankar_tables\test14.tex';
directory2='output\test14.tex';
caption='Numerical results of example~\ref{Example:Patankar:Test14}.';

write_results_v1(directory1,caption,label,...
    CD_I.e,CD_I.o,...
    UW_I.e,UW_I.o,...
    CD_II.e,CD_II.o,...
    UW_II.e,UW_II.o,...
    num_cells_intro);
write_results_v1(directory2,caption,label,...
    CD_I.e,CD_I.o,...
    UW_I.e,UW_I.o,...
    CD_II.e,CD_II.o,...
    UW_II.e,UW_II.o,...
    num_cells_intro);