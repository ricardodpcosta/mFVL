% December, 2016
% inicialize the model, bound conditions for test 1

bc_left=mfvl_bound_cond1d('dirichlet',exp(0),ph1,'bc1');
if strcmp(type{j},'I')==1
    bc_right=mfvl_bound_cond1d('dirichlet',exp(1),ph2,'bc2');
else
    bc_right=mfvl_bound_cond1d('neumann',(-3)*exp(1),ph2,'bc2');
end
%bound.rg.I=mfvl_bound_cond1d('dirichlet',exp(1),ph2,'bc2');

st1=mfvl_source_term1d('explicit',@(x)(-3)*exp(x),ph3,'st1');

mat=mfvl_material1d('solid',ph3,0,0,0,@(x)0.*x+1,@(T)0,'m');
%mat1=mfvl_solid_steel1d(mat1,ph3,@(T)0,'m'); %in case of steel
%mat1=mfvl_liquid_water1d(mat1,ph3,@(T)0,'m'); %in case of water

mod=mfvl_cdr_model1d([bc_left bc_right],[],[],st1,mat,@(x)0.*x-2,@(x)0.*x+0);
% end of file