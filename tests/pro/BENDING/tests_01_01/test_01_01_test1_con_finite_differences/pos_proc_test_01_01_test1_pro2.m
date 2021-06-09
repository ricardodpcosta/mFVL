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
load('output/requisites.mat');
mfvl_lib;
func=@(x)exp(x); % attention
if ~exist('output/plots', 'dir')
    mkdir('output/','plots');
end
% errors
for k=1:numel(num_cells)
    file_name=['nc' num2str(num_cells(k)) '_finite_differences'];
    sol=importdata(['output/' file_name '/sol.dat']);
    data=importdata(['output/' file_name '/data.mat']);
    load(['output/' file_name '/mesh.mat']);
    h=mesh.get_cell_length_all;
   % error position
   y_value=sol'-mesh.eval_mean_value_cells(func);
   h_fig=figure(1);
   vec_x=1:1:num_cells(k);
   plot(vec_x,y_value,'-o','LineWidth',1);
   xlabel('Cell');
   ylabel('Error');
   title(['nc' num2str(num_cells(k)) '\_error\_position']);
   set(h_fig,'Units','Inches');
   pos = get(h_fig,'Position');
   set(h_fig,'PaperPositionMode','Auto','PaperUnits','Inches','PaperSize',[pos(3), pos(4)]);
   print(h_fig,['output/plots/' file_name '_error_position'],'-dpdf','-r0');
   hold off;
   
    
    error(k,1)=max(abs(sol'-mesh.eval_mean_value_cells(func)));
    error(k,2)=sum(abs(sol'-mesh.eval_mean_value_cells(func)).*h);
    error(k,3)=max(abs(data.A*func(mesh.get_cell_centroid_all)'-data.b));
end
p1=format_errors_orders(error(:,1),numel(num_cells),num_cells);
p1_l1=format_errors_orders(error(:,2),numel(num_cells),num_cells);

p1_cons=format_errors_orders(error(:,3),numel(num_cells),num_cells);
if ~exist('output/tables', 'dir')
    mkdir('output/','tables');
end
% write tables
label='Table:';
degree=[0 0];
%directory1='../../../../../../Report/BIC_2017_report/tables/bending_pro_tables/test_01_01_test1_pro2.tex';
directory2='output/tables/results.tex';
directory3='output/tables/results_consistency.tex';
caption='Numerical results with $\omega=1|1$, and $\omega=1$.';

mfvl_write_table4(directory2,caption,label,num_cells,degree,...
    p1.e,p1.o,...
    p1_l1.e,p1_l1.o);
% consistency error
mfvl_write_table4(directory3,caption,label,num_cells,degree,...
    p1_cons.e,p1_cons.o,...
    p1_cons.e,p1_cons.o);
%mfvl_write_table4(directory2,caption,label,num_cells,degree,...
%    p1_pro2.e,p1_pro2.o,...
%    p2_pro2.e,p2_pro2.o);
%mfvl_write_table4(directory3,caption,label,num_cells,degree,...
%    p1_pro2_l1.e,p1_pro2_l1.o,...
%    p2_pro2_l1.e,p2_pro2_l1.o);
save('output/test_pro_bending_01_01_test1_finite_differences_results','p1','p1_l1','p1_cons');
