function mfvl_write_table13(file_name_out,caption_table,label,num_cells,degree,condition,...
    P1_L1_E,P1_L1_O,P1_E,P1_O,P1_cons_L1_E,P1_cons_L1_O,...
    P2_L1_E,P2_L1_O,P2_E,P2_O,P2_cons_L1_E,P2_cons_L1_O,...
    P3_L1_E,P3_L1_O,P3_E,P3_O,P3_cons_L1_E,P3_cons_L1_O,...
    P4_L1_E,P4_L1_O,P4_E,P4_O,P4_cons_L1_E,P4_cons_L1_O,...
    P5_L1_E,P5_L1_O,P5_E,P5_O,P5_cons_L1_E,P5_cons_L1_O,...
    checkmarks)
% this is for presentations tables
fid=fopen(file_name_out,'w');

fprintf(fid,'\\begin{table}[H]\n');
fprintf(fid,'\\centering\n');
fprintf(fid,'\\caption{%s}\n',caption_table);
fprintf(fid,'\\begin{tabular}{@{}l c c c l c c l c c l c c@{}}\n');
fprintf(fid,'\\toprule\n');
fprintf(fid,' & $I$ & cond(A) & $A^{-1}\\geq 0$ &  E$_{c,1}$ & O$_{c,1}$ && E$_1$ & O$_1$ && E$_{\\infty}$ & O$_{\\infty}$\\\\\n');  
fprintf(fid,'\\midrule\n');

fprintf(fid,'\\multirow{%d}{*}{$\\mathbb{P}_{%d}$}\n & %d & %s & %s & %s & %s && %s & %s && %s & %s\\\\\n',numel(num_cells),degree(1),num_cells(1),condition{1,1},checkmarks{1,1},...
    P1_cons_L1_E{1},P1_cons_L1_O{1},P1_L1_E{1},P1_L1_O{1},P1_E{1},P1_O{1});
for i=2:numel(num_cells)
    fprintf(fid,' & %d & %s & %s & %s & %s && %s & %s && %s & %s\\\\\n',num_cells(i),condition{i,1},checkmarks{i,1},...
        P1_cons_L1_E{i},P1_cons_L1_O{i},P1_L1_E{i},P1_L1_O{i},P1_E{i},P1_O{i});
end
fprintf(fid,'\\midrule\n');

fprintf(fid,'\\multirow{%d}{*}{$\\mathbb{P}_{%d}$}\n & %d & %s & %s & %s & %s && %s & %s && %s & %s\\\\\n',numel(num_cells),degree(2),num_cells(1),condition{1,2},checkmarks{1,2},...
    P2_cons_L1_E{1},P2_cons_L1_O{1},P2_L1_E{1},P2_L1_O{1},P2_E{1},P2_O{1});
for i=2:numel(num_cells)
    fprintf(fid,' & %d & %s & %s & %s & %s && %s & %s && %s & %s\\\\\n',num_cells(i),condition{i,2},checkmarks{i,2},...
        P2_cons_L1_E{i},P2_cons_L1_O{i},P2_L1_E{i},P2_L1_O{i},P2_E{i},P2_O{i});
end
fprintf(fid,'\\midrule\n');

fprintf(fid,'\\multirow{%d}{*}{$\\mathbb{P}_{%d}$}\n & %d & %s & %s & %s & %s && %s & %s && %s & %s\\\\\n',numel(num_cells),degree(3),num_cells(1),condition{1,3},checkmarks{1,3},...
    P3_cons_L1_E{1},P3_cons_L1_O{1},P3_L1_E{1},P3_L1_O{1},P3_E{1},P3_O{1});
for i=2:numel(num_cells)
    fprintf(fid,' & %d & %s & %s & %s & %s && %s & %s && %s & %s\\\\\n',num_cells(i),condition{i,3},checkmarks{i,3},...
        P3_cons_L1_E{i},P3_cons_L1_O{i},P3_L1_E{i},P3_L1_O{i},P3_E{i},P3_O{i});
end
fprintf(fid,'\\midrule\n');

fprintf(fid,'\\multirow{%d}{*}{$\\mathbb{P}_{%d}$}\n & %d & %s & %s & %s & %s && %s & %s && %s & %s\\\\\n',numel(num_cells),degree(4),num_cells(1),condition{1,4},checkmarks{1,4},...
    P4_cons_L1_E{1},P4_cons_L1_O{1},P4_L1_E{1},P4_L1_O{1},P4_E{1},P4_O{1});
for i=2:numel(num_cells)
    fprintf(fid,' & %d & %s & %s & %s & %s && %s & %s && %s & %s\\\\\n',num_cells(i),condition{i,4},checkmarks{i,4},...
        P4_cons_L1_E{i},P4_cons_L1_O{i},P4_L1_E{i},P4_L1_O{i},P4_E{i},P4_O{i});
end
fprintf(fid,'\\midrule\n');

fprintf(fid,'\\multirow{%d}{*}{$\\mathbb{P}_{%d}$}\n & %d & %s & %s & %s & %s && %s & %s && %s & %s\\\\\n',numel(num_cells),degree(5),num_cells(1),condition{1,5},checkmarks{1,5},...
    P5_cons_L1_E{1},P5_cons_L1_O{1},P5_L1_E{1},P5_L1_O{1},P5_E{1},P5_O{1});
for i=2:numel(num_cells)
    fprintf(fid,' & %d & %s & %s & %s & %s && %s & %s && %s & %s\\\\\n',num_cells(i),condition{i,5},checkmarks{i,5},...
        P5_cons_L1_E{i},P5_cons_L1_O{i},P5_L1_E{i},P5_L1_O{i},P5_E{i},P5_O{i});
end
fprintf(fid,'\\bottomrule\n');

fprintf(fid,'\\end{tabular}\n');
fprintf(fid,'\\end{table}');
fclose(fid);
end
