import pathlib
import shutil
from os import path, chdir

import sys
import subprocess

def run_command(cmd: str, path: str):
    sys.exit('Wrong command') if cmd not in ['apply', 'destroy', 'plan'] else None

    p = subprocess.Popen(cmd, shell=True, stdout=subprocess.PIPE, stderr=subprocess.PIPE)
    output, err = p.communicate()
    if err:
        sys.exit(err)
    return output

# tmp_dir = tempfile.gettempdir()
#
# def mkdir_safely(dir):
#     try:
#         shutil.rmtree(dir)
#     except FileNotFoundError:
#         pass
#
#     try:
#         pathlib.Path(dir).mkdir(exist_ok=True)
#     except OSError:
#         pass
#
#
# def prepare_render_dirs():
#     output_dir = path.join(tmp_dir, OUTPUT_DIR)
#
#     mkdir_safely(output_dir)
#     chdir(output_dir)
#
#     mkdir_safely(WORK_DIR)
#     chdir(WORK_DIR)
#
#     # mkdir_safely(FINAL_DIR)
#
#     pathlib.Path(WORK_DIR_FOR_COOKIECUTTER).mkdir(parents=True, exist_ok=True)
