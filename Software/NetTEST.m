classdef NetTEST < matlab.System
    % Untitled4 Add summary here
    %
    % This template includes the minimum set of functions required
    % to define a System object with discrete state.

    % Public, tunable properties
    properties
       
    end

    properties(DiscreteState)
    end

    % Pre-computed constants
    properties(Access = private)
        net SeriesNetwork;
%        TESTClassifierNet;
    end

    methods(Access = protected)
        function dataout = getOutputDataTypeImpl(~)
         dataout = 'double';
        end
        
        function sizeout = getOutputSizeImpl(~)
         sizeout = [1 1];
        end
        
        function setupImpl(obj)
             %Perform one-time calculations, such as computing constants
             
%             temp = load("D:\kusunoki\PD3\Software\Data\Networks\TESTClassifierNet.mat");
%             obj.net = temp.TESTClassifierNet;
%             obj.net = evalin('base', 'TESTClassifierNet');
             coder.extrinsic('Simulink.ModelWorkspace')
             obj.net = Simulink.ModelWorkspace.getVariable('ModelWorkspace', 'TESTClassifierNet');
        end

        function y = stepImpl(obj,u)
            % Implement algorithm. Calculate y as a function of input u and
            % discrete states.
            switch (classify(obj.net, u))
                case 'c0'
                    y = 0;
                case 'c1'
                    y = 1;
                otherwise
                    y = 0;
            end
            y=1;
        end
        function resetImpl(obj)
            % Initialize / reset discrete-state properties
        end
        
    end
end
