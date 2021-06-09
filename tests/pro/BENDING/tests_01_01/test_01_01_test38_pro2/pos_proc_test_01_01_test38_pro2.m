% January, 2017
% script for post-processing - PRO
clear all; clc;
addpath('../../../../../');
addpath('../../../../../mfvl_utils_mod');
addpath('../../../../../mfvl_utils_mod/results_treatment');
addpath('../../../../../mfvl_utils_mod/plot_mesh');
addpath('../../../../../mfvl_run');
addpath('../../../../../mfvl_mesh_mod');
addpath('../../../../../mfvl_solver_mod');
addpath('../../../../../mfvl_quadrat_mod');
addpath('../../../../../mfvl_reconst_mod');
addpath('../../../../../mfvl_domain_mod');
addpath('../../../../../mfvl_model_mod');
addpath('../../../../../mfvl_model_mod/mfvl_material_list1d');
addpath('../../../../../mfvl_utils_mod/results_treatment');
load('output/test_pro_bending_01_01_test38_pro2_results.mat');
func=@(x)sin(3*pi*x); % attention
% errors
for i=1:numel(degree)
        for k=1:numel(num_cells)
            error{i}(k)=max(abs(pro{i}{k}.u_approx'-m{k}.eval_mean_value_cells(func)));
        end
end
p7_pro2=format_errors_orders(error{1},numel(num_cells),num_cells);
p8_pro2=format_errors_orders(error{2},numel(num_cells),num_cells);

if ~exist('output/tables', 'dir')
    mkdir('output/','tables');
end
% write tables
label='Table:PRO:test_01_01_test38_pro2';
directory1='../../../../../../Report/BIC_2017_report/tables/bending_pro_tables/test_01_01_test38_pro2.tex';
directory2='output/tables/test_01_01_test38_pro2.tex';
caption='Numerical results of the example~/ref{Example:Pro:bending:Test01_01_glob1} with $/omega=1|3$, and $/omega=10$.';
% 
% mfvl_write_table4(directory1,caption,label,num_cells,degree,...
%     p7_pro2.e,p7_pro2.o,...
%     p8_pro2.e,p8_pro2.o);
% 
% mfvl_write_table4(directory2,caption,label,num_cells,degree,...
%     p7_pro2.e,p7_pro2.o,...
%     p8_pro2.e,p8_pro2.o);
save('output/test_pro_bending_01_01_test38_pro2_results.mat');
