% December, 2016
% test 10 processing
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
conv_term={@(x)0.*x+100 @(x)0.*x+1};
u=[100 1];
Pe=1./u;
for j=1:numel(conv_term)
    for i=1:numel(num_cells_intro)
        geo_test10;
        model_test10;
        mesh_test10;
        
        pat{j}{i,1}=mfvl_pat(m{i},domain,mod,bound,'CD','I');
        pat{j}{i,2}=mfvl_pat(m{i},domain,mod,bound,'UW','I');
    end
end
% work files
save('output\test10_results.mat');