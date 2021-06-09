function mfvl_symcomp_tables_02_02(file_name_out,caption_table,label,num_cells,degree,p1_l_inf,p1_l_1,...
    p2_l_inf,p2_l_1,p3_l_inf,p3_l_1,p4_l_inf,p4_l_1)

p1_inf_e=p1_l_inf.e;
p1_inf_o=p1_l_inf.o;

p1_1_e=p1_l_1.e;
p1_1_o=p1_l_1.o;
%
p2_inf_e=p2_l_inf.e;
p2_inf_o=p2_l_inf.o;

p2_1_e=p2_l_1.e;
p2_1_o=p2_l_1.o;
%
p3_inf_e=p3_l_inf.e;
p3_inf_o=p3_l_inf.o;

p3_1_e=p3_l_1.e;
p3_1_o=p3_l_1.o;
%
p4_inf_e=p4_l_inf.e;
p4_inf_o=p4_l_inf.o;

p4_1_e=p4_l_1.e;
p4_1_o=p4_l_1.o;
%
% p5_inf_e=p5_l_inf.e;
% p5_inf_o=p5_l_inf.o;
% 
% p5_1_e=p5_l_1.e;
% p5_1_o=p5_l_1.o;
% %
% p6_inf_e=p6_l_inf.e;
% p6_inf_o=p6_l_inf.o;
% 
% p6_1_e=p6_l_1.e;
% p6_1_o=p6_l_1.o;
%
fid=fopen(file_name_out,'w');

fprintf(fid,'\\begin{table}[H]\n');
fprintf(fid,'\\setlength{\\tabcolsep}{5pt}\n');
fprintf(fid,'\\centering\n');
fprintf(fid,'\\caption{%s}\n',caption_table);
fprintf(fid,'\\resizebox{\\linewidth}{!}{%%\n  \\begin{tabular}{@{}l c c c c c c c c c c@{}}\n');
fprintf(fid,'\\toprule\n');
fprintf(fid,'& & \\multicolumn{4}{c}{$\\omega=1|1$} &  & \\multicolumn{4}{c}{$\\omega=1|3$}\\\\\n');
fprintf(fid,'\\cline{3-6} \\cline{8-11} \\\\\n');
fprintf(fid,'& $I$ & E$_{0,1}$ & O$_{0,1}$ & E$_{0,\\infty}$ & O$_{0,\\infty}$ &  & E$_{0,1}$ & O$_{0,1}$ & E$_{0,\\infty}$ & O$_{0,\\infty}$\\\\\n');
fprintf(fid,'\\midrule\n');
fprintf(fid,'\\multirow{%d}{*}{$\\mathbb{P}_{%d}$(d)}\n & %d & %s & %s  & %s & %s &  & %s & %s & %s & %s\\\\\n',...
    numel(num_cells),degree(1),num_cells(1),...
    p1_1_e{1},p1_1_o{1},...
    p1_inf_e{1},p1_inf_o{1},...
    p2_1_e{1},p2_1_o{1},...
    p2_inf_e{1},p2_inf_o{1});
for i=2:numel(num_cells)
    fprintf(fid,' & %d & %s & %s  & %s & %s &  & %s & %s & %s & %s\\\\\n',...
    num_cells(i),...
    p1_1_e{i},p1_1_o{i},...
    p1_inf_e{i},p1_inf_o{i},...
    p2_1_e{i},p2_1_o{i},...
    p2_inf_e{i},p2_inf_o{i});
end
fprintf(fid,'\\midrule\n');
%%%
fprintf(fid,'\\multirow{%d}{*}{$\\mathbb{P}_{%d}$(d+1)}\n & %d & %s & %s  & %s & %s &  & %s & %s & %s & %s\\\\\n',...
    numel(num_cells),degree(1),num_cells(1),...
    p3_1_e{1},p3_1_o{1},...
    p3_inf_e{1},p3_inf_o{1},...
    p4_1_e{1},p4_1_o{1},...
    p4_inf_e{1},p4_inf_o{1});
for i=2:numel(num_cells)
    fprintf(fid,' & %d & %s & %s  & %s & %s &  & %s & %s & %s & %s\\\\\n',...
    num_cells(i),...
    p3_1_e{i},p3_1_o{i},...
    p3_inf_e{i},p3_inf_o{i},...
    p4_1_e{i},p4_1_o{i},...
    p4_inf_e{i},p4_inf_o{i});
end
% fprintf(fid,'\\midrule\n');
%%%
% fprintf(fid,'\\multirow{%d}{*}{$\\mathbb{P}_{%d}$(d+2)}\n & %d & %s & %s  & %s & %s &  & %s & %s & %s & %s\\\\\n',...
%     numel(num_cells),degree(1),num_cells(1),...
%     p5_1_e{1},p5_1_o{1},...
%     p5_inf_e{1},p5_inf_o{1},...
%     p6_1_e{1},p6_1_o{1},...
%     p6_inf_e{1},p6_inf_o{1});
% for i=2:numel(num_cells)
%     fprintf(fid,' & %d & %s & %s  & %s & %s &  & %s & %s & %s & %s\\\\\n',...
%     num_cells(i),...
%     p5_1_e{i},p5_1_o{i},...
%     p5_inf_e{i},p5_inf_o{i},...
%     p6_1_e{i},p6_1_o{i},...
%     p6_inf_e{i},p6_inf_o{i});
% end

fprintf(fid,'\\bottomrule\n');
fprintf(fid,'\\end{tabular}}\n');
fprintf(fid,'\\label{%s}\n',label);
fprintf(fid,'\\end{table}\n');
fclose(fid);
end
