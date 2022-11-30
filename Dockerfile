FROM python:3.10

ARG TENSORFLOW_MODELS_REPOSITORY=https://github.com/tensorflow/models

WORKDIR /notebooks

RUN apt-get update && apt-get install -y protobuf-compiler libgl1 &&\
    git clone --depth 1 ${TENSORFLOW_MODELS_REPOSITORY} &&\
        cd models/research/ &&\
        protoc object_detection/protos/*.proto --python_out=. &&\
        cp object_detection/packages/tf2/setup.py . &&\
        python -m pip install .

COPY ./requirements.txt .
RUN pip install -r requirements.txt

COPY notebooks /notebooks/

WORKDIR /notebooks

CMD ["jupyter", "lab", "--ip", "0.0.0.0", "--port", "8888", "--NotebookApp.token=''", "--NotebookApp.password=''", "--no-browser", "--allow-root"]