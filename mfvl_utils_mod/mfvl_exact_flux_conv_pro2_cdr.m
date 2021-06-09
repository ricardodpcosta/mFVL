function f_conv = mfvl_exact_flux_conv_pro2_cdr(func,vertices_coordinates,v)
%MFVL_EXACT_FLUX_PRO1_BENDING Summary of this function goes here
%   Detailed explanation goes here

num_vertices=numel(vertices_coordinates);
f_conv=zeros(1,num_vertices);
% for i=1:num_vertices
%     flux(i)=dif_coef(i)*func(vertices(i));
% end
for i=1:num_vertices
    f_conv(i)=max(0,v(i))*...
        func(vertices_coordinates(i))+...
        min(0,v(i))*...
        func(vertices_coordinates(i));
end
end