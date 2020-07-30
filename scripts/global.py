import yaml
import os

def update_keys(key_type, environment, update_value):
    with open('secrets.yaml', 'r') as f:
        secrets = yaml.safe_load(f)

    public_key_types = ['public_key', 'public_key_path', 'key_name', 'private_key', 'private_key_path']
    # private_key_types = []

    public_key_types.remove('key_type')

    with open('secrets.yaml', 'w') as f:
        yaml.dump()


