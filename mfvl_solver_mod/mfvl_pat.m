% December, 2016
% class for mfvl_diff_pat
classdef mfvl_pat<handle
    properties (Access=public)
        mesh
        domain
        model
        degree
        u_approx
    end
    methods
        function pat=mfvl_pat(mesh,domain,model,type_conv)
            global mfvl_degree_default;
            a=model.get_material(1).thermal_conductivity;
            r=model.get_reaction;
            v=model.get_velocity;
            source_term=model.get_source_term(1).get_value; % attention
            pat.u_approx=solver(pat,mesh,model,a,v,r,type_conv,source_term);
            pat.mesh=mesh;
            pat.domain=domain;
            pat.model=model;
            pat.degree=mfvl_degree_default;
        end
        
        % make_residual
        function res=make_residual(pat,mesh,model,U,a,v,r,type_conv,source_term)
            global mfvl_bound_cond_dirichlet;
            global mfvl_bound_cond_neumann;
            h=mesh.get_cell_length_all;
            num_cells=mesh.get_num_cells;
            cell_centroids=mesh.get_cell_centroid_all;
            S=mesh.eval_mean_value_cells(source_term).*h;
            R=r(cell_centroids).*U.*h;
            for i=1:model.get_num_bound_conds
                type(i)=model.get_bound_cond(i).get_type;
            end
            if (type(1)==mfvl_bound_cond_dirichlet) && (type(2)==mfvl_bound_cond_dirichlet)
                type_bound='I';
            else
                if (type(1)==mfvl_bound_cond_dirichlet) && (type(2)==mfvl_bound_cond_neumann)
                    type_bound='II';
                else
                    if (type(1)==mfvl_bound_cond_neumann)&&(type(2)==mfvl_bound_cond_neumann)
                        type_bound='III';
                    else
                        error('mfvl_pat: error in bound conds.');
                    end
                end
            end
            
            [f_diff,f_conv]=make_flux(pat,mesh,model,U,a,v,type_bound,type_conv);
            switch type_bound
                case 'I'
                    res=-f_diff(2:num_cells+1)+f_diff(1:num_cells)+f_conv(2:num_cells+1)-f_conv(1:num_cells)+R-S;
                case 'II'
                    res(1:num_cells-1)=-f_diff(2:num_cells)+f_diff(1:num_cells-1)+f_conv(2:num_cells)-f_conv(1:num_cells-1)+R(1:num_cells-1)-S(1:num_cells-1);
                    res(num_cells)=model.get_bound_cond(2).get_value(1)+f_diff(num_cells)-f_conv(num_cells)+R(num_cells)-S(num_cells);
                case 'III' % correct, this is the case of two numann bound condition
                    res(1)=model.get_bound_cond(1).get_value+f_diff(1)-f_conv(1)+R(1)-S(1);
                    res(2:num_cells-1)=-f_diff(3:num_cells)+f_diff(2:num_cells-1)+f_conv(3:num_cells)-f_conv(2:num_cells-1)+R(2:num_cells-1)-S(2:num_cells-1);
                    res(num_cells)=model.get_bound_cond(2).get_value(1)+f_diff(num_cells)-f_conv(num_cells)+R(num_cells)-S(num_cells);
            end
        end
        
        
        
        
        % make_flux
        function [f_diff,f_conv]=make_flux(pat,mesh,model,U,a,v,type_bound,type_conv)
            num_cells=mesh.get_num_cells;
            h=mesh.get_cell_length_all;
            vertices_coordinates=mesh.get_vertex_point_all;
            a_vec=a(vertices_coordinates);
            v_vec=v(vertices_coordinates);
            % bound conditions
            bc.lf=model.get_bound_cond(1).get_value(1);
            bc.rg=model.get_bound_cond(2).get_value(1);
            switch (type_bound)
                case 'I'
                    % diffusion terms
                    f_diff(1)=(a_vec(1)*2*(U(1)-bc.lf))/(h(1));
                    for i=2:num_cells
                        f_diff(i)=a_vec(i)*2*(U(i)-U(i-1))/(h(i-1)+h(i));
                    end
                    f_diff(num_cells+1)=a_vec(num_cells+1)*2*(bc.rg-U(num_cells))/h(num_cells);
                    % convection terms
                    switch (type_conv)
                        case 'CD'
                            f_conv(1)=v_vec(1)*bc.lf;
                            for i=2:num_cells
                                f_conv(i)=v_vec(i)*(U(i)*h(i)+U(i-1)*h(i))/(h(i-1)+h(i));
                            end
                            f_conv(num_cells+1)=v_vec(num_cells+1)*bc.rg;
                        case 'UW'
                            f_conv(1)=max(0,v_vec(1))*bc.lf+min(0,v_vec(1))*U(1);
                            for i=2:num_cells
                                f_conv(i)=max(0,v_vec(i))*U(i-1)+min(0,v_vec(i))*U(i);
                            end
                            f_conv(num_cells+1)=max(0,v_vec(num_cells+1))*U(num_cells)+min(0,v_vec(num_cells+1))*bc.rg;
                    end
                case 'II'
                    % diffusion terms
                    f_diff(1)=(a_vec(1)*2*(U(1)-bc.lf))/(h(1));
                    for i=2:num_cells
                        f_diff(i)=a_vec(i)*2*(U(i)-U(i-1))/(h(i-1)+h(i));
                    end
                    f_diff(num_cells+1)=0;
                    % convection terms
                    switch (type_conv)
                        case 'CD'
                            f_conv(1)=v_vec(1)*bc.lf;
                            for i=2:num_cells
                                f_conv(i)=v_vec(i)*(U(i)*h(i)+U(i-1)*h(i))/(h(i-1)+h(i));
                            end
                            %f_conv(num_cells+1)=v_vec(num_cells+1)*bc.rg;
                        case 'UW'
                            f_conv(1)=max(0,v_vec(1))*bc.lf+min(0,v_vec(1))*U(1);
                            for i=2:num_cells
                                f_conv(i)=max(0,v_vec(i))*U(i-1)+min(0,v_vec(i))*U(i);
                            end
                            %f_conv(num_cells+1)=max(0,v_vec(num_cells+1))*U(num_cells)+min(0,v_vec(num_cells+1))*bc.rg;
                    end
                    
                    
                case 'III'
                    % diffusion terms
                    %f_diff(1)=(a_vec(1)*2*(U(1)-bc.lf))/(h(1));
                    f_diff(1)=0;
                    for i=2:num_cells
                        f_diff(i)=a_vec(i)*2*(U(i)-U(i-1))/(h(i-1)+h(i));
                    end
                    f_diff(num_cells+1)=0;
                    % convection terms
                    switch (type_conv)
                        case 'CD'
                            %f_conv(1)=v_vec(1)*bc.lf;
                            for i=2:num_cells
                                f_conv(i)=v_vec(i)*(U(i)*h(i)+U(i-1)*h(i))/(h(i-1)+h(i));
                            end
                            %f_conv(num_cells+1)=v_vec(num_cells+1)*bc.rg;
                        case 'UW'
                            %f_conv(1)=max(0,v_vec(1))*bc.lf+min(0,v_vec(1))*U(1);
                            for i=2:num_cells
                                f_conv(i)=max(0,v_vec(i))*U(i-1)+min(0,v_vec(i))*U(i);
                            end
                            %f_conv(num_cells+1)=max(0,v_vec(num_cells+1))*U(num_cells)+min(0,v_vec(num_cells+1))*bc.rg;
                            
                    end
            end
        end
        
        % solver
        function res=solver(pat,mesh,model,a,v,r,type_conv,source_term)
            %num_cells=mesh.get_num_cells;
            B=-make_residual(pat,mesh,model,zeros([1 mesh.get_num_cells]),a,v,r,type_conv,source_term);
            iden=eye(mesh.get_num_cells);
            A=zeros(mesh.get_num_cells);
            for i=1:mesh.get_num_cells
                A(:,i)=make_residual(pat,mesh,model,iden(:,i)',a,v,r,type_conv,source_term)+B;
            end
            res=A\B';
        end
        
        
        
        
        % setters
        function pat=set_degree(pat,d)
            pat.degree=d;
        end
        % getters
        function res=get_mesh(pat)
            res=pat.mesh;
        end
        function res=get_domain(pat)
            res=pat.domain;
        end
        function res=get_model(pat)
            res=pat.model;
        end
        function res=get_degree(pat)
            res=pat.degree;
        end
    end
end
% end of file