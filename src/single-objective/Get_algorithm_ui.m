function [algorithmsName, algorithms] = Get_algorithm_ui(listboxValues)
    % GET_ALGORITHM
    % Converts algorithm names from listbox values into function handles.
    %
    % Inputs:
    %   listboxValues - Cell array or string array of algorithm names from app.listbox.Value
    %                   (e.g., app.AlgorithmListBox.Value)
    %
    % Outputs:
    %   algorithmsName - List of algorithm names (string array)
    %   algorithms     - Cell array of function handles corresponding to the names

    %% Ensure input is a string array for consistent handling
    if iscell(listboxValues)
        algorithmsName = string(listboxValues(:));  % Convert cell array to string array
    elseif ischar(listboxValues)
        algorithmsName = string({listboxValues});   % Single char input
    else
        algorithmsName = listboxValues(:);          % Already string array
    end
    
    %% Remove empty entries (if any)
    algorithmsName = algorithmsName(strlength(algorithmsName) > 0);
    
    %% Convert the algorithm names from string to function handles
    numAlgorithms = numel(algorithmsName);
    algorithms = cell(numAlgorithms, 1);
    
    for i = 1:numAlgorithms
        algorithms{i} = str2func(algorithmsName(i));
    end
end
