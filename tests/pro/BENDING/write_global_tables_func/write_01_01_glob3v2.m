clear all;clc;
addpath('../../../mfvl_utils_mod/results_treatment');
addpath('test_01_01_test9v2/output');
addpath('test_01_01_test10v2/output');
addpath('test_01_01_test11v2/output');
addpath('test_01_01_test12v2/output');
load('test_pro_bending_01_01_test9v2_results');
load('test_pro_bending_01_01_test10v2_results');
load('test_pro_bending_01_01_test11v2_results');
load('test_pro_bending_01_01_test12v2_results');
caption_table{1}='$\omega=1|1,1$';
caption_table{2}='$\omega=1|3,1$';
caption_table{3}='$\omega=1|3,3$';
caption_table{4}='$\omega=1|3,10$';
caption_table{5}='Numerical results of PRO1 scheme to the example~\ref{Example:PRO:bending:01_01_glob3v2}.';
file_name_out='table_01_01_glob3v2.tex';
label='PRO:bending:01_01_glob3v2';
mfvl_write_table6(file_name_out,caption_table,label,num_cells,stencil_size,degree,...
    P1_PRO1,...
    P2_PRO1,...
    P3_PRO1,...
    P4_PRO1,...
    P5_PRO1,...
    P6_PRO1,...
    P7_PRO1,...
    P8_PRO1,...
    P9_PRO1,...
    P10_PRO1,...
    P11_PRO1,...
    P12_PRO1);

directory2='../../../../Report/BIC_2017_report/tables/bending_pro_tables/global_tables/table_01_01_glob3v2.tex';
mfvl_write_table6(directory2,caption_table,label,num_cells,stencil_size,degree,...
    P1_PRO1,...
    P2_PRO1,...
    P3_PRO1,...
    P4_PRO1,...
    P5_PRO1,...
    P6_PRO1,...
    P7_PRO1,...
    P8_PRO1,...
    P9_PRO1,...
    P10_PRO1,...
    P11_PRO1,...
    P12_PRO1);
