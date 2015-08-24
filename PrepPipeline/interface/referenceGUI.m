function [paramsOut] = referenceGUI(hObject, callbackdata, inputData)%#ok<INUSL>
title = 'Reference parameters';
defaultStruct = inputData.userData.reference;
referenceTypeMenu = {'Robust'; 'Average'; 'Specific'; 'None'};
reportingLevelMenu = {'Minimum'; 'Verbose'};
meanEstimateTypeMenu = {'Huber'; 'Median'; 'Mean'; 'None'};
interpolationOrderMenu = {'Post-reference'; 'Pre-reference'; 'None'};
while(true)
    mainFigure = findobj('Type', 'Figure', '-and', 'Name', inputData.name);
    userdata = get(mainFigure, 'UserData');
    if isempty(userdata) || ~isfield(userdata, 'reference')
        paramsOut = struct();
    else
        paramsOut = userdata.reference;
    end
    [defaultStruct, errors] = checkStructureDefaults(paramsOut, defaultStruct);
    
    if ~isempty(errors)
        warning('referenceGUI:bad parameters', getMessageString(errors)); %#ok<CTPCT>
    end
    
    % Creates structure for
    fNamesDefault = fieldnames(defaultStruct);
    for k = 1:length(fNamesDefault)
        textColorStruct.(fNamesDefault{k}) = 'k';
    end
    
    if defaultStruct.ransacOff.value
        ransacOffValue = 1;
    else
        ransacOffValue = 0;
    end
    
    referenceTypeValue = typeMenuPosition(...
        defaultStruct.referenceType.value, referenceTypeMenu);
    reportingLevelValue = typeMenuPosition(...
        defaultStruct.reportingLevel.value, reportingLevelMenu);
    meanEstimateTypeValue = typeMenuPosition( ...
        defaultStruct.meanEstimateType.value, meanEstimateTypeMenu);
    closeOpenWindows(title);
    geometry = {[1.5, 1, 1.5, 1], [1.5, 1, 1.5, 1], 3, [1.5, 1, 1.5, 1], [1.5, 1, 1.5, 1], ...
        [1.5, 1, 1.5, 1], 3, [1.5, 1, 1.5, 1], [1.5, 1, 1.5, 1], [1.5, 1, 1.5, 1], 3, ...
        [1.5, 1, 1.5, 1], [1.5, 1, 1.5, 1], [1.5, 1, 1.5, 1], 3};
    geomvert = [];
    uilist={{'style', 'text', 'string', 'Reference channels', ...
        'TooltipString', defaultStruct.referenceChannels.description}...
        {'style', 'edit', 'string', ...
        vector2str(defaultStruct.referenceChannels.value), 'tag', ...
        'referenceChannels', 'ForegroundColor', ...
        textColorStruct.referenceChannels}...
        {'style', 'text', 'string', 'Evaluation channels', ...
        'TooltipString', defaultStruct.evaluationChannels.description}...
        {'style', 'edit', 'string', ...
        vector2str(defaultStruct.evaluationChannels.value), ...
        'tag', 'evaluationChannels', 'ForegroundColor', ...
        textColorStruct.evaluationChannels}...
        {'style', 'text', 'string', 'Re-referenced channels', ...
        'TooltipString', defaultStruct.rereferencedChannels.description}...
        {'style', 'edit', 'string', ...
        vector2str(defaultStruct.rereferencedChannels.value), ...
        'tag', 'rereferencedChannels', 'ForegroundColor', ...
        textColorStruct.rereferencedChannels}...
        {'style', 'text', 'string', ''}...
        {'style', 'text', 'string', ''}...
        {'style', 'text', 'string', ''}...
        {'style', 'text', 'string', 'Turn ransac off', ...
        'TooltipString', defaultStruct.ransacOff.description}...
        {'style', 'checkbox', 'Value', ransacOffValue, ...
        'tag', 'ransacOff', 'ForegroundColor', textColorStruct.ransacOff}...
        {'style', 'text', 'string', 'Ransac sample size', ...
        'TooltipString', defaultStruct.ransacSampleSize.description}...
        {'style', 'edit', 'string', ...
        num2str(defaultStruct.ransacSampleSize.value), ...
        'tag', 'ransacSampleSize', 'ForegroundColor', ...
        textColorStruct.ransacSampleSize}...
        {'style', 'text', 'string', 'Ransac channel fraction', ...
        'TooltipString', defaultStruct.ransacChannelFraction.description}...
        {'style', 'edit', 'string', ...
        num2str(defaultStruct.ransacChannelFraction.value), ...
        'tag','ransacChannelFraction', 'ForegroundColor', ...
        textColorStruct.ransacChannelFraction}...
        {'style', 'text', 'string', 'Ransac correlation threshold', ...
        'TooltipString', defaultStruct.ransacCorrelationThreshold.description}...
        {'style', 'edit', 'string', ...
        num2str(defaultStruct.ransacCorrelationThreshold.value), ...
        'tag','ransacCorrelationThreshold', 'ForegroundColor', ...
        textColorStruct.ransacCorrelationThreshold}...
        {'style', 'text', 'string','Ransac unbroken time', ...
        'TooltipString', defaultStruct.ransacUnbrokenTime.description}...
        {'style','edit','string', ...
        num2str(defaultStruct.ransacUnbrokenTime.value), ...
        'tag', 'ransacUnbrokenTime', 'ForegroundColor', ...
        textColorStruct.ransacUnbrokenTime}...
        {'style', 'text', 'string', 'Ransac window', ...
        'TooltipString', defaultStruct.ransacWindowSeconds.description}...
        {'style','edit','string', ...
        num2str(defaultStruct.ransacWindowSeconds.value), ...
        'tag', 'ransacWindowSeconds', 'ForegroundColor', ...
        textColorStruct.ransacWindowSeconds}...
        {'style', 'text', 'string', ''}...
        {'style', 'text', 'string', 'Sampling rate', ...
        'TooltipString', defaultStruct.srate.description}...
        {'style', 'edit', 'string', ...
        num2str(defaultStruct.srate.value), ...
        'tag', 'srate', 'ForegroundColor', textColorStruct.srate}...
        {'style', 'text', 'string', 'Robust deviation threshold', ...
        'TooltipString', defaultStruct.robustDeviationThreshold.description}...
        {'style', 'edit', 'string', ...
        num2str(defaultStruct.robustDeviationThreshold.value), ...
        'tag', 'robustDeviationThreshold', 'ForegroundColor', ...
        textColorStruct.robustDeviationThreshold}...
        {'style', 'text', 'string', 'Correlation window', ...
        'TooltipString', defaultStruct.correlationWindowSeconds.description}...
        {'style', 'edit', 'string', ...
        num2str(defaultStruct.correlationWindowSeconds.value), ...
        'tag','correlationWindowSeconds', 'ForegroundColor', ...
        textColorStruct.correlationWindowSeconds}...
        {'style', 'text', 'string', 'High frequency noise threshold', ...
        'TooltipString', defaultStruct.highFrequencyNoiseThreshold.description}...
        {'style', 'edit', 'string', ...
        num2str(defaultStruct.highFrequencyNoiseThreshold.value), ...
        'tag', 'highFrequencyNoiseThreshold', 'ForegroundColor', ...
        textColorStruct.highFrequencyNoiseThreshold}...
        {'style', 'text', 'string','Correlation threshold', ...
        'TooltipString',defaultStruct.correlationThreshold.description}...
        {'style', 'edit', 'string', ...
        num2str(defaultStruct.correlationThreshold.value), ...
        'tag', 'correlationThreshold', 'ForegroundColor', ...
        textColorStruct.correlationThreshold}...
        {'style', 'text', 'string', 'Bad time threshold', ...
        'TooltipString', defaultStruct.badTimeThreshold.description}...
        {'style', 'edit', 'string', ...
        num2str(defaultStruct.badTimeThreshold.value), ...
        'tag', 'badTimeThreshold', 'ForegroundColor', ...
        textColorStruct.badTimeThreshold}...
        {'style', 'text', 'string', ''}...
        {'style', 'text', 'string', 'Max reference iterations', ...
        'TooltipString', defaultStruct.maxReferenceIterations.description}...
        {'style', 'edit', 'string', ...
        num2str(defaultStruct.maxReferenceIterations.value), ...
        'tag', 'maxReferenceIterations', 'ForegroundColor', ...
        textColorStruct.maxReferenceIterations}...
        {'style', 'text', 'string', 'Reference type', ...
        'TooltipString', defaultStruct.referenceType.description}...
        {'style', 'popupmenu', 'string', 'Robust|Average|Specific', ...
        'value', referenceTypeValue, 'tag', 'referenceType', ...
        'ForegroundColor', textColorStruct.referenceType}...
        {'style', 'text', 'string', 'Reporting level', ...
        'TooltipString', defaultStruct.reportingLevel.description}...
        {'style', 'popupmenu', 'string', 'Minimum|Verbose', ...
        'value', reportingLevelValue, ...
        'tag', 'reportingLevel', 'ForegroundColor', ...
        textColorStruct.reportingLevel}...
        {'style', 'text', 'string', 'Interpolation order', ...
        'TooltipString', defaultStruct.interpolationOrder.description}...
        {'style', 'popupmenu', 'string', 'Post-reference|Pre-reference|None', ...
        'tag', 'interpolationOrder', 'ForegroundColor', ...
        textColorStruct.interpolationOrder}...
        {'style', 'text', 'string', 'Mean estimate type', ...
        'TooltipString', defaultStruct.meanEstimateType.description}...
        {'style', 'popupmenu', 'string', 'Huber|Median|Mean|None', ...
        'value', meanEstimateTypeValue, 'tag', 'meanEstimateType', ...
        'ForegroundColor', textColorStruct.reportingLevel}...
        {'style', 'edit', 'string', ...
        num2str(defaultStruct.samples.value), ...
        'tag', 'samples', 'visible', 'off'}...
        {'style', 'text', 'string', ''},...
        {'style', 'text', 'string', ''}};
    
    [~, ~, ~, paramsOut] = ...
        inputgui('geometry', geometry, 'geomvert', geomvert, ...
        'uilist', uilist, 'title', title, 'helpcom', ...
        'pophelp(''pop_prepPipeline'')');
    if(isempty(paramsOut))
        break;
    end
    [paramsOut, typeErrors, fNamesErrors] = ...
        changeType(paramsOut, defaultStruct);
    paramsOut.referenceType = ...
        typeMenuString(paramsOut.referenceType, referenceTypeMenu);
    paramsOut.reportingLevel = ...
        typeMenuString(paramsOut.reportingLevel, reportingLevelMenu);
    paramsOut.interpolationOrder = ...
        typeMenuString(paramsOut.interpolationOrder, interpolationOrderMenu);
    paramsOut.meanEstimateType = ...
        typeMenuString(paramsOut.meanEstimateType, meanEstimateTypeMenu);
    mainFigure = findobj('Type', 'Figure', '-and', 'Name', inputData.name);
    userdata = get(mainFigure, 'UserData');
    userdata.reference = paramsOut;
    set(mainFigure, 'UserData', userdata);
    if isempty(typeErrors)
        break;
    end
    textColorStruct = highlightErrors(fNamesErrors, ...
        fNamesDefault, textColorStruct);
    displayErrors(typeErrors); % Displays the errors and restarts GUI
end

    function position = typeMenuPosition(theString, menuString)
        menuIndex = 1:length(menuString);
        position = strcmpi(theString, menuString);
        position = menuIndex(position);
    end

    function theString = typeMenuString(position, menuString)
        theString = menuString{position};
    end

end
