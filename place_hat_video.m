function video_name = place_hat_video(input_video)
    % Function that places a hat on a video of a person.
    % Input: person - The video of the person
    % Output: A 10 letter video file name (does not include '.mp4')

    % Read a video frame
    videoReader = VideoReader(input_video);
    
    % Create video writer
    video_name = char(randi([97 122], 1, 10));
    v = VideoWriter(video_name, 'MPEG-4');
    open(v);
    
    % Select hat at random. Change num_hats to the number of hats
    num_hats = 7;
    rand = randi([1 num_hats], 1, 1);

    while hasFrame(videoReader)
        % Get the next frame
        videoFrame = readFrame(videoReader);
        videoFrame = place_hat(videoFrame, rand);
        
        % Display the annotated video frame using the video player object
        writeVideo(v, videoFrame);
    end
    close(v);
end
