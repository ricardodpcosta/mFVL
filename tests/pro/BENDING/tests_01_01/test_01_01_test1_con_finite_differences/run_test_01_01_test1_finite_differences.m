% January, 2017
% test processing - PRO
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
mfvl_lib;

num_cells=[10 20 40 80 160];

if ~exist('output', 'dir')
    mkdir('output');
end

save('output/requisites.mat','num_cells');
for k=1:numel(num_cells)
   
    geo_test_01_01_test1_pro2;
    model_test_01_01_test1_pro2;
    mesh_test_01_01_test1_pro2;
    disp(k);
    file_name=['nc' num2str(num_cells(k)) '_finite_differences'];
    if ~exist(['output/' file_name], 'dir')
        mkdir('output/',file_name);
    end
    
    file_name_mesh=['output/' file_name '/mesh.mat'];
    file_name_domain=['output/' file_name '/domain.mat'];
    file_name_model=['output/' file_name '/model.mat'];
    file_name_data=['output/' file_name '/data.mat'];
    file_name_sol=['output/' file_name '/sol.dat'];
    
    mesh=m{k};
    
    save(file_name_mesh,'mesh');
    save(file_name_domain,'domain');
    save(file_name_model,'mod');

    phi_lf_0=mod.get_bound_cond(1).get_value(1);
    phi_lf_1=mod.get_bound_cond(1).get_value(2);
    phi_rg_0=mod.get_bound_cond(2).get_value(1);
    phi_rg_1=mod.get_bound_cond(2).get_value(2);
    x_rg=domain.get_point(2).get_coord;
    h_val=x_rg/num_cells(k);
    h=mesh.get_cell_length_all;
    source=mod.get_source_term(1).get_value; % attention
    S=source(mesh.get_cell_centroid_all);
    %mesh.eval_mean_value_cells(source).*h;
    
    [A,b]=pre_conditioner(num_cells(k),mesh.get_cell_centroid_all,...
        phi_lf_0,phi_lf_1,...
        phi_rg_0,phi_rg_1,h_val,x_rg,S);
    sol=A\b;
    save(file_name_sol,'sol','-ascii','-double');
    save(file_name_data,'A','b');
end

% work files

% ========================
% end of file
% ========================
