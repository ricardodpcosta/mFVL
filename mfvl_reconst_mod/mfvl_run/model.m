% December, 2016
% inicialize the model model
bc1=mfvl_bound_cond1d('dirichlet',@(x)0,ph1,'bc1');
bc2=mfvl_bound_cond1d('neumann',@(x)0,ph2,'bc2');
st1=mfvl_source_term1d('explicit',@(x)x,ph3,'st1');

mat1=mfvl_material1d('solid',ph3,0,0,0,0,@(T)0,'m');
%mat1=mfvl_solid_steel1d(mat1,ph3,@(T)0,'m'); %in case of steel
%mat1=mfvl_liquid_water1d(mat1,ph3,@(T)0,'m'); %in case of water

mod=mfvl_cdr_model1d([bc1 bc2],[],[],st1,mat1,@(x)0,@(x)0);
% end of file