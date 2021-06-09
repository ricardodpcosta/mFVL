% December, 2016
% inicialize the mesh

gauss_order=6;
% quadrature
quadrat=mfvl_gauss1d(gauss_order);
% mesh
m{i}=mfvl_mesh1d(quadrat,domain);
% end of file