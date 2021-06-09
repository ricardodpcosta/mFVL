% October, 2016
% class for 1d domains
classdef mfvl_domain1d < handle
    properties (Access=public)
        num_points
        num_lines
        num_physicals
        point
        line
        physical
    end
    methods
        % constructor
        function domain=mfvl_domain1d(points,lines,physicals)
            domain.num_points=numel(points);
            domain.num_lines=numel(lines);
            domain.num_physicals=numel(physicals);
            domain.point=points;
            domain.line=lines;
            domain.physical=physicals;
        end
        % delete
        function mfvl_delete(this)
            delete(this);
        end
        % clean
        function mfvl_clean(this)
            this.num_points=0;
            this.num_lines=0;
            this.num_physicals=0;
            this.point=0;
            this.line=0;
            this.physical=0;
        end
        % copy
        function mfvl_copy(this,that)
            that.num_points=this.num_points;
            that.num_lines=this.num_lines;
            that.num_physicals=this.num_physicals;
            that.point=this.point;
            that.line=this.line;
            that.physical=this.physical;
        end
        % equal
        function res=mfvl_equal(this,that)
            if (~strcmp(this.num_points,that.num_points) || (this.num_lines~=that.num_lines ||...
                    this.num_physicals~=that.num_physicals || this.point~=that.point ||...
                    this.line~=that.line|| this.physical~=that.physical))
                res=false;
            else
                res=true;
            end
        end
        % getters
        function res=get_num_points(domain)
            res=domain.num_points;
        end
        function res=get_num_lines(domain)
            res=domain.num_lines;
        end
        function res=get_num_physicals(domain)
            res=domain.num_physicals;
        end
        function res=get_point_all(domain)
            res=domain.point;
        end
        function res=get_point(domain,index)
            if (index<0 || index>domain.num_points)
                Error('Error in: get_point');
            end
            res=domain.point(index);
        end
        function res=get_line_all(domain)
            res=domain.point;
        end
        function res=get_line(domain,index)
            if (index<0 || index>domain.num_lines)
                Error('Error in: get_line');
            end
            res=domain.line(index);
        end
        function res=get_physical_all(domain)
            res=domain.physical;
        end
        function res=get_physical(domain,index)
            if (index<0 || index>domain.num_lines)
                Error('Error in: get_physical');
            end
            res=domain.physical(index);
        end
    end
end
% end of file