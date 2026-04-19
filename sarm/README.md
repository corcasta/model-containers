# lerobot-sarm

## Modified `lerobot` files

This repo vendors a copy of [`lerobot`](./lerobot) version **0.5.2**, with local modifications on top of upstream commit `bd74f673` (`chore: bump doc-builder SHA for PR upload workflow (#3386)`). The following files have been modified relative to that commit:

- `lerobot/src/lerobot/datasets/utils.py`
- `lerobot/src/lerobot/policies/sarm/processor_sarm.py`

## Prerequisites
This will only be used WHILE running the container.
Create a `.env` file in the project root with the following variables:

```
HF_TOKEN=<your_huggingface_token>
WANDB_API_KEY=<your_wandb_api_key>
```

## Build

```bash
docker build -t lerobot-sarm:v1 -f Dockerfile .
```

## Run

```bash
docker run --gpus all -it --env-file .env --shm-size 24G -v $PWD/train.sh:/work/train.sh lerobot-sarm:v1
```

Before running, you can edit `train.sh` to adjust training parameters (dataset, policy, steps, batch size, etc.) as needed. The script is mounted into the container at runtime, so changes take effect without rebuilding the image. To check what parameters are available just run `lerobot-train --help`

```bash
lerobot-train \
  --dataset.repo_id=mkohegyi/corkinbox100 \
  --policy.type=sarm \
  --policy.device=cuda \
  --policy.n_obs_steps=8 \
  --policy.frame_gap=30 \
  --policy.annotation_mode=single_stage \
  --policy.image_key=observation.images.context \
  --policy.push_to_hub=true \
  --policy.repo_id=corcastaQ/oscar-sarm-test \
  --output_dir=outputs/train/sarm_single \
  --batch_size=1 \
  --steps=5000 \
  --save_checkpoint=true \
  --save_freq=250 \
  --wandb.enable=true \
  --wandb.project=sarm
```


Use `--shm-size` to control how much shared memory is allocated to the container (e.g. `--shm-size 24G`). Increase this if you run into shared-memory errors during data loading.
