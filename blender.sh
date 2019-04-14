#!/bin/sh

IMAGE_ID=1

# voxceleb video id (in crop/videos/*)
# Options:
# 00116
# 00296
# 00329
VIDEO_ID=00329

# Clean up
rm -rf src/crop/out.mp4
rm -rf src/crop/out_audio.mp4

# Change to source dir
cd src/

# Generate ./crop/1.png
~/anaconda3/envs/icface-dlib/bin/python image_crop.py \
    --image ./crop/test/trump.jpeg \
    --id $IMAGE_ID

# Generate a sample video
~/anaconda3/envs/icface/bin/python test.py \
    --dataroot ./ \
    --model pix2pix \
    --which_model_netG resnet_6blocks \
    --which_direction AtoB \
    --dataset_mode aligned \
    --norm batch \
    --display_id 0 \
    --batchSize 1 \
    --loadSize 128 \
    --fineSize 128 \
    --no_flip \
    --name gpubatch_resnet \
    --how_many 1 \
    --ndf 256 \
    --ngf 128 \
    --which_ref ./crop/$IMAGE_ID.png \
    --gpu_ids 0 \
    --csv_path ./crop/videos/$VIDEO_ID.csv \
    --results_dir results_video

# Splice the audio
ffmpeg \
    -i ./crop/out.mp4 \
    -i ./crop/videos/$VIDEO_ID.mp4 \
    -c copy -map 0:0 -map 1:1 -shortest \
    ./crop/out_audio.mp4