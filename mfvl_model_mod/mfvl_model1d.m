% October, 2016
% abstract class for 1d models definition
classdef (Abstract) mfvl_model1d < handle
    properties (Access=public)
        num_bound_conds
        num_inter_conds
        num_initi_conds
        num_source_terms
        num_materials
        bound_cond
        inter_cond
        initi_cond
        source_term
        material
        bound_cond_to_codes_map
        bound_cond_to_codes_size
        inter_cond_to_codes_map
        inter_cond_to_codes_size
        initi_cond_to_codes_map
        initi_cond_to_codes_size
        source_term_to_codes_map
        source_term_to_codes_size
        material_to_codes_map
        material_to_codes_size
    end
    methods
        % make codes maps
        function make_bound_cond_to_codes_map(model)
            for i=1:model.num_bound_conds
                n=1;
                physical=model.bound_cond(i).get_physical;
                for k=1:physical.get_num_points
                    model.bound_cond_to_codes_map(n,i)=physical.get_point(k).get_code;
                    n=n+1;
                end
                for l=1:physical.get_num_lines
                    model.bound_cond_to_codes_map(n,i)=physical.get_line(l).get_code;
                    n=n+1;
                end
            end
            for i=1:size(model.bound_cond_to_codes_map,2)
                model.bound_cond_to_codes_size(i)=numel(model.bound_cond_to_codes_map(:,i));
            end
        end
        function make_inter_cond_to_codes_map(model)
            for i=1:model.num_inter_conds
                n=1;
                physical=model.inter_cond(i).get_physical;
                for k=1:physical.get_num_points
                    model.inter_cond_to_codes_map(n,i)=physical.get_point(k).get_code;
                    n=n+1;
                end
                for l=1:physical.get_num_lines
                    model.inter_cond_to_codes_map(n,i)=physical.get_line(l).get_code;
                    n=n+1;
                end
            end
            for i=1:size(model.inter_cond_to_codes_map,2)
                model.inter_cond_to_codes_size(i)=numel(model.inter_cond_to_codes_map(:,i));
            end
        end
        function make_initi_cond_to_codes_map(model)
            for i=1:model.num_initi_conds
                n=1;
                physical=model.initi_cond(i).get_physical;
                for k=1:physical.get_num_points
                    model.initi_cond_to_codes_map(n,i)=physical.get_point(k).get_code;
                    n=n+1;
                end
                for l=1:physical.get_num_lines
                    model.initi_cond_to_codes_map(n,i)=physical.get_line(l).get_code;
                    n=n+1;
                end
            end
            for i=1:size(model.initi_cond_to_codes_map,2)
                model.initi_cond_to_codes_size(i)=numel(model.initi_cond_to_codes_map(:,i));
            end
        end
        function make_source_term_to_codes_map(model)
            for i=1:model.num_source_terms
                n=1;
                physical=model.source_term(i).get_physical;
                for k=1:physical.get_num_points
                    model.source_term_to_codes_map(n,i)=physical.get_point(k).get_code;
                    n=n+1;
                end
                for l=1:physical.get_num_lines
                    model.source_term_to_codes_map(n,i)=physical.get_line(l).get_code;
                    n=n+1;
                end
            end
            for i=1:size(model.source_term_to_codes_map,2)
                model.source_term_to_codes_size(i)=numel(model.source_term_to_codes_map(:,i));
            end
        end
        function make_material_to_codes_map(model)
            for i=1:model.num_materials
                n=1;
                physical=model.material(i).get_physical;
                for k=1:physical.get_num_points
                    model.material_to_codes_map(n,i)=physical.get_point(k).get_code;
                    n=n+1;
                end
                for l=1:physical.get_num_lines
                    model.material_to_codes_map(n,i)=physical.get_line(l).get_code;
                    n=n+1;
                end
            end
            for i=1:size(model.material_to_codes_map,2)
                model.material_to_codes_size(i)=numel(model.material_to_codes_map(:,i));
            end
        end
        % getters
        function res=get_num_bound_conds(model)
            res=model.num_bound_conds;
        end
        function res=get_num_inter_conds(model)
            res=model.num_inter_conds;
        end
        function res=get_num_initi_conds(model)
            res=model.num_initi_conds;
        end
        function res=get_num_source_terms(model)
            res=model.num_source_terms;
        end
        function res=get_num_material(model)
            res=model.num_materials;
        end
        function res=get_bound_cond(model,index)
            res=model.bound_cond(index);
        end
        function res=get_bound_cond_all(model)
            res=model.bound_cond;
        end
        function res=get_inter_cond(model,index)
            res=model.inter_cond(index);
        end
        function res=get_inter_cond_all(model)
            res=model.inter_cond;
        end
        function res=get_initi_cond(model,index)
            res=model.initi_cond(index);
        end
        function res=get_initi_cond_all(model)
            res=model.initi_cond;
        end
        function res=get_source_term(model,index)
            res=model.source_term(index);
        end
        function res=get_source_term_all(model)
            res=model.source_term;
        end
        function res=get_material(model,index)
            res=model.material(index);
        end
        function res=get_material_all(model)
            res=model.material;
        end
        function res=get_bound_cond_to_codes_map(model,index)
            res=model.bound_cond_to_codes_map(:,index);
        end
        function res=get_bound_cond_to_codes_map_all(model)
            res=model.bound_cond_to_codes_map;
        end
        function res=get_bound_cond_to_codes_size(model,index)
            res=model.bound_cond_to_codes_size(:,index);
        end
        function res=get_bound_cond_to_codes_size_all(model)
            res=model.bound_cond_to_codes_size;
        end
        function res=get_inter_cond_to_codes_map(model,index)
            res=model.inter_cond_to_codes_map(:,index);
        end
        function res=get_inter_cond_to_codes_map_all(model)
            res=model.inter_cond_to_codes_map;
        end
        function res=get_inter_cond_to_codes_size(model,index)
            res=model.inter_cond_to_codes_size(:,index);
        end
        function res=get_inter_cond_to_codes_size_all(model)
            res=model.inter_cond_to_codes_size;
        end
        function res=get_initi_cond_to_codes_map(model,index)
            res=model.initi_cond_to_codes_map(:,index);
        end
        function res=get_initi_cond_to_codes_map_all(model)
            res=model.initi_cond_to_codes_map;
        end
        function res=get_initi_cond_to_codes_size(model,index)
            res=model.initi_cond_to_codes_size(:,index);
        end
        function res=get_initi_cond_to_codes_size_all(model)
            res=model.initi_cond_to_codes_size;
        end
        function res=get_source_term_to_codes_map(model,index)
            res=model.source_term_to_codes_map(:,index);
        end
        function res=get_source_term_to_codes_map_all(model)
            res=model.source_term_to_codes_map;
        end
        function res=get_source_term_to_codes_size(model,index)
            res=model.source_term_to_codes_size(:,index);
        end
        function res=get_source_term_to_codes_size_all(model)
            res=model.source_term_to_codes_size;
        end
        function res=get_material_to_codes_map(model,index)
            res=model.material_to_codes_map(:,index);
        end
        function res=get_material_to_codes_map_all(model)
            res=model.material_to_codes_map;
        end
        function res=get_material_to_codes_size(model,index)
            res=model.material_to_codes_size(:,index);
        end
        function res=get_material_to_codes_size_all(model)
            res=model.material_to_codes_size;
        end
    end
end
% end of file
