% December, 2016
% test 15 processing
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
conv_term={@(x)0.*x+1 @(x)0.*x+10 @(x)0.*x+40 @(x)0.*x+100};
u=[1 10 40 100];

num_cells_intro=4;%[10 20 30 40];
conv_term={@(x)0.*x-100 @(x)0.*x-1 @(x)0.*x+1 @(x)0.*x+100};
u=[-100 -1 1 100];

Pe=u./1;
for j=1:numel(conv_term)
    for i=1:numel(num_cells_intro)
        geo_test15;
        model_test15;
        mesh_test15;
    
        pat{j}{i,1}=mfvl_pat(m{i},domain,mod,'CD')
%         pat{j}{i,2}=mfvl_pat(m{i},domain,mod,'UW');
    end
end
% work files
save('output\test15_results.mat');