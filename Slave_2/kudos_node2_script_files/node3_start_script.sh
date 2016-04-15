echo Hello
sudo yum -y update
sudo systemctl stop firewalld
sudo systemctl disable firewalld
sudo yum -y install ntp
sudo systemctl start ntpd
sudo systemctl enable ntpd

# Updating the /etc/hosts file with IP and domain name of master , slaves.
$config=`cat << EOF > /etc/hosts
192.168.10.10   kube-master
192.168.20.20  kube-master2
192.168.10.11  kube-node1
192.168.10.12  kube-node2
192.168.10.13  kube-node3
EOF`

sudo yum -y install flannel kubernetes

$config2=`cat <<-EOF > /etc/sysconfig/flanneld
FLANNEL_ETCD="http://kube-master2:2379"
FLANNEL_ETCD_KEY="/atomic.io/network"
EOF`

$config3=`cat <<-EOF > /etc/kubernetes/config
KUBE_LOGTOSTDERR="--logtostderr=true"
KUBE_LOG_LEVEL="--v=0"
KUBE_ALLOW_PRIV="--allow_privileged=false"
KUBE_MASTER="--master=http://kube-master2:8080"
EOF`

$config4=`cat <<-EOF > /etc/kubernetes/kubelet
KUBELET_ADDRESS="--address=0.0.0.0"
KUBELET_PORT="--port=10250"
KUBELET_HOSTNAME="--hostname_override=kube-node2"
KUBELET_API_SERVER="--api_servers=http://kube-master2:8080"
KUBELET_ARGS=""
EOF`

for SERVICES in kube-proxy kubelet docker flanneld; do
sudo systemctl restart $SERVICES
sudo systemctl enable $SERVICES
sudo systemctl status $SERVICES
done

echo KUDOS
