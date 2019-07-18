classdef net_EMGClassify < matlab.System
    % Untitled4 Add summary here
    %
    % This template includes the minimum set of functions required
    % to define a System object with discrete state.

    % Public, tunable properties
    properties
        net

    end

    properties(DiscreteState)

    end

    % Pre-computed constants
    properties(Access = private)

    end

    methods(Access = protected)
        function setupImpl(obj)
            % Perform one-time calculations, such as computing constants
            load('Data\Networks\EMGClassifier.mat');
            obj.net = EMGClassifier;
        end

        function y = stepImpl(obj,u)
            % Implement algorithm. Calculate y as a function of input u and
            % discrete states.
            y = predict(obj.net, u);
        end

        function resetImpl(obj)
            % Initialize / reset discrete-state properties
        end
    end
end