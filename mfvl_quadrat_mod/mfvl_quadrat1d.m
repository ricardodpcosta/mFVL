% November, 2016
classdef (Abstract) mfvl_quadrat1d < handle
    properties (Access=public)
        order
        num_points
        weights
        num_weights
        point_coefs
        num_coefs
    end
    methods
        % eval_point
        function res = eval_point(quadrat,index,point1,point2)
            if quadrat.point_coefs(index) > 1
                error('quadrat points not initialize in call mfvl_quadrat1d::eval_point');
            end
            if index<1 || index>quadrat.num_points
                error(['Invalid argument value for ' num2str(index) ' in call mfvl_quadrat1d::mfvl_eval_point']);
            end
            i=2*index;
            aux1=quadrat.point_coefs(i-1);
            aux2=quadrat.point_coefs(i);
            res=aux1*point1+aux2*point2;
        end
        % eval_mean_value
        function res=eval_mean_value(quadrat,point1,point2,func)
            if quadrat.num_points < 1
                error('quadrat points not initialized in call mfvl_quadrat1d::mfvl_func_mean_value');
            end
            if size(point1,1)<1
                error(['Invalid argument size for ' num2str(point1) ' in call mfvl_quadrat1d::eval_mean_value']);
            end
            res=0;
            for i=1:quadrat.num_points
                gp=eval_point(quadrat,i,point1,point2);
                res=res+func(gp)*quadrat.weights(i); %sum of the values in each function
            end
        end
        % getters
        function res=get_order(quadrat)
            res=quadrat.order;
        end
        function res=get_num_points(quadrat)
            res=quadrat.num_points;
        end
        function res=get_weights_all(quadrat)
            res=quadrat.weights;
        end
        function res=get_weights(quadrat,index)
            if (index<1) || (index>quadrat.num_points)
                error(['get_weights :: 1>index>' num2str(quadrat.num_points)]);
            end
            res=quadrat.weights(index,:);
        end
        function res=get_point_coefs_all(quadrat)
            res=quadrat.point_coefs;
        end
        function res=get_point_coefs(quadrat,index)
            if (index<1) || (index>2*quadrat.num_points)
                error(['get_point_coefs :: 1>index>' num2str(2*quadrat.num_points)]);
            end
            res=quadrat.point_coefs(index,:);
        end
    end
end
% end of file