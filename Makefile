help:
	echo "Run:"
	echo "	./scripts/init_k8s_mac_local.sh"
	echo "to setup enviroment for MacOs"

cluster-start: help
	minikube start

dashboard-start:
	minikube dashboard

PATTERN?="update_db"
test: check
	cargo test ${PATTERN}
