%imds = imageDatastore('train', 'IncludeSubfolders',true, 'LabelSource','foldernames');
function label = classify_emotion(person)
    % Function that classifies the facial emotion of a person.
    % Input: person - An array containing the person's face
    % Returns the classification as 
    % 'angry', 'sad', 'disgusted', 'fearful', 
    % 'happy', 'surprised', 'neutral'

    % The input needs to be greyscale and 48 x 48
    person = im2gray(person);
    person = imresize(person, [48 48]);

    % Run through network
    load("network.mat");
    label = classify(trainedNetwork_2, person);
end
