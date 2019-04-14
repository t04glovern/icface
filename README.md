# ICface

Repository cleanup of [Blade6570/icface](https://github.com/Blade6570/icface) while I play around with it.

## Setup

The general requirements are as follows:

- Python 3.7
- Pytorch 0.4.1.post2
- Visdom and dominate
- Natsort

### Pretrained Model

The following command uses `aws s3` to pull the pretrained model to `src/checkpoints/gpubatch_resnet/`

```bash
./data_get.sh get
```

### Conda

I've ported all this into a nice little conda environment for you to use

```bash
conda env create -f environment.yml
conda env create -f environment-dlib.yml
cd src
```

## Generate Image

```bash
# Activate dlib conda
conda activate icface-dlib

# Generate ./crop/1.png
python image_crop.py \
  --image ./crop/test/trump.jpeg \
  --id 1
```

## Generate Video

```bash
# Activate icface conda
conda activate icface

# Generate a sample video
python test.py \
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
  --which_ref ./crop/<video-id>.png \
  --gpu_ids 0 \
  --csv_path ./crop/videos/<input-video>.csv \
  --results_dir results_video

# Splice the audio
ffmpeg -i ./crop/out.mp4 -i ./crop/videos/<input-video>.mp4 -c copy -map 0:0 -map 1:1 -shortest ./crop/out_audio.mp4
```

## Generating Action Points

```bash
# Outside Container
docker run -it --rm algebr/openface:latest

# Outside Container (new terminal window)
docker cp src/crop/videos/<video-id>.mp4 <docker-container>:/home/openface-build

# Within container (/home/openface-build)
./build/bin/FeatureExtraction -f <video-id>.mp4

# Outside Container
docker cp <docker-container>:/home/openface-build/processed/<video-id>.csv src/crop/videos
```

## Attribution

- [https://github.com/Blade6570/icface](https://github.com/Blade6570/icface)

```bash
@article{tripathy+kannala+rahtu,
  title={ICface: Interpretable and Controllable Face Reenactment Using GANs},
  author={Tripathy, Soumya and Kannala, Juho and Rahtu, Esa},
  journal={arXiv preprint arXiv:1904.01909},
  year={2019}
}
```

- [https://github.com/TadasBaltrusaitis/OpenFace](https://github.com/TadasBaltrusaitis/OpenFace)
  - [Command line arguments](https://github.com/TadasBaltrusaitis/OpenFace/wiki/Command-line-arguments)
  - [Docker setup](https://github.com/TadasBaltrusaitis/OpenFace/wiki#quickstart-usage-of-openface-with-docker-thanks-edgar-aroutiounian)