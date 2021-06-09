% November, 2016
% make_flux
function [f_diff,f_conv] = make_flux(m,rec_point,rec_none,schemes,a,v,r)
num_cells=m.get_num_cells;
vertices_coordinates=m.get_vertex_point_all;
a=a(vertices_coordinates);
v=v(vertices_coordinates);
r=r(vertices_coordinates);
switch (schemes)
    case 'pro1'
        f_diff(1)=a(1)*rec_point{1}.eval_deriv(vertices_coordinates(1));
        for i=2:num_cells
            f_diff(i)=a(i)*(rec_point{i}.eval_deriv(vertices_coordinates(i))+rec_point{i+1}.eval_deriv(vertices_coordinates(i)))/(2);
        end
        f_diff(num_cells+1)=a(num_cells+1)*rec_point{num_cells+2}.eval_deriv(vertices_coordinates(num_cells+1));
        for i=1:num_cells+1
            f_conv(i)=max(0,v(i))*rec_point{i}.eval_value(vertices_coordinates(i))+min(0,v(i))*rec_point{i+1}.eval_value(vertices_coordinates(i));
        end
    case 'pro2'
        f_diff(1)=a(1)*rec_point{1}.eval_deriv(vertices_coordinates(1));
        for i=2:num_cells
            f_diff(i)=a(i)*rec_none{i-1}.eval_deriv(vertices_coordinates(i));
        end
        f_diff(num_cells+1)=a(num_cells+1)*rec_point{num_cells+2}.eval_deriv(vertices_coordinates(num_cells+1));
        for i=1:num_cells+1
            f_conv(i)=max(0,v(i))*rec_point{i}.eval_value(vertices_coordinates(i))+min(0,v(i))*rec_point{i+1}.eval_value(vertices_coordinates(i));
        end
    otherwise
        error('Error :: Invalid Scheme');
end
end
% end of file