% October, 2016
% class for 1d points
classdef mfvl_point1d < handle
    properties (Access=public)
        label
        code
        coord
    end
    methods
        % constructor
        function res=mfvl_point1d(coord,label)
            res.label=label;%string
            res.code=mfvl_new_point1d_code;%will identify every point; unique
            res.coord=coord;%coordinate
        end
        % delete
        function mfvl_delete(this)
            delete(this);
        end
        % clean
        function mfvl_clean(this)
            this.label='';
            this.code=0;
            this.coord=0.0;
        end
        % copy
        function mfvl_copy(this,that)
            that.label=this.label;
            that.code=this.code;
            that.coord=this.coord;
        end
        % equal
        function res=mfvl_equal(this,that)
            if (~strcmp(this.label,that.label) || (this.code~=that.code ||...
                    this.coord~=that.coord))
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
        function res=get_coord(res)
            % get the coordinate
            res=res.coord;
        end
%         function res=get_point_info(res)
%             res.label=res.label;
%             res.code=res.code;
%             res.coord=res.coord;
%         end
    end
end
% end of file