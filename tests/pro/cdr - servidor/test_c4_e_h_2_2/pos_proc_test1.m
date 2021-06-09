% November, 2017
% script for post-processing for test with c4 and h^2/2 - PRO
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
                 right_bound=0;
                 vertex_data=[left_bound zeros([1 (num_cells(k)-1)]) right_bound];
                 S=pro_s.mesh.eval_mean_value_cells(source_term).*h;
                 a=pro_s.model.material.thermal_conductivity;
                 v=pro_s.model.velocity;
                 r=pro_s.model.reaction;
                 value=pro_s.make_residual(degree(i),[weight1 weight2],U,vertex_data,S,a,v,r,stencil_size(:,i),auto_stencil_opt);
                check_aux{k,i}=pro_s.checkmark;

                % errors
                error{m}{i}(k,f)=max(abs(sol'-mesh.eval_mean_value_cells(func)));
                error_l1{m}{i}(k,f)=sum(abs(sol'-mesh.eval_mean_value_cells(func)).*h);
                error_cons_l1{m}{i}(k,f)=sum(abs(value).*h');
            end
        end
    end
end

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
label='Table:PRO:c4 uniform (h^2)/2';
directory='output/tables/uniform_h_square_over_2_c4.tex';
caption='Numerical results of pure diffusion for $\phi(x)=\exp(x)$, $\kappa(x)=1$, and $u(x)=0$ (c4; uniform mesh; $\epsilon=\frac{h^2}{2}$).';

mfvl_write_table13(directory,caption,label,num_cells,degree,condition,...
    P1_L1.e,P1_L1.o,P1.e,P1.o,P1_cons_L1.e,P1_cons_L1.o,...
    P2_L1.e,P2_L1.o,P2.e,P2.o,P2_cons_L1.e,P2_cons_L1.o,...
    P3_L1.e,P3_L1.o,P3.e,P3.o,P3_cons_L1.e,P3_cons_L1.o,...
    P4_L1.e,P4_L1.o,P4.e,P4.o,P4_cons_L1.e,P4_cons_L1.o,...
    P5_L1.e,P5_L1.o,P5.e,P5.o,P5_cons_L1.e,P5_cons_L1.o,...
    check_aux);

% end of file
