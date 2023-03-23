# Start with the official PyTorch image
FROM pytorch/pytorch:1.10.0-cuda11.3-cudnn8-runtime

# Set the working directory
WORKDIR /app

# Install necessary packages
RUN apt-get update && apt-get install -y \
    ffmpeg \
    libsm6 \
    libxext6 \
    libfontconfig1 \
    libxrender1 \
    && rm -rf /var/lib/apt/lists/*

# Copy files to the working directory
COPY visual_chatgpt.py requirement.txt download.sh ./

# Create a new environment and install dependencies
RUN conda create -n visgpt python=3.8 -y && \
    echo "conda activate visgpt" >> ~/.bashrc && \
    /bin/bash -c "source ~/.bashrc" && \
    pip install --no-cache-dir -r requirement.txt && \
    bash download.sh && \
    conda clean --all --yes && \
    rm -rf /opt/conda/pkgs/*

# Set an environment variable for the OpenAI API key
ENV OPENAI_API_KEY=''

# Create a new directory for the generated images
RUN mkdir /app/image && chmod 777 /app/image

# Start the application
CMD ["bash", "-c", "python visual_chatgpt.py"]