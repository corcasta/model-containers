# lerobot-sarm

## Modified `lerobot` files

This repo vendors a copy of [`lerobot`](./lerobot) version **0.5.2**, with local modifications on top of upstream commit `bd74f673` (`chore: bump doc-builder SHA for PR upload workflow (#3386)`). The following files have been modified relative to that commit:

- `lerobot/src/lerobot/policies/factory.py` line 511-522


## Prerequisites
This will only be used WHILE running the container.
Create a `.env` file in the project root with the following variables:

```
HF_TOKEN=<your_huggingface_token>
WANDB_API_KEY=<your_wandb_api_key>
```

## Build

```bash
docker build -t lerobot-pi05:v1 -f Dockerfile .
```

## Run

```bash
docker run --gpus all -it --env-file .env --shm-size 80G -v $PWD/train.sh:/work/train.sh lerobot-pi05:v1
```

Before running, you can edit `train.sh` to adjust training parameters (dataset, policy, steps, batch size, etc.) as needed. The script is mounted into the container at runtime, so changes take effect without rebuilding the image. To check what parameters are available just run `lerobot-train --help`

```bash
lerobot-train \
  --dataset.repo_id=corcastaQ/corkinbox100_curated_relative \
  --policy.repo_id=corcastaQ/oscar-pi05-cork-test \
  --policy.pretrained_path=lerobot/pi05_base \
  --policy.type=pi05 \
  --policy.device=cuda \
  --policy.gradient_checkpointing=true \
  --policy.n_obs_steps=30 \
  --policy.n_action_steps=30 \
  --policy.use_relative_actions=true \
  --policy.freeze_vision_encoder=false \
  --policy.train_expert_only=false \
  --policy.push_to_hub=true \
  --policy.compile_model=false \
  --rename_map='{"observation.images.wrist": "observation.images.left_wrist_0_rgb", "observation.images.context": "observation.images.base_0_rgb"}' \
  --policy.empty_cameras=1 \
  --policy.relative_exclude_joints='["gripper.pos"]' \
  --batch_size=32 \
  --steps=15000 \
  --save_checkpoint=true \
  --save_freq=500 \
  --wandb.enable=true \
  --wandb.project=pi05-cork \
  --output_dir=outputs/train/pi05_trained
```


Use `--shm-size` to control how much shared memory is allocated to the container (e.g. `--shm-size 24G`). Increase this if you run into shared-memory errors during data loading.
