% January, 2017
% inicialize the model, bound conditions for test 1 - pro

% bounds --- this is for dirichlet bound conditions
bc_left=mfvl_bound_cond1d('dirichlet',exp(domain.point(1).coord),domain.physical(1),'bc1');
switch prob_type
    case 'I'
        bc_right=mfvl_bound_cond1d('dirichlet',exp(domain.point(2).coord),domain.physical(2),'bc2'); % attention to the point
    case 'II'
        bc_right=mfvl_bound_cond1d('neumann',-exp(domain.point(2).coord),domain.physical(2),'bc2');
end
% source_term
f_term=@(x)(-1)*exp(x);
st1=mfvl_source_term1d('explicit',f_term,domain.physical(3),'st1');
% material
diff_term=@(x)0.*x+1;
ei=0;
mat=mfvl_material1d('solid',domain.physical(3),0,0,0,diff_term,ei,@(T)0,'m');
% model
reac_term=@(x)0.*x+0;
conv_term=@(x)0.*x+0;
mod=mfvl_cdr_model1d([bc_left bc_right],[],[],st1,mat,conv_term,reac_term);
% end of file