kubectl create -f /vagrant/kudos_definition_files/dashboard.yaml
kubectl get svc --namespace=kube-system
kubectl describe svc kubernetes-dashboard --namespace=kube-system
echo "HURRAY !!! Open your favourite and type < nodeIP:nodeport > and enjoy the Dashboard"
