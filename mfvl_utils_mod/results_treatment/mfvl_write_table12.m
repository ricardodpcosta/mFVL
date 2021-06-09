function mfvl_write_table12(file_name_out,caption_table,label,num_cells,degree,E1,O1,E2,O2,E3,O3,E4,O4,E5,O5)
% this is for presentations tables
fid=fopen(file_name_out,'w');

fprintf(fid,'\\begin{table}[H]\n');
fprintf(fid,'\\centering\n');
fprintf(fid,'\\resizebox*{!}{\\dimexpr\\textheight-4\\baselineskip\\relax}{%\n');
fprintf(fid,'\\begin{tabular}{@{}l c c c@{}}\n');
fprintf(fid,'\\toprule\n');
fprintf(fid,' & $I$ & E$_{0,I}(E_{\\infty})$ & E$_{0,I}(O_{\\infty})$\\\\\n');
fprintf(fid,'\\midrule\n');

fprintf(fid,'\\multirow{%d}{*}{$\\mathbb{P}_{%d}$}\n & %d & %s & %s\\\\\n',numel(num_cells),degree(1),num_cells(1),E1{1},O1{1});
for i=2:numel(num_cells)
    fprintf(fid,' & %d & %s & %s  \\\\\n',num_cells(i),E1{i},O1{i});
end
fprintf(fid,'\\midrule\n');

fprintf(fid,'\\multirow{%d}{*}{$\\mathbb{P}_{%d}$}\n & %d & %s & %s\\\\\n',numel(num_cells),degree(2),num_cells(1),E2{1},O2{1});
for i=2:numel(num_cells)
    fprintf(fid,' & %d & %s & %s  \\\\\n',num_cells(i),E2{i},O2{i});
end
fprintf(fid,'\\midrule\n');

fprintf(fid,'\\multirow{%d}{*}{$\\mathbb{P}_{%d}$}\n & %d & %s & %s\\\\\n',numel(num_cells),degree(3),num_cells(1),E3{1},O3{1});
for i=2:numel(num_cells)
    fprintf(fid,' & %d & %s & %s  \\\\\n',num_cells(i),E3{i},O3{i});
end
fprintf(fid,'\\midrule\n');

fprintf(fid,'\\multirow{%d}{*}{$\\mathbb{P}_{%d}$}\n & %d & %s & %s\\\\\n',numel(num_cells),degree(4),num_cells(1),E4{1},O4{1});
for i=2:numel(num_cells)
    fprintf(fid,' & %d & %s & %s  \\\\\n',num_cells(i),E4{i},O4{i});
end
fprintf(fid,'\\midrule\n');

fprintf(fid,'\\multirow{%d}{*}{$\\mathbb{P}_{%d}$}\n & %d & %s & %s\\\\\n',numel(num_cells),degree(5),num_cells(1),E5{1},O5{1});
for i=2:numel(num_cells)
    fprintf(fid,' & %d & %s & %s  \\\\\n',num_cells(i),E5{i},O5{i});
end

fprintf(fid,'\\bottomrule\n');

fprintf(fid,'\\end{tabular}}\n');
fprintf(fid,'\\end{table}');
fclose(fid);
end
