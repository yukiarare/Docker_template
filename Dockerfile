# ベースイメージを指定
FROM nvidia/cuda:11.8.0-base-ubuntu22.04

# 作業ディレクトリを設定
WORKDIR /code

# 必要なパッケージのインストールと設定
RUN apt-get update && \
    apt-get -y upgrade && \
    apt-get install -y curl python3 python3-distutils git && \
    curl https://bootstrap.pypa.io/get-pip.py -o get-pip.py && \
    python3 get-pip.py && \
    rm get-pip.py && \
    ln -sf $(which python3) /usr/bin/python

# requirements.txtをコピーし、必要なPythonパッケージをインストール
COPY ./requirements.txt /code/
RUN pip install --upgrade pip && \
    pip install -r requirements.txt

# Gitの設定
RUN git config --global user.email "nrpyk.osaka@gmail.com" && \
    git config --global user.name "yukiarare"

# データストアとデータセット用のボリュームを設定

RUN mkdir /mnt/home
RUN mkdir /mnt/nfs

COPY fstab /etc/fstab

# 作業ディレクトリを設定
WORKDIR /mnt

# Jupyter Notebookの設定ファイルをコピー
COPY jupyter_notebook_config.py /root/.jupyter/jupyter_notebook_config.py

# デフォルトコマンドを設定
CMD mount -a & jupyter lab --ip=0.0.0.0 --allow-root --port 8888 --NotebookApp.token='' --no-browser
