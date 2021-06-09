% January, 2017
% test4 processing - PRO
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

num_cells=[20 30 40];
flux_num=2;
degree=[1 2 3 4 5];
type={'II'};
weight1=3;
weight2=1;
scheme='cdr';
auto_stencil_opt='user';
stencil_size(1,:)=[2 4 4 6 6];
stencil_size(2,:)=zeros([1 numel(degree)]);%mean_value stencil
stencil_size(3,:)=zeros([1 numel(degree)]);% point_value stencil size
stencil_size(4,:)=zeros([1 numel(degree)]);% none stencil size

global a_matrix;
global stencil_matrix;
global consts_matrix;
global a_matrix_none;
global stencil_matrix_none;
save('output/requisites.mat','num_cells','degree','weight1','weight2','flux_num','stencil_size','auto_stencil_opt','type');
if ~exist('output/meshes_uniform','dir') || ~exist('output/domains','dir')
    for k=1:numel(num_cells)
        if ~exist('output/meshes_uniform', 'dir')
            mkdir('output/meshes');
        end
        if ~exist('output/domains', 'dir')
            mkdir('output/domains');
        end
        file_name=['nc' num2str(num_cells(k))];
        geo_test4;
        mesh_test4;
        file_name_mesh=['output/meshes_uniform/' file_name '_mesh.mat'];
        save(file_name_mesh,'mesh');
        file_name_domain=['output/domains/' file_name '_domain.mat'];
        save(file_name_domain,'domain');
    end
end
for j=1:numel(type)
    prob_type=type{j};
    for d=1:numel(degree)
        for f=1:numel(flux_num)
            if (flux_num(f)==1)
                flux='pro1';
            else
                flux='pro2';
            end
            for k=1:numel(num_cells)
                a_matrix=cell([1 num_cells(k)+2]);
                a_matrix_none=cell([1 num_cells(k)-1]);
                stencil_matrix_none=cell([1 num_cells(k)-1]);
                stencil_matrix=cell([1 num_cells(k)+2]);
                consts_matrix=cell([1 num_cells(k)]);
                load(['output/meshes_uniform/nc' num2str(num_cells(k)) '_mesh.mat']);
                load(['output/domains/nc' num2str(num_cells(k)) '_domain.mat']);
                        
                %domain.point(2).coord=domain.point(2).coord+(1/num_cells(k))/2;
                model_test4;
                
                disp([d f k]);
                file_name=['nc' num2str(num_cells(k)) '_deg' num2str(degree(d)) '_wei1' num2str(weight1) num2str(weight2) '_' flux];
                if ~exist(['output/' file_name], 'dir')
                    mkdir('output/',file_name);
                end
                file_name_model=['output/' file_name '/model.mat'];
                file_name_pro=['output/' file_name '/pro.mat'];
                file_name_sol=['output/' file_name '/sol.dat'];
                
                save(file_name_model,'mod');
                
                pro{j}{d}{k,f}=mfvl_pro_cdr_4(mesh,domain,mod,degree(d),flux,[weight1 weight2],stencil_size(:,d),auto_stencil_opt);
                
                pro_s=pro{j}{d}{k,f};
                sol=pro{j}{d}{k,f}.u_approx;
                save(file_name_pro,'pro_s');
                save(file_name_sol,'sol','-ascii','-double');
            end
        end
    end
end

% work files
