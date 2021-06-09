% November, 2016
classdef mfvl_stencil1d < handle
    properties (Access=public)
        index
        ref_type
        size
        stencil_indexes
        include_ref
    end
    methods
        function stencil = mfvl_stencil1d(mesh,index,ref_type,size,include_ref)
            stencil.index=index;
            stencil.ref_type=ref_type;
            stencil.size=size;
            stencil.include_ref=include_ref;
            cell_to_cell=mesh.get_cell_to_cell_map_all;
            if ((stencil.size <= 0) ||stencil.size > mesh.get_num_cells)
                error(['Error: 0 < size <= ' num2str(mesh.get_num_cells)]);
            end
            if strcmp(include_ref,'yes')==0 && strcmp(include_ref,'no')==0
                error('Error: Choose between ''yes'' or ''no'' in include_ref variable');
            end
            if size >= mesh.get_num_cells && strcmp(include_ref,'no')==1
                error(['Error: When use include_ref = ''no'', check if 0 < size < ' num2str(mesh.get_num_cells-1)]);
            end
            num_new_cells=1;
            aux=1;
            stencil.stencil_indexes=[];
            switch ref_type
                case 'cell'
                    if ((stencil.index <= 0) || (stencil.index > mesh.get_num_cells))
                        error(['Error: 0<index<=' num2str(mesh.get_num_cells)]);
                    end
                    new_cells(num_new_cells) = index;
                    num_new_cells = num_new_cells+1;
                    if strcmp(include_ref,'no')==1
                        size=size+1;
                    end
                case 'vertex'
                    if ((stencil.index <= 0) || (stencil.index > mesh.get_num_vertices))
                        error(['Error: 0<index<=' num2str(mesh.get_num_vertices)]);
                    end
                    vertex_to_cell=mesh.get_vertex_to_cell_map_all;
                    c1=vertex_to_cell(1,index);
                    c2=vertex_to_cell(2,index);
                    if (c1~=0)
                        new_cells(num_new_cells) = c1;
                        num_new_cells=num_new_cells+1;
                    end
                    if (c2~=0)
                        new_cells(num_new_cells) = c2;
                        num_new_cells=num_new_cells+1;
                    end
                    if strcmp(include_ref,'yes')==0 && strcmp(include_ref,'no')==1
                        error('Error: Don''t use include_ref in Vertex case --- check if include_ref is ''yes''');
                    end
                otherwise
                    error('Error: ref_type shoud be ''Cell'' or ''Vertex'' ');
            end
            while (aux <= size)
                for i=1:num_new_cells-1
                    if (any(stencil.stencil_indexes==new_cells(i))==0)
                        stencil.stencil_indexes(aux)=new_cells(i);
                        aux=aux+1;
                    end
                    if ((aux-1)==size)
                        break;
                    end
                end
                old_cells=new_cells;
                num_old_cells=num_new_cells;
                new_cells=[];
                num_new_cells=1;
                for i=1:(num_old_cells-1)
                    c1=cell_to_cell(1,old_cells(i));
                    c2=cell_to_cell(2,old_cells(i));
                    if (c1~=0) %attention
                        if (any(old_cells==c1)==0)
                            new_cells(num_new_cells)=c1;
                            num_new_cells=num_new_cells+1;
                        end
                    end
                    if (c2~=0)
                        if (any(old_cells==c2)==0)
                            new_cells(num_new_cells)=c2;
                            num_new_cells=num_new_cells+1;
                        end
                    end
                end
            end
            if strcmp(include_ref,'no')==1
                stencil.stencil_indexes((stencil.stencil_indexes==index))=[];
            end
        end
        % getters
        function res=get_index(stencil)
            res=stencil.index;
        end
        function res=get_ref_type(stencil)
            res=stencil.ref_type;
        end
        function res=get_size(stencil)
            res=stencil.size;
        end
        function res=get_stencil(stencil,index)
            if (index<1) || (index>stencil.size)
                error(['get_stencil :: 1>index>' num2str(stencil.size)]);
            end
            res=stencil.stencil_indexes(index);
        end
        function res=get_stencil_all(stencil)
            res=stencil.stencil_indexes;
        end
        function res=get_include_ref(stencil)
            res=stencil.include_ref;
        end
    end
end
% end of file