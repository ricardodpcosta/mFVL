% January, 2017
% class for mfvl_pro_bending_new
classdef mfvl_pro_bending_new<handle
    properties (Access=public)
        mesh
        domain
        model
        weight
        flux_scheme
        pro_scheme
        degree
        u_approx
    end
    methods
        function pro=mfvl_pro_bending_new(mesh,domain,model,degree,weight,stencil_size,force,auto_stencil_opt,pro_scheme,flux_scheme)
            pro.mesh=mesh;
            pro.domain=domain;
            pro.model=model;
            pro.degree=degree;
            pro.weight=weight;
            pro.pro_scheme=pro_scheme;
            pro.flux_scheme=flux_scheme;
            pro.u_approx=solver(pro,degree,weight,stencil_size,force,auto_stencil_opt);
        end
        
        
        
        
        % make_flux
        function tau = make_flux(pro,rec_point,rec_none,force)
            global mfvl_bound_cond_type23;
            num_cells=pro.mesh.get_num_cells;
            vertices_coordinates=pro.mesh.get_vertex_point_all;
            tau=zeros([1 pro.mesh.get_num_vertices]);
            
            ei=pro.model.get_material(1).get_ei;
            switch (pro.flux_scheme)
                case 'pro1'
                    tau(1)=ei*rec_point{1}.eval_deriv(vertices_coordinates(1),3);
                    for i=2:num_cells
                        tau(i)=ei*(rec_point{i}.eval_deriv(vertices_coordinates(i),3)+rec_point{i+1}.eval_deriv(vertices_coordinates(i),3))/2;
                    end
                    if pro.model.get_bound_cond(2).get_type==mfvl_bound_cond_type23
                        tau(num_cells+1)=-force;
                    else
                        tau(num_cells+1)=ei*rec_point{num_cells+2}.eval_deriv(vertices_coordinates(num_cells+1),3);
                    end
                case 'pro2'
                    tau(1)=ei*rec_point{1}.eval_deriv(vertices_coordinates(1),3);
                    for i=2:num_cells
                        tau(i)=ei*rec_none{i-1}.eval_deriv(vertices_coordinates(i),3);
                    end
                    if pro.model.get_bound_cond(2).get_type==mfvl_bound_cond_type23
                        tau(num_cells+1)=-force;
                    else
                        tau(num_cells+1)=ei*rec_point{num_cells+2}.eval_deriv(vertices_coordinates(num_cells+1),3);
                    end
                otherwise
                    error('Error :: Invalid Scheme. mfvl_pro - make_flux');
            end
        end
        
        
        
        
        % make_data
        function [rec_point,rec_none]=make_data(pro,degree,weight,cells_data,vertex_data,stencil_size,auto_stencil_opt)
            if strcmp(pro.flux_scheme,'pro2')==1
                rec_none=make_none_bending(pro,degree,weight,cells_data,stencil_size,auto_stencil_opt);
            else
                rec_none=0;
            end
            rec_point=make_point_value_bending(pro,degree,weight,cells_data,vertex_data,stencil_size,auto_stencil_opt);
        end
        
        
        
        
        
        function rec=make_none_bending(pro,degree,weight,cells_data,stencil_size,auto_stencil_opt)
            global a_matrix_none;
            global stencil_matrix_none;
            global mfvl_bound_cond_type01;
            global mfvl_bound_cond_type02;
            x_bar=0; % attention
            psi_bar=0;
            num_vertices=pro.mesh.get_num_vertices;
            target_type='vertex';
            lsm_weight=weight;
            num_lsm_weights=2;
            conservation='none';
            stencil_size_factor=1.5;
            rec=cell(1,num_vertices-2);
            vertex_data=0;
            for i=2:num_vertices-1
                if isempty(a_matrix_none{i-1})==1
                    a_matrix_value=[];
                else
                    a_matrix_value=a_matrix_none{i-1};
                end
                if isempty(stencil_matrix_none{i-1})==1
                    stencil=[];
                else
                    stencil=stencil_matrix_none{i-1};
                end
                ref_index=i;
                if (i==2)
                    if pro.model.bound_cond(1).get_type==mfvl_bound_cond_type01
                        conservation='none_der1';
                        x_bar=pro.get_model.get_bound_cond(1).get_physical.get_point(1).get_coord;
                        psi_bar=pro.get_model.get_bound_cond(1).get_value(2);
                    elseif pro.model.bound_cond(1).get_type==mfvl_bound_cond_type02
                        conservation='none_der2';
                        x_bar=pro.get_model.get_bound_cond(1).get_physical.get_point(1).get_coord;
                        psi_bar=pro.get_model.get_bound_cond(1).get_value(2)/(-pro.model.material.get_ei);
                    end
                elseif (i==num_vertices-1)
                    if pro.model.bound_cond(2).get_type==mfvl_bound_cond_type01
                        conservation='none_der1';
                        x_bar=pro.get_model.get_bound_cond(2).get_physical.get_point(1).get_coord;
                        psi_bar=pro.get_model.get_bound_cond(2).get_value(2);
                    elseif pro.model.bound_cond(1).get_type==mfvl_bound_cond_type02
                        conservation='none_der2';
                        x_bar=pro.get_model.get_bound_cond(2).get_physical.get_point(1).get_coord;
                        psi_bar=pro.get_model.get_bound_cond(2).get_value(2)/(-pro.model.material.get_ei);
                    end
                else
                    conservation='none';
                    x_bar=0;
                    psi_bar=0;
                end
                rec{i-1}=mfvl_reconst1d(pro.mesh,...
                    target_type,lsm_weight,...
                    degree,conservation,num_lsm_weights,cells_data,vertex_data,ref_index,stencil_size_factor,x_bar,psi_bar,stencil_size,auto_stencil_opt,pro.pro_scheme,...
                    a_matrix_value,stencil);
                
                if isempty(a_matrix_none{i-1})==1
                    a_matrix_none{i-1}=rec{i-1}.get_lsm_lhs;
                end
                if isempty(stencil_matrix_none{i-1})==1
                    stencil_matrix_none{i-1}=rec{i-1}.get_stencil;
                end
            end
            
        end
        
        
        
        
        % make_point_value_bending reconstructions
        function rec=make_point_value_bending(pro,degree,weight,cells_data,vertex_data,stencil_size,auto_stencil_opt)
            global mfvl_bound_cond_type01;
            global mfvl_bound_cond_type02;
            global mfvl_bound_cond_type23;
            global a_matrix;
            global stencil_matrix;
            
            x_bar=pro.get_model.get_bound_cond(1).get_physical.get_point(1).get_coord;
            psi_bar=pro.get_model.get_bound_cond(1).get_value(1);
            target_type='vertex';
            lsm_weight=weight;
            num_lsm_weights=2;
            conservation='point_value';
            stencil_size_factor=1.5;
            
            num_cells=pro.mesh.get_num_cells;
            num_vertices=pro.mesh.get_num_vertices;
            
            rec=cell(num_vertices+1,1);
            % point value conservation for the 1st vertex
            if isempty(a_matrix{1})==1
                a_matrix_value=[];
            else
                a_matrix_value=a_matrix{1};
            end
            if isempty(stencil_matrix{1})==1
                stencil=[];
            else
                stencil=stencil_matrix{1};
            end
            rec{1}=mfvl_reconst1d(pro.mesh,...
                target_type,lsm_weight,...
                degree,conservation,num_lsm_weights,cells_data,vertex_data,1,stencil_size_factor,x_bar,psi_bar,stencil_size,auto_stencil_opt,pro.pro_scheme,...
                a_matrix_value,stencil);
            if isempty(a_matrix{1})==1
                a_matrix{1}=rec{1}.get_lsm_lhs;
            end
            if isempty(stencil_matrix{1})==1
                stencil_matrix{1}=rec{1}.get_stencil;
            end
            % der1 or der2 conservation for the first cell
            target_type='cell';
            if pro.model.bound_cond(1).get_type==mfvl_bound_cond_type01
                conservation='mean_value_der1';
                x_bar=pro.get_model.get_bound_cond(1).get_physical.get_point(1).get_coord;
                psi_bar=pro.get_model.get_bound_cond(1).get_value(2);
                if strcmp(pro.pro_scheme,'pro2')==1
                    degree_rec=degree;
                end
                if strcmp(pro.pro_scheme,'pro4')==1
                    degree_rec=degree+1;
                end
            end
            if pro.model.bound_cond(1).get_type==mfvl_bound_cond_type02
                conservation='mean_value_der2';
                x_bar=pro.get_model.get_bound_cond(1).get_physical.get_point(1).get_coord;
                psi_bar=pro.get_model.get_bound_cond(1).get_value(2)/(-pro.model.material.get_ei);
                if strcmp(pro.pro_scheme,'pro2')==1
                    degree_rec=degree+1;
                end
                if strcmp(pro.pro_scheme,'pro4')==1
                    degree_rec=degree+2;
                end
            end
            
            
            
            
            
            
            if (pro.model.bound_cond(1).get_type==mfvl_bound_cond_type01 && pro.model.bound_cond(2).get_type==mfvl_bound_cond_type23)
                conservation='mean_value_der1';
                x_bar=pro.get_model.get_bound_cond(1).get_physical.get_point(1).get_coord;
                psi_bar=pro.get_model.get_bound_cond(1).get_value(2);
                if strcmp(pro.pro_scheme,'pro2')==1
                    degree_rec=degree;
                end
                if strcmp(pro.pro_scheme,'pro4')==1
                    degree_rec=degree+1;
                end
            end
            
            
            
            
            
            
            
            if isempty(a_matrix{2})==1
                a_matrix_value=[];
            else
                a_matrix_value=a_matrix{2};
            end
            if isempty(stencil_matrix{2})==1
                stencil=[];
            else
                stencil=stencil_matrix{2};
            end
            ref_index=1;
            rec{2}=mfvl_reconst1d(pro.mesh,...
                target_type,lsm_weight,...
                degree_rec,conservation,num_lsm_weights,cells_data,vertex_data,ref_index,stencil_size_factor,x_bar,psi_bar,stencil_size,auto_stencil_opt,pro.pro_scheme,...
                a_matrix_value,stencil);
            if isempty(a_matrix{2})==1
                a_matrix{2}=rec{2}.get_lsm_lhs;
            end
            if isempty(stencil_matrix{2})==1
                stencil_matrix{2}=rec{2}.get_stencil;
            end
            
            
            
            
            % normal mean value conservation
            conservation='mean_value';
            x_bar=0;
            psi_bar=0;
            
            for i=3:num_cells
                if isempty(a_matrix{i})==1
                    a_matrix_value=[];
                else
                    a_matrix_value=a_matrix{i};
                end
                if isempty(stencil_matrix{i})==1
                    stencil=[];
                else
                    stencil=stencil_matrix{i};
                end
                ref_index=i-1;
                rec{i}=mfvl_reconst1d(pro.mesh,...
                    target_type,lsm_weight,...
                    degree,conservation,num_lsm_weights,cells_data,vertex_data,ref_index,stencil_size_factor,x_bar,psi_bar,stencil_size,auto_stencil_opt,pro.pro_scheme,...
                    a_matrix_value,stencil);
                
                if isempty(a_matrix{i})==1
                    a_matrix{i}=rec{i}.get_lsm_lhs;
                end
                if isempty(stencil_matrix{i})==1
                    stencil_matrix{i}=rec{i}.get_stencil;
                end
            end
            
            % der1 or der2 conservation for the last cell
            switch pro.model.bound_cond(2).get_type
                case mfvl_bound_cond_type01
                    conservation='mean_value_der1';
                    x_bar=pro.get_model.get_bound_cond(2).get_physical.get_point(1).get_coord;
                    psi_bar=pro.get_model.get_bound_cond(2).get_value(2);
                    if strcmp(pro.pro_scheme,'pro2')==1
                        degree_rec=degree;
                    end
                    if strcmp(pro.pro_scheme,'pro4')==1
                        degree_rec=degree+1;
                    end
                    %%%
                case mfvl_bound_cond_type02
                    conservation='mean_value_der2';
                    x_bar=pro.get_model.get_bound_cond(2).get_physical.get_point(1).get_coord;
                    psi_bar=pro.get_model.get_bound_cond(2).get_value(2)/(-pro.model.material.get_ei);
                    if strcmp(pro.pro_scheme,'pro2')==1
                        degree_rec=degree;
                    end
                    if strcmp(pro.pro_scheme,'pro4')==1
                        degree_rec=degree+2;
                    end
                    %%%
                case mfvl_bound_cond_type23
                    conservation='mean_value_der3';
                    x_bar=pro.get_model.get_bound_cond(2).get_physical.get_point(1).get_coord;
                    psi_bar=pro.get_model.get_bound_cond(2).get_value(2)/(-pro.model.material.get_ei);
                    if strcmp(pro.pro_scheme,'pro2')==1
                        degree_rec=degree;
                    end
                    if strcmp(pro.pro_scheme,'pro4')==1
                        degree_rec=degree+3;
                    end
            end
            if isempty(a_matrix{num_cells+1})==1
                a_matrix_value=[];
            else
                a_matrix_value=a_matrix{num_cells+1};
            end
            if isempty(stencil_matrix{num_cells+1})==1
                stencil=[];
            else
                stencil=stencil_matrix{num_cells+1};
            end
            ref_index=num_cells;
            rec{num_cells+1}=mfvl_reconst1d(pro.mesh,...
                target_type,lsm_weight,...
                degree_rec,conservation,num_lsm_weights,cells_data,vertex_data,ref_index,stencil_size_factor,x_bar,psi_bar,stencil_size,auto_stencil_opt,pro.pro_scheme,...
                a_matrix_value,stencil);
            if isempty(a_matrix{num_cells+1})==1
                a_matrix{num_cells+1}=rec{num_cells+1}.get_lsm_lhs;
            end
            if isempty(stencil_matrix{num_cells+1})==1
                stencil_matrix{num_cells+1}=rec{num_cells+1}.get_stencil;
            end
            
            
            
            
            
            % point value conservation for the last vertex
            if isempty(a_matrix{num_cells+2})==1
                a_matrix_value=[];
            else
                a_matrix_value=a_matrix{num_cells+2};
            end
            if isempty(stencil_matrix{num_cells+2})==1
                stencil=[];
            else
                stencil=stencil_matrix{num_cells+2};
            end
            
            
            
            
            conservation='point_value';
            target_type='vertex';
            x_bar=pro.get_model.get_bound_cond(2).get_physical.get_point(1).get_coord;
            psi_bar=pro.get_model.get_bound_cond(2).get_value(1);
            rec{num_cells+2}=mfvl_reconst1d(pro.mesh,...
                target_type,lsm_weight,...
                degree,conservation,num_lsm_weights,cells_data,vertex_data,num_vertices,stencil_size_factor,x_bar,psi_bar,stencil_size,auto_stencil_opt,pro.pro_scheme,...
                a_matrix_value,stencil);
            if isempty(a_matrix{num_cells+2})==1
                a_matrix{num_cells+2}=rec{num_cells+2}.get_lsm_lhs;
            end
            if isempty(stencil_matrix{num_cells+2})==1
                stencil_matrix{num_cells+2}=rec{num_cells+2}.get_stencil;
            end
        end
        
        
        % make_residual
        function res= make_residual(pro,degree,weight,cells_data,stencil_size,force,auto_stencil_opt,S,vertex_data)
            num_cells=pro.mesh.get_num_cells;
            [rec_point,rec_none]=make_data(pro,degree,weight,cells_data,vertex_data,stencil_size,auto_stencil_opt);
            
            tau=make_flux(pro,rec_point,rec_none,force);
            res=-tau(2:num_cells+1)+tau(1:num_cells)-S;
            
            res=res';
        end
        
        
        
        
        
        % solver
        function [res,cons_sol]=solver(pro,degree,weight,stencil_size,force,auto_stencil_opt)
            global mfvl_bound_cond_type01;
            global mfvl_bound_cond_type02;
            num_cells=pro.mesh.get_num_cells;
            if pro.model.bound_cond(1).get_type==mfvl_bound_cond_type01 ||...
                    pro.model.bound_cond(1).get_type==mfvl_bound_cond_type02
                left_bound=pro.model.get_bound_cond(1).get_value(1); % attention
            else
                left_bound=0; % attention
            end
            if pro.model.bound_cond(2).get_type==mfvl_bound_cond_type01 ||...
                    pro.model.bound_cond(2).get_type==mfvl_bound_cond_type02
                right_bound=pro.model.get_bound_cond(2).get_value(1); % attention
            else
                right_bound=0; % attention
            end
            
            vertex_data=[left_bound zeros([1 (num_cells-1)]) right_bound]; % i dont know if this is correct
            
            source_term=pro.model.get_source_term(1).get_value; % attention
            h=pro.mesh.get_cell_length_all;
            S=pro.mesh.eval_mean_value_cells(source_term).*h;
            
            cells_data=zeros([1 num_cells]);
            B=-make_residual(pro,degree,weight,cells_data,stencil_size,force,auto_stencil_opt,S,vertex_data);
            
            %x0=mfvl_f_of_x(pro.mesh.get_left_bound,pro.mesh.get_right_bound,...
            %  left_bound,right_bound,...
            %linspace(pro.mesh.get_left_bound,pro.mesh.get_right_bound,num_cells));
            epsilon=1e-12;
            mm=eye(num_cells);
            
            max_iter=num_cells;
            [res,flag,relres,iter,resvec]=gmres(@(xx)make_residual(pro,degree,weight,xx,stencil_size,force,auto_stencil_opt,S,vertex_data)+B,B,...
                num_cells,epsilon,max_iter,[],[]);
        end
        % getters
        function res=get_model(pro)
            res=pro.model;
        end
    end
end
