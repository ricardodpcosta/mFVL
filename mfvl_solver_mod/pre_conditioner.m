function [A,b]=pre_conditioner(num_cells,cell_centroids,...
    phi_lf_0,phi_lf_1,...
    phi_rg_0,phi_rg_1,h_val,x_rg,S)

%phi_lf_0=1;
%phi_lf_1=1;

%phi_rg_0=exp(1);
%phi_rg_1=exp(1);

%h_val=0.1;
%num_cells=1/h_val;
%vertices_coordinates=0:h_val:1;
%cell_centroids=vertices_coordinates(1:1/h_val)+h_val/2;
%x_rg=1;

%             phis=sym('phi',[1 num_cells]);
%             syms a b c d e;
%             % first cell
%             mi=cell_centroids(1);
%             eq1=['a*(mi-h/2)^4+b*(mi-h/2)^3+c*(mi-h/2)^2+d*(mi-h/2)+e=phi_lf_0'];
%             eq2=['4*a*(mi-h/2)^3+3*b*(mi-h/2)^2+2*c*(mi-h/2)+d=phi_lf_1'];
%             eq3=['a*(mi)^4+b*(mi)^3+c*(mi)^2+d*(mi)+e=phi1'];
%             eq4=['a*(mi+h)^4+b*(mi+h)^3+c*(mi+h)^2+d*(mi+h)+e=phi2'];
%             eq5=['a*(mi+2*h)^4+b*(mi+2*h)^3+c*(mi+2*h)^2+d*(mi+2*h)+e=phi3'];
%             [a_m(1),b_m(1),c_m(1),d_m(1),e_m(1)] = solve(eq1,eq2,eq3,eq4,eq5,'a','b','c','d','e');
%             clearvars a b c d e;
%             syms a b c d e;
%             % second cell
%             mi=cell_centroids(2);
%             eq1=['a*(mi-3*h/2)^4+b*(mi-3*h/2)^3+c*(mi-3*h/2)^2+d*(mi-3*h/2)+e=phi_lf_0'];
%             eq2=['a*(mi-h)^4+b*(mi-h)^3+c*(mi-h)^2+d*(mi-h)+e=phi1'];
%             eq3=['a*(mi)^4+b*(mi)^3+c*(mi)^2+d*(mi)+e=phi2'];
%             eq4=['a*(mi+h)^4+b*(mi+h)^3+c*(mi+h)^2+d*(mi+h)+e=phi3'];
%             eq5=['a*(mi+2*h)^4+b*(mi+2*h)^3+c*(mi+2*h)^2+d*(mi+2*h)+e=phi4'];
%             [a_m(2),b_m(2),c_m(2),d_m(2),e_m(2)] = solve(eq1,eq2,eq3,eq4,eq5,'a','b','c','d','e');
%             clearvars a b c d e;
%             syms a b c d e;
%             % 3 : I-2
%             for i=3:num_cells-2
%                 mi=cell_centroids(i);
%                 eq1=['a*(mi-2*h)^4+b*(mi-2*h)^3+c*(mi-2*h)^2+d*(mi-2*h)+e=phi' num2str(i-2)];
%                 eq2=['a*(mi-h)^4+b*(mi-h)^3+c*(mi-h)^2+d*(mi-h)+e=phi' num2str(i-1)];
%                 eq3=['a*(mi)^4+b*(mi)^3+c*(mi)^2+d*(mi)+e=phi' num2str(i)];
%                 eq4=['a*(mi+h)^4+b*(mi+h)^3+c*(mi+h)^2+d*(mi+h)+e=phi' num2str(i+1)];
%                 eq5=['a*(mi+2*h)^4+b*(mi+2*h)^3+c*(mi+2*h)^2+d*(mi+2*h)+e=phi' num2str(i+2)];
%
%                 [a_m(i),b_m(i),c_m(i),d_m(i),e_m(i)] = solve(eq1,eq2,eq3,eq4,eq5,'a','b','c','d','e');
%                 clearvars a b c d e;
%                 syms a b c d e;
%             end
%             % Penultimate cell
%             mi=cell_centroids(num_cells-1);
%             eq1=['a*(mi-2*h)^4+b*(mi-2*h)^3+c*(mi-2*h)^2+d*(mi-2*h)+e=phi' num2str(num_cells-3)];
%             eq2=['a*(mi-h)^4+b*(mi-h)^3+c*(mi-h)^2+d*(mi-h)+e=phi' num2str(num_cells-2)];
%             eq3=['a*(mi)^4+b*(mi)^3+c*(mi)^2+d*(mi)+e=phi' num2str(num_cells-1)];
%             eq4=['a*(mi+h)^4+b*(mi+h)^3+c*(mi+h)^2+d*(mi+h)+e=phi' num2str(num_cells)];
%             eq5=['a*(mi+3*h/2)^4+b*(mi+3*h/2)^3+c*(mi+3*h/2)^2+d*(mi+3*h/2)+e=phi_rg_0'];
%             [a_m(num_cells-1),b_m(num_cells-1),c_m(num_cells-1),d_m(num_cells-1),e_m(num_cells-1)] = solve(eq1,eq2,eq3,eq4,eq5,'a','b','c','d','e');
%             clearvars a b c d e;
%             syms a b c d e;
%             % last cell
%             mi=cell_centroids(num_cells);
%             eq1=['a*(mi-2*h)^4+b*(mi-2*h)^3+c*(mi-2*h)^2+d*(mi-2*h)+e=phi' num2str(num_cells-2)];
%             eq2=['a*(mi-h)^4+b*(mi-h)^3+c*(mi-h)^2+d*(mi-h)+e=phi' num2str(num_cells-1)];
%             eq3=['a*(mi)^4+b*(mi)^3+c*(mi)^2+d*(mi)+e=phi' num2str(num_cells)];
%             eq4=['a*(mi+h/2)^4+b*(mi+h/2)^3+c*(mi+h/2)^2+d*(mi+h/2)+e=phi_rg_0'];
%             eq5=['4*a*(mi+h/2)^3+3*b*(mi+h/2)^2+2*c*(mi+h/2)+d=phi_rg_1'];
%             [a_m(num_cells),b_m(num_cells),c_m(num_cells),d_m(num_cells),e_m(num_cells)] = solve(eq1,eq2,eq3,eq4,eq5,'a','b','c','d','e');
%             clearvars a b c d e;
%             syms a b c d e;
%
%             mi=cell_centroids(1);
%             eq{1}=matlabFunction(a_m(1));
%             eq{1}=eq{1}(h_val,phis(1),phis(2),phis(3),phi_lf_0,phi_lf_1);
%
%             mi=cell_centroids(2);
%             eq{2}=matlabFunction(a_m(2));
%             eq{2}=eq{2}(h_val,phis(1),phis(2),phis(3),phis(4),phi_lf_0);
%
%             for i=3:num_cells-2
%                 %mi=cell_centroids(i);
%                 eq{i}=matlabFunction(a_m(i));
%                 eq{i}=eq{i}(h_val,phis(i-2),phis(i-1),phis(i),phis(i+1),phis(i+2));
%             end
%
%             mi=cell_centroids(num_cells-1);
%             eq{num_cells-1}=matlabFunction(a_m(num_cells-1));
%             eq{num_cells-1}=eq{num_cells-1}(h_val,phis(num_cells-3),phis(num_cells-2),phis(num_cells-1),phis(num_cells),phi_rg_0);
%
%             mi=cell_centroids(num_cells);
%             eq{num_cells}=matlabFunction(a_m(num_cells));
%             eq{num_cells}=eq{num_cells}(h_val,phis(num_cells-2),phis(num_cells-1),phis(num_cells),phi_rg_0,phi_rg_1);
%
%             for i=1:num_cells
%                 func=char(eq{:,i});
%                 fun_vec{i}=['-24*(' func(1,:) ')==' num2str(S(i))];
%             end
%             fun_vec=strjoin(fun_vec,', ');
%
%
%             [A, b] = equationsToMatrix([fun_vec], [phis]);
%             A=double(A);
%             b=double(b);

