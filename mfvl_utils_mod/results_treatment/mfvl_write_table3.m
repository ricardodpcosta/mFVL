function mfvl_write_table3(file_name_out,caption_table,label,num_cells,degree,E1,O1,E2,O2,E3,O3,E4,O4,E5,O5,E6,O6,E7,O7,E8,O8,E9,O9,E10,O10)
fid=fopen(file_name_out,'w');

fprintf(fid,'\\begin{table}[H]\n');
fprintf(fid,'\\caption{%s}\n',caption_table);
fprintf(fid,'\\setlength{\\tabcolsep}{5pt}\n');
fprintf(fid,'\\centering\n');
fprintf(fid,'\\begin{tabular}{@{}l c c c c c@{}}\n');
fprintf(fid,'\\toprule\n');
fprintf(fid,' &  & \\multicolumn{2}{c}{PRO1} & \\multicolumn{2}{c}{PRO2}\\\\\n');
fprintf(fid,'\\midrule\n');
fprintf(fid,' & $I$ & E$_{0,\\infty}$ & O$_{0,\\infty}$ & E$_{0,\\infty}$ & O$_{0,\\infty}$\\\\\n');
fprintf(fid,'\\midrule\n');

fprintf(fid,'\\multirow{%d}{*}{$\\mathbb{P}_{%d}$}\n & %d & %s & %s & %s & %s\\\\\n',numel(num_cells),degree(1),num_cells(1),E1{1},O1{1},E2{1},O2{1});
for i=2:numel(num_cells)
    fprintf(fid,' & %d & %s & %s & %s & %s \\\\\n',num_cells(i),E1{i},O1{i},E2{i},O2{i});
end
fprintf(fid,'\\midrule\n');

fprintf(fid,'\\multirow{%d}{*}{$\\mathbb{P}_{%d}$}\n & %d & %s & %s & %s & %s\\\\\n',numel(num_cells),degree(2),num_cells(1),E3{1},O3{1},E4{1},O4{1});
for i=2:numel(num_cells)
    fprintf(fid,' & %d & %s & %s & %s & %s \\\\\n',num_cells(i),E3{i},O3{i},E4{i},O4{i});
end
fprintf(fid,'\\midrule\n');

fprintf(fid,'\\multirow{%d}{*}{$\\mathbb{P}_{%d}$}\n & %d & %s & %s & %s & %s\\\\\n',numel(num_cells),degree(3),num_cells(1),E5{1},O5{1},E6{1},O6{1});
for i=2:numel(num_cells)
    fprintf(fid,' & %d & %s & %s & %s & %s \\\\\n',num_cells(i),E5{i},O5{i},E6{i},O6{i});
end
fprintf(fid,'\\midrule\n');

fprintf(fid,'\\multirow{%d}{*}{$\\mathbb{P}_{%d}$}\n & %d & %s & %s & %s & %s\\\\\n',numel(num_cells),degree(4),num_cells(1),E7{1},O7{1},E8{1},O8{1});
for i=2:numel(num_cells)
    fprintf(fid,' & %d & %s & %s & %s & %s \\\\\n',num_cells(i),E7{i},O7{i},E8{i},O8{i});
end
fprintf(fid,'\\midrule\n');

fprintf(fid,'\\multirow{%d}{*}{$\\mathbb{P}_{%d}$}\n & %d & %s & %s & %s & %s\\\\\n',numel(num_cells),degree(5),num_cells(1),E9{1},O9{1},E10{1},O10{1});
for i=2:numel(num_cells)
    fprintf(fid,' & %d & %s & %s & %s & %s \\\\\n',num_cells(i),E9{i},O9{i},E10{i},O10{i});
end
fprintf(fid,'\\bottomrule\n');
fprintf(fid,'\\end{tabular}\n');
fprintf(fid,'\\label{%s}\n',label);
fprintf(fid,'\\end{table}\n');
fclose(fid);
end