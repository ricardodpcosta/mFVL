% January, 2017
% inicialize the geometry for test 3 -PRO
% points
p1=mfvl_point1d(0,'xl');
p2=mfvl_point1d(1,'xr');
% lines
l1=mfvl_line1d(p1,p2,num_cells(k),@(x)1,'l1');
% physicals
ph1=mfvl_physical1d(p1,[],'ph1');
ph2=mfvl_physical1d(p2,[],'ph2');
ph3=mfvl_physical1d([p1 p2],l1,'ph3');
% domain
domain=mfvl_domain1d([p1 p2],l1,[ph1 ph2 ph3]);
% end of file