function mfvl_write_table6(file_name_out,caption_table,label,num_cells,stencil_size,degree,...
    P1,...
    P2,...
    P3,...
    P4,...
    P5,...
    P6,...
    P7,...
    P8)
P1_E=P1.e;
P1_O=P1.o;

P2_E=P2.e;
P2_O=P2.o;

P3_E=P3.e;
P3_O=P3.o;

P4_E=P4.e;
P4_O=P4.o;

P5_E=P5.e;
P5_O=P5.o;

P6_E=P6.e;
P6_O=P6.o;

P7_E=P7.e;
P7_O=P7.o;

P8_E=P8.e;
P8_O=P8.o;

fid=fopen(file_name_out,'w');

fprintf(fid,'\\begin{table}[H]\n');
fprintf(fid,'\\setlength{\\tabcolsep}{5pt}\n');
fprintf(fid,'\\centering\n');
fprintf(fid,'\\caption{%s}\n',caption_table{5});
fprintf(fid,'\\resizebox{\\linewidth}{!}{%%\n  \\begin{tabular}{@{}l c c c c c c c c c c c c@{}}\n');
fprintf(fid,'\\toprule\n');
fprintf(fid,'&  & \\multicolumn{2}{c}{%s} &  & \\multicolumn{2}{c}{%s} &  & \\multicolumn{2}{c}{%s} &  & \\multicolumn{2}{c}{%s} \\\\\n',...
    caption_table{1},caption_table{2},caption_table{3},caption_table{4});
fprintf(fid,'\\cline{3-4} \\cline{6-7} \\cline{9-10} \\cline{12-13}\n');
fprintf(fid,' & $I$ & E$_{0,\\infty}$ & O$_{0,\\infty}$ &  & E$_{0,\\infty}$ & O$_{0,\\infty}$ &  & E$_{0,\\infty}$ & O$_{0,\\infty}$ &  & E$_{0,\\infty}$ & O$_{0,\\infty}$ \\\\\n');
fprintf(fid,'\\midrule\n');

fprintf(fid,'\\multirow{%d}{*}{$\\mathbb{P}_{%d}$(%d)}\n & %d & %s & %s  &  & %s & %s &  & %s & %s &  & %s & %s\\\\\n',...
    numel(num_cells),degree(1),stencil_size(1),num_cells(1),...
    P1_E{1},P1_O{1},...
    P3_E{1},P3_O{1},...
    P5_E{1},P5_O{1},...
    P7_E{1},P7_O{1});
for i=2:numel(num_cells)
    fprintf(fid,' & %d & %s & %s  &  & %s & %s &  & %s & %s &  & %s & %s\\\\\n',...
        num_cells(i),...
        P1_E{i},P1_O{i},P3_E{i},P3_O{i},P5_E{i},P5_O{i},P7_E{i},P7_O{i});
end
fprintf(fid,'\\midrule\n');

fprintf(fid,'\\multirow{%d}{*}{$\\mathbb{P}_{%d}$(%d)}\n & %d & %s & %s  &  & %s & %s &  & %s & %s &  & %s & %s\\\\\n',...
    numel(num_cells),degree(2),stencil_size(2),num_cells(1),...
    P2_E{1},P2_O{1},...
    P4_E{1},P4_O{1},...
    P6_E{1},P6_O{1},...
    P8_E{1},P8_O{1});
for i=2:numel(num_cells)
    fprintf(fid,' & %d & %s & %s  &  & %s & %s &  & %s & %s &  & %s & %s\\\\\n',...
        num_cells(i),...
        P2_E{i},P2_O{i},P4_E{i},P4_O{i},P6_E{i},P6_O{i},P8_E{i},P8_O{i});
end

fprintf(fid,'\\bottomrule\n');
fprintf(fid,'\\end{tabular}}\n');
fprintf(fid,'\\label{%s}\n',label);
fprintf(fid,'\\end{table}\n');
fclose(fid);
end
