% November, 2016
% mfvl_mesh1d
classdef mfvl_mesh1d < handle
    properties (Access=public)
        num_cells
        left_bound
        right_bound
        %density_function
        num_vertices
        vertex_point
        cell_centroid
        cell_to_vertex_map
        cell_to_vertex_size
        vertex_to_cell_map
        vertex_to_cell_size
        cell_to_gauss_points_map
        cell_to_gauss_points_size
        cell_to_cell_map
        cell_to_cell_size
        cell_length
        quadrat
        domain
        cell_code
        vertex_code
    end
    methods
        function mesh = mfvl_mesh1d(quadrat,domain)
            mesh.num_cells=0;
            mesh.domain=domain;
            mesh.quadrat=quadrat;
            num_lines=domain.get_num_lines;
            num_points=domain.get_num_points;
            mesh.left_bound=domain.get_point(1).get_coord;
            mesh.right_bound=domain.get_point(num_points).get_coord;
            
            %mesh.left_bound=left_bound;
            %mesh.right_bound=right_bound;
            count2=1;
            for count=1:num_lines
                num_cells_aux=domain.get_line(count).get_num_cells;
                num_vertices_aux=num_cells_aux+1;
                
                left_aux=domain.get_line(count).get_point1.get_coord;
                right_aux=domain.get_line(count).get_point2.get_coord;
                density_function=domain.get_line(count).get_density_function;
                
                % cell_code
                for count2=count2:(num_cells_aux+mesh.num_cells)
                    mesh.cell_code(count2)=domain.get_line(count).get_code;
                end
                count2=count2+1;

                % vertex_point
                two_times_num_cells=2*num_cells_aux;
                %func=density_function;% To make a uniform mesh put @(x)1 for Func value
                aux_point=left_aux:(right_aux-left_aux)/(two_times_num_cells):right_aux;
                If=zeros([1 two_times_num_cells]);
                for i=1:two_times_num_cells
                    If(i)=(aux_point(i+1)-aux_point(i))*mesh.quadrat.eval_mean_value(aux_point(i),aux_point(i+1),density_function);
                end
                area_density=sum(If);
                f=zeros([1 two_times_num_cells]);
                f(1)=0;
                for i=2:two_times_num_cells
                    f(i)=f(i-1)+If(i-1)/area_density;
                end
                f(two_times_num_cells+1)=1;
                h=(right_aux-left_aux)/num_cells_aux;
                mesh.vertex_point(1,count)=left_aux;
                for i=2:num_cells_aux
                    eta=(h*(i-1))/(right_aux-left_aux);
                    for j=1:two_times_num_cells
                        if  eta>=f(j) && eta<=f(j+1)
                            mesh.vertex_point(i,count)=aux_point(j)+(aux_point(j+1)-aux_point(j))/(f(j+1)-f(j))*(eta-f(j));
                            break;
                        end
                    end
                end
                mesh.vertex_point(num_vertices_aux,count)=right_aux;
                mesh.num_cells=mesh.num_cells+num_cells_aux;
            end
            mesh.num_vertices=mesh.num_cells+1;
            mesh.vertex_point=unique(sort(mesh.vertex_point(:)))';
            
            % vertex_code
            mesh.vertex_code=zeros([1 mesh.num_vertices]);
            %mesh.vertex_code(1)=domain.get_point(1).get_code;
            mesh.vertex_code(1)=domain.get_point(1).get_code;
            pos=domain.get_line(1).get_num_cells;
            for i=1:domain.get_num_lines
                pos(i)=domain.get_line(i).get_num_cells;
                mesh.vertex_code(sum(pos)+1)=domain.get_point(i+1).get_code;
            end
            mesh.vertex_code(mesh.num_vertices)=domain.get_point(domain.get_num_points).get_code;
            k=0;
            for i=1:domain.get_num_lines
                count(i)=domain.get_line(i).get_num_cells;
                for j=2+k:sum(count(1:i))
                    mesh.vertex_code(j)=domain.get_line(i).get_code;
                end
                k=sum(count(1:i));
            end
            
            
