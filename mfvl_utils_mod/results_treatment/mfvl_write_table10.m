function mfvl_write_table10(file_name_out,caption_table,label,num_cells,stencil_size,degree,P1)
P1_E=P1.e;
P1_O=P1.o;

fid=fopen(file_name_out,'w');

fprintf(fid,'\\begin{table}[H]\n');
fprintf(fid,'\\setlength{\\tabcolsep}{5pt}\n');
fprintf(fid,'\\centering\n');
fprintf(fid,'\\caption{%s}\n',caption_table);
fprintf(fid,'\\resizebox{\\linewidth}{!}{%%\n  \\begin{tabular}{@{}l c c c@{}}\n');
fprintf(fid,'\\toprule\n');
fprintf(fid,' & $I$ & E$_{0,\\infty}$ & O$_{0,\\infty}$\\\\\n');
fprintf(fid,'\\midrule\n');

fprintf(fid,'\\multirow{%d}{*}{$\\mathbb{P}_{%d}$(%d)}\n & %d & %s & %s\\\\\n',...
    numel(num_cells),degree(1),stencil_size(1),num_cells(1),...
    P1_E{1},P1_O{1});
for i=2:numel(num_cells)
    fprintf(fid,' & %d & %s & %s\\\\\n',...
        num_cells(i),...
        P1_E{i},P1_O{i});
end

fprintf(fid,'\\bottomrule\n');
fprintf(fid,'\\end{tabular}}\n');
fprintf(fid,'\\label{%s}\n',label);
fprintf(fid,'\\end{table}\n');
fclose(fid);
end
