import json
import logging
import tempfile
from os import path, listdir, mkdir
import sys
import typer
import yaml
from shutil import copyfile
from cookiecutter.main import cookiecutter

logger = logging.getLogger()
app = typer.Typer()


@app.command()
def create(stack: str = None, context: str = None, no_input: bool = False):
    
    temp_dir = tempfile.mkdtemp()

    if stack:
        typer.echo(f"Creating {stack} deployment")
    else:
        stack = typer.prompt("What stack do you want to create?")
        stacks_available = [i.split('.')[0] for i in listdir('stacks')]
        sys.exit('Stack not available ') if stack not in stacks_available else None

    typer.echo(f"Adding temp dir {temp_dir}")

    # Load the stack 
    with open(path.join('stacks', stack + '.yaml')) as f:
        stack_config = yaml.load(f, Loader=yaml.FullLoader)

    # Print the cookiecutter.json in tmp dir to run CC on
    with open(path.join(temp_dir, 'cookiecutter.json'), 'w') as f:
        json.dump(stack_config['user_vars'], f)

    # Create template dir for cookiecutter based on first item in user input.  This is just so we have a place to render
    template_dir = path.join(temp_dir, '{{cookiecutter.' + list(stack_config['user_vars'].keys())[0] + '}}')
    mkdir(template_dir)

    # Make deployment file with the values we need to render along with immutable stack vars  
    deployment_vars_tpl = {k: "{{cookiecutter." + k + "}}" for (k, v) in stack_config['user_vars'].items()}
    deployment_vars_tpl.update(stack_config['stack_vars'])
    with open(path.join(template_dir, 'cookiecutter.yaml'), 'w') as f:
        yaml.dump(deployment_vars_tpl, f, default_flow_style=False, sort_keys=False)

    cookiecutter(temp_dir, output_dir=temp_dir, no_input=no_input, extra_context=context)


@app.command()
def apply(stack: str, id: int = 0):
    typer.echo(f"Applying deployment = {stack}.{id}")

    if id == 0:
        ids = [i for i in listdir('deployments') if i.split('.')[0] == 'api-ha']


if __name__ == "__main__":
    app()
