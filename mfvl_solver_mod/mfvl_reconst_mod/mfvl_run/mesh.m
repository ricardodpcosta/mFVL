% December, 2016
% inicialize the mesh

gauss_order=6;

% quadrature
quadrat=mfvl_gauss1d(gauss_order);

% left_bound=p1.get_coord;
% right_bound=p2.get_coord;
%density_function=@(x)1;

% o objeto domain
m=mfvl_mesh1d(quadrat,domain);
% end of file