% January, 2017
% inicialize the mesh

% quadrature
gauss_order=6;
quadrat=mfvl_gauss1d(gauss_order);
% mesh
m{k}=mfvl_mesh1d(quadrat,domain);
% end of file