% November, 2016
classdef mfvl_gauss1d < mfvl_quadrat1d
    properties (Access=private)
%         order
%         num_points
%         weights
%         num_weights
%         point_coefs
%         num_coefs
    end
    methods
        function gauss=mfvl_gauss1d(order)
            if (order<1) || (order>6)
                error([' Error: order.']);
            end
            gauss.order=order;
            gauss.num_points= round(order/2);
            switch order
                case {1,2} %if the user want to construct a 1 order reconstruction it will initiate a 2 order quadrature
                    gauss.weights=1.0;
                    gauss.point_coefs=[0.5;0.5];
                case {3,4}
                    gauss.weights=[0.5;0.5];
                    gauss.point_coefs=...
                        [(1.0-1/(sqrt(3)))*0.5;...
                        1-(1.0-1/(sqrt(3)))*0.5;...
                        1-(1.0-1/(sqrt(3)))*0.5;...
                        (1.0-1/(sqrt(3)))*0.5];
                case {5,6}
                    gauss.weights=[5/18;8/18;5/18];
                    gauss.point_coefs=...
                        [(1.0-sqrt(3/5))*0.5;...
                        1-(1.0-sqrt(3/5))*0.5;...
                        0.5;...
                        0.5;...
                        1-(1.0-sqrt(3/5))*0.5;...
                        (1.0-sqrt(3/5))*0.5];
                otherwise
                    error(['Invalid argument for order=' num2str(order) ' in call mfvl_gauss1d.']);
            end
            gauss.num_coefs=numel(gauss.point_coefs);
            gauss.num_weights=numel(gauss.weights);
        end
    end
end
% end of file