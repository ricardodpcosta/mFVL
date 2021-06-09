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
for i=1:numel(degree)
    for k=1:numel(num_cells)
        file_name=['nc' num2str(num_cells(k)) '_deg' num2str(degree(i)) '_wei1' num2str(weight1) num2str(weight2) '_' pro_scheme];
        sol=importdata(['output/' file_name '/sol.dat']);
        load(['output/' file_name '/mesh.mat']);
        h=mesh.get_cell_length_all;
        value=sol'-mesh.eval_mean_value_cells(func);
        value2=(sol'-mesh.eval_mean_value_cells(func))./(h.^2);
        
        h_fig=figure(1);
        vec_x=1:1:num_cells(k);
        plot(vec_x,value,'-o','LineWidth',1);
        xlabel('Cell');
        ylabel('Error');
        title(['nc' num2str(num_cells(k)) '\_deg' num2str(degree(i)) '\_' pro_scheme]);
        set(h_fig,'Units','Inches');
        pos = get(h_fig,'Position');
        set(h_fig,'PaperPositionMode','Auto','PaperUnits','Inches','PaperSize',[pos(3), pos(4)]);
        print(h_fig,['output/plots/' file_name],'-dpdf','-r0');
        hold off;
        
        h_fig=figure(2);
        vec_x=1:1:num_cells(k);
        plot(vec_x,value2,'-o','LineWidth',1);
        xlabel('Cell');
        ylabel('Error');
        title(['nc' num2str(num_cells(k)) '\_deg' num2str(degree(i)) '\_' pro_scheme '\_v2']);
        set(h_fig,'Units','Inches');
        pos = get(h_fig,'Position');
        set(h_fig,'PaperPositionMode','Auto','PaperUnits','Inches','PaperSize',[pos(3), pos(4)]);
        print(h_fig,['output/plots/' file_name '_v2'],'-dpdf','-r0');
        hold off;
        error{1,i}(k)=max(abs(sol'-mesh.eval_mean_value_cells(func)));
        error{2,i}(k)=sum(abs(sol'-mesh.eval_mean_value_cells(func)).*h);
    end
end
p2_pro2=format_errors_orders(error{1,1},numel(num_cells),num_cells);

p2_pro2_l1=format_errors_orders(error{2,1},numel(num_cells),num_cells);

if ~exist('output/tables', 'dir')
    mkdir('output/','tables');
end
% write tables
label='Table:PRO:test_01_01_test2_pro2';
directory1='../../../../../../Report/BIC_2017_report/tables/bending_pro_tables/test_01_01_test2_pro2.tex';
directory2='output/tables/test_01_01_test2_pro2.tex';
directory3='output/tables/test_01_01_test2_pro2_l1.tex';
caption='Numerical results with $\omega=1|3$, and $\omega=1$.';

%mfvl_write_table4(directory1,caption,label,num_cells,degree,...
%    p3_pro2.e,p3_pro2.o,...
%    p4_pro2.e,p4_pro2.o);
%mfvl_write_table4(directory2,caption,label,num_cells,degree,...
%    p3_pro2.e,p3_pro2.o,...
%    p4_pro2.e,p4_pro2.o);
%mfvl_write_table4(directory3,caption,label,num_cells,degree,...
%    p3_pro2_l1.e,p3_pro2_l1.o,...
%    p4_pro2_l1.e,p4_pro2_l1.o);
save('output/test_pro_bending_01_01_test2_pro2_results','p2_pro2','p2_pro2_l1');
