% January, 2017
% class for mfvl_pro
classdef mfvl_pro<handle
    properties (Access=public)
        mesh
        domain
        model
        weight
        degree
        flux
        u_approx
    end
    methods
        function pro=mfvl_pro(mesh,domain,model,degree,flux,weight)
            pro.mesh=mesh;
            pro.domain=domain;
            pro.model=model;
            pro.degree=degree;
            pro.weight=weight;
            pro.flux=flux; %pro1 or pro2
            a=model.get_material(1).thermal_conductivity;
            r=model.get_reaction;
            v=model.get_velocity;
            pro.u_approx=solver(pro,mesh,model,flux,degree,weight,a,v,r);
        end
        
        
        
        
        
        % make_flux
        function [f_diff,f_conv] = make_flux(pro,mesh,rec_point,rec_none,scheme,a,v)
            num_cells=mesh.get_num_cells;
            vertices_coordinates=mesh.get_vertex_point_all;
            a=a(vertices_coordinates);
            v=v(vertices_coordinates);
            switch (scheme)
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
                    error('Error :: Invalid Scheme');
            end
        end
        
        
        
        
        
        % make_data
        function [rec_point,rec_none]=make_data(pro,mesh,degree,weight,cells_data,vertex_data)
            rec_none=make_none(pro,mesh,degree,weight,cells_data);
            rec_point=make_point_value(pro,mesh,degree,weight,cells_data,vertex_data);
        end
        
        
        
        
        
        % make_none reconstructions
        function rec=make_none(pro,mesh,degree,weight,cells_data)
            num_vertices=mesh.get_num_vertices;
            target_type='vertex';
            lsm_weight=weight;
            num_lsm_weights=2;
            conservation='none';
            stencil_size_factor=1;
            rec=cell(max(num_vertices)-2,numel(num_vertices));
            for k=1:numel(num_vertices)
                vertex_data=0;
                for i=2:num_vertices(k)-1
                    ref_index=i;
                    rec{i-1,k}=mfvl_reconst1d(mesh,target_type,...
                        lsm_weight,degree,...
                        conservation,num_lsm_weights,...
                        cells_data,vertex_data,...
                        ref_index,stencil_size_factor);
                end
            end
        end
        
        
        
        
        
        % make_point_value reconstructions
        function rec=make_point_value(pro,mesh,degree,weight,cells_data,vertex_data)
            target_type='vertex';
            lsm_weight=weight;
            num_lsm_weights=2;
            conservation='point_value';
            stencil_size_factor=1.5;
            
            num_cells=mesh.get_num_cells;
            num_vertices=mesh.get_num_vertices;
            rec=cell(max(num_vertices)+1,numel(num_vertices));
            for k=1:numel(num_cells)
                rec{1,k}=mfvl_reconst1d(mesh,target_type,lsm_weight,degree,conservation,num_lsm_weights,cells_data,vertex_data,1,stencil_size_factor);
                conservation='mean_value';
                target_type='cell';
                x=2;
                for i=1:num_cells(k)
                    ref_index=i;
                    rec{x,k}=mfvl_reconst1d(mesh,target_type,lsm_weight,degree,conservation,num_lsm_weights,cells_data,vertex_data,ref_index,stencil_size_factor);
                    x=x+1;
                end
                conservation='point_value';
                target_type='vertex';
                rec{x,k}=mfvl_reconst1d(mesh,target_type,lsm_weight,degree,conservation,num_lsm_weights,cells_data,vertex_data,num_vertices(k),stencil_size_factor);
            end
        end
        
        
        
        
        
        % make_residual
        function res= make_residual(pro,mesh,model,flux,degree,weight,U,a,v,r)
            num_cells=mesh.get_num_cells;
            left_bound=model.get_bound_cond(1).get_value;
            right_bound=model.get_bound_cond(2).get_value;            
            source_term=model.get_source_term(1).get_value; % attention
            vertex_data=[left_bound zeros([1 (num_cells-1)]) right_bound]; % i dont know if this is correct
            
            [rec_point,rec_none]=make_data(pro,mesh,degree,weight,U,vertex_data);
            [f_diff,f_conv]=make_flux(pro,mesh,rec_point,rec_none,flux,a,v);

            h=mesh.get_cell_length_all;
            %cell_centroids=mesh.get_cell_centroid_all;

            S=mesh.eval_mean_value_cells(source_term).*h;
            R=mesh.eval_mean_value_cells(r).*U.*h;% this is not working
            res=-f_diff(2:num_cells+1)+f_diff(1:num_cells)+f_conv(2:num_cells+1)-f_conv(1:num_cells)+R-S;
        end
        
        
        
        
        
        % solver
        function res=solver(pro,mesh,model,flux,degree,weight,a,v,r)
            num_cells=mesh.get_num_cells;
            B=-make_residual(pro,mesh,model,flux,degree,weight,zeros([1 num_cells]),a,v,r);      
            iden=eye(num_cells);
            A=zeros(num_cells);
            for i=1:num_cells
                A(:,i)=make_residual(pro,mesh,model,flux,degree,weight,iden(:,i)',a,v,r)+B;
            end
            res=A\B';
        end
        
    end
end