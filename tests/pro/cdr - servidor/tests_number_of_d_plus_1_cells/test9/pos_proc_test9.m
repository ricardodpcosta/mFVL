% January, 2017
% script for post-processing for test 1 - PRO
clear all; clc;
global a_matrix;
global stencil_matrix;
global a_matrix_none;
global stencil_matrix_none;
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
mfvl_lib;
load('output/requisites.mat');
if ~exist('output/plots', 'dir')
    mkdir('output/','plots');
end
func=@(x)exp(x); % attention
% errors
j=1;
for m=1:numel(type)
    for i=1:numel(degree)
        for f=1:numel(flux_num)
            if (flux_num(f)==1)
                flux='pro1';
            else
                flux='pro2';
            end
            for k=1:numel(num_cells)
                file_name=['nc' num2str(num_cells(k)) '_deg' num2str(degree(i)) '_wei1' num2str(weight1) num2str(weight2) '_' flux];
                sol=importdata(['output/' file_name '/sol.dat']);
                load(['output/meshes_uniform/nc' num2str(num_cells(k)) '_mesh.mat']);
                load(['output/' file_name '/pro.mat']);
                cond_aux(k,i)=pro_s.condition;
                h=pro_s.mesh.get_cell_length_all;
                U=mesh.eval_mean_value_cells(func);
                a_matrix=cell([1 num_cells(k)+2]);
                stencil_matrix=cell([1 num_cells(k)+2]);
                a_matrix_none=cell([1 num_cells(k)-1]);
                stencil_matrix_none=cell([1 num_cells(k)-1]);
                source_term=pro_s.model.get_source_term(1).get_value;
                left_bound=pro_s.model.get_bound_cond(1).get_value(1);
                right_bound=0;%-source_term(mesh.get_vertex_point(mesh.get_num_vertices));
                vertex_data=[left_bound zeros([1 (num_cells(k)-1)]) right_bound];
                S=pro_s.mesh.eval_mean_value_cells(source_term).*h;
                a=pro_s.model.material.thermal_conductivity;
                v=pro_s.model.velocity;
                r=pro_s.model.reaction;
                value=pro_s.make_residual(degree(i),[weight1 weight2],U,vertex_data,S,a,v,r,stencil_size(:,i),auto_stencil_opt);
                %                 vertices_coordinates=mesh.get_vertex_point_all;
                check_aux{k,i}=pro_s.checkmark;
                
                %                 % error position
                %                 h_fig=figure(1);
                %                 vec_x=1:1:num_cells(k);
                %                 plot(vec_x,(sol'-mesh.eval_mean_value_cells(func)),'-o','LineWidth',1);
                %                 xlabel('Cell');
                %                 ylabel('Error');
                %                 title(['nc' num2str(num_cells(k)) '\_deg' num2str(degree(i)) '\_wei1' num2str(weight1) num2str(weight2) '\_' flux]);
                %                 set(h_fig,'Units','Inches');
                %                 pos = get(h_fig,'Position');
                %                 set(h_fig,'PaperPositionMode','Auto','PaperUnits','Inches','PaperSize',[pos(3), pos(4)]);
                %                 print(h_fig,['output/plots/' file_name],'-dpdf','-r0');
                %                 hold off;
                %                 % dif_flux errors
                %                 h_fig=figure(1);
                %                 vec_x=1:1:num_cells(k)+1;
                %                 plot(vec_x,(pro_s.dif_flux-f_diff),'-o','LineWidth',1);
                %                 xlabel('Vertex');
                %                 ylabel('Error');
                %                 title(['nc' num2str(num_cells(k)) '\_deg' num2str(degree(i)) '\_wei1' num2str(weight1) num2str(weight2) '\_' flux '\_flux\_error']);
                %                 set(h_fig,'Units','Inches');
                %                 pos = get(h_fig,'Position');
                %                 set(h_fig,'PaperPositionMode','Auto','PaperUnits','Inches','PaperSize',[pos(3), pos(4)]);
                %                 print(h_fig,['output/plots/' file_name  '_flux_error'],'-dpdf','-r0');
                %                 hold off;
                
                % errors
                error{m}{i}(k,f)=max(abs(sol'-mesh.eval_mean_value_cells(func)));
                error_l1{m}{i}(k,f)=sum(abs(sol'-mesh.eval_mean_value_cells(func)).*h);
                %error_cons{m}{i}(k,f)=max(abs(value)./h');
                error_cons_l1{m}{i}(k,f)=sum(abs(value).*h');
                %error_diff_flux{m}{i}(k,f)=max(abs(pro_s.dif_flux-f_diff));
                %j=j+1;
                %plot(1:1:num_cells(k),value)
            end
        end
    end
end
%P1_PRO2_cons=format_errors_orders(error_cons{1}{1}(:,1),numel(num_cells),num_cells);

P1=format_errors_orders(error{1}{1}(:,1),numel(num_cells),num_cells);
P1_L1=format_errors_orders(error_l1{1}{1}(:,1),numel(num_cells),num_cells);
P1_cons_L1=format_errors_orders(error_cons_l1{1}{1}(:,1),numel(num_cells),num_cells);
for i=1:numel(degree)
    condition(i,1)=format_errors_orders(cond_aux(:,i),numel(num_cells),num_cells);
end

P2=format_errors_orders(error{1}{2}(:,1),numel(num_cells),num_cells);
P2_L1=format_errors_orders(error_l1{1}{2}(:,1),numel(num_cells),num_cells);
P2_cons_L1=format_errors_orders(error_cons_l1{1}{2}(:,1),numel(num_cells),num_cells);


P3=format_errors_orders(error{1}{3}(:,1),numel(num_cells),num_cells);
P3_L1=format_errors_orders(error_l1{1}{3}(:,1),numel(num_cells),num_cells);
P3_cons_L1=format_errors_orders(error_cons_l1{1}{3}(:,1),numel(num_cells),num_cells);


P4=format_errors_orders(error{1}{4}(:,1),numel(num_cells),num_cells);
P4_L1=format_errors_orders(error_l1{1}{4}(:,1),numel(num_cells),num_cells);
P4_cons_L1=format_errors_orders(error_cons_l1{1}{4}(:,1),numel(num_cells),num_cells);


P5=format_errors_orders(error{1}{5}(:,1),numel(num_cells),num_cells);
P5_L1=format_errors_orders(error_l1{1}{5}(:,1),numel(num_cells),num_cells);
P5_cons_L1=format_errors_orders(error_cons_l1{1}{5}(:,1),numel(num_cells),num_cells);

% condition
condition=cell(3,numel(degree));
for i=1:numel(degree)
    cond_aux_2{i}=format_errors_orders(cond_aux(:,i),numel(num_cells),num_cells);
end
for i=1:numel(degree)
    for k=1:numel(num_cells)
        condition{k,i}=cond_aux_2{i}.e(k);
    end
end
condition=cell2table(condition);
condition=table2array(condition);

if ~exist('output/tables', 'dir')
    mkdir('output/tables');
end
% write tables
label='Table:PRO:Test9';
%directory1='../../../../Report/BIC_2017_report/tables/new_pro_tables/new.tex';
directory2='output/tables/test_9.tex';
%directory3='output/tables/uniform_0_d_dir.tex';
caption='Numerical results of pure diffusion for $\phi(x)=\exp(x)$, $\kappa(x)=1$, and $u(x)=0$ (Neumann bc and 8 cells with $d+1$  and the other cells with $d$).';

% mfvl_write_table3(directory1,caption,...
%     label,num_cells,degree,...
%     P1_PRO1.e,P1_PRO1.o,...
%     P1_PRO2.e,P1_PRO2.o,...
%     P2_PRO1.e,P2_PRO1.o,...
%     P2_PRO2.e,P2_PRO2.o,...
%     P3_PRO1.e,P3_PRO1.o,...
%     P3_PRO2.e,P3_PRO2.o,...
%     P4_PRO1.e,P4_PRO1.o,...
%     P4_PRO2.e,P4_PRO2.o,...
%     P5_PRO1.e,P5_PRO1.o,...
%     P5_PRO2.e,P5_PRO2.o);
mfvl_write_table13(directory2,caption,label,num_cells,degree,condition,...
    P1_L1.e,P1_L1.o,P1.e,P1.o,P1_cons_L1.e,P1_cons_L1.o,...
    P2_L1.e,P2_L1.o,P2.e,P2.o,P2_cons_L1.e,P2_cons_L1.o,...
    P3_L1.e,P3_L1.o,P3.e,P3.o,P3_cons_L1.e,P3_cons_L1.o,...
    P4_L1.e,P4_L1.o,P4.e,P4.o,P4_cons_L1.e,P4_cons_L1.o,...
    P5_L1.e,P5_L1.o,P5.e,P5.o,P5_cons_L1.e,P5_cons_L1.o,...
    check_aux);

% mfvl_write_table12(directory3,caption,label,num_cells,degree,...
%     P1_PRO1_cons.e,P1_PRO1_cons.o,...
%     P2_PRO1_cons.e,P2_PRO1_cons.o,...
%     P3_PRO1_cons.e,P3_PRO1_cons.o,...
%     P4_PRO1_cons.e,P4_PRO1_cons.o,...
%     P5_PRO1_cons.e,P5_PRO1_cons.o);


% mfvl_write_table3(directory2,caption,...
%     label,num_cells,degree,...
%     P1_PRO1.e,P1_PRO1.o,...
%     P1_PRO2.e,P1_PRO2.o,...
%     P2_PRO1.e,P2_PRO1.o,...
%     P2_PRO2.e,P2_PRO2.o,...
%     P3_PRO1.e,P3_PRO1.o,...
%     P3_PRO2.e,P3_PRO2.o,...
%     P4_PRO1.e,P4_PRO1.o,...
%     P4_PRO2.e,P4_PRO2.o,...
%     P5_PRO1.e,P5_PRO1.o,...
%     P5_PRO2.e,P5_PRO2.o);
%
% mfvl_write_table3(directory3,caption,...
%     label,num_cells,degree,...
%     P1_PRO1_cons.e,P1_PRO1_cons.o,...
%     P1_PRO2_cons.e,P1_PRO2_cons.o,...
%     P2_PRO1_cons.e,P2_PRO1_cons.o,...
%     P2_PRO2_cons.e,P2_PRO2_cons.o,...
%     P3_PRO1_cons.e,P3_PRO1_cons.o,...
%     P3_PRO2_cons.e,P3_PRO2_cons.o,...
%     P4_PRO1_cons.e,P4_PRO1_cons.o,...
%     P4_PRO2_cons.e,P4_PRO2_cons.o,...
%     P5_PRO1_cons.e,P5_PRO1_cons.o,...
%     P5_PRO2_cons.e,P5_PRO2_cons.o);
