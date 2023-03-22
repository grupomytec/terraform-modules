FROM python:3.10.9-alpine3.17 as builder

ENV PYTHONDONTWRITEBYTECODE 1
ENV PYTHONUNBUFFERED 1
ENV PYTHON_SCRIPT="ecs-ec2-spotio"
ENV VIRTUAL_ENV=/opt/venv

RUN python3 -m venv $VIRTUAL_ENV

ENV PATH="$VIRTUAL_ENV/bin:$PATH"

COPY ./$PYTHON_SCRIPT $PYTHON_SCRIPT

WORKDIR $PYTHON_SCRIPT

RUN pip3 install -r requirements.txt

FROM python:3.10.9-alpine3.17

ENV VIRTUAL_ENV=/opt/venv

COPY --from=builder $VIRTUAL_ENV $VIRTUAL_ENV

ENV TERRAFORM_DIR="/opt/terraform"
ENV PYTHON_SCRIPT="$TERRAFORM_DIR/ecs-ec2-spotio"
ENV SCRIPT_DIR="$TERRAFORM_DIR/scripts"
ENV PATH="$VIRTUAL_ENV/bin:$PATH"

RUN apk update && apk add --no-cache terraform aws-cli python3 py3-pip git jq

WORKDIR $TERRAFORM_DIR
COPY . .

RUN chmod -R +x $SCRIPT_DIR/* && \
    chmod -R +x $PYTHON_SCRIPT/*

WORKDIR /usr/bin
RUN ln -s $SCRIPT_DIR/ecs-manager.sh ecs-manager

WORKDIR /

CMD [ "/bin/ash" ]