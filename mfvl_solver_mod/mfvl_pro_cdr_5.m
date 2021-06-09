% January, 2017
% class for mfvl_pro
classdef mfvl_pro_cdr_5<handle
    properties (Access=public)
        mesh
        domain
        model
        weight
        simulation_scheme
        degree
        rec %%% incluir
        flux
        u_approx
        dif_flux
        conv_flux
        condition
        checkmark
    end
    methods
        
        function pro=mfvl_pro_cdr_5(mesh,domain,model,degree,flux,weight,stencil_size,auto_stencil_opt)
            global mfvl_cdr_scheme;
            pro.mesh=mesh;
            pro.domain=domain;
            pro.model=model;
            pro.degree=degree;
            pro.weight=weight(1);
            pro.simulation_scheme=mfvl_cdr_scheme;
            a=model.get_material(1).thermal_conductivity;
            r=model.get_reaction;
            v=model.get_velocity;
            
            pro.flux=flux; %pro1 or pro2
            [pro.u_approx,pro.condition]=solver(pro,degree,weight,a,v,r,stencil_size,auto_stencil_opt);
        end
        
        
        
        
        
        % make_flux
        function [f_diff,f_conv] = make_flux(pro,rec_point,rec_none,a,v)
            %global mfvl_bound_cond_neumann;
            num_cells=pro.mesh.get_num_cells;
            vertices_coordinates=pro.mesh.get_vertex_point_all;
            f_diff=zeros([1 pro.mesh.get_num_vertices]);
            f_conv=zeros([1 pro.mesh.get_num_vertices]);
            
            a=a(vertices_coordinates);
            v=v(vertices_coordinates);
            switch pro.flux
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
            %             if pro.get_model.get_bound_cond(2).get_type==mfvl_bound_cond_neumann;
            %                 f_conv(num_cells+1)=0;
            %                 f_diff(num_cells+1)=0;
            %             end
            pro.dif_flux=f_diff;
            pro.conv_flux=f_conv;
        end
        
        
        
        
        % make_data
        function [rec_point,rec_none]=make_data(pro,degree,weight,cells_data,vertex_data,stencil_size,auto_stencil_opt)
            if strcmp(pro.flux,'pro2')==1
               rec_none=make_none(pro,degree,weight,cells_data,stencil_size,auto_stencil_opt);
            else
                rec_none=0;
            end      
            rec_point=make_point_value(pro,degree,weight,cells_data,vertex_data,stencil_size,auto_stencil_opt);
        end
        
        
        
        
        
        % make_none reconstructions
        function rec=make_none(pro,degree,weight,cells_data,stencil_size,auto_stencil_opt)
            global a_matrix_none;
            global stencil_matrix_none;
            stencil_size_matrix=stencil_size;
            % to change the stencil_size
            if stencil_size_matrix(4)==0
                stencil_size=stencil_size_matrix(1);
            else
                stencil_size=stencil_size_matrix(4);
            end
            x_bars=0;
            psi_bars=0;
            num_vertices=pro.mesh.get_num_vertices;
            target_type='vertex';
            lsm_weight=weight;
            num_lsm_weights=2;
            conservation='none';
            stencil_size_factor=1.5;%1;
            rec=cell(max(num_vertices)-2,numel(num_vertices));
            vertex_data=0;
            
            
            for i=2:num_vertices-5
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
                rec{i-1}=mfvl_reconst1d(pro.mesh,...
                    target_type,...
                    lsm_weight,...
                    degree,...
                    conservation,...
                    num_lsm_weights,...
                    cells_data,...
                    vertex_data,...
                    ref_index,...
                    stencil_size_factor,...
                    x_bars,...
                    psi_bars,...
                    stencil_size,...
                    auto_stencil_opt,...
                    pro.simulation_scheme,...
                    a_matrix_value,...
                    stencil);
                
                if isempty(a_matrix_none{i-1})==1
                    a_matrix_none{i-1}=rec{i-1}.get_lsm_lhs;
                end
                if isempty(stencil_matrix_none{i-1})==1
                    stencil_matrix_none{i-1}=rec{i-1}.get_stencil;
                end
            end
            %%%%%%%%%%%%%
            for i=num_vertices-4:num_vertices-1
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
                rec{i-1}=mfvl_reconst1d(pro.mesh,...
                    target_type,...
                    lsm_weight,...
                    degree+1,...
                    conservation,...
                    num_lsm_weights,...
                    cells_data,...
                    vertex_data,...
                    ref_index,...
                    stencil_size_factor,...
                    x_bars,...
                    psi_bars,...
                    stencil_size,...
                    auto_stencil_opt,...
                    pro.simulation_scheme,...
                    a_matrix_value,...
                    stencil);
                
                if isempty(a_matrix_none{i-1})==1
                    a_matrix_none{i-1}=rec{i-1}.get_lsm_lhs;
                end
                if isempty(stencil_matrix_none{i-1})==1
                    stencil_matrix_none{i-1}=rec{i-1}.get_stencil;
                end
            end
        end
        
        % make_point_value reconstructions
        function rec=make_point_value(pro,degree,weight,cells_data,vertex_data,stencil_size,auto_stencil_opt)
            global a_matrix;
            global stencil_matrix;
            global consts_matrix;
            global mfvl_bound_cond_neumann;
            stencil_size_matrix=stencil_size;
            % to change the stencil_size
            if stencil_size_matrix(3)==0
                stencil_size=stencil_size_matrix(1);
            else
                stencil_size=stencil_size_matrix(3);
            end
            x_bars=pro.model.bound_cond(1).physical.point(1).get_coord;
            psi_bars=pro.model.bound_cond(1).value;
            target_type='vertex';
            lsm_weight=weight;
            num_lsm_weights=2;
            conservation='point_value';
            stencil_size_factor=1.5;
            
            num_cells=pro.mesh.get_num_cells;
            num_vertices=pro.mesh.get_num_vertices;
            rec=cell(num_vertices+1,1);
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
                target_type,...
                lsm_weight,...
                degree,...
                conservation,...
                num_lsm_weights,...
                cells_data,...
                vertex_data,...
                1,...
                stencil_size_factor,...
                x_bars,...
                psi_bars,...
                stencil_size,...
                auto_stencil_opt,...
                pro.simulation_scheme,...
                a_matrix_value,...
                stencil);
            if isempty(a_matrix{1})==1
                a_matrix{1}=rec{1}.get_lsm_lhs;
            end
            if isempty(stencil_matrix{1})==1
                stencil_matrix{1}=rec{1}.get_stencil;
            end
            
            conservation='mean_value';
            target_type='cell';
            % to change the stencil_size
            if stencil_size_matrix(2)==0
                stencil_size=stencil_size_matrix(1);
            else
                stencil_size=stencil_size_matrix(2);
            end
            x=2;
            for i=1:num_cells-4
                if isempty(a_matrix{x})==1
                    a_matrix_value=[];
                else
                    a_matrix_value=a_matrix{x};
                end
                if isempty(stencil_matrix{x})==1
                    stencil=[];
                else
                    stencil=stencil_matrix{x};
                end
                ref_index=i;
                rec{x}=mfvl_reconst1d(pro.mesh,...
                    target_type,...
                    lsm_weight,...
                    degree,...
                    conservation,...
                    num_lsm_weights,...
                    cells_data,...
                    vertex_data,...
                    ref_index,...
                    stencil_size_factor,...
                    x_bars,...
                    psi_bars,...
                    stencil_size,...
                    auto_stencil_opt,...
                    pro.simulation_scheme,...
                    a_matrix_value,...
                    stencil);
                if isempty(a_matrix{x})==0
                    rec{x}.consts=consts_matrix{i};
                end
                if isempty(a_matrix{x})==1
                    a_matrix{x}=rec{x}.get_lsm_lhs;
                    consts_matrix{i}=rec{x}.get_consts;
                end
                if isempty(stencil_matrix{x})==1
                    stencil_matrix{x}=rec{x}.get_stencil;
                end
                x=x+1;
            end
            for i=num_cells-3:num_cells
                if isempty(a_matrix{x})==1
                    a_matrix_value=[];
                else
                    a_matrix_value=a_matrix{x};
                end
                if isempty(stencil_matrix{x})==1
                    stencil=[];
                else
                    stencil=stencil_matrix{x};
                end
                ref_index=i;
                rec{x}=mfvl_reconst1d(pro.mesh,...
                    target_type,...
                    lsm_weight,...
                    degree+1,...
                    conservation,...
                    num_lsm_weights,...
                    cells_data,...
                    vertex_data,...
                    ref_index,...
                    stencil_size_factor,...
                    x_bars,...
                    psi_bars,...
                    stencil_size,...
                    auto_stencil_opt,...
                    pro.simulation_scheme,...
                    a_matrix_value,...
                    stencil);
                if isempty(a_matrix{x})==0
                    rec{x}.consts=consts_matrix{i};
                end
                if isempty(a_matrix{x})==1
                    a_matrix{x}=rec{x}.get_lsm_lhs;
                    consts_matrix{i}=rec{x}.get_consts;
                end
                if isempty(stencil_matrix{x})==1
                    stencil_matrix{x}=rec{x}.get_stencil;
                end
                x=x+1;
            end
            
            
            
            
            if pro.model.bound_cond(2).get_type==mfvl_bound_cond_neumann
                x_bars=pro.domain.point(2).coord;
                degree_rec=degree+1;
                psi_bars=pro.model.bound_cond(2).value/(-pro.model.material(1).thermal_conductivity(x_bars));
                
                conservation='point_value_der1';
                target_type='vertex';
            else
                x_bars=pro.model.bound_cond(2).physical.point(1).get_coord;
                psi_bars=pro.model.bound_cond(2).value;
                degree_rec=degree;
                conservation='point_value';
                target_type='vertex';
            end
            
            % to change the stencil_size
            if stencil_size_matrix(3)==0
                stencil_size=stencil_size_matrix(1);
            else
                stencil_size=stencil_size_matrix(3);
            end
            if isempty(a_matrix{x})==1
                a_matrix_value=[];
            else
                a_matrix_value=a_matrix{x};
            end
            if isempty(stencil_matrix{x})==1
                stencil=[];
            else
                stencil=stencil_matrix{x};
            end
            rec{x}=mfvl_reconst1d(pro.mesh,...
                target_type,...
                lsm_weight,...
                degree_rec,...
                conservation,...
                num_lsm_weights,...
                cells_data,...
                vertex_data,...
                num_vertices,...
                stencil_size_factor,...
                x_bars,...
                psi_bars,...
                stencil_size,...
                auto_stencil_opt,...
                pro.simulation_scheme,...
                a_matrix_value,...
                stencil);
            if isempty(a_matrix{x})==1
                a_matrix{x}=rec{x}.get_lsm_lhs;
            end
            if isempty(stencil_matrix{x})==1
                stencil_matrix{x}=rec{x}.get_stencil;
            end
        end
        
        
        % make_residual
        function res=make_residual(pro,degree,weight,U,vertex_data,S,a,v,r,stencil_size,auto_stencil_opt)
            global mfvl_bound_cond_neumann;
            global mfvl_bound_cond_dirichlet;
            num_cells=pro.mesh.get_num_cells;
            
            [rec_point,rec_none]=make_data(pro,degree,weight,U,vertex_data,stencil_size,auto_stencil_opt);
            [f_diff,f_conv]=make_flux(pro,rec_point,rec_none,a,v);
            
            h=pro.mesh.get_cell_length_all;
            R=zeros(1,num_cells);
            for i=1:num_cells
                gp=pro.mesh.get_cell_to_gauss_points_map(i);
                res_r=0;
                for j=1:pro.mesh.get_cell_to_gauss_points_size(i)
                    res_r=res_r+pro.mesh.quadrat.get_weights(j)*r (gp(j))*rec_point{i+1}.eval_value(gp(j));
                end
                R(i)=h(i)*res_r;
            end
            
            if pro.get_model.get_bound_cond(2).get_type==mfvl_bound_cond_neumann
                %                res(1:num_cells-1)=-f_diff(2:num_cells)+f_diff(1:num_cells-1)+f_conv(2:num_cells)-f_conv(1:num_cells-1)+R(1:num_cells-1)-S(1:num_cells-1);
                %                res(num_cells)=pro.get_model.get_bound_cond(2).get_value(1)+f_diff(num_cells)-f_conv(num_cells)+R(num_cells)-S(num_cells);
                res=-f_diff(2:num_cells+1)+f_diff(1:num_cells)+f_conv(2:num_cells+1)-f_conv(1:num_cells)+R-S;
            elseif pro.get_model.get_bound_cond(2).get_type==mfvl_bound_cond_dirichlet
                res=-f_diff(2:num_cells+1)+f_diff(1:num_cells)+f_conv(2:num_cells+1)-f_conv(1:num_cells)+R-S;
            end
            res=res';
        end
        
        
        
        
        
        % solver
        function [res,condition]=solver(pro,degree,weight,a,v,r,stencil_size,auto_stencil_opt)
            global mfvl_bound_cond_neumann;
            num_cells=pro.mesh.get_num_cells;
            h=pro.mesh.get_cell_length_all;
            source_term=pro.model.get_source_term(1).get_value; % attention
            left_bound_value=pro.model.get_bound_cond(1).get_value(1); % attention
            if pro.get_model.get_bound_cond(2).get_type==mfvl_bound_cond_neumann
                right_bound_value=0;%-source_term(pro.mesh.get_vertex_point(pro.mesh.get_num_vertices));
            else
                right_bound_value=pro.model.get_bound_cond(2).get_value(1); % attention
            end
            vertex_data=[left_bound_value zeros([1 (num_cells-1)]) right_bound_value]; % i dont know if this is correct
            S=pro.mesh.eval_mean_value_cells(source_term).*h;
            
            num_cells=pro.mesh.get_num_cells;
            
            B=-make_residual(pro,degree,weight,zeros([1 num_cells]),vertex_data,S,a,v,r,stencil_size,auto_stencil_opt);
            
            iden=eye(num_cells);
            A=zeros(num_cells);
            for i=1:num_cells
                A(:,i)=make_residual(pro,degree,weight,iden(:,i)',vertex_data,S,a,v,r,stencil_size,auto_stencil_opt)+B;
            end
            res=A\B;
            condition=cond(A);
            s=(inv(A)>=1e-10);
            if sum(sum(s))~=numel(A)
                pro.checkmark='$\x$';
            else
                pro.checkmark='$\checkmark$';
            end
            %         epsilon=1e-12;
            %         max_iter=num_cells;
            %         left_bound=pro.mesh.get_left_bound;
            %         right_bound=pro.mesh.get_right_bound;
            %         x0=mfvl_f_of_x(left_bound,right_bound,...
            %             left_bound_value,right_bound_value,...
            %             linspace(left_bound,right_bound,num_cells));
            %         [res,flag,rel_res,iter,res_vec]=gmres(@(xx)make_residual(pro,degree,weight,xx,vertex_data,S,a,v,r,stencil_size,auto_stencil_opt)+B,B,...
            %             num_cells,epsilon,max_iter,[],[],x0');
        end
        % getters
        function res=get_model(pro)
            res=pro.model;
        end
        function res=get_mesh(pro)
            res=pro.mesh;
        end
    end
end
