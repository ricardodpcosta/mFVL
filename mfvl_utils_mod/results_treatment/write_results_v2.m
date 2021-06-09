function write_results_v2(fileNameOut,caption_frame,label,e1_CD,e2_CD,e3_CD,e4_CD,o1_CD,o2_CD,o3_CD,o4_CD,e1_UW,e2_UW,e3_UW,e4_UW,o1_UW,o2_UW,o3_UW,o4_UW,I)
fid=fopen(fileNameOut,'w');

fprintf(fid,'{\\renewcommand{\\baselinestretch}{1.0}\n');
fprintf(fid,'\\begin{table}[H]\n');
fprintf(fid,'\\caption{%s}\n\n',caption_frame);
fprintf(fid,'\\footnotesize\n');
fprintf(fid,'\\centering\n');
fprintf(fid,'\\begin{tabular}{@{}l c c c c c c c c c c c c@{}}\n');
fprintf(fid,'\\toprule\n');
fprintf(fid,'\\multirow{2}{*}{Type II} & \\multirow{2}{*}{$I$} & \\multicolumn{2}{c}{$u=1$} & \\multicolumn{1}{c}{} & \\multicolumn{2}{c}{$u=100$} & \\multicolumn{1}{c}{} & \\multicolumn{2}{c}{$u=-1$} & \\multicolumn{1}{c}{} & \\multicolumn{2}{c}{$u=-100$}\\\\\n');
fprintf(fid,'\\cline{3-4}\n');
fprintf(fid,'\\cline{6-7}\n');
fprintf(fid,'\\cline{9-10}\n');
fprintf(fid,'\\cline{12-13}\n');
fprintf(fid,'&  & \\multicolumn{1}{c}{E$_{0,\\infty}$} & \\multicolumn{1}{c}{O$_{0,\\infty}$} & \\multicolumn{1}{c}{} & \\multicolumn{1}{c}{E$_{0,\\infty}$} & \\multicolumn{1}{c}{O$_{0,\\infty}$} & \\multicolumn{1}{c}{} & \\multicolumn{1}{c}{E$_{0,\\infty}$} & \\multicolumn{1}{c}{O$_{0,\\infty}$} & \\multicolumn{1}{c}{} & \\multicolumn{1}{c}{E$_{0,\\infty}$} & \\multicolumn{1}{c}{O$_{0,\\infty}$}\\\\\n');
fprintf(fid,'\\midrule\n');
%%%%%
fprintf(fid,'\\multirow{%d}{*}{\\textbf{CD}}\n',numel(I));
for j=1:numel(I)
    fprintf(fid,'& %d & %s & %s &  & %s & %s &  & %s & %s &  & %s & %s\\\\\n',I(j),e1_CD{j},o1_CD{j},e2_CD{j},o2_CD{j},e3_CD{j},o3_CD{j},e4_CD{j},o4_CD{j});
end
fprintf(fid,'\\midrule\n');
%%%%%
fprintf(fid,'\\multirow{%d}{*}{\\textbf{UW}}\n',numel(I));
for j=1:numel(I)
    fprintf(fid,'& %d & %s & %s &  & %s & %s &  & %s & %s &  & %s & %s\\\\\n',I(j),e1_UW{j},o1_UW{j},e2_UW{j},o2_UW{j},e3_UW{j},o3_UW{j},e4_UW{j},o4_UW{j});
end
%%%%%
fprintf(fid,'\\bottomrule\n');
fprintf(fid,'\\end{tabular}\n');
fprintf(fid,'\\label{%s}\n',label);
fprintf(fid,'\\end{table}}\n');

fclose(fid);
end
