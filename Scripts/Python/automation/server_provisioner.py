#!/usr/bin/env python3

import paramiko
import sys
from pathlib import Path

class ServerProvisioner:
    def __init__(self, host, user, key_file):
        self.host = host
        self.user = user
        self.ssh = paramiko.SSHClient()
        self.ssh.set_missing_host_key_policy(paramiko.AutoAddPolicy())
        self.ssh.connect(host, username=user, key_filename=key_file)
    
    def execute_command(self, command):
        """Execute command on remote server"""
        stdin, stdout, stderr = self.ssh.exec_command(command)
        return stdout.read().decode(), stderr.read().decode()
    
    def install_docker(self):
        """Install Docker on server"""
        commands = [
            "sudo apt-get update",
            "sudo apt-get install -y apt-transport-https ca-certificates curl",
            "curl -fsSL https://get.docker.com | sudo sh",
            "sudo usermod -aG docker $USER",
            "sudo systemctl enable docker",
            "sudo systemctl start docker"
        ]
        
        for cmd in commands:
            print(f"Running: {cmd}")
            out, err = self.execute_command(cmd)
            if err:
                print(f"Error: {err}")
    
    def setup_monitoring(self):
        """Setup node-exporter for monitoring"""
        commands = [
            "docker run -d --name=node-exporter --restart=always "
            "-p 9100:9100 prom/node-exporter"
        ]
        
        for cmd in commands:
            print(f"Running: {cmd}")
            out, err = self.execute_command(cmd)
    
    def close(self):
        self.ssh.close()

if __name__ == "__main__":
    if len(sys.argv) < 4:
        print("Usage: python server_provisioner.py <host> <user> <key_file>")
        sys.exit(1)
    
    provisioner = ServerProvisioner(sys.argv[1], sys.argv[2], sys.argv[3])
    provisioner.install_docker()
    provisioner.setup_monitoring()
    provisioner.close()
