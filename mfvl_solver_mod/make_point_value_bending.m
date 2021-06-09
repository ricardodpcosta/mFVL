     function rec=make_point_value_bending(pro,degree,weight,cells_data,vertex_data,stencil_size,auto_stencil_opt)
            global mfvl_bound_cond_type01;
            global mfvl_bound_cond_type02;
            global mfvl_bound_cond_type23;
            global a_matrix;
            global stencil_matrix;
            
            x_bar=0;
            psi_bar=0;
            target_type='vertex';
            lsm_weight=weight;
            num_lsm_weights=2;
            conservation='point_value';
            stencil_size_factor=1.5;
            
            num_cells=pro.mesh.get_num_cells;
            num_vertices=pro.mesh.get_num_vertices;

            rec=cell(num_vertices+1,1);
            % point value conservation for the 1st vertex
            if isempty(a_matrix{1})==1
                a_matrix_value=[];
            else
                a_matrix_value=a_matrix{1};
            end
            if isempty(stencil_matrix{1})==1
                stencil=[];
            else
                stencil=stencil_matrix{1};
            end
            rec{1}=mfvl_reconst1d(pro.mesh,...
                target_type,lsm_weight,...
                degree,conservation,num_lsm_weights,cells_data,vertex_data,1,stencil_size_factor,x_bar,psi_bar,stencil_size,auto_stencil_opt,pro.pro_scheme,...
                a_matrix_value,stencil);
            if isempty(a_matrix{1})==1
                a_matrix{1}=rec{1}.get_lsm_lhs;
            end
            if isempty(stencil_matrix{1})==1
                stencil_matrix{1}=rec{1}.get_stencil;
            end
                % der1 or der2 conservation for the first cell
                target_type='cell';
                if pro.model.bound_cond(1).get_type==mfvl_bound_cond_type01
                    conservation='mean_value_der1';
                    x_bar=pro.get_model.get_bound_cond(1).get_physical.get_point(1).get_coord;
                    psi_bar=pro.get_model.get_bound_cond(1).get_value(2);
                    if strcmp(pro.pro_scheme,'pro1')==1
                        degree_rec=degree;
                    end
                    if strcmp(pro.pro_scheme,'pro2')==1
                        degree_rec=degree;
                    end
                    if strcmp(pro.pro_scheme,'pro3')==1
                        degree_rec=degree+1;
                    end
                end
                if pro.model.bound_cond(1).get_type==mfvl_bound_cond_type02
                    conservation='mean_value_der2';
                    x_bar=pro.get_model.get_bound_cond(1).get_physical.get_point(1).get_coord;
                    psi_bar=pro.get_model.get_bound_cond(1).get_value(2)/(-pro.model.material.get_ei);
                    if strcmp(pro.pro_scheme,'pro1')==1
                        degree_rec=degree;
                    end
                    if strcmp(pro.pro_scheme,'pro2')==1
                        degree_rec=degree;
                    end
                    if strcmp(pro.pro_scheme,'pro3')==1
                        degree_rec=degree+2;
                    end
                end
                
                if isempty(a_matrix{2})==1
                    a_matrix_value=[];
                else
                    a_matrix_value=a_matrix{2};
                end
                if isempty(stencil_matrix{2})==1
                    stencil=[];
                else
                    stencil=stencil_matrix{2};
                end
                ref_index=1;
                rec{2}=mfvl_reconst1d(pro.mesh,...
                    target_type,lsm_weight,...
                    degree_rec,conservation,num_lsm_weights,cells_data,vertex_data,ref_index,stencil_size_factor,x_bar,psi_bar,stencil_size,auto_stencil_opt,pro.pro_scheme,...
                    a_matrix_value,stencil);
                if isempty(a_matrix{2})==1
                    a_matrix{2}=rec{2}.get_lsm_lhs;
                end
                if isempty(stencil_matrix{2})==1
                    stencil_matrix{2}=rec{2}.get_stencil;
                end
                % normal mean value conservation
                conservation='mean_value';
                x_bar=0;
                psi_bar=0;

                for i=3:num_cells
                    if isempty(a_matrix{i})==1
                        a_matrix_value=[];
                    else
                        a_matrix_value=a_matrix{i};
                    end
                    if isempty(stencil_matrix{i})==1
                        stencil=[];
                    else
                        stencil=stencil_matrix{i};
                    end
                    ref_index=i-1;
                    rec{i}=mfvl_reconst1d(pro.mesh,...
                        target_type,lsm_weight,...
                        degree,conservation,num_lsm_weights,cells_data,vertex_data,ref_index,stencil_size_factor,x_bar,psi_bar,stencil_size,auto_stencil_opt,pro.pro_scheme,...
                        a_matrix_value,stencil);
                    
                    if isempty(a_matrix{i})==1
                    a_matrix{i}=rec{i}.get_lsm_lhs;
                    end
                    if isempty(stencil_matrix{i})==1
                        stencil_matrix{i}=rec{i}.get_stencil;
                    end
                end
                
                

                % der1 or der2 conservation for the last cell
                if pro.model.bound_cond(2).get_type==mfvl_bound_cond_type01
                    conservation='mean_value_der1';
                    x_bar=pro.get_model.get_bound_cond(2).get_physical.get_point(1).get_coord;
                    psi_bar=pro.get_model.get_bound_cond(2).get_value(2);
                    if strcmp(pro.pro_scheme,'pro1')==1
                        degree_rec=degree;
                    end
                    if strcmp(pro.pro_scheme,'pro2')==1
                        degree_rec=degree;
                    end
                    if strcmp(pro.pro_scheme,'pro3')==1
                        degree_rec=degree+1;
                    end
                end
                if pro.model.bound_cond(2).get_type==mfvl_bound_cond_type02
                    conservation='mean_value_der2';
                    x_bar=pro.get_model.get_bound_cond(2).get_physical.get_point(1).get_coord;
                    psi_bar=pro.get_model.get_bound_cond(2).get_value(2)/(-pro.model.material.get_ei);
                    if strcmp(pro.pro_scheme,'pro1')==1
                        degree_rec=degree;
                    end
                    if strcmp(pro.pro_scheme,'pro2')==1
                        degree_rec=degree;
                    end
                    if strcmp(pro.pro_scheme,'pro3')==1
                        degree_rec=degree+2;
                    end
                end
                if pro.model.bound_cond(2).get_type==mfvl_bound_cond_type23
                    conservation='mean_value_der2';
                    x_bar=pro.get_model.get_bound_cond(2).get_physical.get_point(1).get_coord;
                    psi_bar=pro.get_model.get_bound_cond(2).get_value(1)/(-pro.model.material.get_ei);
                    if strcmp(pro.pro_scheme,'pro1')==1
                        degree_rec=degree;
                    end
                    if strcmp(pro.pro_scheme,'pro2')==1
                        degree_rec=degree;
                    end
                    if strcmp(pro.pro_scheme,'pro3')==1
                        degree_rec=degree+3;
                    end
                end
                
                if isempty(a_matrix{num_cells+1})==1
                    a_matrix_value=[];
                else
                    a_matrix_value=a_matrix{num_cells+1};
                end
                if isempty(stencil_matrix{num_cells+1})==1
                    stencil=[];
                else
                    stencil=stencil_matrix{num_cells+1};
                end
                ref_index=num_cells;
                rec{num_cells+1}=mfvl_reconst1d(pro.mesh,...
                    target_type,lsm_weight,...
                    degree_rec,conservation,num_lsm_weights,cells_data,vertex_data,ref_index,stencil_size_factor,x_bar,psi_bar,stencil_size,auto_stencil_opt,pro.pro_scheme,...
                    a_matrix_value,stencil);
                if isempty(a_matrix{num_cells+1})==1
                    a_matrix{num_cells+1}=rec{num_cells+1}.get_lsm_lhs;
                end
                if isempty(stencil_matrix{num_cells+1})==1
                    stencil_matrix{num_cells+1}=rec{num_cells+1}.get_stencil;
                end
                % point value conservation for the last vertex
                if isempty(a_matrix{num_cells+2})==1
                    a_matrix_value=[];
                else
                    a_matrix_value=a_matrix{num_cells+2};
                end
                if isempty(stencil_matrix{num_cells+2})==1
                    stencil=[];
                else
                    stencil=stencil_matrix{num_cells+2};
                end
                conservation='point_value';
                target_type='vertex';
                x_bar=0;
                psi_bar=0;
                rec{num_cells+2}=mfvl_reconst1d(pro.mesh,...
                    target_type,lsm_weight,...
                    degree,conservation,num_lsm_weights,cells_data,vertex_data,num_vertices,stencil_size_factor,x_bar,psi_bar,stencil_size,auto_stencil_opt,pro.pro_scheme,...
                    a_matrix_value,stencil);
                if isempty(a_matrix{num_cells+2})==1
                    a_matrix{num_cells+2}=rec{num_cells+2}.get_lsm_lhs;
                end
                if isempty(stencil_matrix{num_cells+2})==1
                    stencil_matrix{num_cells+2}=rec{num_cells+2}.get_stencil;
                end
        end