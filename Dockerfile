FROM python:3.8-slim

COPY ./ /app
WORKDIR /app

ARG AWS_ACCESS_KEY_ID
ARG AWS_SECRET_ACCESS_KEY


# aws credentials configuration
ENV AWS_ACCESS_KEY_ID=$AWS_ACCESS_KEY_ID \
    AWS_SECRET_ACCESS_KEY=$AWS_SECRET_ACCESS_KEY


# install requirementss
RUN pip install "dvc[s3]"   # since s3 is the remote storage
RUN pip install -r requirements.txt

# initialise dvc
RUN dvc init -f --no-scm

# configuring remote server in dvc
RUN  dvc remote add -f -d remote s3://shivamlopsbucket/

RUN cat .dvc/config

# pulling the trained model
RUN dvc pull

ENV LC_ALL=C.UTF-8
ENV LANG=C.UTF-8

# running the application
EXPOSE 5001
CMD ["python", "app.py",]
#CMD ["uvicorn", "app:app", "--host", "0.0.0.0", "--port", "8000"]
