% December, 2016
% inicialize the geometry
p1=mfvl_point1d(0,'xl');
p2=mfvl_point1d(0.5,'xc1');
p3=mfvl_point1d(1,'xr');

l1=mfvl_line1d(p1,p2,num_cells_cycle,@(x)1,'l1');
l2=mfvl_line1d(p2,p3,num_cells_cycle,@(x)1,'l2');

ph1=mfvl_physical1d(p1,[],'ph1');
ph2=mfvl_physical1d(p2,[],'ph2');
ph3=mfvl_physical1d(p3,[],'ph3');
ph4=mfvl_physical1d([p1 p2],l1,'ph4');
ph5=mfvl_physical1d([p2 p3],l2,'ph5');
domain=mfvl_domain1d([p1 p2 p3],[l1 l2],[ph1 ph2 ph3 ph4 ph5]);
% end of file