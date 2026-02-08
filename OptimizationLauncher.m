classdef OptimizationLauncher < matlab.apps.AppBase

    % =====================================================================
    % PROPERTIES: UI Components
    % =====================================================================
    properties (Access = public)
        UIFigure      matlab.ui.Figure
        GridLayout    matlab.ui.container.GridLayout
        
        % --- LEFT PANEL (Settings) ---
        LeftPanel     matlab.ui.container.Panel
        TitleLabel    matlab.ui.control.Label
        BenchLabel    matlab.ui.control.Label
        BenchDropDown matlab.ui.control.DropDown
        RunLabel      matlab.ui.control.Label
        RunEdit       matlab.ui.control.NumericEditField
        IterLabel     matlab.ui.control.Label
        IterEdit      matlab.ui.control.NumericEditField
        PopLabel      matlab.ui.control.Label
        PopEdit       matlab.ui.control.NumericEditField
        ParallelSwitch matlab.ui.control.Switch
        ParallelLabel  matlab.ui.control.Label
        StartButton   matlab.ui.control.Button
        
        % --- CENTER PANEL (Algorithm Manager) ---
        CenterPanel   matlab.ui.container.Panel
        AlgoListLabel matlab.ui.control.Label
        AlgoListBox   matlab.ui.control.ListBox
        ImportButton  matlab.ui.control.Button
        RefreshButton matlab.ui.control.Button
        
        % --- RIGHT PANEL (Logs) ---
        RightPanel    matlab.ui.container.Panel
        LogTextArea   matlab.ui.control.TextArea
        StatusLabel   matlab.ui.control.Label
    end
    
    properties (Access = private)
        BasePath char
        AlgoPath char
        CECsDim cell 
    end

    % =====================================================================
    % METHODS: Logic
    % =====================================================================
    methods (Access = private)
        
        % LOGGING HELPER
        function log(app, msg)
            timestamp = datestr(now, 'HH:MM:SS');
            app.LogTextArea.Value = [app.LogTextArea.Value; {sprintf('[%s] %s', timestamp, msg)}];
            scroll(app.LogTextArea, 'bottom');
        end

        % SCAN ALGORITHM FOLDER
        function refreshAlgorithmList(app)
            if ~exist(app.AlgoPath, 'dir')
                app.log('Error: "optimization algorithms" folder not found.');
                return;
            end
            
            % Find .m files
            files = dir(fullfile(app.AlgoPath, '*.m'));
            if isempty(files)
                app.AlgoListBox.Items = {'No algorithms found'};
            else
                % Exclude system files if necessary, here we just list names
                names = {files.name};
                % Remove extension for cleaner look
                displayNames = regexprep(names, '\.m$', ''); 
                app.AlgoListBox.Items = displayNames;
                app.log(sprintf('Found %d algorithms.', length(names)));
            end
        end

        % IMPORT BUTTON CALLBACK
        function importButtonPushed(app, ~)
            [file, path] = uigetfile('*.m', 'Select Your Algorithm File');
            if isequal(file, 0)
                return; % User cancelled
            end
            
            sourceFile = fullfile(path, file);
            destFile = fullfile(app.AlgoPath, file);
            
            try
                copyfile(sourceFile, destFile);
                app.log(sprintf('Successfully imported: %s', file));
                app.refreshAlgorithmList();
                
                % Auto-select the new one
                nameNoExt = regexprep(file, '\.m$', '');
                app.AlgoListBox.Value = nameNoExt;
                
            catch ME
                uialert(app.UIFigure, ME.message, 'Import Error');
            end
        end

        % RUN BUTTON CALLBACK
        function runButtonPushed(app, ~)
            app.StartButton.Enable = 'off';
            app.StartButton.Text = 'Running...';
            app.StatusLabel.Text = 'Status: Initializing...';
            app.StatusLabel.FontColor = [0.85 0.33 0.10]; 
            
            try
                % Inputs
                maxRun = app.RunEdit.Value;
                maxItr = app.IterEdit.Value;
                populationNo = app.PopEdit.Value;
                isParallel = strcmp(app.ParallelSwitch.Value, 'On');
                selectedIndex = app.BenchDropDown.Value;
                
                % Get Selected Algorithms (To pass to backend if supported)
                selectedAlgos = app.AlgoListBox.Value;
                fid = fopen('selectedAlgos.txt','w');

                % Join all elements with a newline character, then print the single string
                fprintf(fid, '%s', strjoin(selectedAlgos, '\n'));

                fclose(fid);
                

               


                
                % Path Setup
                cd(app.BasePath);
                addedPaths = genpath(app.BasePath);
                addpath(addedPaths);
                
                if exist('ProjectContext', 'file')
                   ProjectContext('init', app.BasePath);
                end
                
                % Parallel Setup
                global RUN_PARALLEL;
                RUN_PARALLEL = isParallel;
                if RUN_PARALLEL
                    c = parcluster;
                    numWorkers = min(maxRun, c.NumWorkers);
                    if isempty(gcp('nocreate')) && numWorkers > 1
                         parpool("Processes", numWorkers);
                    end
                end

                % EXECUTION
                app.log(sprintf('--- Starting Benchmark Index %d ---', selectedIndex));
                app.StatusLabel.Text = 'Status: Optimizing...';
                drawnow;

                % Pass data to your main function
           
                RunBenchmarkSuite(selectedIndex, populationNo, maxRun, maxItr, app.CECsDim{selectedIndex},selectedAlgos);

                app.log('Done.');
                app.StatusLabel.Text = 'Status: Complete';
                app.StatusLabel.FontColor = [0.47 0.67 0.19];
                rmpath(addedPaths);
                
            catch ME
                app.log(['ERROR: ' ME.message]);
                uialert(app.UIFigure, ME.message, 'Error');
                app.StatusLabel.Text = 'Status: Error';
                app.StatusLabel.FontColor = [1 0 0];
            end
            
            app.StartButton.Enable = 'on';
            app.StartButton.Text = 'Start Optimization';
        end
    end

    % =====================================================================
    % LAYOUT INITIALIZATION
    % =====================================================================
    methods (Access = public)

        function createComponents(app)
            % Main Window
            app.UIFigure = uifigure('Visible', 'off');
            app.UIFigure.Position = [100 100 900 500]; % Wider for 3 panels
            app.UIFigure.Name = 'Optimization Framework Launcher';
            
            % Grid: 3 Columns [Settings, Algos, Log]
            app.GridLayout = uigridlayout(app.UIFigure);
            app.GridLayout.ColumnWidth = {250, 250, '1x'}; 
            app.GridLayout.RowHeight = {'1x'};

            % --- 1. LEFT PANEL (Configuration) ---
            app.LeftPanel = uipanel(app.GridLayout);
            app.LeftPanel.Layout.Column = 1;
            app.LeftPanel.Title = 'Configuration';
            
            app.BenchLabel = uilabel(app.LeftPanel, 'Text', 'Benchmark Suite:', 'Position', [20 400 200 22]);
            app.BenchDropDown = uidropdown(app.LeftPanel, 'Position', [20 375 210 22]);
            app.BenchDropDown.Items = {'1: CEC2005', '2: CEC2014', '3: CEC2017', '4: CEC2019', '5: CEC2020', '6: CEC2022', '7: Real World'};
            app.BenchDropDown.ItemsData = [1 2 3 4 5 6 7];
            app.BenchDropDown.Value = 5;

            app.RunLabel = uilabel(app.LeftPanel, 'Text', 'Runs:', 'Position', [20 330 50 22]);
            app.RunEdit = uieditfield(app.LeftPanel, 'numeric', 'Value', 1, 'Position', [80 330 50 22]);
            
            app.PopLabel = uilabel(app.LeftPanel, 'Text', 'Pop:', 'Position', [140 330 40 22]);
            app.PopEdit = uieditfield(app.LeftPanel, 'numeric', 'Value', 10, 'Position', [180 330 50 22]);
            
            app.IterLabel = uilabel(app.LeftPanel, 'Text', 'Max Iterations:', 'Position', [20 290 100 22]);
            app.IterEdit = uieditfield(app.LeftPanel, 'numeric', 'Value', 10, 'Position', [130 290 100 22]);
            
            app.ParallelLabel = uilabel(app.LeftPanel, 'Text', 'Parallel:', 'Position', [20 250 60 22]);
            app.ParallelSwitch = uiswitch(app.LeftPanel, 'slider', 'Items', {'Off','On'}, 'Position', [90 250 45 20]);
            
            app.StartButton = uibutton(app.LeftPanel, 'Text', 'Start Optimization', ...
                'Position', [20 50 210 50], 'BackgroundColor', [0 0.447 0.741], 'FontColor', [1 1 1], ...
                'ButtonPushedFcn', createCallbackFcn(app, @runButtonPushed, true));

            % --- 2. CENTER PANEL (Algorithm Manager) ---
            app.CenterPanel = uipanel(app.GridLayout);
            app.CenterPanel.Layout.Column = 2;
            app.CenterPanel.Title = 'Algorithm Manager';
            
            app.AlgoListLabel = uilabel(app.CenterPanel, 'Text', 'Available Algorithms:', 'Position', [20 440 200 22]);
            
            % List Box
            app.AlgoListBox = uilistbox(app.CenterPanel, 'Position', [20 150 210 280]);
            app.AlgoListBox.Multiselect = 'on'; % Allow selecting multiple
            
            % Import Button
            app.ImportButton = uibutton(app.CenterPanel, 'Text', '+ Import New Algorithm', ...
                'Position', [20 90 210 30], 'BackgroundColor', [0.47 0.67 0.19], 'FontColor', [1 1 1], ...
                'ButtonPushedFcn', createCallbackFcn(app, @importButtonPushed, true));
                
            % Refresh Button
            app.RefreshButton = uibutton(app.CenterPanel, 'Text', 'Refresh List', ...
                'Position', [20 50 210 30], ...
                'ButtonPushedFcn', createCallbackFcn(app, @(btn,event) refreshAlgorithmList(app), true));

            % --- 3. RIGHT PANEL (Logs) ---
            app.RightPanel = uipanel(app.GridLayout);
            app.RightPanel.Layout.Column = 3;
            app.RightPanel.Title = 'Status & Log';
            
            app.StatusLabel = uilabel(app.RightPanel, 'Text', 'Status: Ready', ...
                'Position', [10 440 300 30], 'FontWeight', 'bold');
            
            app.LogTextArea = uitextarea(app.RightPanel, 'Position', [10 10 300 420]);
            app.LogTextArea.Editable = 'off';

            % Initial Setup
            app.UIFigure.Visible = 'on';
        end

        function app = OptimizationLauncher
            % Init Paths
            app.BasePath = fileparts(which('OptimizationLauncher.m'));
            app.AlgoPath = fullfile(app.BasePath, 'optimization algorithms');
            
            % CEC Dimensions (From your Main.m)
            app.CECsDim = { ...
                { {'fixDim', []} }, { 10, 30, 50, 100 }, { 10, 30, 50, 100 }, ...
                { {'fixDim', []} }, { 10, 20 }, { 10, 20 }, { {'fixDim', []} } 
            };
            
            createComponents(app);
            refreshAlgorithmList(app); % Load algorithms on startup
        end
    end
end
