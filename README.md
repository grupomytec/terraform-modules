# terraform-modules

Terraform Modules created by Grupo Mytec

## How it works

Basically this set of modules works through a set of scripts that can and should be specified within a pipeline for creating resources.

The variables necessary for the operation are defined through files or during the execution of the container by environment variables.

### Container dependency's

For everything to work correctly you need to define some basic variables for the whole process to start.

    # dependency of the script with terraform and the other modules
    export APP_NAME=""                  # < app name is used for resource segment  
    export CLUSTER_NAME=""              # < cluster name's is used for resource ref
    export ENVIRONMENT=""               # < environment is used for segmentation
    export ENV_DIR=""                   # < app envs directory's

    # aws environment variables dependency
    export AWS_REGION=""                # < aws region of resource implement  
    export AWS_ACCESS_KEY_ID=""         # < aws acces key
    export AWS_SECRET_ACCESS_KEY=""     # < aws secret's access key 

    # spotio credentials
    export SPOTIO_AUTH_TOKEN=""         # < spotio user api token    
    export SPOTIO_AUTH_USER=""          # < spotio api user e.g "act-..."
    export SPOTIO_ACCOUNT=""            # < spotio cluster account e.g "Rock Stage Dev"

### Running scripts pipeline

To run the terraform templates the automation scripts can be called according to the templade naming as follows.

    ...
    env:
        export APP_NAME=""
        export CLUSTER_NAME=""
        export ENVIRONMENT=""
        export ENV_DIR=""
        ...

    - name: Create ecs ec2 cluster
      run: ecs-manager --stage ecs-ec2-cluster

    - name: Import created ecs ec2 cluster to spotio
      run: ecs-manager --stage ecs-ec2-spotio
    ...

###  How to implement as pipeline

[**Here**](docs/iac-terraform.yml) is an example of how to implement the pipeline with the container running the set of automation scripts.


