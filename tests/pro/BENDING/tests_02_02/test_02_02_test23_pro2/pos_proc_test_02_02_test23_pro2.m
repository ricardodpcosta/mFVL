% January, 2017
% script for post-processing - PRO
clear all; clc;
addpath('../../../../');
addpath('../../../../mfvl_utils_mod');
addpath('../../../../mfvl_utils_mod/results_treatment');
addpath('../../../../mfvl_utils_mod/plot_mesh');
addpath('../../../../mfvl_run');
addpath('../../../../mfvl_mesh_mod');
addpath('../../../../mfvl_solver_mod');
addpath('../../../../mfvl_quadrat_mod');
addpath('../../../../mfvl_reconst_mod');
addpath('../../../../mfvl_domain_mod');
addpath('../../../../mfvl_model_mod');
addpath('../../../../mfvl_model_mod/mfvl_material_list1d');
addpath('../../../../mfvl_utils_mod/results_treatment');
load('output/test_pro_bending_02_02_test23_pro2_results.mat');
func=@(x)(exp(x)); % attention
% errors
for i=1:numel(degree)
    for f=1:numel(flux_num)
        for k=1:numel(num_cells)
            error{i}(k,f)=max(abs(pro{i}{k,f}.u_approx'-m{k}.eval_mean_value_cells(func)));
        end
    end
end
p5_pro2=format_errors_orders(error{1}(:,1),numel(num_cells),num_cells);
p6_pro2=format_errors_orders(error{2}(:,1),numel(num_cells),num_cells);

% write tables
label='Table:PRO:test_02_02_test23_pro2';
directory1='../../../../../Report/BIC_2017_report/tables/bending_pro_tables/test_02_02_test23_pro2.tex';
directory2='output/test_02_02_test23_pro2.tex';
caption='Numerical results of the example~/ref{Example:Pro:bending:Test02_02_glob6} with $/omega=1|3$, and $/omega=3$.';
 mfvl_write_table4(directory1,caption,label,num_cells,degree,...
     p5_pro2.e,p5_pro2.o,...
     p6_pro2.e,p6_pro2.o);

 mfvl_write_table4(directory2,caption,label,num_cells,degree,...
     p5_pro2.e,p5_pro2.o,...
     p6_pro2.e,p6_pro2.o);
save('output/test_pro_bending_02_02_test23_pro2_results.mat');
