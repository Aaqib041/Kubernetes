sudo yum -y update
sudo systemctl stop firewalld
sudo systemctl disable firewalld
sudo echo FIREWALL SERVICES STOPPED

sudo yum -y install ntp
sudo systemctl start ntpd
sudo systemctl enable ntpd

foo=`cat <<-EOF >> /etc/hosts
192.168.20.20   kube-master2
192.168.10.11   kube-node1
192.168.10.12  kube-node2
EOF`

sudo yum -y install etcd kubernetes

$config1=`cat <<-EOF > /etc/etcd/etcd.conf
ETCD_NAME=default
ETCD_DATA_DIR="/var/lib/etcd/default.etcd"
ETCD_LISTEN_CLIENT_URLS="http://0.0.0.0:2379"
ETCD_ADVERTISE_CLIENT_URLS="http://localhost:2379"
EOF`


$config2=`cat <<-EOF > /etc/kubernetes/apiserver
KUBE_API_ADDRESS="--address=0.0.0.0"
KUBE_API_PORT="--port=8080"
KUBELET_PORT="--kubelet-port=10250"
KUBE_ETCD_SERVERS="--etcd-servers=http://127.0.0.1:2379"
KUBE_SERVICE_ADDRESSES="--service-cluster-ip-range=10.254.0.0/16"
KUBE_ADMISSION_CONTROL="--admission-control=NamespaceLifecycle,NamespaceExists,LimitRanger,SecurityContextDeny,ResourceQuota"
KUBE_API_ARGS=""
EOF`

for SERVICES in etcd kube-apiserver kube-controller-manager kube-scheduler docker; do
sudo systemctl start $SERVICES
sudo systemctl restart $SERVICES
sudo systemctl enable $SERVICES
sudo systemctl status $SERVICES
done

etcdctl mk /atomic.io/network/config '{"Network":"172.17.0.0/16"}'
echo KUDOS
