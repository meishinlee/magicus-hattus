%openExample('vision/FaceTrackingUsingKLTExample')
function output = place_hat(person, randomize)
    % Function that places a hat on an image of a person.
    % Input: 
    %   person - the image of a person
    %   randomize - random hat index, 0 if randomized
    % Returns: The image of a person with a hat on

    % Create a cascade detector object.
    faceDetector = vision.CascadeObjectDetector();
    
    % Pass image through face detection model
    bbox = step(faceDetector, person);

    % Pass image through emotion classification model
    if size(bbox, 1) > 0
        [~, index] = max(bbox(:, 3));
        label = string(classify_emotion(person(bbox(index, 2):bbox(index, 2) + bbox(index, 4), bbox(index, 1):bbox(index, 1) + bbox(index, 3))));
    else
        label = '';
    end

    % Load hat image. You must have "hats" inside the same folder as the
    % place_hat.mlx file.
    hats = ["hats\hat-transparent.png" "hats\SortingHat-transparent.png" "hats\BunnyHat-transparent.png" "hats\Mickey-transparent.png" "hats\WitchHat-transparent.png" "hats\WizardHat-transparent.png" "hats\UnicornHorn-transparent.png"];

    % Load lightning image. You must have "lightning-transparent.png"
    % inside the same folder as the plaace_hat.mlx file.
    [lightning, ~, lightning_trans] = imread("lightning-transparent.png");
    lightning_trans = cat(3, lightning_trans, lightning_trans, lightning_trans);
    lightning_w = size(person, 2) / 4;
    lightning_h = round(lightning_w / size(lightning, 2) * size(lightning, 1));
    lightning = imresize(lightning, [lightning_h lightning_w]);
    lightning_trans = imresize(lightning_trans, [lightning_h lightning_w]);

    r = randomize;

    for i = 1:size(bbox, 1)
        % Get x, y, width, height of bounding box
        bbox_x = bbox(i, 1);
        bbox_y = bbox(i, 2);
        bbox_w = bbox(i, 3);

        % Get hat
        if randomize == 0
            r = randi([1 size(hats, 2)], 1, 1);
        end
        [hat, ~, trans] = imread(hats(r));
        trans = cat(3, trans, trans, trans);
        
        % bbox_w is the width of the hat
        % new_h is the height of the hat
        new_h = round(bbox_w / size(hat, 1) * size(hat, 2));
        hat_resize = imresize(hat, [new_h, bbox_w]);
        trans_resize = imresize(trans, [new_h, bbox_w]);
        
        % Crop the hat in case it goes above the image of the person
        hat_cropped = imcrop(hat_resize, [1 (new_h-bbox_y+1) bbox_w bbox_y]);
        trans_cropped = imcrop(trans_resize, [1 (new_h-bbox_y+1) bbox_w bbox_y]);
        
        % Overlay images
        if size(hat_cropped, 1) == new_h
            % Has not been cropped
            temp = person(bbox_y-new_h+1:bbox_y, bbox_x:bbox_x + bbox_w, :);
            temp(trans_cropped > 0) = hat_cropped(trans_cropped > 0);
            person(bbox_y-new_h+1:bbox_y, bbox_x:bbox_x + bbox_w, :) = temp;
        else
            % Has been cropped
            temp = person(1:bbox_y, bbox_x:bbox_x + bbox_w, :);
            temp(trans_cropped > 0) = hat_cropped(trans_cropped > 0);
            person(1:bbox_y, bbox_x:bbox_x + bbox_w, :) = temp;
        end

        % Add lightning
        if strcmp(label, 'angry') || strcmp(label, 'sad') || strcmp(label, 'fearful') || strcmp(label, 'disgusted')
            for j = 1:3
                lightning_x = randi([1 size(person, 2)-size(lightning, 2)], 1, 1);
                lightning_y = randi([1 size(person, 1)-size(lightning, 1)], 1, 1);
                temp = person(1+lightning_y:lightning_h+lightning_y, 1+lightning_x:lightning_w+lightning_x, :);
                temp(lightning_trans > 0) = lightning(lightning_trans > 0);
                person(1+lightning_y:lightning_h+lightning_y, 1+lightning_x:lightning_w+lightning_x, :) = temp;
            end
        end
    end
    output = person;
end
