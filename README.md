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

To run the terraform templates the automation scripts can be called according to the templade naming as follows. Pay attention to the definition of the **ENV_DIR** variable, this is where we define all the environment and application settings, for that there is a directory structure.

you can define any directory to store the reports just keep in mind that the files follow the pattern: 

    ├── .iac                     <-- just remember to point it in the ENV_DIR or CONFIGS variable
    └── test                     <-- just remember to point it in the ENV_DIR or CONFIGS variable
        ├── app-secrets.json     <-- default application secrets file don't rename
        ├── app.json             <-- default application environment file don't rename
        ├── ecs-ec2-alb.env      <-- default application load balancer config file not rename
        ├── ecs-ec2-cluster.env  <-- default elastic cluster config file not rename
        └── ecs-ec2-service.env  <-- default service/task config file not rename

then just configure the pipeline
    ...
    
    jobs:

      create:
        environment: ""
        runs-on: ubuntu-latest
        container:
          image: ghcr.io/${{ github.repository }}:dev
        env:
          ENVIRONMENT: ""
          APP_NAME: ""
          CLUSTER_NAME: ""
          SPOTIO_ACCOUNT: ""
          AWS_REGION: ""
          AWS_ACCESS_KEY_ID: ""
          AWS_SECRET_ACCESS_KEY: ""
          SPOTIO_AUTH_USER: ""
          SPOTIO_AUTH_TOKEN: ""
          CONFIGS: ""
          ...

      - name: Checkout
        uses: actions/checkout@v3

      - name: Define Environment Directory
        run: |
          export ENV_DIR="$PWD/$CONFIGS"

      - name: Create Cluster
        run: ecs-manager --stage ecs-ec2-cluster
      
      - name: Create Alb
        run: ecs-manager --stage ecs-ec2-alb

      - name: Import Cluster
        run: ecs-manager --stage ecs-ec2-spotio
      
      - name: Create Service
        run: ecs-manager --stage ecs-ec2-service
        ...

###  How to implement as pipeline

[**Here**](docs/iac-terraform.yml) is an example of how to implement the pipeline with the container running the set of automation scripts.


