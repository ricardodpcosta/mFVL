% January, 2017
% script for post-processing - PRO
clear all; clc;
global a_matrix;
global stencil_matrix;
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
mfvl_lib;
load('output/requisites.mat');
if ~exist('output/plots', 'dir')
    mkdir('output/','plots');
end
func=@(x)x^4;
% errors
for i=1:numel(degree)
    for k=1:numel(num_cells)
        file_name=['nc' num2str(num_cells(k)) '_deg' num2str(degree(i)) '_wei1' num2str(weight1) num2str(weight2) '_' pro_scheme];
        sol=importdata(['output/' file_name '/sol.dat']);
        load(['output/' file_name '/mesh.mat']);
        load(['output/' file_name '/pro.mat']);
        
        U=mesh.eval_mean_value_cells(func);
        a_matrix=cell([1 num_cells(k)+2]);
        stencil_matrix=cell([1 num_cells(k)+2]);
        left_bound=pro_s.model.get_bound_cond(1).get_value(1);
        right_bound=pro_s.model.get_bound_cond(2).get_value(1);
        vertex_data=[left_bound zeros([1 (num_cells(k)-1)]) right_bound];
        source_term=pro_s.model.get_source_term(1).get_value;
        h=pro_s.mesh.get_cell_length_all;
        S=pro_s.mesh.eval_mean_value_cells(source_term).*h;
        value=pro_s.make_residual(degree(i),[weight1 weight2],U,stencil_size(i),force,auto_stencil_opt,S,vertex_data);
        value=value'./h;
       
        if k==1 && i==1
            plot_mesh1d(mesh);
            pos = get(figure(1),'Position');
            set(figure(1),'PaperPositionMode','Auto','PaperUnits','Inches','PaperSize',[pos(3), pos(4)]);
            print(figure(1),'output/plots/mesh','-dpdf','-r0');
        end
        h=figure(1);
        vec_x=1:1:num_cells(k);
        plot(vec_x,value,'-o','LineWidth',1);
        xlabel('Cell');
        ylabel('Error');
        title(['nc' num2str(num_cells(k)) '\_deg' num2str(degree(i)) '\_' pro_scheme '\_cons']);
        set(h,'Units','Inches');
        pos = get(h,'Position');
        set(h,'PaperPositionMode','Auto','PaperUnits','Inches','PaperSize',[pos(3), pos(4)]);
        print(h,['output/plots/' file_name '_cons'],'-dpdf','-r0');
        hold off;
        error{i}(k)=max(abs(value));
    end
end
p1_pro1=format_errors_orders(error{1},numel(num_cells),num_cells);
p2_pro1=format_errors_orders(error{2},numel(num_cells),num_cells);

if ~exist('output/tables', 'dir')
    mkdir('output/','tables');
end
% write tables
label='Table:PRO:test_01_01_test48_pro1';
directory1='../../../../../../Report/BIC_2017_report/tables/bending_pro_tables/test_01_01_test48_pro1_cons.tex';
directory2='output/tables/test_01_01_test48_pro1_cons.tex';
caption='Numerical results of the example~/ref{Example:Pro:bending:Test01_01_glob1} with $/omega=1|1$, and $/omega=1$.';

%mfvl_write_table4(directory1,caption,label,num_cells,degree,...
%    p1_pro1.e,p1_pro1.o,...
%    p2_pro1.e,p2_pro1.o);

mfvl_write_table4(directory2,caption,label,num_cells,degree,...
    p1_pro1.e,p1_pro1.o,...
    p2_pro1.e,p2_pro1.o);
save('output/test_pro_bending_01_01_test48_pro1_results','p1_pro1','p2_pro1');
