function mfvl_write_table2(file_name_out,caption_frame,num_cells,E1,O1,E2,O2)
fid=fopen(file_name_out,'w');

fprintf(fid,'\\begin{table}[H]\n');
fprintf(fid,'\\setlength{\\tabcolsep}{5pt}\n');
fprintf(fid,'\\centering\n');
fprintf(fid,'\\begin{tabular}{@{}l c c c@{}}\n');
fprintf(fid,'\\toprule\n');
fprintf(fid,' & $I$ & E$_{0,\\infty}$ & O$_{0,\\infty}$\\\\\n');
fprintf(fid,'\\midrule\n');
fprintf(fid,'\\multirow{%d}{*}{$\\hat{\\Phi}$} & %d & %s & %s\\\\\n',numel(num_cells),num_cells(1),E1{1},O1{1});
for i=2:numel(num_cells)
    fprintf(fid,' & %d & %s & %s\\\\\n',num_cells(i),E1{i},O1{i});
end
fprintf(fid,'\\bottomrule\n');

fprintf(fid,'\\toprule\n');
fprintf(fid,' & $I$ & E$_{1,\\infty}$ & O$_{1,\\infty}$\\\\\n');
fprintf(fid,'\\midrule\n');
fprintf(fid,'\\multirow{%d}{*}{$\\hat{\\Phi}''$} & %d & %s & %s\\\\\n',numel(num_cells),num_cells(1),E2{1},O2{1});
for i=2:numel(num_cells)
    fprintf(fid,' & %d & %s & %s\\\\\n',num_cells(i),E2{i},O2{i});
end
fprintf(fid,'\\bottomrule\n');
fprintf(fid,'\\end{tabular}\n');
fprintf(fid,'\\end{table}\n');

fclose(fid);
end
