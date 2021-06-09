function [] = plot_mesh1d_stencil(mesh,s)
figure(3)
gauss_points_matrix=mesh.get_cell_to_gauss_points_map_all();
gauss_points_vector=sort(gauss_points_matrix(:));
line_a1 = [mesh.get_vertex_point_all;mesh.get_vertex_point_all];
line_b1 = [repmat(-.5,1,mesh.get_num_cells+1);repmat(.5,1,mesh.get_num_cells+1)];
cell_centroid=mesh.get_cell_centroid_all;
line_a2 = [cell_centroid(s.get_stencil_all);cell_centroid(s.get_stencil_all)];
line_b2 = [repmat(-.5,1,numel(cell_centroid(s.get_stencil_all)));repmat(.5,1,numel(cell_centroid(s.get_stencil_all)))];
point_left=[mesh.get_left_bound mesh.get_right_bound];
point_right=[0 0];
plot(line_a1,line_b1,'r-');
hold all;
plot(point_left,point_right,'k-');
plot_stencil=plot(line_a2,line_b2,'b-');
plot_cell_centroid=plot(cell_centroid,zeros([1 mesh.get_num_cells]),'ob');
plot_gauss=plot(gauss_points_vector,zeros([1 mesh.get_num_cells*mesh.get_num_gauss_points]),'r*');
ylim([-.6 .6]);
legend([plot_cell_centroid, plot_gauss, plot_stencil'], {'Cell centroid', 'Gauss points', 'Stencil cells'},'location','northeastoutside');
%legend([plot_cell_centroid, plot_gauss, plot_stencil],'cell_centroid','Gauss Points','stencil');
title(['cells:' num2str(mesh.get_num_cells) '   g.o.:' num2str(mesh.get_gauss_order) '   xl.=' num2str(mesh.get_left_bound) '   xr.=' num2str(mesh.get_right_bound) '   RefType=' num2str(s.get_ref_type)  '   #S=' num2str(s.get_size) '   index=' num2str(s.get_index) '   include_ref=' s.get_include__ref]);
grid on;
set(gca, 'YTick', []);
axis square;
hold off;
end