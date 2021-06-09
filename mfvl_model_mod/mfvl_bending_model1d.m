% October, 2016
% class for 1d bending model
classdef mfvl_bending_model1d < mfvl_model1d
    properties (Access=public)

    end
    methods
        % constructor
        function model=mfvl_bending_model1d (bound_conds,inter_conds,initi_conds,source_terms,materials)
            % a completar... 
            model.bound_cond=bound_conds;
            model.inter_cond=inter_conds;
            model.initi_cond=initi_conds;
            model.source_term=source_terms;
            model.material=materials;
            model.num_bound_conds=numel(bound_conds);
            model.num_inter_conds=numel(inter_conds);
            model.num_initi_conds=numel(initi_conds);
            model.num_source_terms=numel(source_terms);
            model.num_materials=numel(materials);
            make(model);
        end
        % make data
        function make(model)
            model.make_bound_cond_to_codes_map();
            model.make_inter_cond_to_codes_map();
            model.make_initi_cond_to_codes_map();
            model.make_source_term_to_codes_map();
            model.make_material_to_codes_map();
        end
        % getters

    end
end
% end of file