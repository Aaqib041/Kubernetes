#! /bin/bash

for SERVICES in etcd kube-apiserver kube-controller-manager kube-scheduler; do
sudo systemctl start $SERVICES
sudo systemctl restart $SERVICES
sudo systemctl enable $SERVICES
sudo systemctl status $SERVICES
done

echo KUDOS
