% January, 2017
% test processing - PRO
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
mfvl_lib;

num_cells=[20 40 80 160];
flux_num=1;
degree=[3 5 7];
weight1=3;
weight2=3;
scheme='bending';
stencil_size=[4 6 8];
force=1;
auto_stencil_opt='user';

for d=1:numel(degree)
    for f=1:numel(flux_num)
        if (flux_num(f)==1)
            flux='pro1';
        else
            flux='pro2';
        end
        for k=1:numel(num_cells)
            geo_test_01_23_test7;
            model_test_01_23_test7;
            mesh_test_01_23_test7;
            disp([d f k]);  
 
            pro{d}{k,f}=mfvl_pro(m{k},domain,mod,degree(d),flux,[weight1 weight2],scheme,stencil_size(d),force,auto_stencil_opt);
        end
    end
end

% work files
save('output\test_pro_bending_01_23_test7_results.mat');
load gong.mat;
sound(y);