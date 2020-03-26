import os
from shutil import rmtree, move, copytree, copy
import yaml

# The dir with the templates
# HOOKS_DIR = os.path.dirname(os.path.abspath(__file__))
PROJECT_DIR = os.path.realpath(os.path.curdir)
PARENT_DIR = os.path.dirname(PROJECT_DIR)
SRC_DIR = os.path.join(PARENT_DIR, 'polkadot')
DEPLOYMENT_NAME = '{{cookiecutter.deployment_name}}'

print(os.listdir(PROJECT_DIR))

with open(os.path.join(PROJECT_DIR, 'paths.yaml')) as f:
    config_files = yaml.load(f, Loader=yaml.FullLoader)

# config_files = [
#     {'name': 'account_aws.hcl.j2',
#      'path': 'aws/account.hcl'},
#     {'name': 'account_packet.hcl.j2',
#      'path': 'packet/account.hcl'},
#     {'name': 'global.yaml.j2',
#      'path': 'global.yaml'},
#     {'name': 'ansible_inventory.tpl.j2',
#      'path': 'ansible-playbook/ansible_inventory.tpl'},
#     {'name': 'region.hcl.j2',
#      'path': 'region.hcl'},
#     {'name': 'secrets.yaml.j2',
#      'path': 'secrets.yaml'},
#     {'name': 'sentry_aws.tfvars.j2',
#      'path': 'aws/sentry/terraform.tfvars'},
# ]

def move_files_to_dir(target_dir):
    for file in config_files:
        move(os.path.join(PROJECT_DIR, file['name']), os.path.join(target_dir, file['path']))


def main():
    if DEPLOYMENT_NAME in ['default']:
        # Case where one is deploying locally
        move_files_to_dir(SRC_DIR)
        rmtree(PROJECT_DIR)
    else:
        # Case where one is creating a new deployment to be tracked separately
        files = os.listdir(SRC_DIR)
        for f in files:
            if os.path.isdir(os.path.join(SRC_DIR, f)):
                copytree(os.path.join(SRC_DIR, f), os.path.join(PROJECT_DIR, f))
            if os.path.isfile(os.path.join(SRC_DIR, f)):
                copy(os.path.join(SRC_DIR, f), os.path.join(PROJECT_DIR, f))
        move_files_to_dir(PROJECT_DIR)


if __name__ == '__main__':
    main()
