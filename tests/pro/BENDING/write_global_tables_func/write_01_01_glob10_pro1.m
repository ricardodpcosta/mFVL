clear all;clc;
addpath('../../../../mfvl_utils_mod/results_treatment');
addpath('../tests_01_01/test_01_01_test39_pro1/output');
addpath('../tests_01_01/test_01_01_test40_pro1/output');
addpath('../tests_01_01/test_01_01_test41_pro1/output');
addpath('../tests_01_01/test_01_01_test42_pro1/output');
load('requisites');
load('test_pro_bending_01_01_test39_pro1_results');
load('test_pro_bending_01_01_test40_pro1_results');
load('test_pro_bending_01_01_test41_pro1_results');
load('test_pro_bending_01_01_test42_pro1_results');
caption_table{1}='$\omega=1|1,1$';
caption_table{2}='$\omega=1|3,1$';
caption_table{3}='$\omega=1|3,3$';
caption_table{4}='$\omega=1|3,10$';
caption_table{5}='Numerical results of PRO1 scheme.';
file_name_out='../global_tables/table_01_01_glob10_pro1.tex';
label='PRO:bending:01_01_glob10_pro1';
mfvl_write_table6(file_name_out,caption_table,label,num_cells,stencil_size,degree,...
    p1_pro1,...
    p2_pro1,...
    p3_pro1,...
    p4_pro1,...
    p5_pro1,...
    p6_pro1,...
    p7_pro1,...
    p8_pro1);

directory2='../../../../../Report/BIC_2017_report/tables/bending_pro_tables/global_tables/table_01_01_glob10_pro1.tex';
mfvl_write_table6(file_name_out,caption_table,label,num_cells,stencil_size,degree,...
    p1_pro1,...
    p2_pro1,...
    p3_pro1,...
    p4_pro1,...
    p5_pro1,...
    p6_pro1,...
    p7_pro1,...
    p8_pro1);
