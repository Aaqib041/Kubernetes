docker pull index.tenxcloud.com/google_containers/kube-ui:v4
docker tag index.tenxcloud.com/google_containers/kube-ui:v4 gcr.io/google_containers/kube-ui:v4
docker rmi index.tenxcloud.com/google_containers/kube-ui:v4

echo KUBE_UI_IMAGE successfully Pulled
