function mfvl_write_table4(file_name_out,caption_table,label,num_cells,degree,E1,O1,E2,O2)
fid=fopen(file_name_out,'w');

fprintf(fid,'\\begin{table}[H]\n');
fprintf(fid,'\\caption{%s}\n',caption_table);
fprintf(fid,'\\setlength{\\tabcolsep}{5pt}\n');
fprintf(fid,'\\centering\n');
fprintf(fid,'\\begin{tabular}{@{}l c c c@{}}\n');
fprintf(fid,'\\toprule\n');
fprintf(fid,' &  & \\multicolumn{2}{c}{PRO1}\\\\\n');
fprintf(fid,'\\midrule\n');
fprintf(fid,' & $I$ & E$_{0,\\infty}$ & O$_{0,\\infty}$\\\\\n');
fprintf(fid,'\\midrule\n');

fprintf(fid,'\\multirow{%d}{*}{$\\mathbb{P}_{%d}$}\n & %d & %s & %s\\\\\n',numel(num_cells),degree(1),num_cells(1),E1{1},O1{1});
for i=2:numel(num_cells)
    fprintf(fid,' & %d & %s & %s\\\\\n',num_cells(i),E1{i},O1{i});
end
fprintf(fid,'\\midrule\n');

fprintf(fid,'\\multirow{%d}{*}{$\\mathbb{P}_{%d}$}\n & %d & %s & %s\\\\\n',numel(num_cells),degree(2),num_cells(1),E2{1},O2{1});
for i=2:numel(num_cells)
    fprintf(fid,' & %d & %s & %s\\\\\n',num_cells(i),E2{i},O2{i});
end
fprintf(fid,'\\bottomrule\n');
fprintf(fid,'\\end{tabular}\n');
fprintf(fid,'\\label{%s}\n',label);
fprintf(fid,'\\end{table}\n');
fclose(fid);
end
