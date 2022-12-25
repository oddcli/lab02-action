import json
import os
import io
import paramiko
import concurrent.futures


def threaded(func):
    def wrapper(*args, **kwargs):
        with concurrent.futures.ThreadPoolExecutor() as executor:
            try:
                result = executor.submit(func, *args, **kwargs)
            except Exception as e:
                print(f"Exception occurred in 'executor.submit' on '@threaded' decorator: {e}")
        return result
    return wrapper

@threaded
def deploy(vps_info, username, command, ssh_key):
    try:
        ssh_client = paramiko.SSHClient()
        ssh_client.set_missing_host_key_policy(paramiko.AutoAddPolicy())

        if ssh_key:
            pkey = paramiko.RSAKey.from_private_key(io.StringIO(ssh_key))
            try:
                ssh_client.connect(vps_info['address'], port=vps_info['port'], pkey=pkey, username=username, timeout=5)
            except Exception as e:
                print(f"SSH error by KEY auth: {e.message}")

        else:
            try:
                ssh_client.connect(vps_info['address'], port=vps_info['port'], password=vps_info['pwd'], username=username, timeout=5)
            except Exception as e:
                print(f"SSH error by PASSWORD auth: {e.message}")

    except Exception as e:
        print(e.message)

    try:
        stdin, stdout, stderr = ssh_client.exec_command(command)
        for line in stdout:
            print(line)
    except Exception as e:
        print(e.message)

if __name__ == '__main__':

    vps_list_file = os.environ["VPS_LIST_FILE"]
    deploy_command_file = os.environ["DEPLOY_COMMAND"]
    ssh_key = os.environ["SSH_KEY"]
    username = os.environ["USERNAME"]

    try:
        with open(vps_list_file, 'r') as f:
            vps_list = json.load(f)
    except:
        print("Error reading VPS list file")

    try:
        if os.path.isfile(deploy_command_file):
            with open(deploy_command_file, 'r') as f:
                deploy_command = f.read()
    except:
        print("Error reading deploy commands")

    with concurrent.futures.ThreadPoolExecutor() as executor:
        try:
            future_list = [executor.submit(deploy, vps_info, username, deploy_command, ssh_key) for vps_info in vps_list]
        except Exception as e:
            print(f"Exception occurred in 'future_list' list comprehension: {e}")

    for future in concurrent.futures.as_completed(future_list):
        try:
            result = future.result()
        except Exception as error:
            print(error)
        else:
            print(f"Resultado : {result} {result.args}")
