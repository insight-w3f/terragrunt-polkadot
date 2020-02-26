import os
from shutil import rmtree, move, copytree, copy

# The dir with the templates
PROJECT_DIR = os.path.realpath(os.path.curdir)
PARENT_DIR = os.path.dirname(PROJECT_DIR)
SRC_DIR = os.path.join(PARENT_DIR, 'polkadot')
DEPLOYMENT_NAME = '{{cookiecutter.deployment_name}}'

config_files = [
    {'name': 'account_aws.tfvars.j2',
     'path': 'aws/account.tfvars'},
    {'name': 'account_packet.tfvars.j2',
     'path': 'packet/account.tfvars'},
    {'name': 'global.yaml.j2',
     'path': 'global.yaml'},
    {'name': 'ansible_inventory.tpl.j2',
     'path': 'ansible-playbook/ansible_inventory.tpl'},
    {'name': 'region.tfvars.j2',
     'path': 'region.tfvars'},
    {'name': 'secrets.yaml.j2',
     'path': 'secrets.yaml'},
    {'name': 'sentry_aws.tfvars.j2',
     'path': 'aws/sentry/group.tfvars'},
]


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