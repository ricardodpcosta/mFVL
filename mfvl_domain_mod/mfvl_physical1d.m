% October, 2016
% class for 1d physicals
classdef mfvl_physical1d < handle
    properties (Access=public)
        label
        code
        num_points
        num_lines
        num_elements
        point % array
        line % array
    end
    methods
        % constructor
        function physical=mfvl_physical1d(points,lines,label)
            physical.label=label;
            physical.code=mfvl_new_physical1d_code;
            physical.num_points=numel(points);
            physical.num_lines=numel(lines);
            physical.num_elements=numel(points)+numel(lines);
            physical.point=points;
            physical.line=lines;
        end
        % delete
        function mfvl_delete(this)
            delete(this);
        end
        % clean
        function mfvl_clean(this)
            this.label='';
            this.code=0;
            this.num_points=0;
            this.num_lines=0;
            this.num_elements=0;
            this.point=0;
            this.line=0;
        end
        % copy
        function mfvl_copy(this,that)
            that.label=this.label;
            that.code=this.code;
            that.num_points=this.num_points;
            that.num_lines=this.num_lines;
            that.num_elements=this.num_elements;
            that.point=this.point;
            that.line=this.line;
        end
        % equal
        function res=mfvl_equal(this,that)
            if (~strcmp(this.label,that.label) || (this.code~=that.code ||...
                    this.num_points~=that.num_points || this.num_points~=that.num_lines ||...
                    this.num_points~=that.num_elements || this.num_points~=that.point || this.num_points~=that.line))
                res=false;
            else
                res=true;
            end
        end
        % getters
        function res=get_label(physical)
            res=physical.label;
        end
        function res=get_code(physical)
            res=physical.code;
        end
        function res=get_num_points(physical)
            res=physical.num_points;
        end
        function res=get_num_lines(physical)
            res=physical.num_lines;
        end
        function res=get_num_elements(physical)
            res=physical.num_elements;
        end
        function res=get_point_all(physical)
            res=physical.point;
        end
        function res=get_point(physical,index)
            if (index<0 || index>physical.num_points)
                Error('Error in: get_point');
            end
            res=physical.point(index);
        end
        function res=get_line_all(physical)
            res=physical.line;
        end
        function res=get_line(physical,index)
            if (index<0 || index>physical.num_lines)
                Error('Error in: get_line');
            end
            res=physical.line(index);
        end
    end
end
% end of file