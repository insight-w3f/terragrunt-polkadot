import subprocess
import sys
from os import listdir, path

import inquirer
import typer
import yaml
from jinja2 import Template, FileSystemLoader, Environment

app = typer.Typer()

STACKS_AVAILABLE = sorted([i.split('.')[0] for i in listdir('stacks')])
DEPLOYMENTS_AVAILABLE = sorted([i for i in listdir('deployments')])


def prompt_deployment_action(action: str):
    deployments = inquirer.prompt([inquirer.Checkbox('deployments',
                                                     message=f"What deployments would you like to {action}?",
                                                     choices=DEPLOYMENTS_AVAILABLE,
                                                     default=DEPLOYMENTS_AVAILABLE[0])])['deployments']
    sys.exit('Need to select provider') if len(deployments) == 0 else None
    return deployments


def prompt_deployment_create():
    deployment_questions = [
        inquirer.Text('namespace',
                      message='What namespace?',
                      default='polkadot'),
        inquirer.List('network_name',
                      message='What network name?',
                      choices=['kusama', 'mainnet'],
                      default='kusama'),
        inquirer.Text('environment',
                      message='What environment?',
                      default='prod'),
    ]
    return inquirer.prompt(deployment_questions)


def prompt_data_center():
    with open(path.join('configs', 'regions.yaml')) as f:
        regions_available = yaml.load(f, Loader=yaml.FullLoader)

    providers = inquirer.prompt([inquirer.Checkbox('providers',
                                                   message='What providers?',
                                                   choices=[('AWS', 'aws'),
                                                            ('Google Cloud', 'gcp'),
                                                            ('Azure', 'azure'),
                                                            ('DigitalOcean', 'do')],
                                                   default=('aws', 'gcp'))])['providers']
    sys.exit('Need to select provider') if len(providers) == 0 else None

    regions = {}
    for p in providers:
        regions[p] = inquirer.prompt([inquirer.Checkbox(p,
                                                        message=f'What regions for {p}?',
                                                        choices=regions_available[p],
                                                        default=regions_available[p][0])])[p]
    return regions


def prompt_user_vars(user_vars: dict):
    for k, v in user_vars.items():
        # Single choice
        if isinstance(v, str):
            user_vars.update({k: inquirer.prompt([inquirer.Text(k, message=k + "?", default=v)])[k]})

        if isinstance(v, list):
            user_vars.update({k: inquirer.prompt([inquirer.List(k, message=k + "?", choices=v)])[k]})
    return user_vars


def render_targets(targets: str, provider: str):
    output_targets = []
    for t in targets:
        output_targets.append(Template(t).render({'provider': provider}))
    return output_targets


def render_variables_file(context: dict, template_name: str = 'variables.hcl.j2'):
    with open(path.join('templates', template_name)) as file_:
        template = Template(file_.read())

    with open("variables.hcl", "w") as f:
        f.write(template.render(context))


def get_provider_from_region(region: str):
    pass


def run_subprocess(command: str):
    p = subprocess.Popen(command, shell=True, stdout=subprocess.PIPE, stderr=subprocess.PIPE)
    output, err = p.communicate()
    if err:
        sys.exit(err)
    return output


@app.command()
def create(stack: str = None, context: str = None, no_input: bool = False):
    # Find available stacks from 'stacks' directory and ask user which stack they want to deploy
    if not stack:
        stack = inquirer.prompt(
            [inquirer.List('stack', message="What stack do you want to create?", choices=STACKS_AVAILABLE)])['stack']
    sys.exit('Stack not available ') if stack not in STACKS_AVAILABLE else None
    with open(path.join('stacks', stack + '.yaml')) as f:
        stack_config = yaml.load(f, Loader=yaml.FullLoader)

    # Load context
    sys.exit('Need to supply context when no input - exiting') if not context and no_input else None
    if context:
        with open(context, 'r') as f:
            context_dict = yaml.load(f, Loader=yaml.FullLoader)
    else:
        context_dict = {}
        
    # 
    # TODO: Need to fillout context logic... This is garbage now 
    # 
    # Validate context
    if no_input and not {'namespace', 'environment'} <= context_dict.keys():
        sys.exit('Need to provide namespace network_name environment region provider in context')
    else:
        context_dict.update(prompt_deployment_create())

    # Prompt user for stack user vars
    context_dict.update(prompt_user_vars(stack_config['user_vars']))
    # Prompt for provider and region
    deployment_target_map = prompt_data_center()

    for p in deployment_target_map:
        targets = render_targets(stack_config['targets'], p)

        for r in deployment_target_map[p]:
            deployment_dict = {'targets': targets, 'vars': context_dict}
            deployment_file_name = f"{stack}.{context_dict['namespace']}.{context_dict['network_name']}.{r}.yaml"
            with open(path.join('deployments', deployment_file_name), 'w') as f:
                yaml.dump(deployment_dict, f, default_flow_style=False, sort_keys=False)

#     TODO: Ask if want to deploy right away 

# @app.command()
# def list_deployments():
#     print(DEPLOYMENTS_AVAILABLE)
#     return DEPLOYMENTS_AVAILABLE


@app.command()
def apply(deployment: str = 'current'):
    # Iterates through targets and applies each one
    if deployment == 'select':
        deployments = prompt_deployment_action('apply')
    else:
        deployments = [deployment]

    for d in deployments:
        with open(path.join('deployments', d)) as f:
            deployment_config = yaml.load(f, Loader=yaml.FullLoader)

        for t in deployment_config['targets']:
            command = f"terragrunt apply --terragrunt-source-update --terragrunt-non-interactive --auto-approve --terragrunt-working-dir{t}"
            run_subprocess(command)


@app.command()
def destroy(deployment: str = 'select'):
    # Iterates through targets and destroys each one
    if deployment == 'select':
        deployments = prompt_deployment_action('destroy')
    else:
        deployments = [deployment]

    print(deployments)

    for d in deployments:
        with open(path.join('deployments', d)) as f:
            deployment_config = yaml.load(f, Loader=yaml.FullLoader)

        for t in deployment_config['targets'].reverse():
            command = f"terragrunt destroy --terragrunt-source-update --terragrunt-non-interactive --auto-approve --terragrunt-working-dir{t}"
            run_subprocess(command)


if __name__ == '__main__':
    app()
