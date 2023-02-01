#!/opt/venv/bin/python3

import requests
import os
import sys

# export SPOTIO_AUTH_TOKEN
# export SPOTIO_AUTH_USER
# export SPOTIO_ACCOUNT="Rock Stage Dev"

AUTH_TOKEN = os.getenv('SPOTIO_AUTH_TOKEN')
HEADERS = { f"Authorization" : f"Bearer {AUTH_TOKEN}" }
URLS = {
    "account_get": "https://api.spotinst.io/setup/account",
    "cluster_get": "https://api.spotinst.io/ocean/aws/ecs/cluster",
    "cluster_import": "https://api.spotinst.io/ocean/aws/ecs/cluster/{}/import",
    "cluster_create": "https://api.spotinst.io/ocean/aws/ecs/cluster/{}",
    "cluster_remove": "https://api.spotinst.io/ocean/aws/ecs/cluster/{}"
}

def get_uri(endpoint, account_id, value=""):
    return URLS[endpoint].format(value) + f"?accountId={account_id}"

def cluster_data_manager(cluster_data):
    cluster_data["cluster"]["compute"]["instanceTypes"] = {
        "whitelist": None
    }

    cluster_data["cluster"]["autoScaler"] = {
        "resourceLimits": {
            "maxMemoryGib": 2,
            "maxVCpu": 2
        }
    }

    cluster_data["cluster"]["capacity"] = {
        "target": 1,
        "minimum": 1,
        "maximum": 1000
    }

    cluster_data["cluster"]["compute"]["launchSpecification"]["tags"] = [{
        "tagKey": "default",
        "tagValue": "default"
    }]

    return cluster_data


def get_cluster_id(account_id):
    account_id = f"accountId={account_id}"

    uri_get_cluster_list = f"https://api.spotinst.io/ocean/aws/ecs/cluster?{account_id}"

    get_uri("cluster_get", account_id)

    cluster_list = requests.get(
        uri_get_cluster_list, headers=HEADERS)
    
    if cluster_list.status_code != 200:
        print('* fail to retrive cluster data')
        exit(1)

    return cluster_list.json()


def get_cluster_account_id(account_id):
    response = requests.get(
        get_uri("account_get", account_id), headers=HEADERS)

    print(f'\ntrying to get cluster account ...\n')

    if response.status_code != 200:
        print(f'* fail to get account and returned code {response.status_code}')
        exit(1)

    if len(response.json()["response"]) > 0:
        for item in response.json()["response"]["items"]:
            if spotio_account == item['name']:
                print(f'* account \"{spotio_account}\" with id {item["accountId"]}')

                return item['accountId']

def import_cluster(account_id, cluster_name):
    cluster_import_payload = {
        "region": f"{aws_region}",
        "name": f"{cluster_name}",
        # "instanceId": "i-0bb6630962c0c3df2"
    }

    print(f'\ntrying to import cluster data ...\n')

    cluster_import_reponse = requests.post(
        get_uri("cluster_import", account_id, cluster_name), 
        headers=HEADERS, 
        json=cluster_import_payload)

    if cluster_import_reponse.status_code != 200:
        print(f'* fail to import cluster data with code {cluster_import_reponse.status_code}')
        exit(1)

    cluster_data = cluster_import_reponse.json()
    cluster = cluster_data["response"]["items"]

    if len(cluster) == 0:
        print('* could not get cluster data')
        exit(1)

    cluster_payload = cluster_data_manager(cluster[0])

    cluster_creation = requests.post(
        get_uri("cluster_create", account_id), 
        headers=HEADERS, 
        json=cluster_data_manager(cluster_payload))

    if cluster_creation.status_code != 200:
        cluster_erros = cluster_creation.json()["response"]["errors"][0]["message"]

        print(f'* fail to create cluster with code {cluster_creation.status_code}')
        print(f'* {cluster_erros}')
        exit(1)
    
    print(f'* cluster \"{cluster_name}\" imported with sucess!')

def remove_cluster(account_id, cluster_name):

    cluster_content = get_cluster_id(account_id)

    cluster_spotio_id = ""

    if len(clustem_items := cluster_content["response"]["items"]) > 0:
        for cluster in clustem_items:
            if cluster["name"] == cluster_name:
                cluster_spotio_id = cluster["id"]

    cluster_delete = requests.delete(
        get_uri("cluster_remove", account_id, value=cluster_spotio_id), 
        headers=HEADERS)
    
    print(f'* cluster \"{cluster_name}\" removed with sucess!')
    


if __name__ == "__main__":
    auth_user = os.getenv('SPOTIO_AUTH_USER')
    spotio_account = os.getenv('SPOTIO_ACCOUNT')
    cluster_name = os.getenv('CLUSTER_NAME')
    aws_region = os.getenv('AWS_REGION')

    try:
        param = sys.argv[1]
    except:
        print(
            "select an option\n\n"
            " --import -i\n"
            "   import cluster on spotio using an existent one on AWS ECS\n"
            " --remove\n"
            "   remove a imported cluster from spotio\n")
        
        exit(0)

    if None in [auth_user, spotio_account, cluster_name, aws_region]:
        print("\n some environement variable wasn't set yet ...")
        exit(1)


    account_id = get_cluster_account_id(auth_user)
    if param == "--import" or param == "-i":
        import_cluster(account_id, cluster_name)

    if param == "--remove" or param == "-r":
        remove_cluster(account_id, cluster_name)
