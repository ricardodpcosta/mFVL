% December, 2016
% number of cells ---> will input in geo script
num_cells_intro=[5 10 15 20 80 160];
% run the geo.m, model.m and the mesh.m
for i=1:numel(num_cells_intro)
    num_cells_cycle=num_cells_intro(i);
    geo;
    model;
    mesh;
   
    % solve
    source_term=@(x)(x.^2-1.5)*exp(x); % this will change always
    func=@(x)exp(x);
    func_diff=@(x)exp(x);
    a=@(x)1.*x+1;
    v=@(x)1.*x-0.5;
    r=@(x)1.*x.^2+0;
        
    pat{i,1}=mfvl_diff_pat(m,domain,mod,source_term,func,func_diff,a,v,r,'CD','I');
    pat{i,2}=mfvl_diff_pat(m,domain,mod,source_term,func,func_diff,a,v,r,'CD','II');
    pat{i,3}=mfvl_diff_pat(m,domain,mod,source_term,func,func_diff,a,v,r,'UW','I');
    pat{i,4}=mfvl_diff_pat(m,domain,mod,source_term,func,func_diff,a,v,r,'UW','II');
end
for i=1:size(pat,1)
    CD_I(i)=pat{i,1}.error;
    CD_II(i)=pat{i,2}.error;
    UW_I(i)=pat{i,3}.error;
    UW_II(i)=pat{i,4}.error;
end
CD_I=format_errors_orders(CD_I,numel(num_cells_intro),num_cells_intro.*2); %duplicate
CD_II=format_errors_orders(CD_II,numel(num_cells_intro),num_cells_intro.*2); %duplicate
UW_I=format_errors_orders(UW_I,numel(num_cells_intro),num_cells_intro.*2); %duplicate
UW_II=format_errors_orders(UW_II,numel(num_cells_intro),num_cells_intro.*2); %duplicate
% write table
% write_results_v1('..\Report\BIC_2017_report\tables\new_patankar_tables\test1.tex','Test 1',...
%     CD_I.e,CD_I.o,...
%     UW_I.e,UW_I.o,...
%     CD_II.e,CD_II.o,...
%     UW_II.e,UW_II.o,...
%     num_cells_intro.*2);

% end of file