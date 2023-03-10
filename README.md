![Header](https://cdn.discordapp.com/attachments/997270112400838766/1060762701766348870/projectheadmaker_several_mechanical_tentacles_of_an_octopus_typ_e865b2b8-218d-4b05-aaca-4ea170a3ed59.png)

# lab02-action

A [GitHub action] to allow running commands in parallel on multiple servers via SSH.

## Usage example:

The bellow snippet (yaml) execute the action assuming password in __pwd__ keys in `vps_list.json` as SSH auth method.

```yml
- name: Deploy
  uses: path/to/action
  with:
    vps_list_file: vps_list.json
    deploy_command_file: deploy_commands.sh
    username: ${{ secrets.USERNAME }}

```

The bellow snippet (yaml) execute the action assuming RSA key in GitHub secret 'SSH_KEY' as SSH auth method, in this case all __pwd__ keys in `vps_list.json` are ignored.

```yml
- name: Deploy
  uses: path/to/action
  with:
    vps_list_file: vps_list.json
    deploy_command_file: deploy_commands.sh
    ssh_key: ${{ secrets.SSH_KEY }}
    username: ${{ secrets.USERNAME }}

```
---

## Usage inputs: ✍️

The action expects the following inputs to be provided:

- `vps_list_file`: path to the JSON file with the list of VPS. Each item in the list should contain the following keys:
  - `address`: IP address or domain name of the VPS.
  - `port`: SSH port number of the VPS.
  - `pwd`: login password for the VPS (optional).
 
- `deploy_command_file`: path to the file with the deploy commands, one per line.

- `ssh_key`: SSH private key for authentication on the VPS (optional), create GitHub secret "SSH_KEY".

- `username`: username for login on the SSH VPS, create GitHub secret "USERNAME".

The action reads the configuration files and then connects to each VPS in the list and runs the deploy commands. The action uses threads to concurrently deploy to multiple VPS.

## Configuration files: 🗃️

Assuming we have the following configuration files:

#### __`deploy_commands.sh`__ *(a pseudo nginx deploy in this example)*.

A `deploy_commands.sh` is a plain text file that contains a shell script to be executed on the VPS.

```bash
# update package list and install NGINX
apt-get update && apt-get install nginx -y

# create a new server block configuration file
cat << EOF > /etc/nginx/conf.d/example.com.conf
server {
    listen 80;
    server_name example.com;

    location / {
        proxy_pass http://localhost:8000;
        proxy_set_header Host \$host;
        proxy_set_header X-Real-IP \$remote_addr;
        proxy_set_header X-Forwarded-For \$proxy_add_x_forwarded_for;
    }
}
EOF

# restart NGINX to apply the new configuration
systemctl restart nginx

```
---

#### __`vps_list.json`__ *(hosts to perform command execution of __deploy_commands.sh__ file)*.

A `vps_list.json` is a JSON file that contains a list of dictionaries, each dictionary representing a VPS. The dictionary should contain the following keys:

 - __address__: IP address or domain name of the VPS
 - __port__: SSH port number of the VPS
 - __pwd__: login password for the VPS (optional)

```json
[
    {
        "address": "vps1.example.com",
        "port": 22,
        "pwd": "password1"
    },
    {
        "address": "vps2.example.com",
        "port": 22,
        "pwd": "password2"
    }
]

```
---

## This action use: 👾

- [x] Python 3.6 or later
- [x] paramiko module
