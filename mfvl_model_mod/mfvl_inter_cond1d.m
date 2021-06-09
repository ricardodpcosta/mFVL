% October, 2016
% class for 1d interface conditions
classdef mfvl_inter_cond1d < handle
    properties (Access=public)
        label
        code
        type
        value
        physical
    end
    methods
        % constructor
        function inter_cond=mfvl_inter_cond1d(type,value,physical,label)
            global mfvl_inter_cond_continuity;
            global mfvl_inter_cond_transference;
            % a completar...
            inter_cond.label=label;
            inter_cond.code=mfvl_new_inter_cond1d_code;
            if strcmp(type,'continuity')==1
                inter_cond.type=mfvl_inter_cond_continuity;
            end
            if strcmp(type,'transference')==1
                inter_cond.type=mfvl_inter_cond_transference;
            end
            if (strcmp(type,'continuity')==0 && strcmp(type,'transference')==0)
                error('Error: Use ''continuity'' or ''transference'' in mfvl_inter_cond1d.');
            end
            inter_cond.value=value;%depende do tempo para o dirichlet; como faço???????????????
            inter_cond.physical=physical;%conjunto de pontos
        end
        % delete
        function mfvl_delete(this)
            delete(this);
        end
        % clean
        function mfvl_clean(this)
            this.label='';
            this.code=0;
            this.type=0;
            this.value=0;
            this.physical=0;
        end
        % copy
        function mfvl_copy(this,that)
            that.label=this.label;
            that.code=this.code;
            that.type=this.type;
            that.value=this.value;
            that.physical=this.physical;
        end
        % equal
        function res=mfvl_equal(this,that)
            if (~strcmp(this.label,that.label) || this.code~=that.code ||...
                    this.type~=that.type || this.value~=that.value || this.physical~=that.physical)
                res=false;
            else
                res=true;
            end
        end
        % getters
        function res=get_label(inter_cond)
            res=inter_cond.label;
        end
        function res=get_code(inter_cond)
            res=inter_cond.code;
        end
        function res=get_type(inter_cond)
            global mfvl_inter_cond_continuity;
            global mfvl_inter_cond_transference;
            if inter_cond.type==mfvl_inter_cond_continuity
                res='continuity';
            end
            if inter_cond.type==mfvl_inter_cond_transference
                res='transference';
            end
        end
        function res=get_value(inter_cond)
            res=inter_cond.value;
        end
        function res=get_physical(inter_cond)
            res=inter_cond.physical;
        end
    end
end
% end of file