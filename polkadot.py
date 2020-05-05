import sys
from os import listdir, path
import inquirer
import typer
from jinja2 import Template
import yaml

app = typer.Typer()


def prompt_deployment():
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
        if type(v) == str:
            user_vars.update({k: inquirer.prompt([inquirer.Text(k, message=k + "?", default=v)])[k]})

        if type(v) == list:
            user_vars.update({k: inquirer.prompt([inquirer.List(k, message=k + "?", choices=v)])[k]})
    return user_vars


def render_targets(targets: str, provider: str):
    output_targets = []
    for t in targets:
        output_targets.append(Template(t).render({'provider': provider}))
    return output_targets


@app.command()
def create(stack: str = None, context: str = None, no_input: bool = False):
    # Find available stacks from 'stacks' directory and ask user which stack they want to deploy
    stacks_available = sorted([i.split('.')[0] for i in listdir('stacks')])
    if not stack:
        stack = inquirer.prompt(
            [inquirer.List('stack', message="What stack do you want to create?", choices=stacks_available)])['stack']
    sys.exit('Stack not available ') if stack not in stacks_available else None
    with open(path.join('stacks', stack + '.yaml')) as f:
        stack_config = yaml.load(f, Loader=yaml.FullLoader)

    # Load context
    sys.exit('Need to supply context when no input - exiting') if not context and no_input else None
    if context:
        with open(context, 'r') as f:
            context_dict = yaml.load(f, Loader=yaml.FullLoader)
    else:
        context_dict = {}
    # Validate context
    if no_input and not {'namespace', 'environment'} <= context_dict.keys():
        sys.exit('Need to provide namespace network_name environment region provider in context')
    else:
        context_dict.update(prompt_deployment())

    # Prompt user for stack user vars
    context_dict.update(prompt_user_vars(stack_config['user_vars']))
    # Prompt for provider and region
    deployment_target_map = prompt_data_center()

    for p in deployment_target_map:
        targets = render_targets(stack_config['targets'], p)

        for r in deployment_target_map[p]:
            deployment_dict = {'targets': targets, 'vars': context_dict}
            deployment_file_name = f"{stack}.{context_dict['namespace']}.{r}.yaml"
            with open(path.join('deployments', deployment_file_name), 'w') as f:
                yaml.dump(deployment_dict, f, default_flow_style=False, sort_keys=False)


if __name__ == '__main__':
    app()
