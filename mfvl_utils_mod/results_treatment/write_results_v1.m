function write_results_v1(fileNameOut,caption_frame,label,erros_CD_tipoI,ordens_CD_tipoI,erros_UW_tipoI,ordens_UW_tipoI,erros_CD_tipoII,ordens_CD_tipoII,erros_UW_tipoII,ordens_UW_tipoII,I)
fid=fopen(fileNameOut,'w');

fprintf(fid,'{\\renewcommand{\\baselinestretch}{1.0}\n');
fprintf(fid,'\\begin{table}[H]\n');
fprintf(fid,'\\caption{%s}\n\n',caption_frame);
fprintf(fid,'\\setlength{\\tabcolsep}{5pt}\n');
fprintf(fid,'\\centering\n');
fprintf(fid,'\\begin{tabular}{@{}l c c c c c c c c c c@{}}\n');
fprintf(fid,'\\toprule\n');
fprintf(fid,'\\multirow{2}{*}{Type} &  & \\multirow{2}{*}{$I$} &  & \\multicolumn{3}{c}{CD} &  & \\multicolumn{3}{c}{UW} \\\\\n');
fprintf(fid,'\\cline{5-7}\n');
fprintf(fid,'\\cline{9-11}\n');
fprintf(fid,' & & & & E$_{0,\\infty}$ & & O$_{0,\\infty}$ & & E$_{0,\\infty}$ & & O$_{0,\\infty}$\\\\\n');
fprintf(fid,'\\midrule\n');
%%%%%
fprintf(fid,'\\multirow{4}{*}{\\textbf{I}} \n'); 
for j=1:numel(I)
    fprintf(fid,' & & %d & & %s & & %s & & %s & & %s\\\\\n',I(j),erros_CD_tipoI{j},ordens_CD_tipoI{j},erros_UW_tipoI{j},ordens_UW_tipoI{j});
end
fprintf(fid,'\\midrule\n');
fprintf(fid,'\\multirow{4}{*}{\\textbf{II}} \n'); 
for j=1:numel(I)
    fprintf(fid,' & & %d & & %s & & %s & & %s & & %s\\\\\n',I(j),erros_CD_tipoII{j},ordens_CD_tipoII{j},erros_UW_tipoII{j},ordens_UW_tipoII{j});    
end
%%%%%
fprintf(fid,'\\bottomrule\n');
fprintf(fid,'\\end{tabular}\n');
fprintf(fid,'\\label{%s}\n',label);
fprintf(fid,'\\end{table}}\n');
fclose(fid);
end

