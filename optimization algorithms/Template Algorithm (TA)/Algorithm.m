function [bestFitness,bestPosition,convergenceCurve] = Algorithm(  lb, ub,dim, nPop, maxItr,objectiveFunction)
    % Algorithm - Template entry point for an optimization algorithm.
    % Replace this file with the actual implementation and keep a stable entry point
    % if you plan to integrate with an external benchmarking framework.
    %
    % Inputs:
    %   objectiveFunction : function handle
    %   dim               : problem dimension
    %   lb, ub            : lower/upper bounds (scalar or 1xD vector)
    %   maxItr            : number of iterations
    %   nPop              : population size
    %
    % Outputs:
    %   bestPosition      : 1xD best solution
    %   bestFitness       : best objective value
    %   convergenceCurve  : 1xmaxItr bestFitness at each iteration
    %
    % NOTE: This is only a template. It does not implement a real optimizer.

    % Normalize bounds to vectors
    if isscalar(lb), lb = lb * ones(1, dim); end
    if isscalar(ub), ub = ub * ones(1, dim); end

    % Random initialization
    pop = lb + rand(nPop, dim) .* (ub - lb);
    fit = zeros(nPop, 1);
    for i = 1:nPop
        fit(i) = objectiveFunction(pop(i, :));
    end

    [bestFitness, idx] = min(fit);
    bestPosition = pop(idx, :);

    convergenceCurve = zeros(1, maxItr);
    convergenceCurve(1) = bestFitness;

    for t = 2:maxItr
        % TODO: add your algorithm update steps here

        % Keep best (placeholder)
        convergenceCurve(t) = bestFitness;
    end
end
