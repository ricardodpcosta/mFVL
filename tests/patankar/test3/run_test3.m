% December, 2016
% test 3 processing
clear; clc;
addpath('..\..\..\');
addpath('..\..\..\mfvl_utils_mod');
addpath('..\..\..\mfvl_utils_mod/results_treatment');
addpath('..\..\..\mfvl_utils_mod/plot_mesh');
addpath('..\..\..\mfvl_run');
addpath('..\..\..\mfvl_mesh_mod');
addpath('..\..\..\mfvl_solver_mod');
addpath('..\..\..\mfvl_quadrat_mod');
addpath('..\..\..\mfvl_reconst_mod');
addpath('..\..\..\mfvl_domain_mod');
addpath('..\..\..\mfvl_model_mod');
addpath('..\..\..\mfvl_model_mod/mfvl_material_list1d');
mfvl_lib;

num_cells_intro=[10 20 30 40 80 160];
for i=1:numel(num_cells_intro)
    geo_test3;
    model_test3;
    mesh_test3;
    
    pat{i,1}=mfvl_pat(m{i},domain,mod,bound,'CD','I');
    pat{i,2}=mfvl_pat(m{i},domain,mod,bound,'CD','II');
    pat{i,3}=mfvl_pat(m{i},domain,mod,bound,'UW','I');
    pat{i,4}=mfvl_pat(m{i},domain,mod,bound,'UW','II');
end
% work files
save('output\test3_results.mat');