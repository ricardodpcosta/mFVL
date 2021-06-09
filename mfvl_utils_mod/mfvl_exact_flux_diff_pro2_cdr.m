function flux = mfvl_exact_flux_diff_pro2_cdr(func,vertices,dif_coef)
%MFVL_EXACT_FLUX_PRO1_BENDING Summary of this function goes here
%   Detailed explanation goes here

num_vertices=numel(vertices);
flux=zeros(1,num_vertices);
for i=1:num_vertices
    flux(i)=dif_coef(i)*func(vertices(i));
end

end