from os import path, listdir, mkdir
from cookiecutter.main import cookiecutter
import typer
import tempfile
import yaml
import json
import logging

logger = logging.getLogger()
app = typer.Typer()


@app.command()
def create(stack: str):
    temp_dir = tempfile.mkdtemp()
    cookiecutter_path = path.join(temp_dir, 'cookiecutter.json')
    template_path = path.join(temp_dir, '{{cookiecutter.region}}')
    mkdir(template_path)

    typer.echo(f"Creating {stack} deployment")

    with open(path.join('stacks', stack + '.yaml')) as f:
        stack_config = yaml.load(f)

    with open(cookiecutter_path) as f:
        json.dump(stack_config['deployment'], f)

    logger.debug('Adding temp dir %s', temp_dir)

    cookiecutter(temp_dir)
    # For when adding context file potentially
    # cookiecutter(temp_dir,
    #              config_file=path.join(COOKIECUTTER_TEMPLATES_DIR, "config_aws_lambda.yaml"),
    #              # no_input=True,
    #              extra_context=extra_context)




@app.command()
def apply(stack: str, id: int = 0):
    typer.echo(f"Applying deployment = {stack}.{id}")

    if id == 0:
        ids = [i for i in listdir('deployments') if i.split('.')[0] == 'api-ha']


if __name__ == "__main__":
    app()
