% November, 2016
% make_residual
function [res] = make_residual(m,flux,degree,num_cells,u_matrix,u,a,v,r,source_term,left_bound,right_bound)
vertex_data=[u(left_bound) zeros([1 (num_cells-1)]) u(right_bound)];
[rec_point,rec_none]=make_data(m,degree,u_matrix,vertex_data);
[f_diff,f_conv]=make_flux(m,rec_point,rec_none,flux,a,v,r);
r=r(m.get_cell_centroid_all);
length=m.get_cell_length_all;
%Centroid=m{1}.get_cell_centroid_all;
%Vertices=m{1}.GetVertexPointAll;
b_matrix=m.eval_mean_value_cells(source_term).*length;
res=-f_diff(2:num_cells+1)+f_diff(1:num_cells)+f_conv(2:num_cells+1)-f_conv(1:num_cells)+r-b_matrix;
end
% end of file