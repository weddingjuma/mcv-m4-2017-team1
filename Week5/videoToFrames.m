v = VideoReader('01_twolanes.MOV');
i=0;
while hasFrame(v)
    ii = sprintf('%06d', i);
    frame = readFrame(v);
    imwrite(frame, strcat('datasets/ronda/01_twolanes/', ii, '.jpg'))
    i = i+1;
end