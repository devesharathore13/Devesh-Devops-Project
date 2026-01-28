#!/usr/bin/env python3

import docker
from datetime import datetime

class DockerManager:
    def __init__(self):
        self.client = docker.from_env()
    
    def list_containers(self, all=False):
        """List all containers"""
        containers = self.client.containers.list(all=all)
        return [
            {
                'id': c.id[:12],
                'name': c.name,
                'status': c.status,
                'image': c.image.tags[0] if c.image.tags else 'none'
            }
            for c in containers
        ]
    
    def deploy_container(self, image, name, ports=None, env=None):
        """Deploy a new container"""
        try:
            # Stop and remove existing container
            try:
                old_container = self.client.containers.get(name)
                old_container.stop()
                old_container.remove()
                print(f"Removed old container: {name}")
            except docker.errors.NotFound:
                pass
            
            # Start new container
            container = self.client.containers.run(
                image,
                name=name,
                ports=ports or {},
                environment=env or {},
                detach=True,
                restart_policy={"Name": "unless-stopped"}
            )
            print(f"Started new container: {name}")
            return True
        except Exception as e:
            print(f"Error deploying container: {e}")
            return False
    
    def cleanup_images(self, days=7):
        """Remove unused images older than specified days"""
        try:
            self.client.images.prune(filters={'dangling': False})
            print("Cleaned up unused images")
        except Exception as e:
            print(f"Error cleaning images: {e}")
    
    def get_container_stats(self, name):
        """Get container resource usage"""
        try:
            container = self.client.containers.get(name)
            stats = container.stats(stream=False)
            
            # Calculate CPU percentage
            cpu_delta = stats['cpu_stats']['cpu_usage']['total_usage'] - \
                       stats['precpu_stats']['cpu_usage']['total_usage']
            system_delta = stats['cpu_stats']['system_cpu_usage'] - \
                          stats['precpu_stats']['system_cpu_usage']
            cpu_percent = (cpu_delta / system_delta) * 100.0
            
            # Calculate memory usage
            memory_usage = stats['memory_stats']['usage']
            memory_limit = stats['memory_stats']['limit']
            memory_percent = (memory_usage / memory_limit) * 100.0
            
            return {
                'cpu_percent': round(cpu_percent, 2),
                'memory_mb': round(memory_usage / 1024 / 1024, 2),
                'memory_percent': round(memory_percent, 2)
            }
        except Exception as e:
            print(f"Error getting stats: {e}")
            return None

if __name__ == "__main__":
    dm = DockerManager()
    
    print("Running containers:")
    for container in dm.list_containers():
        print(f"  {container['name']}: {container['status']}")
