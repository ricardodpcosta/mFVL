% December, 2016
% script for post-processing for test 15
clc;
clear;
load('output\test15_results.mat');
xx=linspace(0,1,1000);
y_lim_min=[0 0 0 -0.02];
y_lim_max=[0.14 0.07 0.025 0.06];
% errors
for j=1:numel(conv_term)
    func=phi_matrix{j};
    for i=1:size(pat{j},1)
        CD_II(i,j)=max(abs(pat{j}{i,1}.u_approx'-m{i}.eval_mean_value_cells(func)));
        UW_II(i,j)=max(abs(pat{j}{i,2}.u_approx'-m{i}.eval_mean_value_cells(func)));
        
        % graphs
%         plot(xx,func(xx),'b',m{i}.get_cell_centroid_all,pat{j}{i,1}.u_approx','ro',m{i}.get_cell_centroid_all,pat{j}{i,2}.u_approx','*b');
%         legend('Analytic','Numeric CD','Numeric UW','Location','northwest');
%         ylim([y_lim_min(j) y_lim_max(j)]);
%         title(['Pe=' num2str(Pe(j)) ' and I=' num2str(num_cells_intro(i))]);
%         figname1 = ['output\fig_pec_' num2str(Pe(j)) '_' num2str(i)];
%         figname2 = ['..\..\..\..\Report\BIC_2017_report\images\Patankar\fig_pec_' num2str(Pe(j)) '_' num2str(i)];
%         %print('FillPageFigure','-dpdf','-fillpage')
%         %saveas(gcf,figname1,'png');
%         
%         set(gcf,'Units','Inches');
%         pos = get(gcf,'Position');
%         set(gcf,'PaperPositionMode','Auto','PaperUnits','Inches','PaperSize',[pos(3), pos(4)]);
%         print(gcf,figname1,'-dpdf','-r0');
%         print(gcf,figname2,'-dpdf','-r0');
%         hold off;
    end
end
CD_II_1=format_errors_orders(CD_II(:,1),numel(num_cells_intro),num_cells_intro);
UW_II_1=format_errors_orders(UW_II(:,1),numel(num_cells_intro),num_cells_intro);

CD_II_2=format_errors_orders(CD_II(:,2),numel(num_cells_intro),num_cells_intro);
UW_II_2=format_errors_orders(UW_II(:,2),numel(num_cells_intro),num_cells_intro);

CD_II_3=format_errors_orders(CD_II(:,3),numel(num_cells_intro),num_cells_intro);
UW_II_3=format_errors_orders(UW_II(:,3),numel(num_cells_intro),num_cells_intro);

CD_II_4=format_errors_orders(CD_II(:,4),numel(num_cells_intro),num_cells_intro);
UW_II_4=format_errors_orders(UW_II(:,4),numel(num_cells_intro),num_cells_intro);
% write tables
label='Table:Patankar:Test15';
directory1='..\..\..\..\Report\BIC_2017_report\tables\new_patankar_tables\test15.tex';
directory2='output\test15.tex';
caption='Numerical results of Example~\ref{Example:Patankar:Test15}.';


write_results_v2(directory1,caption,label,...
    CD_II_1.e,CD_II_2.e,CD_II_3.e,CD_II_4.e,...
    CD_II_1.o,CD_II_2.o,CD_II_3.o,CD_II_4.o,...
    UW_II_1.e,UW_II_2.e,UW_II_3.e,UW_II_4.e,...
    UW_II_1.o,UW_II_2.o,UW_II_3.o,UW_II_4.o,...
    num_cells_intro);
write_results_v2(directory2,caption,label,...
    CD_II_1.e,CD_II_2.e,CD_II_3.e,CD_II_4.e,...
    CD_II_1.o,CD_II_2.o,CD_II_3.o,CD_II_4.o,...
    UW_II_1.e,UW_II_2.e,UW_II_3.e,UW_II_4.e,...
    UW_II_1.o,UW_II_2.o,UW_II_3.o,UW_II_4.o,...
    num_cells_intro);