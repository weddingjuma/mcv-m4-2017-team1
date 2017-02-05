function displayTrackingResults(frame,mask,tracks,velocity)
% Convert the frame and the mask to uint8 RGB.
frame = im2uint8(frame);
mask = uint8(repmat(mask, [1, 1, 3])) .* 255;

minVisibleCount = 4;
if ~isempty(tracks)
    
    % Noisy detections tend to result in short-lived tracks.
    % Only display tracks that have been visible for more than
    % a minimum number of frames.
    reliableTrackInds = ...
        [tracks(:).totalVisibleCount] > minVisibleCount;
    reliableTracks = tracks(reliableTrackInds);
    
    % Display the objects. If an object has not been detected
    % in this frame, display its predicted bounding box.
    if ~isempty(reliableTracks)
        % Get bounding boxes.
        bboxes = cat(1, reliableTracks.bbox);
        
        % Get ids.
        ids = int32([reliableTracks(:).id]);
        
        % Create labels for objects indicating the ones for
        % which we display the predicted rather than the actual
        % location.
        labels = cellstr(int2str(ids'));
        velocity1=cell2mat(velocity);
        predictedTrackInds = ...
            [reliableTracks(:).consecutiveInvisibleCount] > 0;
        isPredicted = cell(size(labels));
        isPredicted(predictedTrackInds) = {' predicted'};
        labelsextra=cell(size(labels));
        color={};
        for k=1:length(ids)
            labelsextra(k)= { ' velocity= '};
        end
        
        if isempty(velocity)
            labels = strcat(labels, isPredicted);
        else
            vel=cellstr(int2str(velocity1(ids)'));
            labels = strcat(labels, labelsextra ,vel, isPredicted);
             v=velocity1(ids)
            for k=1:length(v)
           
            if v(k)>100
                if isempty(color)
                    color{1}='red';
                else
                color{end+1}='red';
                end
            else
                if isempty(color)
                    color{1}='yellow';
                else
                color{end+1}='yellow';
                end
            end
            end
            color
        end
        
        % Draw the objects on the frame.
        frame = insertObjectAnnotation(frame, 'rectangle', ...
            bboxes, labels,'Color',color);
         % Draw the objects on the mask.
        mask = insertObjectAnnotation(mask, 'rectangle', ...
            bboxes, labels,'Color',color);

    end
end

% Display the mask and the frame.
subplot(1,2,1)
imshow(frame)
subplot(1,2,2)
imshow(mask)
drawnow()
end