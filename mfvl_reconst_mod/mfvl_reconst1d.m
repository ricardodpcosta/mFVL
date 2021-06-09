% November, 2016
classdef mfvl_reconst1d < handle
    properties (Access=public)
        target_type
        lsm_weight % vector
        degree
        conservation
        num_coefs
        num_lsm_weights
        ref_index
        ref_point
        stencil
        consts
        ref_value
        lsm_rhs
        lsm_lhs
        lsm_coefs
        stencil_size_factor
        stencil_size
        x_bars
        psi_bars
        mesh
        lsm_weight2 % value
    end
    methods
        function rec=mfvl_reconst1d(mesh,target_type,lsm_weight,...
                degree,conservation,num_lsm_weights,...
                cells_data,vertex_data,ref_index,stencil_size_factor,x_bar,psi_bar,stencil_size,auto_stencil_opt,scheme,...
                lsm_lhs_value,stencil_matrix)
            global mfvl_reconst_vertex;
            global mfvl_reconst_cell;
            global mfvl_conservation_mean_value;
            global mfvl_conservation_mean_value_der1;
            global mfvl_conservation_mean_value_der2;
            global mfvl_conservation_mean_value_der3;
            global mfvl_conservation_none_der1;
            global mfvl_conservation_none_der2;
            global mfvl_conservation_point_value;
            global mfvl_conservation_point_value_der1;
            global mfvl_conservation_none;
            rec.stencil_size_factor=stencil_size_factor;
            rec.ref_index=ref_index;
            rec.mesh=mesh;
            rec.lsm_weight2=lsm_weight(2);
            
            switch target_type
                case 'cell'
                    if (rec.ref_index<0) || (rec.ref_index>mesh.get_num_cells)
                        error(['ref_index :: 0<ref_index<' num2str(mesh.get_num_cells)]);
                    end
                    rec.target_type=mfvl_reconst_cell;
                    rec.ref_point=mesh.get_cell_centroid(rec.ref_index);
                case 'vertex'
                    if (rec.ref_index<0) || (rec.ref_index>mesh.get_num_vertices)
                        error(['ref_index :: 0<ref_index<' num2str(mesh.get_num_vertices)]);
                    end
                    rec.target_type=mfvl_reconst_vertex;
                    rec.ref_point=mesh.get_vertex_point(rec.ref_index);
                otherwise
                    error('target_type : target_type should be ''cell'' or ''vertex''.');
            end
            
            rec.x_bars=x_bar;
            rec.psi_bars=psi_bar;
            
            rec.degree=degree;
            switch conservation
                case 'none'
                    rec.conservation=mfvl_conservation_none;
                    rec.num_coefs=degree+1;
                case 'none_der1'
                    rec.conservation=mfvl_conservation_none_der1;
                    rec.num_coefs=degree+1;
                case 'none_der2'
                    rec.conservation=mfvl_conservation_none_der2;
                    rec.num_coefs=degree+1;
                case 'mean_value'
                    rec.conservation=mfvl_conservation_mean_value;
                    rec.num_coefs=degree;
                    if isempty(lsm_lhs_value)==0
                        rec.consts=0;
                    elseif isempty(lsm_lhs_value)==1
                        rec.consts=make_consts(rec);
                    end
                case 'mean_value_der1'
                    rec.conservation=mfvl_conservation_mean_value_der1;
                    rec.num_coefs=degree;
                    if isempty(lsm_lhs_value)==0
                        rec.consts=0;
                    elseif isempty(lsm_lhs_value)==1
                        rec.consts=make_consts(rec);
                    end
                case 'mean_value_der2'
                    rec.conservation=mfvl_conservation_mean_value_der2;
                    rec.num_coefs=degree;
                    if isempty(lsm_lhs_value)==0
                        rec.consts=0;
                    elseif isempty(lsm_lhs_value)==1
                        rec.consts=make_consts(rec);
                    end
                case 'mean_value_der3'
                    rec.conservation=mfvl_conservation_mean_value_der3;
                    rec.num_coefs=degree;
                case 'point_value'
                    rec.conservation=mfvl_conservation_point_value;
                    rec.num_coefs=degree;
                case 'point_value_der1'
                    rec.conservation=mfvl_conservation_point_value_der1;
                    rec.num_coefs=degree;
                otherwise
                    error('conservation : conservation should be ''none'', ''mean_value'',''point_value'', ''mean_value_der_1'', ''mean_value_der_2'' or ''mean_value_der_3''.');
            end
            if (rec.target_type==mfvl_reconst_cell) && (rec.conservation==mfvl_conservation_none)
                error('mfvl_reconst1d:: target_type should be ''vertex'' when the conservation is ''none''.');
            end
            switch auto_stencil_opt
                case 'auto'
                    rec.stencil_size=ceil(rec.num_coefs*rec.stencil_size_factor);
                    % verify if the number is odd and add 1 if it is
                    if mod(rec.stencil_size,2)==1
                        rec.stencil_size=rec.stencil_size+1;
                    end
                case 'user'
                    rec.stencil_size=stencil_size;
                otherwise
                    error('mfvl_reconst1d:: the auto_stencil_opt variable should be ''auto'' or ''user''.');
            end
            % weights matrix
            lsm_weight=lsm_weight(1);
            if (rec.conservation==mfvl_conservation_mean_value ||...
                    rec.conservation==mfvl_conservation_mean_value_der1 ||...
                    rec.conservation==mfvl_conservation_mean_value_der2 ||...
                    rec.conservation==mfvl_conservation_mean_value_der3)
                
                if rec.ref_index==1
                    rec.lsm_weight=[lsm_weight ones([1 rec.stencil_size-1])];
                elseif rec.ref_index==mesh.get_num_cells
                    rec.lsm_weight=[ones([1 (rec.stencil_size-1)])   lsm_weight];
                else
                    rec.lsm_weight=[repmat(lsm_weight,1,num_lsm_weights) ones([1 rec.stencil_size-num_lsm_weights])];
                end
            end
            if rec.conservation==mfvl_conservation_point_value  || rec.conservation==mfvl_conservation_point_value_der1
                if rec.ref_index==1
                    rec.lsm_weight=[lsm_weight ones([1 rec.stencil_size-1])];
                elseif rec.ref_index==mesh.get_num_vertices
                    rec.lsm_weight=[ones([1 (rec.stencil_size-1)])   lsm_weight];
                else
                    rec.lsm_weight=[repmat(lsm_weight,1,num_lsm_weights) ones([1 (rec.stencil_size-num_lsm_weights)])];
                end
            end
            if rec.conservation==mfvl_conservation_none
                rec.lsm_weight=[repmat(lsm_weight,1,num_lsm_weights) ones([1 (rec.stencil_size-num_lsm_weights)])];
            end
            if rec.conservation==mfvl_conservation_none_der1
                rec.lsm_weight=[repmat(lsm_weight,1,num_lsm_weights) ones([1 (rec.stencil_size-num_lsm_weights)])];
            end
            if rec.conservation==mfvl_conservation_none_der2
                rec.lsm_weight=[repmat(lsm_weight,1,num_lsm_weights) ones([1 (rec.stencil_size-num_lsm_weights)])];
            end
            rec.num_lsm_weights=num_lsm_weights;
            
            
            
            
            
            if isempty(stencil_matrix)==0
                rec.stencil=stencil_matrix;
            elseif isempty(stencil_matrix)==1
                rec.stencil=make_stencil(rec)';
            end
            
            
            rec.lsm_rhs=make_lsm_rhs(rec,cells_data,vertex_data);
            if isempty(lsm_lhs_value)==0
                rec.lsm_lhs=lsm_lhs_value;
            elseif isempty(lsm_lhs_value)==1
                rec.lsm_lhs=make_lsm_lhs(rec);
            end
            rec.lsm_coefs=make_lsm_coefs(rec);
            
            switch rec.conservation
                case mfvl_conservation_point_value
                    rec.ref_value=vertex_data(rec.ref_index);
                case mfvl_conservation_point_value_der1
                    rec.ref_value=vertex_data(rec.ref_index);
                case mfvl_conservation_mean_value
                    rec.ref_value=cells_data(rec.ref_index);
                case mfvl_conservation_mean_value_der1
                    rec.ref_value=cells_data(rec.ref_index);
                case mfvl_conservation_mean_value_der2
                    rec.ref_value=cells_data(rec.ref_index);
                case mfvl_conservation_mean_value_der3
                    rec.ref_value=cells_data(rec.ref_index);
                case {mfvl_conservation_none,mfvl_conservation_none_der1,mfvl_conservation_none_der2}
                    rec.ref_value=rec.lsm_coefs(1);
                otherwise
                    error('Error: invalid conservation.');
            end
        end
        % stencil matrix
        function res=make_stencil(rec)
            global mfvl_conservation_none;
            global mfvl_conservation_none_der1;
            global mfvl_conservation_none_der2;
            global mfvl_conservation_none_der3;
            global mfvl_reconst_cell;
            global mfvl_reconst_vertex;
            if rec.conservation==mfvl_conservation_none
                include_ref='yes';
            elseif rec.conservation==mfvl_conservation_none_der1
                include_ref='yes';
            elseif rec.conservation==mfvl_conservation_none_der2
                include_ref='yes';
            elseif rec.conservation==mfvl_conservation_none_der3
                include_ref='yes';
            else
                include_ref='no';
            end
            if rec.target_type==mfvl_reconst_cell
                ref_type='cell';
            end
            if rec.target_type==mfvl_reconst_vertex
                ref_type='vertex';
                include_ref='yes';
            end
            s=mfvl_stencil1d(rec.mesh,rec.ref_index,ref_type,rec.stencil_size,include_ref);
            res=s.get_stencil_all';
        end
        % M matrix
        function res=make_consts(rec)
            res=zeros([rec.degree 1]);
            for i=1:rec.degree%alpha
                a=rec.mesh.get_cell_to_vertex_map(rec.ref_index);
                p1=rec.mesh.get_vertex_point(a(1));
                p2=rec.mesh.get_vertex_point(a(2));
                res(i)=0;
                for k=1:rec.mesh.get_num_gauss_points
                    res(i)=res(i)+((rec.mesh.get_eval_point(k,p1,p2)-rec.ref_point)^i)*rec.mesh.get_weights(k);
                end
            end
        end
        % A matrix
        function A=make_lsm_lhs(rec)
            global mfvl_conservation_none;
            global mfvl_conservation_mean_value;
            global mfvl_conservation_point_value;
            global mfvl_conservation_point_value_der1;
            global mfvl_conservation_mean_value_der1;
            global mfvl_conservation_mean_value_der2;
            global mfvl_conservation_mean_value_der3;
            global mfvl_conservation_none_der1;
            global mfvl_conservation_none_der2;
            
            A=zeros([rec.stencil_size rec.degree]);
            % A matrix - non-conservative
            if (rec.conservation==mfvl_conservation_none)
                stencil_lhs=rec.stencil;
                for k=1:size(stencil_lhs,2)
                    for j=1:rec.degree+1
                        if j==1
                            A(k,j)=1;
                        else
                            a=rec.mesh.get_cell_to_vertex_map(stencil_lhs(k));
                            p1=rec.mesh.get_vertex_point(a(1));
                            p2=rec.mesh.get_vertex_point(a(2));
                            A(k,j)=0;
                            for l=1:rec.mesh.get_num_gauss_points
                                A(k,j)=A(k,j)+((rec.mesh.get_eval_point(l,p1,p2)-rec.ref_point)^(j-1))*rec.mesh.get_weights(l);
                            end
                        end
                        A(k,j)=rec.lsm_weight(k)*A(k,j);
                    end
                end
            end
            % A matrix - non-conservative der1
            if (rec.conservation==mfvl_conservation_none_der1)
                stencil_lhs=rec.stencil;
                for k=1:size(stencil_lhs,2)
                    for j=1:rec.degree+1
                        if j==1
                            A(k,j)=1;
                        else
                            a=rec.mesh.get_cell_to_vertex_map(stencil_lhs(k));
                            p1=rec.mesh.get_vertex_point(a(1));
                            p2=rec.mesh.get_vertex_point(a(2));
                            A(k,j)=0;
                            for l=1:rec.mesh.get_num_gauss_points
                                A(k,j)=A(k,j)+((rec.mesh.get_eval_point(l,p1,p2)-rec.ref_point)^(j-1))*rec.mesh.get_weights(l);
                            end
                        end
                        A(k,j)=rec.lsm_weight(k)*A(k,j);
                    end
                    for j=1:rec.degree+1 % it's correct?
                        if j==1
                            A(k+1,j)=0;
                        else
                            A(k+1,j)=(rec.lsm_weight2)*(j-1)*(rec.x_bars-rec.ref_point)^(j-2);
                        end
                    end
                end
            end
            % A matrix - non-conservative der2
            if (rec.conservation==mfvl_conservation_none_der2)
                stencil_lhs=rec.stencil;
                for k=1:size(stencil_lhs,2)
                    for j=1:rec.degree+1
                        if j==1
                            A(k,j)=1;
                        else
                            a=rec.mesh.get_cell_to_vertex_map(stencil_lhs(k));
                            p1=rec.mesh.get_vertex_point(a(1));
                            p2=rec.mesh.get_vertex_point(a(2));
                            A(k,j)=0;
                            for l=1:rec.mesh.get_num_gauss_points
                                A(k,j)=A(k,j)+((rec.mesh.get_eval_point(l,p1,p2)-rec.ref_point)^(j-1))*rec.mesh.get_weights(l);
                            end
                        end
                        A(k,j)=rec.lsm_weight(k)*A(k,j);
                    end
                    for j=1:rec.degree+1 % it's correct?
                        if j==1
                            A(k+1,j)=0;
                        else
                            A(k+1,j)=(rec.lsm_weight2)*(j-1)*(j-2)*(rec.x_bars-rec.ref_point)^(j-3);
                        end
                    end
                end
            end
            % A matrix - mean value conservation
            if (rec.conservation==mfvl_conservation_mean_value)
                stencil_lhs=rec.stencil;
                for k=1:size(stencil_lhs,2)
                    for j=1:rec.degree+1
                        a=rec.mesh.get_cell_to_vertex_map(stencil_lhs(k));
                        p1=rec.mesh.get_vertex_point(a(1));
                        p2=rec.mesh.get_vertex_point(a(2));
                        A(k,j)=0;
                        for l=1:rec.mesh.get_num_gauss_points
                            A(k,j)=A(k,j)+((rec.mesh.get_eval_point(l,p1,p2)-rec.ref_point)^(j-1))*rec.mesh.get_weights(l);
                        end
                        A(k,j)=rec.lsm_weight(k)*A(k,j);
                    end
                end
            end
            % A matrix - der1 conservation
            if (rec.conservation==mfvl_conservation_mean_value_der1)
                stencil_lhs=rec.stencil;
                for k=1:size(stencil_lhs,2)
                    for j=1:rec.degree+1
                        a=rec.mesh.get_cell_to_vertex_map(stencil_lhs(k));
                        p1=rec.mesh.get_vertex_point(a(1));
                        p2=rec.mesh.get_vertex_point(a(2));
                        A(k,j)=0;
                        for l=1:rec.mesh.get_num_gauss_points
                            A(k,j)=A(k,j)+((rec.mesh.get_eval_point(l,p1,p2)-rec.ref_point)^(j-1))*rec.mesh.get_weights(l);
                        end
                        A(k,j)=rec.lsm_weight(k)*A(k,j);
                    end
                end
                for j=1:rec.degree+1 % it's correct?
                    A(k+1,j)=(rec.lsm_weight2)*(j-1)*(rec.x_bars-rec.ref_point)^(j-2);
                    if isinf(A(k+1,j))==1 || isnan(A(k+1,j))==1
                        A(k+1,j)=0;
                    end
                end
            end
            % A matrix - der2 conservation
            if (rec.conservation==mfvl_conservation_mean_value_der2)
                stencil_lhs=rec.stencil;
                for k=1:size(stencil_lhs,2)
                    for j=1:rec.degree+1
                        a=rec.mesh.get_cell_to_vertex_map(stencil_lhs(k));
                        p1=rec.mesh.get_vertex_point(a(1));
                        p2=rec.mesh.get_vertex_point(a(2));
                        A(k,j)=0;
                        for l=1:rec.mesh.get_num_gauss_points
                            A(k,j)=A(k,j)+((rec.mesh.get_eval_point(l,p1,p2)-rec.ref_point)^(j-1))*rec.mesh.get_weights(l);
                        end
                        A(k,j)=rec.lsm_weight(k)*A(k,j);
                    end
                end
                for j=1:rec.degree+1 % it's correct?
                    A(k+1,j)=(rec.lsm_weight2)*(j-1)*(j-2)*(rec.x_bars-rec.ref_point)^(j-3);
                    if isinf(A(k+1,j))==1 || isnan(A(k+1,j))==1
                        A(k+1,j)=0;
                    end
                end
            end
            % A matrix - der3 conservation
            if (rec.conservation==mfvl_conservation_mean_value_der3)
                stencil_lhs=rec.stencil;
                for k=1:size(stencil_lhs,2)
                    for j=1:rec.degree+1
                        a=rec.mesh.get_cell_to_vertex_map(stencil_lhs(k));
                        p1=rec.mesh.get_vertex_point(a(1));
                        p2=rec.mesh.get_vertex_point(a(2));
                        A(k,j)=0;
                        for l=1:rec.mesh.get_num_gauss_points
                            A(k,j)=A(k,j)+((rec.mesh.get_eval_point(l,p1,p2)-rec.ref_point)^(j-1))*rec.mesh.get_weights(l);
                        end
                        A(k,j)=rec.lsm_weight(k)*A(k,j);
                    end
                end
                for j=1:rec.degree+1 % it's correct?
                    A(k+1,j)=(rec.lsm_weight2)*(j-1)*(j-2)*(j-3)*(rec.x_bars-rec.ref_point)^(j-4);
                    if isinf(A(k+1,j))==1 || isnan(A(k+1,j))==1
                        A(k+1,j)=0;
                    end
                end
            end
            % A matrix - point value conservation
            if (rec.conservation==mfvl_conservation_point_value)
                stencil_lhs=rec.stencil;
                for k=1:size(stencil_lhs,2)
                    for j=1:rec.degree+1
                        a=rec.mesh.get_cell_to_vertex_map(stencil_lhs(k));
                        p1=rec.mesh.get_vertex_point(a(1));
                        p2=rec.mesh.get_vertex_point(a(2));
                        A(k,j)=0;
                        for l=1:rec.mesh.get_num_gauss_points
                            A(k,j)=A(k,j)+((rec.mesh.get_eval_point(l,p1,p2)-rec.ref_point)^(j-1))*rec.mesh.get_weights(l);
                        end
                        A(k,j)=rec.lsm_weight(k)*A(k,j);
                    end
                end
                for j=1:rec.degree+1 % it's correct?
                    A(k+1,j)=(rec.lsm_weight2)*(rec.x_bars-rec.ref_point)^(j-1);
                    if isinf(A(k+1,j))==1 || isnan(A(k+1,j))==1
                        A(k+1,j)=0;
                    end
                end
            end
            % A matrix - point value der1 conservation
            if (rec.conservation==mfvl_conservation_point_value_der1)
                stencil_lhs=rec.stencil;
                for k=1:size(stencil_lhs,2)
                    for j=1:rec.degree+1
                        a=rec.mesh.get_cell_to_vertex_map(stencil_lhs(k));
                        p1=rec.mesh.get_vertex_point(a(1));
                        p2=rec.mesh.get_vertex_point(a(2));
                        A(k,j)=0;
                        for l=1:rec.mesh.get_num_gauss_points
                            A(k,j)=A(k,j)+((rec.mesh.get_eval_point(l,p1,p2)-rec.ref_point)^(j-1))*rec.mesh.get_weights(l);
                        end
                        A(k,j)=rec.lsm_weight(k)*A(k,j);
                    end
                end
                for j=1:rec.degree+1 % it's correct?
                    if j==1
                        A(k+1,j)=0;
                    else
                        A(k+1,j)=(rec.lsm_weight2)*(j-1)*(rec.x_bars-rec.ref_point)^(j-2);
                    end
                    
                    if isinf(A(k+1,j))==1 || isnan(A(k+1,j))==1
                        A(k+1,j)=0;
                    end
                end
            end
        end
        % B matrix
        function B=make_lsm_rhs(rec,cells_data,vertex_data)
            global mfvl_conservation_none;
            global mfvl_conservation_mean_value;
            global mfvl_conservation_point_value;
            global mfvl_conservation_point_value_der1;
            global mfvl_reconst_cell;
            global mfvl_reconst_vertex;
            global mfvl_conservation_mean_value_der1;
            global mfvl_conservation_mean_value_der2;
            global mfvl_conservation_mean_value_der3;
            global mfvl_conservation_none_der1;
            global mfvl_conservation_none_der2;
            % verifications
            if rec.target_type~=mfvl_reconst_cell && rec.target_type~=mfvl_reconst_vertex
                error('make_lsm_rhs :: target_type should be ''cell'' or ''vertex''.');
            end
            % stencil
            st=rec.stencil;
            % B matrix - non-conservative
            B=zeros([rec.stencil_size 1]);
            if rec.conservation==mfvl_conservation_none
                for i=1:rec.stencil_size
                    B(i,:)=rec.lsm_weight(i)*cells_data(st(i));
                end
            end
            if (rec.conservation==mfvl_conservation_none_der1) || (rec.conservation==mfvl_conservation_none_der2)
                for i=1:rec.stencil_size
                    B(i,:)=rec.lsm_weight(i)*cells_data(st(i));
                end
            end
            % B matrix - mean value conservation
            if rec.conservation==mfvl_conservation_mean_value && rec.target_type==mfvl_reconst_cell
                for i=1:rec.stencil_size
                    B(i,:)=rec.lsm_weight(i)*cells_data(st(i));
                end
            end
            
            if (rec.conservation==mfvl_conservation_mean_value_der1 ||...
                    rec.conservation==mfvl_conservation_mean_value_der2 || rec.conservation==mfvl_conservation_mean_value_der3) && rec.target_type==mfvl_reconst_cell
                for i=1:rec.stencil_size
                    B(i,:)=rec.lsm_weight(i)*cells_data(st(i));
                end
            end
            % B matrix - point value conservation
            if (rec.conservation==mfvl_conservation_point_value || rec.conservation==mfvl_conservation_point_value_der1)&& rec.target_type==mfvl_reconst_vertex
                for i=1:rec.stencil_size
                    B(i,:)=rec.lsm_weight(i)*cells_data(st(i));
                end
            end
            %             if rec.conservation==mfvl_conservation_point_value_der1 && rec.target_type==mfvl_reconst_vertex
            %                 for i=1:rec.stencil_size
            %                     B(i,:)=rec.lsm_weight(i)*(cells_data(st(i)));
            %                 end
            %             end
            % B matrix - der1 conservation value - last line
            if rec.conservation==mfvl_conservation_mean_value_der1
                B(i+1,:)=rec.lsm_weight2*rec.psi_bars;
            end
            % B matrix - der2 conservation value - last line
            if rec.conservation==mfvl_conservation_mean_value_der2
                B(i+1,:)=rec.lsm_weight2*rec.psi_bars;
            end
            % B matrix - der3 conservation value - last line
            if rec.conservation==mfvl_conservation_mean_value_der3
                B(i+1,:)=rec.lsm_weight2*rec.psi_bars;
            end
            % B matrix - der1 none conservation value - last line
            if rec.conservation==mfvl_conservation_none_der1
                B(i+1,:)=rec.lsm_weight2*rec.psi_bars;
            end
            % B matrix - der2 none conservation value - last line
            if rec.conservation==mfvl_conservation_none_der2
                B(i+1,:)=rec.lsm_weight2*rec.psi_bars;
            end
            % B matrix - der1 point value conservation - last line
            if rec.conservation==mfvl_conservation_point_value || rec.conservation==mfvl_conservation_point_value_der1
                B(i+1,:)=rec.lsm_weight2*rec.psi_bars;
            end
        end
        % R matrix
        function R=make_lsm_coefs(rec)
            A=rec.lsm_lhs;
            B=rec.lsm_rhs;
            
            
            
            if size(A,1)==size(A,2) || size(A,1)==1
                R=lsqlin(A,B);
            else
                var1=A(1:size(A,1)-1,:);
                var2=B(1:size(B,1)-1,:);
                var3=A(size(A,1),:);
                var4=B(size(B,1),:);
                R = lsqlin(var1,var2,[],[],var3,var4);
            end
        end
        
        % eval value
        function res=eval_value(rec,point)
            global mfvl_conservation_none;
            global mfvl_conservation_mean_value;
            global mfvl_conservation_point_value;
            global mfvl_conservation_point_value_der1;
            if rec.conservation==mfvl_conservation_none
                res=0;
                for i=1:rec.degree
                    res=res+rec.lsm_coefs(i+1,1)*((point-rec.ref_point)^i);
                end
            end
            if rec.conservation==mfvl_conservation_mean_value
                res=0;
                for i=1:rec.degree+1
                    res=res+rec.lsm_coefs(i,1)*((point-rec.ref_point)^(i-1));
                end
            end
            if rec.conservation==mfvl_conservation_point_value
                res=0;
                for i=1:rec.degree+1
                    res=res+rec.lsm_coefs(i,1)*((point-rec.ref_point)^(i-1));
                end
            end
            if rec.conservation==mfvl_conservation_point_value_der1
                res=0;
                for i=1:rec.degree+1
                    res=res+rec.lsm_coefs(i,1)*(i-1)*((point-rec.ref_point)^(i-2));
                end
            end
            if isinf(res)==1 || isnan(res)==1
                res=0;
            end
        end
        % evaluate the derivative
        function res=eval_deriv(rec,point,order)
            global mfvl_conservation_none;
            global mfvl_conservation_none_der1;
            global mfvl_conservation_none_der2;
            global mfvl_conservation_point_value_der1;
            switch order
                % for the 1st derivative
                case 1
                    res=0;
                    if (rec.conservation==mfvl_conservation_none) || (rec.conservation==mfvl_conservation_none_der1) || (rec.conservation==mfvl_conservation_none_der2)
                        for i=1:rec.degree+1
                            count=rec.lsm_coefs(i,1)*(i-1)*(point-rec.ref_point)^(i-2);
                            if isinf(count)==1 || isnan(count)==1
                                count=0;
                            end
                            res=res+count;
                        end
                    else
                        for i=1:rec.degree+1
                            count=rec.lsm_coefs(i,1)*(i-1)*((point-rec.ref_point)^(i-2));
                            if isinf(count)==1 || isnan(count)==1
                                count=0;
                            end
                            res=res+count;
                        end
                    end
                    % for the 2nd derivative
                case 2
                    res=0;
                    if (rec.conservation==mfvl_conservation_none) || (rec.conservation==mfvl_conservation_none_der1) || (rec.conservation==mfvl_conservation_none_der2)
                        for i=2:rec.degree
                            res=res+rec.lsm_coefs(i+1,1)*(i)*(i-1)*((point-rec.ref_point)^(i-2));
                        end
                    else
                        for i=1:rec.degree+1
                            count=rec.lsm_coefs(i,1)*(i-1)*(i-2)*((point-rec.ref_point)^(i-3));
                            if isinf(count)==1 || isnan(count)==1
                                count=0;
                            end
                            res=res+count;
                        end
                    end
                    % for the 3rd derivative
                case 3
                    res=0;
                    if (rec.conservation==mfvl_conservation_none) || (rec.conservation==mfvl_conservation_none_der1) || (rec.conservation==mfvl_conservation_none_der2)
                        for i=3:rec.degree
                            res=res+rec.lsm_coefs(i+1,1)*(i)*(i-1)*(i-2)*((point-rec.ref_point)^(i-3));
                        end
                    else
                        for i=1:rec.degree+1
                            count=rec.lsm_coefs(i,1)*(i-1)*(i-2)*(i-3)*((point-rec.ref_point)^(i-4));
                            if isinf(count)==1 || isnan(count)==1
                                count=0;
                            end
                            res=res+count;
                        end
                    end
            end
        end
        
        
        
        
        
        % Getters
        function res=get_target_type(rec)
            res=rec.target_type;
        end
        function res=get_lsm_weight(rec)
            res=rec.lsm_weight;
        end
        function res=get_degree(rec)
            res=rec.degree;
        end
        function res=get_conservation(rec)
            res=rec.conservation;
        end
        function res=get_num_coefs(rec)
            res=rec.num_coefs;
        end
        function res=get_num_lsm_weights(rec)
            res=rec.num_lsm_weights;
        end
        function res=get_ref_point(rec)
            res=rec.ref_point;
        end
        function res=get_stencil(rec)
            res=rec.stencil;
        end
        function res=get_consts(rec)
            res=rec.consts;
        end
        function res=get_ref_value(rec)
            res=rec.ref_value;
        end
        function res=get_lsm_rhs(rec)
            res=rec.lsm_rhs;
        end
        function res=get_lsm_lhs(rec)
            res=rec.lsm_lhs;
        end
        function res=get_lsm_coefs(rec)
            res=rec.lsm_coefs;
        end
        function res=get_stencil_size_factor(rec)
            res=rec.stencil_size_factor;
        end
        function res=get_stencil_size(rec)
            res=rec.stencil_size;
        end
    end
end
% end of file
