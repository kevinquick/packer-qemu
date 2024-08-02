#!/usr/bin/env python3
import os, sys
import subprocess
from configparser import ConfigParser

def load_environment(config='config.ini'):
    parser = ConfigParser()
    parser.read(config)
    env_vars = {}
    build_os = sys.argv[1]
    for section in ['generic', build_os]:
        for k,v in parser[section].items():
            env_vars[k.upper()] = v
    # Update the environment for the subprocess
    env = os.environ.copy()
    for k,v in env_vars.items():
        env[k] = v
    return env

def run_command(command, env=load_environment()):
    """Run a command using subprocess with environment variables."""
    # Execute the command
    try:
        # Start the process
        process = subprocess.Popen(command, stdout=subprocess.PIPE, stderr=subprocess.STDOUT, shell=True, text=True, env=env)

        # Print output in real-time
        while True:
            output = process.stdout.readline()
            if output == '' and process.poll() is not None:
                break
            if output:
                print(output.strip())
        
        # Wait for the process to finish and get the exit code
        rc = process.wait()
        return rc
    except KeyboardInterrupt:
        # Continue printing the output while the process completes
        try:
            while True:
                output = process.stdout.readline()
                if output == '' and process.poll() is not None:
                    break
                if output:
                    print(output.strip())
        finally:
            # Once all output is processed, allow user to terminate process if it's still running
            if process.poll() is None:
                process.terminate()  # Only terminate if process is still running
                process.wait()
        print("Process terminated after KeyboardInterrupt.")
        return -1  # Indicate that the process was interrupted

# Build & run packer commands here
command = f'packer build -var-file {sys.argv[1]}.variables.pkrvars.hcl .'
run_command(command)