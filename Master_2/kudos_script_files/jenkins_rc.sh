kubectl create -f /vagrant/kudos_definition_files/jenkins_rc.yaml
kubectl get rc
kubectl describe rc jenkins
jenkins_pod = kubectl get po
kubectl describe po $jenkins_pod
