FROM tensorflow/tensorflow:latest

# Install additional dependencies
RUN apt-get update && \
    apt-get install -y --no-install-recommends \
    git \
    wget \
    curl \
    unzip \
    libopencv-dev \
    python3-opencv \
    && \
    apt-get clean && \
    rm -rf /var/lib/apt/lists/*

# Install Keras and other Python packages
RUN pip install --upgrade pip && \
    pip install keras && \
    pip install pillow && \
    pip install matplotlib && \
    pip install opencv-python-headless && \
    pip install coremltools && \
    pip install jupyter

# Copy the application code to the container
COPY . /app

# Set the working directory
WORKDIR /app

# Start the Jupyter notebook server
CMD ["jupyter", "notebook", "--ip='0.0.0.0'", "--port=8888", "--no-browser", "--allow-root"]
