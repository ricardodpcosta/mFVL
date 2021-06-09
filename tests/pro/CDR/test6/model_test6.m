% January, 2017
% inicialize the model, bound conditions for test 6 - PRO

% bounds --- this is for dirichlet bound conditions
bc_left=mfvl_bound_cond1d('dirichlet',exp(0),ph1,'bc1');
bc_right=mfvl_bound_cond1d('dirichlet',exp(1),ph2,'bc2');
% source_term
f_term=@(x)(-x-2)*exp(x);
st1=mfvl_source_term1d('explicit',f_term,ph3,'st1');
% material
diff_term=@(x)1.*x+1;
ei=0;
mat=mfvl_material1d('solid',ph3,0,0,0,diff_term,ei,@(T)0,'m');
% model
reac_term=@(x)0.*x+0;
conv_term=@(x)0.*x+0;
mod=mfvl_cdr_model1d([bc_left bc_right],[],[],st1,mat,conv_term,reac_term);
% end of file
