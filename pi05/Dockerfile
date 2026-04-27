FROM nvcr.io/nvidia/cuda:12.8.0-runtime-ubuntu24.04
WORKDIR /work

COPY . .

RUN apt update -y \
    && apt upgrade -y \
    && apt install build-essential ffmpeg curl python3 python3-venv python3-dev -y 

ENV PATH="/root/.local/bin:${PATH}"           

# UV installation and env activation
RUN curl -LsSf https://astral.sh/uv/install.sh | sh \
    && uv venv --python 3.12 \
    && . .venv/bin/activate \
    && uv pip install 'lerobot[dataset]' 'lerobot[training]' \
    && cd lerobot \
    && uv pip install -e ".[sarm]"

RUN echo 'source /work/.venv/bin/activate' >> /root/.bashrc \
    && chmod +x setup.sh

# git setup
RUN apt install git -y
RUN git config --global credential.helper store

# Hugging Face CLI Setup for model training
RUN curl -LsSf https://hf.co/cli/install.sh | bash

# We need to figure this out
# RUN hf auth login --token "$HF_TOKEN" --add-to-git-credential

ENTRYPOINT ["./setup.sh"]