%             for i=2:domain.get_line(1).get_num_cells
%                 mesh.vertex_code(i)=domain.get_line(1).get_code;
%             end
%             for i=domain.get_line(1).get_num_cells+2:domain.get_line(1).get_num_cells+domain.get_line(2).get_num_cells
%                 mesh.vertex_code(i)=domain.get_line(2).get_code;
%             end
% 
%             
%             for i=1:domain.get_num_lines
%                 if i==1
%                     mesh.vertex_code(domain.get_line(i).get_num_cells+1)=domain.get_line(i).get_point2.get_code;
%                     for j=2:domain.get_line(i).get_num_cells
%                         mesh.vertex_code(j)=domain.get_line(i).get_code;
%                     end
%                 else
%                     mesh.vertex_code(domain.get_line(i-1).get_num_cells+domain.get_line(i).get_num_cells+1)=domain.get_line(i).get_point2.get_code;
%                     for j=domain.get_line(i-1).get_num_cells+2:domain.get_line(i-1).get_num_cells+domain.get_line(i).get_num_cells
%                         mesh.vertex_code(j)=domain.get_line(i).get_code;
%                     end
%                 end
%             end
%             mesh.vertex_code(mesh.num_vertices)=domain.get_point(domain.get_num_points).get_code;
            
            % cell_centroid
            for i=1:mesh.num_cells
                mesh.cell_centroid(i)=(mesh.vertex_point(i+1)+mesh.vertex_point(i))/2;
            end
            
            % cell_length
            for i=1:mesh.num_cells
                mesh.cell_length(i)=distance_between_points([mesh.vertex_point(i) mesh.vertex_point(i+1)]);
            end
            
            %mesh.num_cells=num_cells;
            mesh.cell_to_vertex_map=[1:1:mesh.num_cells;2:1:mesh.num_cells+1];
            mesh.cell_to_vertex_size=repmat(size(mesh.cell_to_vertex_map,1),1,mesh.num_cells);
            
            mesh.vertex_to_cell_map=[1 1:1:mesh.num_cells;0 2:1:mesh.num_cells 0];%  [1:1:mesh.num_cells mesh.num_cells;0 1:1:mesh.num_cells-1 0];
            mesh.vertex_to_cell_size=[1 repmat(size(mesh.vertex_to_cell_map,1),1,mesh.num_cells-2) 1];
            %mesh.density_function=density_function;
            % quadrature structure

            
            
            

            % cell_to_gauss_points
            for k=1:mesh.num_cells
                for i=1:mesh.quadrat.get_num_points
                    mesh.cell_to_gauss_points_map(i,k)=mesh.quadrat.eval_point(i,mesh.vertex_point(k),mesh.vertex_point(k+1));
                end
            end
            mesh.cell_to_gauss_points_size=repmat(mesh.quadrat.get_num_points,1,mesh.num_cells);
            % cell_to_cell
            for i=1:mesh.num_cells
                x1=mesh.cell_to_vertex_map(:,i);
                x2=zeros([size(x1,1) 1]);
                for k=1:size(x1,1)
                    x2(:,k)=mesh.vertex_to_cell_map(:,x1(k,:));
                end
                x3=(sort(x2(:)));
                a=x3(x3~=i);
                x3=a;
                b=zeros([1 numel(x3)]);
                for k=1:numel(x3)
                    a=x3(k);
                    for j=1:numel(x3)
                        if x3(j)==a
                            b(k)=b(k)+1;
                        end
                    end
                end
                for j=1:size(b,2)
                    if b(j)~=1
                        x3(j)=[];
                    end
                end
                if (i==1) || (i==mesh.num_cells)
                    a=[];
                    a(1)=x3(2);
                    a(2)=x3(1);
                    mesh.cell_to_cell_map(:,i)=a';
                    mesh.cell_to_cell_size(i)=1;
                else
                    mesh.cell_to_cell_map(:,i)=x3;
                    mesh.cell_to_cell_size(i)=2;
                end
            end
            
        end
        function res=eval_mean_value_cells(mesh,func)
            res=zeros([1 mesh.num_cells]);
            for i=1:mesh.num_cells
                res(i)=mesh.eval_mean_value_cell(i,func);
            end
        end
        function res = eval_mean_value_cell(mesh,index,func)
            gp=mesh.get_cell_to_gauss_points_map(index);
            res=0;
            for i=1:mesh.cell_to_gauss_points_size(index)
                res=res+func(gp(i))*mesh.quadrat.get_weights(i);
            end
        end
        % Getters
        function res=get_cell_to_gauss_points_map_all(mesh)
            res=mesh.cell_to_gauss_points_map;
        end
        function res=get_cell_to_gauss_points_map(mesh,index)
            if (index<1) || (index>mesh.num_cells)
                error(['get_cell_to_gauss_points_map :: 1>index>' num2str(mesh.num_cells)]);
            end
            res=mesh.cell_to_gauss_points_map(:,index);
        end
        function res=get_num_cells(mesh)
            res=mesh.num_cells;
        end
        function res=get_num_vertices(mesh)
            res=mesh.num_vertices;
        end
        function res=get_left_bound(mesh)
            res=mesh.left_bound;
        end
        function res=get_right_bound(mesh)
            res=mesh.right_bound;
        end
        function res=get_gauss_order(mesh)
            res=mesh.quadrat.get_order;
        end
        function res=get_num_gauss_points(mesh)
            res=mesh.quadrat.get_num_points;
        end
        function res=get_vertex_point(mesh,index)
            if (index<1) || (index>mesh.num_vertices)
                error(['vertices :: 1>index>' num2str(mesh.num_vertices)]);
            end
            res=mesh.vertex_point(index);
        end
        function res=get_vertex_point_all(mesh)
            res=mesh.vertex_point;
        end
        function res=get_cell_centroid_all(mesh)
            res=mesh.cell_centroid;
        end
        function res=get_cell_centroid(mesh,index)
            if (index<1) || (index>mesh.num_cells)
                error(['centroids :: 1>index>' num2str(mesh.num_cells)]);
            end
            res=mesh.cell_centroid(index);
        end
        function res=get_cell_to_vertex_map_all(mesh)
            res=mesh.cell_to_vertex_map;
        end
        function res=get_cell_to_vertex_map(mesh,index)
            if (index<1) || (index>mesh.num_cells)
                error(['cell_to_vertex :: 1>index>' num2str(mesh.num_cells)]);
            end
            res=mesh.cell_to_vertex_map(:,index);
        end
        function res=get_vertex_to_cell_map_all(mesh)
            res=mesh.vertex_to_cell_map;
        end
        function res=get_vertex_to_cell_map(mesh,index)
            if (index<1) || (index>mesh.num_vertices)
                error(['vertex_to_cell :: 1>index>' num2str(mesh.num_vertices)]);
            end
            res=mesh.vertex_to_cell_map(:,index);
        end
        function res=get_cell_to_cell_map_all(mesh)
            res=mesh.cell_to_cell_map;
        end
        function res=get_cell_to_cell_map(mesh,index)
            if (index<1) || (index>mesh.num_cells)
                error(['cell_to_cell :: 1>index>' num2str(mesh.num_cells)]);
            end
            res=mesh.cell_to_cell_map(:,index);
        end
        function res=get_cell_to_vertex_size_all(Mesh)
            res=Mesh.cell_to_vertex_size;
        end
        function res=get_cell_to_vertex_size(mesh,index)
            if (index<1) || (index>mesh.num_cells)
                error(['cell_to_vertex_size :: 1>index>' num2str(mesh.num_cells)]);
            end
            res=mesh.cell_to_vertex_size(:,index);
        end
        function res=get_cell_length_all(mesh)
            res=mesh.cell_length;
        end
        function res=get_cell_length(mesh,index)
            if (index<1) || (index>mesh.num_cells)
                error(['cell_length :: 1>index>' num2str(mesh.num_cells)]);
            end
            res=mesh.cell_length(index);
        end
        function res=get_cell_to_gauss_points_size_all(mesh)
            res=mesh.cell_to_gauss_points_size;
        end
        function res=get_cell_to_gauss_points_size(mesh,index)
            if (index<1) || (index>mesh.num_cells)
                error(['cell_to_gauss_points_size :: 1>index>' num2str(mesh.num_cells)]);
            end
            res=mesh.cell_to_gauss_points_size(index);
        end
        function res=get_quadrat1d(mesh)
            res.order=mesh.quadrat.get_order;
            res.num_points=mesh.quadrat.get_num_points;
            res.weights=mesh.quadrat.get_weights_all;
            res.point_coefs=mesh.quadrat.get_point_coefs_all;
        end
        function res=get_eval_point(mesh,index,point1,point2)
            res=mesh.quadrat.eval_point(index,point1,point2);
        end
        function res=get_weights(mesh,index)
            res=mesh.quadrat.get_weights(index);
        end
        function res=get_domain(mesh)
            res=mesh.domain;
        end
    end
end
% end of file