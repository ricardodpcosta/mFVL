% October, 2016
% class for 1d convection-diffusion-reaction model
classdef mfvl_cdr_model1d < mfvl_model1d
    properties (Access=public)
        velocity
        reaction
    end
    methods
        % constructor
        function model=mfvl_cdr_model1d(bound_conds,inter_conds,initi_conds,source_terms,materials,velocity,reaction)
            % a completar...
            model.bound_cond=bound_conds;
            model.inter_cond=inter_conds;
            model.initi_cond=initi_conds;
            model.source_term=source_terms;
            model.material=materials;
            model.velocity=velocity;
            model.reaction=reaction;
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
        function res=get_velocity(model)
            res=model.velocity;
        end
        function res=get_reaction(model)
            res=model.reaction;
        end
    end
end
% end of file