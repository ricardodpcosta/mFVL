function [] = plot_mesh1d(mesh)
figure(1);
gauss_points_matrix=mesh.get_cell_to_gauss_points_map_all();%getting gauss points and put the in sort vector
gauss_points_vector=sort(gauss_points_matrix(:));
line_a = [mesh.get_vertex_point_all();mesh.get_vertex_point_all()];
line_b = [repmat(-.5,1,mesh.get_num_cells+1);repmat(.5,1,mesh.get_num_cells+1)];
point_left=[mesh.get_vertex_point(1) mesh.get_vertex_point(mesh.get_num_cells()+1)];
point_right=[0 0];
plot(line_a,line_b,'r-',point_left,point_right,'k-');
hold all;
plot_cell_centroid=plot(mesh.get_cell_centroid_all(),zeros([1 mesh.get_num_cells]),'ob');
plot_gauss=plot(gauss_points_vector,zeros([1 mesh.get_num_cells*mesh.get_num_gauss_points]),'r*');
legend([plot_cell_centroid,plot_gauss],'cell centroid','gauss points','location','northeastoutside')
ylim([-.6 .6]);
title(['cells:' num2str(mesh.get_num_cells) '   g.o.:' num2str(mesh.get_gauss_order) '   xl.=' num2str(mesh.get_left_bound) '   xr.=' num2str(mesh.get_right_bound)]);
grid on;
set(gca, 'YTick', []);
axis square;
hold off;
figure(2)
abc=linspace(0,mesh.get_num_cells,mesh.get_num_cells);
plot(abc,mesh.get_cell_length_all);
xlabel('Cell index');
ylabel('Length');
title(['cells:' num2str(mesh.get_num_cells) '   g.o.:' num2str(mesh.get_gauss_order) '   xl.=' num2str(mesh.get_left_bound) '   xr.=' num2str(mesh.get_right_bound)]);
grid on;
axis square;
hold off;
end