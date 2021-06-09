% December, 2016
% inicialize the model, bound conditions for test 4
bound.lf=mfvl_bound_cond1d('dirichlet',exp(0),ph1,'bc1');

bound.rg.I=mfvl_bound_cond1d('dirichlet',exp(1),ph2,'bc2_I');
bound.rg.II=mfvl_bound_cond1d('neumann',(-0.5)*exp(1),ph2,'bc2_II');

f_term=@(x)(x-0.5)*exp(x);
st1=mfvl_source_term1d('explicit',f_term,ph3,'st1');

diff_term=@(x)0.*x+1;
mat=mfvl_material1d('solid',ph3,0,0,0,diff_term,@(T)0,'m');
%mat1=mfvl_solid_steel1d(mat1,ph3,@(T)0,'m'); %in case of steel
%mat1=mfvl_liquid_water1d(mat1,ph3,@(T)0,'m'); %in case of water
conv_term=@(x)1.*x-0.5;
reac_term=@(x)0.*x+0;
mod=mfvl_cdr_model1d([bound.lf bound.rg.I],[],[],st1,mat,conv_term,reac_term);
% end of file