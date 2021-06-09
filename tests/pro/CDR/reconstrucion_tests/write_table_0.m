function write_table_0(file_name_out,caption_table,xf,E1,O1,E2,O2,E3,O3,E4,O4,E5,O5)
fid=fopen(file_name_out,'w');

fprintf(fid,'\\begin{table}[H]\n');
fprintf(fid,'\\centering\n');
fprintf(fid,'\\caption{%s}\n',caption_table);

fprintf(fid,'\\resizebox{\\textwidth}{!}{\\begin{tabular}{@{}l l c c l c c l c c l c c l c@{}}\n');
fprintf(fid,'\\toprule\n');
fprintf(fid,'\\multirow{2}{*}{$x_f$} & \\multicolumn{2}{l}{d=1} & & \\multicolumn{2}{l}{d=2} & & \\multicolumn{2}{l}{d=3} & & \\multicolumn{2}{l}{d=4} & & \\multicolumn{2}{l}{d=5}\\\\\n');
fprintf(fid,'\\cline{2-3} \\cline{5-6} \\cline{8-9} \\cline{11-12} \\cline{14-15}\\\n');
fprintf(fid,' & E$_{0,\\infty}$ & O$_{0,\\infty}$ & & E$_{0,\\infty}$ & O$_{0,\\infty}$ & & E$_{0,\\infty}$ & O$_{0,\\infty}$ & & E$_{0,\\infty}$ & O$_{0,\\infty}$ & & E$_{0,\\infty}$ & O$_{0,\\infty}$\\\\\n');
fprintf(fid,'\\midrule\n');
%%%%%
for i=1:numel(xf)
    fprintf(fid,' %s & %s & %s && %s & %s & & %s & %s & & %s & %s & & %s & %s\\\\\n',...
    num2str(xf(i)),E1{i},O1{i},E2{i},O2{i},E3{i},O3{i},E4{i},O4{i},E5{i},O5{i}); 
end
%%%%%
fprintf(fid,'\\bottomrule\n');
fprintf(fid,'\\end{tabular}}\n');
fprintf(fid,'\\end{table}\n');

fclose(fid);
end
% end of function