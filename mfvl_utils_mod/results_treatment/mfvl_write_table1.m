function mfvl_write_table1(file_name_out,caption_frame,num_cells,d,size_of_stencil,E1,O1,E2,O2,E3,O3,E4,O4,E5,O5,E6,O6,E7,O7,E8,O8)
fid=fopen(file_name_out,'w');

fprintf(fid,'\\begin{table}[H]\n');

fprintf(fid,'\\setlength{\\tabcolsep}{5pt}\n');
fprintf(fid,'\\centering\n');
fprintf(fid,'\\resizebox{\\textwidth}{!}{\\begin{tabular}{@{}l c c c c c c c@{}}\n');
fprintf(fid,'\\toprule\n');
fprintf(fid,'d & n$_{{\\hat{S}}}$ & $I$ & E$_{0,\\infty}$ & O$_{0,\\infty}$ & E$_{1,\\infty}$ & O$_{1,\\infty}$\\\\\n');
fprintf(fid,'\\midrule\n');
%%%%%
fprintf(fid,'\\multirow{%d}{*}{%d} & \\multirow{%d}{*}{%d} & %d & %s & %s & %s & %s\\\\\n',...
    numel(num_cells),d(1),numel(num_cells),size_of_stencil(1),num_cells(1),E1{1},O1{1},E2{1},O2{1}); 
for i=2:numel(num_cells)
    fprintf(fid,' &  & %d & %s & %s & %s & %s\\\\\n',num_cells(i),E1{i},O1{i},E2{i},O2{i});
end
fprintf(fid,'\\midrule\n');

fprintf(fid,'\\multirow{%d}{*}{%d} & \\multirow{%d}{*}{%d} & %d & %s & %s & %s & %s\\\\\n',numel(num_cells),d(2),numel(num_cells),size_of_stencil(2),num_cells(1),E3{1},O3{1},E4{1},O4{1}); 
for i=2:numel(num_cells)
    fprintf(fid,' &  & %d & %s & %s & %s & %s\\\\\n',num_cells(i),E3{i},O3{i},E4{i},O4{i});
end
fprintf(fid,'\\midrule\n');

fprintf(fid,'\\multirow{%d}{*}{%d} & \\multirow{%d}{*}{%d} & %d & %s & %s & %s & %s\\\\\n',numel(num_cells),d(3),numel(num_cells),size_of_stencil(3),num_cells(1),E5{1},O5{1},E6{1},O6{1}); 
for i=2:numel(num_cells)
    fprintf(fid,' &  & %d & %s & %s & %s & %s\\\\\n',num_cells(i),E5{i},O5{i},E6{i},O6{i});
end
fprintf(fid,'\\midrule\n');

fprintf(fid,'\\multirow{%d}{*}{%d} & \\multirow{%d}{*}{%d} & %d & %s & %s & %s & %s\\\\\n',numel(num_cells),d(4),numel(num_cells),size_of_stencil(4),num_cells(1),E7{1},O7{1},E8{1},O8{1}); 
for i=2:numel(num_cells)
    fprintf(fid,' &  & %d & %s & %s & %s & %s\\\\\n',num_cells(i),E7{i},O7{i},E8{i},O8{i});
end
%%%%%
fprintf(fid,'\\bottomrule\n');
fprintf(fid,'\\end{tabular}}\n');
fprintf(fid,'\\end{table}\n');

fclose(fid);
end
