% January, 2017
% inicialize the mesh

% quadrature
gauss_order=6;
quadrat=mfvl_gauss1d(gauss_order);
% mesh
mesh=mfvl_mesh1d(quadrat,domain);
vertices=mesh.get_vertex_point_all;
vertices=vertices(2:mesh.get_num_cells);
% alpha=0.2;
% factor=30;
% while factor>20
%     % vertex_points
%     a=domain.point(1).coord;
%     b=domain.point(2).coord;
%     for i=1:numel(vertices)
%         vertices(i)=vertices(i)+((b-a)*rand(1)+a)*(1/mesh.get_num_cells)*alpha;
%     end
%     mesh.vertex_point(2:mesh.get_num_cells)=vertices;
%     % cell_centroids
%     for i=1:numel(mesh.cell_centroid)
%         mesh.cell_centroid(i)=(mesh.vertex_point(i+1)+mesh.vertex_point(i))/2;
%     end
%     % cell_to_gauss_points
%     for count=1:mesh.get_num_cells
%         for i=1:mesh.quadrat.get_num_points
%             mesh.cell_to_gauss_points_map(i,count)=mesh.quadrat.eval_point(i,mesh.vertex_point(count),mesh.vertex_point(count+1));
%         end
%     end
%     % cell_length
%     for i=1:mesh.get_num_cells
%         mesh.cell_length(i)=mesh.vertex_point(i+1)-mesh.vertex_point(i);
%     end
%     factor=(min(mesh.get_cell_length_all)/max(mesh.get_cell_length_all))*100;
% end


% end of file