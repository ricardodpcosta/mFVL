% October, 2016
% class for 1d source terms
classdef mfvl_source_term1d < handle
    properties (Access=public)
        label
        code
        type
        value
        physical
    end
    methods
        % constructor
        function source_term=mfvl_source_term1d(type,value,physical,label)
            % a completar...
            global mfvl_source_term_explicit;
            source_term.label=label;
            source_term.code=mfvl_new_source_term1d_code;
            if strcmp(type,'explicit')==1
                source_term.type=mfvl_source_term_explicit;
            end
            source_term.value=value;
            source_term.physical=physical;
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
        function res=get_label(source_term)
            res=source_term.label;
        end
        function res=get_code(source_term)
            res=source_term.code;
        end
        function res=get_type(source_term)
            global mfvl_source_term_explicit;
            if source_term.type==mfvl_source_term_explicit;
                res='explicit';
            end
        end
        function res=get_value(source_term)
            res=source_term.value;
        end
        function res=get_physical(source_term)
            res=source_term.physical;
        end
    end
end
% end of file