% January, 2017
% class for mfvl_pro
classdef mfvl_pro<handle
    properties (Access=public)
        mesh
        domain
        model
        weight
        simulation_scheme
        pro_scheme
        degree
        rec %%% incluir
        flux
        u_approx
    end
    methods
        function pro=mfvl_pro(mesh,domain,model,degree,flux,weight,simulation_scheme,stencil_size,force,auto_stencil_opt,pro_scheme)
            global mfvl_bending_scheme;
            global mfvl_cdr_scheme;
            pro.mesh=mesh;
            pro.domain=domain;
            pro.model=model;
            pro.degree=degree;
            pro.weight=weight;
            pro.pro_scheme=pro_scheme;
            switch simulation_scheme
                case 'cdr'
                    pro.simulation_scheme=mfvl_cdr_scheme;
                    a=model.get_material(1).thermal_conductivity;
                    r=model.get_reaction;
                    v=model.get_velocity;
                case 'bending'
                    pro.simulation_scheme=mfvl_bending_scheme;
                    a=model.get_material(1).thermal_conductivity;
                    r=@(x)0.*x; % check this
                    v=@(x)0.*x; % check this
                otherwise
                    error('Error: mfvl_pro. Invalid scheme.');
            end
            pro.flux=flux; %pro1 or pro2
            pro.u_approx=solver(pro,degree,weight,a,v,r,stencil_size,force,auto_stencil_opt);
        end
        
        
        
        
        
        % make_flux
        function [f_diff,f_conv] = make_flux(pro,rec_point,rec_none,pro_scheme,a,v,force)
            global mfvl_bending_scheme;
            global mfvl_cdr_scheme;
            global mfvl_bound_cond_type23;
            num_cells=pro.mesh.get_num_cells;
            vertices_coordinates=pro.mesh.get_vertex_point_all;
            f_diff=zeros([1 pro.mesh.get_num_vertices]);
            f_conv=zeros([1 pro.mesh.get_num_vertices]);
            switch pro.simulation_scheme
                case mfvl_cdr_scheme
                    a=a(vertices_coordinates);
                    v=v(vertices_coordinates);
                    switch pro.pro_scheme
                        case 'pro1'
                            f_diff(1)=a(1)*rec_point{1}.eval_deriv(vertices_coordinates(1),1);
                            for i=2:num_cells
                                f_diff(i)=a(i)*(rec_point{i}.eval_deriv(vertices_coordinates(i),1)+rec_point{i+1}.eval_deriv(vertices_coordinates(i),1))/(2);
                            end
                            f_diff(num_cells+1)=a(num_cells+1)*rec_point{num_cells+2}.eval_deriv(vertices_coordinates(num_cells+1),1);
                            for i=1:num_cells+1
                                f_conv(i)=max(0,v(i))*rec_point{i}.eval_value(vertices_coordinates(i))+min(0,v(i))*rec_point{i+1}.eval_value(vertices_coordinates(i));
                            end
                        case 'pro2'
                            f_diff(1)=a(1)*rec_point{1}.eval_deriv(vertices_coordinates(1),1);
                            for i=2:num_cells
                                f_diff(i)=a(i)*rec_none{i-1}.eval_deriv(vertices_coordinates(i),1);
                            end
                            f_diff(num_cells+1)=a(num_cells+1)*rec_point{num_cells+2}.eval_deriv(vertices_coordinates(num_cells+1),1);
                            for i=1:num_cells+1
                                f_conv(i)=max(0,v(i))*rec_point{i}.eval_value(vertices_coordinates(i))+min(0,v(i))*rec_point{i+1}.eval_value(vertices_coordinates(i));
                            end
                        otherwise
                            error('Error :: Invalid Scheme. mfvl_pro - make_flux');
                    end
                case mfvl_bending_scheme
                    % in this, f_diff is tau
                    ei=pro.model.get_material(1).get_ei;
                    switch (pro.pro_scheme)
                        case 'pro1'
                            f_diff(1)=ei*rec_point{1}.eval_deriv(vertices_coordinates(1),3);
                            for i=2:num_cells
                                f_diff(i)=ei*(rec_point{i}.eval_deriv(vertices_coordinates(i),3)+rec_point{i+1}.eval_deriv(vertices_coordinates(i),3))/(2);
                            end
                            if pro.model.get_bound_cond(2).get_type==mfvl_bound_cond_type23
                                f_diff(num_cells+1)=-force;
                            else
                                f_diff(num_cells+1)=ei*rec_point{num_cells+2}.eval_deriv(vertices_coordinates(num_cells+1),3);
                            end
                        case 'pro2'
                            f_diff(1)=ei*rec_point{1}.eval_deriv(vertices_coordinates(1),3);
                            for i=2:num_cells
                                f_diff(i)=ei*rec_none{i-1}.eval_deriv(vertices_coordinates(i),3);
                            end
                            if pro.model.get_bound_cond(2).get_type==mfvl_bound_cond_type23
                                f_diff(num_cells+1)=-force;
                            else
                                f_diff(num_cells+1)=ei*rec_point{num_cells+2}.eval_deriv(vertices_coordinates(num_cells+1),3);
                            end
                        otherwise
                            error('Error :: Invalid Scheme. mfvl_pro - make_flux');
                    end
                    f_conv=0;
                otherwise
                    error('Error: invalid scheme. mfvl_pro - make_flux.');
            end
        end
        
        
        
        
        % make_data
        function [rec_point,rec_none]=make_data(pro,degree,weight,cells_data,vertex_data,stencil_size,auto_stencil_opt)
            global mfvl_bending_scheme;
            global mfvl_cdr_scheme;
            switch pro.simulation_scheme
                case mfvl_cdr_scheme
                    rec_none=make_none(pro,degree,weight,cells_data,stencil_size,auto_stencil_opt);
                    rec_point=make_point_value(pro,degree,weight,cells_data,vertex_data,stencil_size,auto_stencil_opt);
                case mfvl_bending_scheme
                    rec_none=0;%make_none_bending(pro,mesh,degree,weight,cells_data,stencil_size,auto_stencil_opt);
                    rec_point=make_point_value_bending(pro,degree,weight,cells_data,vertex_data,stencil_size,auto_stencil_opt);
                otherwise
                    error('Error: invalid scheme. mfvl_pro - make_data.');
            end
        end
        
        
        
        
        
        % make_none reconstructions
        function rec=make_none(pro,mesh,degree,weight,cells_data,stencil_size,auto_stencil_opt)
            stencil_size_matrix=stencil_size;
            % to change the stencil_size
            if stencil_size_matrix(4)==0
                stencil_size=stencil_size_matrix(1);
            else
                stencil_size=stencil_size_matrix(4);
            end
            x_bars=0;
            psi_bars=0;
            num_vertices=mesh.get_num_vertices;
            target_type='vertex';
            lsm_weight=weight;
            num_lsm_weights=2;
            conservation='none';
            stencil_size_factor=1.5;%1;
            rec=cell(max(num_vertices)-2,numel(num_vertices));
            for k=1:numel(num_vertices)
                vertex_data=0;
                for i=2:num_vertices(k)-1
                    ref_index=i;
                    rec{i-1,k}=mfvl_reconst1d(pro,mesh,target_type,...
                        lsm_weight,degree,...
                        conservation,num_lsm_weights,...
                        cells_data,vertex_data,...
                        ref_index,stencil_size_factor,x_bars,psi_bars,stencil_size,auto_stencil_opt);
                end
            end
        end
        % make_none_bending reconstructions
        
        function rec=make_none_bending(pro,mesh,degree,weight,cells_data,stencil_size,auto_stencil_opt)
            x_bars=0; % attention
            psi_bars=0;
            num_vertices=mesh.get_num_vertices;
            target_type='vertex';
            lsm_weight=weight;
            num_lsm_weights=2;
            conservation='none';
            stencil_size_factor=1.5;
            rec=cell(max(num_vertices)-2,numel(num_vertices));
            for k=1:numel(num_vertices)
                vertex_data=0;
                for i=2:num_vertices(k)-1
                    ref_index=i;
                    rec{i-1,k}=mfvl_reconst1d(pro,mesh,target_type,...
                        lsm_weight,degree,...
                        conservation,num_lsm_weights,...
                        cells_data,vertex_data,...
                        ref_index,stencil_size_factor,x_bars,psi_bars,stencil_size,auto_stencil_opt);
                end
            end
        end
        
        
        
        
        % make_point_value reconstructions
        function rec=make_point_value(pro,mesh,degree,weight,cells_data,vertex_data,stencil_size,auto_stencil_opt)
            stencil_size_matrix=stencil_size;
            % to change the stencil_size
            if stencil_size_matrix(3)==0
               stencil_size=stencil_size_matrix(1);
            else
                stencil_size=stencil_size_matrix(3);
            end
            x_bars=0;
            psi_bars=0;
            target_type='vertex';
            lsm_weight=weight;
            num_lsm_weights=2;
            conservation='point_value';
            stencil_size_factor=1.5;
            
            num_cells=mesh.get_num_cells;
            num_vertices=mesh.get_num_vertices;
            rec=cell(max(num_vertices)+1,numel(num_vertices));
            for k=1:numel(num_cells)
                rec{1,k}=mfvl_reconst1d(pro,mesh,...
                    target_type,lsm_weight,...
                    degree,conservation,num_lsm_weights,cells_data,vertex_data,1,stencil_size_factor,x_bars,psi_bars,stencil_size,auto_stencil_opt);
                conservation='mean_value';
                target_type='cell';
                % to change the stencil_size
                if stencil_size_matrix(2)==0
                    stencil_size=stencil_size_matrix(1);
                else
                    stencil_size=stencil_size_matrix(2);
                end
                x=2;
                for i=1:num_cells(k)
                    ref_index=i;
                    rec{x,k}=mfvl_reconst1d(pro,mesh,...
                        target_type,lsm_weight,...
                        degree,conservation,num_lsm_weights,cells_data,vertex_data,ref_index,stencil_size_factor,x_bars,psi_bars,stencil_size,auto_stencil_opt);
                    x=x+1;
                end
                % to change the stencil_size
                if stencil_size_matrix(3)==0
                    stencil_size=stencil_size_matrix(1);
                else
                    stencil_size=stencil_size_matrix(3);
                end
                conservation='point_value';
                target_type='vertex';
                rec{x,k}=mfvl_reconst1d(pro,mesh,...
                    target_type,lsm_weight,...
                    degree,conservation,num_lsm_weights,cells_data,vertex_data,num_vertices(k),stencil_size_factor,x_bars,psi_bars,stencil_size,auto_stencil_opt);
            end
        end
        % make_point_value_bending reconstructions
        function rec=make_point_value_bending(pro,degree,weight,cells_data,vertex_data,stencil_size,auto_stencil_opt)
            global mfvl_bound_cond_type01;
            global mfvl_bound_cond_type02;
            global mfvl_bound_cond_type23;
            x_bar=0;
            psi_bar=0;
            target_type='vertex';
            lsm_weight=weight;
            num_lsm_weights=2;
            conservation='point_value';
            stencil_size_factor=1.5;
            
            num_cells=pro.mesh.get_num_cells;
            num_vertices=pro.mesh.get_num_vertices;

            rec=cell(num_vertices+1,1);
            % point value conservation for the 1st vertex
            rec{1}=mfvl_reconst1d(pro.mesh,...
                    target_type,lsm_weight,...
                    degree,conservation,num_lsm_weights,cells_data,vertex_data,1,stencil_size_factor,x_bar,psi_bar,stencil_size,auto_stencil_opt,pro.pro_scheme);
                % der1 or der2 conservation for the first cell
                target_type='cell';
                if pro.model.bound_cond(1).get_type==mfvl_bound_cond_type01
                    conservation='mean_value_der1';
                    x_bar=pro.get_model.get_bound_cond(1).get_physical.get_point(1).get_coord;
                    psi_bar=pro.get_model.get_bound_cond(1).get_value(2);
                    if strcmp(pro.pro_scheme,'pro1')==1
                        degree_rec=degree;
                    end
                    if strcmp(pro.pro_scheme,'pro2')==1
                        degree_rec=degree;
                    end
                    if strcmp(pro.pro_scheme,'pro3')==1
                        degree_rec=degree+1;
                    end
                end
                if pro.model.bound_cond(1).get_type==mfvl_bound_cond_type02
                    conservation='mean_value_der2';
                    x_bar=pro.get_model.get_bound_cond(1).get_physical.get_point(1).get_coord;
                    psi_bar=pro.get_model.get_bound_cond(1).get_value(2)/(-pro.model.material.get_ei);
                    if strcmp(pro.pro_scheme,'pro1')==1
                        degree_rec=degree;
                    end
                    if strcmp(pro.pro_scheme,'pro2')==1
                        degree_rec=degree;
                    end
                    if strcmp(pro.pro_scheme,'pro3')==1
                        degree_rec=degree+2;
                    end
                end
                ref_index=1;
                rec{2}=mfvl_reconst1d(pro.mesh,...
                        target_type,lsm_weight,...
                        degree_rec,conservation,num_lsm_weights,cells_data,vertex_data,ref_index,stencil_size_factor,x_bar,psi_bar,stencil_size,auto_stencil_opt,pro.pro_scheme);
                
                % normal mean value conservation
                conservation='mean_value';
                x_bar=0;
                psi_bar=0;
                for i=3:num_cells
                    ref_index=i-1;
                    rec{i}=mfvl_reconst1d(pro.mesh,...
                        target_type,lsm_weight,...
                        degree,conservation,num_lsm_weights,cells_data,vertex_data,ref_index,stencil_size_factor,x_bar,psi_bar,stencil_size,auto_stencil_opt,pro.pro_scheme);
                end
                
                % der1 or der2 conservation for the last cell
                if pro.model.bound_cond(2).get_type==mfvl_bound_cond_type01
                    conservation='mean_value_der1';
                    x_bar=pro.get_model.get_bound_cond(2).get_physical.get_point(1).get_coord;
                    psi_bar=pro.get_model.get_bound_cond(2).get_value(2);
                    if strcmp(pro.pro_scheme,'pro1')==1
                        degree_rec=degree;
                    end
                    if strcmp(pro.pro_scheme,'pro2')==1
                        degree_rec=degree;
                    end
                    if strcmp(pro.pro_scheme,'pro3')==1
                        degree_rec=degree+1;
                    end
                end
                if pro.model.bound_cond(2).get_type==mfvl_bound_cond_type02
                    conservation='mean_value_der2';
                    x_bar=pro.get_model.get_bound_cond(2).get_physical.get_point(1).get_coord;
                    psi_bar=pro.get_model.get_bound_cond(2).get_value(2)/(-pro.model.material.get_ei);
                    if strcmp(pro.pro_scheme,'pro1')==1
                        degree_rec=degree;
                    end
                    if strcmp(pro.pro_scheme,'pro2')==1
                        degree_rec=degree;
                    end
                    if strcmp(pro.pro_scheme,'pro3')==1
                        degree_rec=degree+2;
                    end
                end
                if pro.model.bound_cond(2).get_type==mfvl_bound_cond_type23
                    conservation='mean_value_der2';
                    x_bar=pro.get_model.get_bound_cond(2).get_physical.get_point(1).get_coord;
                    psi_bar=pro.get_model.get_bound_cond(2).get_value(1)/(-pro.model.material.get_ei);
                    if strcmp(pro.pro_scheme,'pro1')==1
                        degree_rec=degree;
                    end
                    if strcmp(pro.pro_scheme,'pro2')==1
                        degree_rec=degree;
                    end
                    if strcmp(pro.pro_scheme,'pro3')==1
                        degree_rec=degree+3;
                    end
                end
                
                
                ref_index=num_cells;
                rec{num_cells+1}=mfvl_reconst1d(pro.mesh,...
                    target_type,lsm_weight,...
                    degree_rec,conservation,num_lsm_weights,cells_data,vertex_data,ref_index,stencil_size_factor,x_bar,psi_bar,stencil_size,auto_stencil_opt,pro.pro_scheme);
                % point value conservation for the last vertex
                conservation='point_value';
                target_type='vertex';
                x_bar=0;
                psi_bar=0;
                rec{num_cells+2}=mfvl_reconst1d(pro.mesh,...
                    target_type,lsm_weight,...
                    degree,conservation,num_lsm_weights,cells_data,vertex_data,num_vertices,stencil_size_factor,x_bar,psi_bar,stencil_size,auto_stencil_opt,pro.pro_scheme);
        end
        % make_residual
        function res= make_residual(pro,degree,weight,U,a,v,r,stencil_size,force,auto_stencil_opt)
            global mfvl_bending_scheme;
            global mfvl_cdr_scheme;
            global mfvl_bound_cond_type01;
            global mfvl_bound_cond_type02;
            num_cells=pro.mesh.get_num_cells;
            switch pro.simulation_scheme
                case mfvl_cdr_scheme
                    left_bound=pro.mesh.model.get_bound_cond(1).get_value(1); % attention
                    right_bound=pro.model.get_bound_cond(2).get_value(1); % attention
                    source_term=pro.model.get_source_term(1).get_value; % attention
                    vertex_data=[left_bound zeros([1 (num_cells-1)]) right_bound]; % i dont know if this is correct
                    
                    [rec_point,rec_none]=make_data(pro,degree,weight,U,vertex_data,stencil_size,auto_stencil_opt);
                    [f_diff,f_conv]=make_flux(pro,rec_point,rec_none,a,v,force);
                    
                    h=pro.mesh.get_cell_length_all;
                    S=pro.mesh.eval_mean_value_cells(source_term).*h;
                    for i=1:num_cells
                        gp=pro.mesh.get_cell_to_gauss_points_map(i);
                        res=0;
                        for j=1:pro.mesh.get_cell_to_gauss_points_size(i)
                            res=res+pro.mesh.quadrat.get_weights(j)*r (gp(j))*rec_point{i+1}.eval_value(gp(j));
                        end
                        R(i)=h(i)*res;
                    end
                    res=-f_diff(2:num_cells+1)+f_diff(1:num_cells)+f_conv(2:num_cells+1)-f_conv(1:num_cells)+R-S;
                    
                case mfvl_bending_scheme
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

                    source_term=pro.model.get_source_term(1).get_value; % attention
                    vertex_data=[left_bound zeros([1 (num_cells-1)]) right_bound]; % i dont know if this is correct
                    [rec_point,rec_none]=make_data(pro,degree,weight,U,vertex_data,stencil_size,auto_stencil_opt);
                    
                    [f_diff,~]=make_flux(pro,rec_point,rec_none,a,v,force);
                    tau=f_diff;
                    h=pro.mesh.get_cell_length_all;
                    S=pro.mesh.eval_mean_value_cells(source_term).*h;
                    R=pro.mesh.eval_mean_value_cells(r).*U.*h;% this is not working
                    res=-tau(2:num_cells+1)+tau(1:num_cells)+R-S;
                otherwise
                    error('Error:invalid scheme - mfvl_pro - make_residual.');
            end 
        end
        
        
        
        
        
        % solver
        function res=solver(pro,degree,weight,a,v,r,stencil_size,force,auto_stencil_opt)
            num_cells=pro.mesh.get_num_cells;
            B=-make_residual(pro,degree,weight,zeros([1 num_cells]),a,v,r,stencil_size,force,auto_stencil_opt);
            iden=eye(num_cells);
            A=zeros(num_cells);

            for i=1:num_cells
                A(:,i)=make_residual(pro,degree,weight,iden(:,i)',a,v,r,stencil_size,force,auto_stencil_opt)+B;
            end
            
            
%maxIter = num_cells;
%U0 = zeros([1 num_cells]);
%epsilon=1e-20;
%[UApprox,flag,~,iter,resvec]=gmres(A,B',num_cells/2,epsilon,maxIter/2,eye(num_cells),eye(num_cells),U0');
%iteracoes    = (iter(1)-1)*num_cells+iter(2);
            
            
            
            res=A\B';
        end
        % getters
        function res=get_model(pro)
            res=pro.model;
        end
        function res=get_scheme(pro)
            res=pro.scheme;
        end
    end
end