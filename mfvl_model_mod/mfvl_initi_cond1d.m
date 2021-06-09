% October, 2016
% class for 1d initial conditions
classdef mfvl_initi_cond1d < handle
    properties (Access=private)
        label
        code
        type
        value
        physical
    end
    methods
        % constructor
        function initi_cond=mfvl_initi_cond1d(type,value,physical,label)
            % a completar...
            global mfvl_initi_cond_explicit;
            initi_cond.label=label;
            initi_cond.code=mfvl_new_initi_cond1d_code;
            if strcmp(type,'explicit')==1
                initi_cond.type=mfvl_initi_cond_explicit;
            end
            if strcmp(type,'explicit')==0
                error('Error: Use ''explicit'' in mfvl_initi_cond1d.');
            end
            initi_cond.value=value;
            initi_cond.physical=physical;
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
        function res=get_label(initi_cond)
            res=initi_cond.label;
        end
        function res=get_code(initi_cond)
            res=initi_cond.code;
        end
        function res=get_type(initi_cond)
                res=initi_cond.type;
        end
        function res=get_value(initi_cond)
            res=initi_cond.value;
        end
        function res=get_physical(initi_cond)
            res=initi_cond.physical;
        end
    end
end
% end of file