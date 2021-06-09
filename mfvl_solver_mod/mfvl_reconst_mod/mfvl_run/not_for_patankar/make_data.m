% November, 2016
% make_data
function [rec_point,rec_none]=make_data(m,degree,cells_data,vertex_data)
profiler=0;
if profiler==1
    profile on
end
rec_none=make_none(m,degree,cells_data);
rec_point=make_point_value(m,degree,cells_data,vertex_data);
if profiler==1
    profile viewer
end
end

function rec=make_none(m,degree,cells_data)
num_vertices=m.get_num_vertices;
target_type='vertex';
lsm_weight=1;
num_lsm_weights=2;
conservation='none';
stencil_size_factor=1;
rec=cell(max(num_vertices)-2,numel(num_vertices));
for k=1:numel(num_vertices)
    vertex_data=0;
    for i=2:num_vertices(k)-1
        ref_index=i;
        rec{i-1,k}=mfvl_reconst1d(m,target_type,lsm_weight,degree,conservation,num_lsm_weights,cells_data,vertex_data,ref_index,stencil_size_factor);
    end
end
end

function rec=make_point_value(m,degree,cells_data,vertex_data)
target_type='vertex';
lsm_weight=1;
num_lsm_weights=2;
conservation='point_value';
stencil_size_factor=1.5;
num_cells=m.get_num_cells;
num_vertices=m.get_num_vertices;
rec=cell(max(num_vertices)+1,numel(num_vertices));
for k=1:numel(num_cells)
    rec{1,k}=mfvl_reconst1d(m,target_type,lsm_weight,degree,conservation,num_lsm_weights,cells_data,vertex_data,1,stencil_size_factor);
    conservation='mean_value';
    target_type='cell';
    x=2;
    for i=1:num_cells(k)
        ref_index=i;
        rec{x,k}=mfvl_reconst1d(m,target_type,lsm_weight,degree,conservation,num_lsm_weights,cells_data,vertex_data,ref_index,stencil_size_factor);
        x=x+1;
    end
    conservation='point_value';
    target_type='vertex';
    rec{x,k}=mfvl_reconst1d(m,target_type,lsm_weight,degree,conservation,num_lsm_weights,cells_data,vertex_data,num_vertices(k),stencil_size_factor);
end
end
% end of file