% October, 2016
% class for 1d boundary conditions
classdef mfvl_bound_cond1d < handle
    properties (Access=public)
        label
        code
        type
        value
        physical
    end
    methods
        % constructor
        function bound_cond=mfvl_bound_cond1d(type,value,physical,label)
            global mfvl_bound_cond_dirichlet;
            global mfvl_bound_cond_neumann;
            global mfvl_bound_cond_type01;
            global mfvl_bound_cond_type02;
            global mfvl_bound_cond_type23;
            % a completar... %apontadores; criar code
            % o type � o tipo de bc Dir. e Neu.
            %criar  globais
            % value- fun��o a variar com o tempo
            % physical-  para uue conunto de linhas ou pontos para que a ccond � val.
            bound_cond.code=mfvl_new_bound_cond1d_code;
            if strcmp(type,'dirichlet')==1
                bound_cond.type=mfvl_bound_cond_dirichlet;
            end
            if strcmp(type,'neumann')==1
                bound_cond.type=mfvl_bound_cond_neumann;
            end
            if strcmp(type,'type01')==1
                bound_cond.type=mfvl_bound_cond_type01;
            end
            if strcmp(type,'type02')==1
                bound_cond.type=mfvl_bound_cond_type02;
            end
            if strcmp(type,'type23')==1
                bound_cond.type=mfvl_bound_cond_type23;
            end
            if (strcmp(type,'dirichlet')==0 && strcmp(type,'neumann')==0 && strcmp(type,'type01')==0 && strcmp(type,'type02')==0 && strcmp(type,'type23')==0)
                error('Error: Use ''dirichet'', ''neumann'', ''type01'', ''type02'' or ''type23'' in mfvl_bound_cond1d.');
            end
            bound_cond.value=value;%depende do tempo para o dirichlet; como fa�o???????????????
            bound_cond.physical=physical;%conjunto de pontos
            bound_cond.label=label;
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
        function res=get_label(bound_cond)
            res=bound_cond.label;
        end
        function res=get_code(bound_cond)
            res=bound_cond.code;
        end
        function res=get_type(bound_cond)
            res=bound_cond.type;
        end
        function res=get_value(bound_cond,index)
            res=bound_cond.value(index);
        end
        function res=get_value_all(bound_cond)
            res=bound_cond.value;
        end
        function res=get_physical(bound_cond)
           res=bound_cond.physical; 
        end
    end
end
% end of file