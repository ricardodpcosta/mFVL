function write_results_v4(fileNameOut,caption_frame,label,...
    erro_CD_1,ordem_CD_1,...
    erro_UW_1,ordem_UW_1,...
    erro_CD_2,ordem_CD_2,...
    erro_UW_2,ordem_UW_2,I)

fid=fopen(fileNameOut,'w');
fprintf(fid,'{\\renewcommand{\\baselinestretch}{1.0}\n');
fprintf(fid,'\\begin{table}[H]\n');
fprintf(fid,'\\caption{%s}\n\n',caption_frame);
fprintf(fid,'\\setlength{\\tabcolsep}{5pt}\n');
fprintf(fid,'\\centering\n');
fprintf(fid,'\\begin{tabular}{@{}l c c c c c c c c c c@{}}\n');
fprintf(fid,'\\toprule\n');
fprintf(fid,'\\multicolumn{1}{c}{\\multirow{2}{*}{Type I}} & \\multicolumn{1}{c}{} & \\multicolumn{1}{c}{\\multirow{2}{*}{$I$}} & \\multicolumn{1}{c}{} & \\multicolumn{3}{c}{$u=100$} &  & \\multicolumn{3}{c}{$u=1$} \\\\\n');
fprintf(fid,'\\cline{5-7}\n');
fprintf(fid,'\\cline{9-11} \n');
fprintf(fid,'\\multicolumn{1}{c}{} & \\multicolumn{1}{c}{} & \\multicolumn{1}{c}{} & \\multicolumn{1}{c}{} & \\multicolumn{1}{c}{E$_{0,\\infty}$} & \\multicolumn{1}{c}{} & \\multicolumn{1}{c}{O$_{0,\\infty}$} &  & \\multicolumn{1}{c}{E$_{0,\\infty}$} &  & \\multicolumn{1}{c}{O$_{0,\\infty}$}\\\\\n');
fprintf(fid,'\\midrule\n');
%%%%%
fprintf(fid,'\\multirow{%d}{*}{\\textbf{CD}}\n',numel(I));
for j=1:numel(I)
    fprintf(fid,'&  & %d &  & %s &  & %s &  & %s &  & %s\\\\\n',I(j),erro_CD_1{j},ordem_CD_1{j},erro_CD_2{j},ordem_CD_2{j});
end
fprintf(fid,'\\midrule\n');
%%%%%
fprintf(fid,'\\multirow{%d}{*}{\\textbf{UW}}\n',numel(I));
for j=1:numel(I)
    fprintf(fid,'&  & %d &  & %s &  & %s &  & %s &  & %s\\\\\n',I(j),erro_UW_1{j},ordem_UW_1{j},erro_UW_2{j},ordem_UW_2{j});
end
%%%%%
fprintf(fid,'\\bottomrule\n');
fprintf(fid,'\\end{tabular}\n');
fprintf(fid,'\\label{%s}\n',label);
fprintf(fid,'\\end{table}}\n');

fclose(fid);
end