A=zeros(num_cells);
b=zeros(num_cells,1);
% first cell
A(1,1)=-48/h_val^4;
A(1,2)=32/(3*h_val^4);
A(1,3)=-48/(25*h_val^4);
b(1)=S(1)-(64*phi_lf_1)/(5*h_val^3)-(2944*phi_lf_0)/(75*h_val^4);
% second cell
A(2,1)=8/(h_val^4);
A(2,2)=-8/(h_val^4);
A(2,3)=24/(5*h_val^4);
A(2,4)=-8/(7*h_val^4);
b(2)=S(2)+(128*phi_lf_0)/(35*h_val^4);
% third cell to I-2 cell
for i=3:num_cells-2
    A(i,i-2)=-1/(h_val^4);
    A(i,i-1)=4/(h_val^4);
    A(i,i)=-6/(h_val^4);
    A(i,i+1)=4/(h_val^4);
    A(i,i+2)=-1/(h_val^4);
    b(i)=S(i);
end
% penultimate cell
A(num_cells-1,num_cells-3)=-8/(7*h_val^4);
A(num_cells-1,num_cells-2)=24/(5*h_val^4);
A(num_cells-1,num_cells-1)=-8/(h_val^4);
A(num_cells-1,num_cells)=8/(h_val^4);
b(num_cells-1)=S(num_cells-1)+(128*phi_rg_0)/(35*h_val^4);
% last cell
A(num_cells,num_cells-2)=-48/(25*h_val^4);
A(num_cells,num_cells-1)=32/(3*h_val^4);
A(num_cells,num_cells)=-48/h_val^4;
b(num_cells)=S(num_cells)+(64*phi_rg_1)/(5*h_val^3)-(2944*phi_rg_0)/(75*h_val^4);
end

