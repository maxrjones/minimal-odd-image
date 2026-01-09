# Inherit from a JupyterHub compatible Docker image
FROM quay.io/jupyter/base-notebook:2024-10-14

RUN echo ${NB_UID}
# Add conda packages
COPY environment.yml /tmp/environment.yml
RUN mamba env update --prefix ${CONDA_DIR} --file /tmp/environment.yml

COPY apt.txt /tmp/apt.txt

USER root

RUN apt-get update && \
    xargs -a /tmp/apt.txt apt install -y && \
    apt-get autoremove -y && \
    apt-get autoclean && \
    rm -rf /var/lib/apt/lists/* && \
    rm /tmp/apt.txt

RUN curl "https://awscli.amazonaws.com/awscli-exe-linux-x86_64.zip" -o "awscliv2.zip" && \
    unzip awscliv2.zip && \
    ./aws/install

USER ${NB_UID}
