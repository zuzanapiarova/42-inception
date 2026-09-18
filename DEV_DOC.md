# DEV DOC

## Prerequisites

- Docker Engine
- Docker Compose
- A filled `srcs/.env` file based on `srcs/.env.example`

## Set Up VM

1. VirtualBox --> New
2. VM Name, folder /goinfre/zpiarova, no iso, type linux, versin debian 64bit, for other setup use defaults
3. set port forwarding: settings --> network --> advanced --> port forwarding --> add rules --> 
- Rule 1 - TCP - 127.0.0.1 - 4242 - (guest ip empty) - 22 - SSH

3. upon starting select the iso image - I used `debian-13.1.0-amd64-netinst.iso`
4. Select Install for manual install
5. hostname debian, create root password and user, add domain
6. In partition selection, select first - Guided- use entire disk, confirm next one, and in partitioning scheme choose All files in one
7. Then just finish, write changes to disk: yes

8. media instalation: continue, scan extra instalation media: yes, then again: no
9. debian archive mirror: deb.debian.org
10. for proxy jsut default enter

11. software selection: SSH Server, standard system utilities
12. install GRUB bootloader to primary drive; yes
13. Select disk to install grub on: device for boot loader installation - in 42 /dev/sda
14. Installation complete - continue

15. Use the VM - login with username and password set during config

16. Switch to root: `su -`
17. Install sudo: `apt-get update && apt-get upgrade && apt-get install sudo -y` and add user `adduser <username> sudo`
18. Edit visudo so that ..TODO why.. `sudo visudo` - under root ALL=(ALL:ALL) ALL add username ALL=(ALL) ALL, and ctrl+X and yes to save
19. for ssh edit /etc/ssh/sshd_config and uncomment Port  22 (XXX no change from 22 to 4242)
20. Restart sshd `sudo service ssh restart`

21. SSH into the VM from the host termminal so you can run copy-paste commands: `ssh -p 4242 zpiarova@localhost` (need to set up port forwarding for host ip 127.0.0.1 port 4242 to vm port 22)

22. Install all dependencies:
a. tools
`sudo apt-get install git wget zsh vim make openbox xinit kitty firefox-esr filezilla -y`
b. docker installation
```
sudo apt-get update && sudo apt-get upgrade -y
sudo apt-get install ca-certificates curl gnupg -y

sudo install -m 0755 -d /etc/apt/keyrings
curl -fsSL https://download.docker.com/linux/debian/gpg | sudo gpg --dearmor -o /etc/apt/keyrings/docker.gpg
sudo chmod a+r /etc/apt/keyrings/docker.gpg

echo \
  "deb [arch="$(dpkg --print-architecture)" signed-by=/etc/apt/keyrings/docker.gpg] https://download.docker.com/linux/debian \
  "$(. /etc/os-release && echo "$VERSION_CODENAME")" stable" | \
  sudo tee /etc/apt/sources.list.d/docker.list > /dev/null

sudo apt-get update
sudo apt-get install docker-ce docker-ce-cli containerd.io docker-buildx-plugin docker-compose-plugin

sudo gpasswd -a $USER docker
newgrp docker
```
c. gui and browser
```
sudo apt update
sudo apt install task-gnome-desktop firefox-esr

sudo reboot
```

23. Clone the folder in the VM. If making any changes, dont forget to git push!!!! BUT to push from within the VM via https you NEED TO input a PAT instead of the password to authenticate to git:
- run `git pull`
- on github.com --> Settings --> developer settings --> Fine-grained --> restrict it to only the repository
- when prompted add your github username (not email) and paste the PAT instead of the password

24. Set up vscode for ssh: 
25. Add VS Code extension `Remote - SSH: Editing Configuration Files`, then in bottom left corner cick icon `>< (Open a Remote Window)`
26. If there is no `Connect Current Window to Host` in commmand prompt select SSH, add new, and select the config file in /home/.. 
27. Then select `Connect Current Window to Host` and select folder of the VMs cloned repository
28. You can see that it's successfully connected when you see the pop up on the bottom right corner of the screen - Host Added! Source: Remote - SSH (Extension) [Open Config] [Connect]

29. Add the ssh key of the vm to the intra so the VM is authorized to access vogsphere git: `ssh-keygen -t ed25519 -C "vm-github"`, display public key: `cat ~/.ssh/id_ed25519.pub` and add to intra

## Environment Setup

1. Copy `srcs/.env.example` to `srcs/.env`.
2. Fill in the database, WordPress, FTP, Redis, and runner variables.
3. Make sure the host name in `srcs/.env` points to `127.0.0.1` in `/etc/hosts`.

## Build and Launch

Use the Makefile from the repository root:

```bash
make up
```

This starts the compose stack in detached mode. To rebuild images and prepare the local data directories, use:

```bash
make build
```

## Container Management

- `make up` starts the stack.
- `make down` stops containers and keeps volumes.
- `make clean` stops containers and removes volumes.
- `make fclean` removes volumes and local data directories.
- `make restart` recreates the stack from a clean state.

You can also inspect the stack with:

```bash
docker compose -f srcs/docker-compose.yml ps
```

## Data and Persistence

The compose file uses bind-mounted local directories under `data/`:

- `data/wordpress-data` for MariaDB data.
- `data/wordpress-site` for WordPress files and shared web content.

These directories are created by the Makefile and survive container restarts. Removing them with `make fclean` resets the stored site and database data.
