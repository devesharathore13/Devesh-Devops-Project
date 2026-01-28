#!/usr/bin/env python3

from kubernetes import client, config
import sys

class K8sClient:
    def __init__(self, namespace="default"):
        config.load_kube_config()
        self.v1 = client.CoreV1Api()
        self.apps_v1 = client.AppsV1Api()
        self.namespace = namespace
    
    def list_pods(self):
        """List all pods in namespace"""
        try:
            pods = self.v1.list_namespaced_pod(self.namespace)
            return [pod.metadata.name for pod in pods.items]
        except Exception as e:
            print(f"Error listing pods: {e}")
            return []
    
    def get_pod_logs(self, pod_name, tail_lines=100):
        """Get logs from a pod"""
        try:
            logs = self.v1.read_namespaced_pod_log(
                name=pod_name,
                namespace=self.namespace,
                tail_lines=tail_lines
            )
            return logs
        except Exception as e:
            print(f"Error getting logs: {e}")
            return None
    
    def scale_deployment(self, deployment_name, replicas):
        """Scale a deployment"""
        try:
            body = {"spec": {"replicas": replicas}}
            self.apps_v1.patch_namespaced_deployment_scale(
                name=deployment_name,
                namespace=self.namespace,
                body=body
            )
            print(f"Scaled {deployment_name} to {replicas} replicas")
            return True
        except Exception as e:
            print(f"Error scaling deployment: {e}")
            return False
    
    def restart_deployment(self, deployment_name):
        """Restart a deployment"""
        try:
            from datetime import datetime
            now = datetime.utcnow().isoformat() + "Z"
            
            body = {
                "spec": {
                    "template": {
                        "metadata": {
                            "annotations": {
                                "kubectl.kubernetes.io/restartedAt": now
                            }
                        }
                    }
                }
            }
            
            self.apps_v1.patch_namespaced_deployment(
                name=deployment_name,
                namespace=self.namespace,
                body=body
            )
            print(f"Restarted deployment: {deployment_name}")
            return True
        except Exception as e:
            print(f"Error restarting deployment: {e}")
            return False

if __name__ == "__main__":
    k8s = K8sClient(namespace="production")
    
    print("Pods in production:")
    for pod in k8s.list_pods():
        print(f"  - {pod}")
