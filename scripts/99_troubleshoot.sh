
# Make sure that containerd is running with systemd cgroup for runc
echo "Make sure tools are installed"
sudo apt-get install bpfcc-tools
echo "Create some containers and observe wheater the execsnopp rules in systemd-cgroup"
sudo /usr/sbin/execsnoop-bpfcc -n runc

# Example outputs:
# $ sudo /usr/sbin/execsnoop-bpfcc -n runc
# PCOMM            PID    PPID   RET ARGS
# runc             7984   7974     0 /usr/local/bin/runc --root /run/containerd/runc/k8s.io --log /run/containerd/io.containerd.runtime.v2.task/k8s.io/b6725c857dd7492a37f73038db80b7443ea1ed9c24b2d98a4b4e15ee8dad24c4/log.json --log-format json --systemd-cgroup create --bundle /run/containerd/io.containerd.runtime.v2.task/k8s.io/b6725c857dd7492a37f73038db80b7443ea1ed9c24b2d98a4b4e15ee8dad24c4 --pid-file /run/containerd/io.containerd.runtime.v2.task/k8s.io/b6725c857dd7492a37f73038db80b7443ea1ed9c24b2d98a4b4e15ee8dad24c4/init.pid b6725c857dd7492a37f73038db80b7443ea1ed9c24b2d98a4b4e15ee8dad24c4
# runc             7999   7974     0 /usr/local/bin/runc --root /run/containerd/runc/k8s.io --log /run/containerd/io.containerd.runtime.v2.task/k8s.io/b6725c857dd7492a37f73038db80b7443ea1ed9c24b2d98a4b4e15ee8dad24c4/log.json --log-format json --systemd-cgroup start b6725c857dd7492a37f73038db80b7443ea1ed9c24b2d98a4b4e15ee8dad24c4
# runc             8028   7974     0 /usr/local/bin/runc --root /run/containerd/runc/k8s.io --log /run/containerd/io.containerd.runtime.v2.task/k8s.io/7168c8744f0d2212fac0123f874e348972afae8d2f96a225daa4bae5f593725a/log.json --log-format json --systemd-cgroup create --bundle /run/containerd/io.containerd.runtime.v2.task/k8s.io/7168c8744f0d2212fac0123f874e348972afae8d2f96a225daa4bae5f593725a --pid-file /run/containerd/io.containerd.runtime.v2.task/k8s.io/7168c8744f0d2212fac0123f874e348972afae8d2f96a225daa4bae5f593725a/init.pid --console-socket /tmp/pty2458939095/pty.sock 7168c8744f0d2212fac0123f874e348972afae8d2f96a225daa4bae5f593725a
# runc             8047   7974     0 /usr/local/bin/runc --root /run/containerd/runc/k8s.io --log /run/containerd/io.containerd.runtime.v2.task/k8s.io/7168c8744f0d2212fac0123f874e348972afae8d2f96a225daa4bae5f593725a/log.json --log-format json --systemd-cgroup start 7168c8744f0d2212fac0123f874e348972afae8d2f96a225daa4bae5f593725a

# https://stackoverflow.com/questions/53394201/kubernetes-context-is-not-set
CLUSTER_NAME="kubernetes"
KCONFIG=admin.conf
KUSER="kubernetes-admin"
KCERT=admin

cd /etc/kubernetes/

$ kubectl config set-cluster ${CLUSTER_NAME} \
  --certificate-authority=pki/ca.crt \
  --embed-certs=true \
  --server=https://${KUBERNETES_PUBLIC_ADDRESS}:6443 \
  --kubeconfig=${KCONFIG}

$ kubectl config set-credentials kubernetes-admin \
  --client-certificate=admin.crt \
  --client-key=admin.key \
  --embed-certs=true \
  --kubeconfig=/etc/kubernetes/admin.conf

$ kubectl config set-context ${KUSER}@${CLUSTER_NAME} \
  --cluster=${CLUSTER_NAME} \
  --user=${KUSER} \
  --kubeconfig=${KCONFIG}

$ kubectl config use-context ${KUSER}@${CLUSTER_NAME} --kubeconfig=${KCONFIG}
$ kubectl config view --kubeconfig=${KCONFIG}
