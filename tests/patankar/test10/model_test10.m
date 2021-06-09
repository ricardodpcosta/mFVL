% December, 2016
% inicialize the model, bound conditions for test 10
syms x;
phi(x)=(1/Pe(j))*(x-(exp(Pe(j)*x)-1)/(exp(Pe(j))-1));
f_term(x)=-(diff(phi(x),2))+diff(u(j)*phi(x));
phi=matlabFunction(phi);
phi_matrix{j}=phi;
f_term=matlabFunction(f_term);

bound.lf=mfvl_bound_cond1d('dirichlet',phi(0),ph1,'bc1');
phi_diff(x)=diff(phi(x));
bc(x)=-phi_diff(x)+u(j)*phi(x);
bc=double(bc(1));
bound.rg.I=mfvl_bound_cond1d('dirichlet',phi(1),ph2,'bc2_I');
bound.rg.II=mfvl_bound_cond1d('neumann',bc,ph2,'bc2_II');

st1=mfvl_source_term1d('explicit',f_term,ph3,'st1');

diff_term=@(x)0.*x+1;
mat=mfvl_material1d('solid',ph3,0,0,0,diff_term,@(T)0,'m');
%mat1=mfvl_solid_steel1d(mat1,ph3,@(T)0,'m'); %in case of steel
%mat1=mfvl_liquid_water1d(mat1,ph3,@(T)0,'m'); %in case of water
reac_term=@(x)0.*x+0;
mod=mfvl_cdr_model1d([bound.lf bound.rg.I],[],[],st1,mat,conv_term{j},reac_term);
clearvars x phi f_term phi_diff bc; 
% end of file