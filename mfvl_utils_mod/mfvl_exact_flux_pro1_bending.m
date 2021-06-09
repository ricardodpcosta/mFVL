function tau = mfvl_exact_flux_pro1_bending(func,vertices,mu)
%MFVL_EXACT_FLUX_PRO1_BENDING Summary of this function goes here
%   Detailed explanation goes here

num_vertices=numel(vertices);
tau=zeros(1,num_vertices);
for i=1:num_vertices
    tau(i)=mu*func(vertices(i));
end

end