% October, 2016
% class for 1d lines
classdef mfvl_line1d < handle
    properties (Access=public)
        label
        code
        point1
        point2
        density_function %new
        num_cells %new
    end
    methods
        % constructor
        function line=mfvl_line1d(point1,point2,num_cells,density_function,label)
            line.code=mfvl_new_line1d_code;
            line.label=label;
            line.point1=point1;
            line.point2=point2;
            line.num_cells=num_cells; %new
            line.density_function=density_function; %new
        end
        % delete
        function mfvl_delete(this)
            delete(this);
        end
        % clean
        function mfvl_clean(this)
            this.label='';
            this.code=0;
            this.point1=0.0;
            this.point2=0.0;
            this.num_cells=0;
            this.density_function=@(x)0;
        end
        % copy
        function mfvl_copy(this,that)
            that.label=this.label;
            that.code=this.code;
            that.point1=this.point1;
            that.point2=this.point2;
            that.num_cells=this.num_cells;
            that.density_function=this.density_function;
        end
        % equal
        function res=mfvl_equal(this,that)
            if (~strcmp(this.label,that.label) || (this.code~=that.code ||...
                    this.point1~=that.point1 || this.point2~=that.point2 || this.num_cells~=that.num_cells || this.density_function~=that.density_function))
                res=false;
            else
                res=true;
            end
        end
        % getters
        function res=get_label(res)
            res=res.label;
        end
        function res=get_code(res)
            res=res.code;
        end
        function res=get_point1(res)
            res=res.point1;
        end
        function res=get_point2(res)
            res=res.point2;
        end
        function res=get_num_cells(res)
            res=res.num_cells;
        end
        function res=get_density_function(res)
            res=res.density_function;
        end
    end
end
% end of file