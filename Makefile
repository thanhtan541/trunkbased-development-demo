help:
	echo "Run:"
	echo "	./scripts/init_k8s_mac_local.sh"
	echo "to setup enviroment for MacOs"

enable-ingress:
	minikube addons enable ingress

tunnel-open:
	minikube tunnel

cluster-start: help
	minikube start

dashboard-start:
	minikube dashboard

SLOT?=0
cleanup:
	kubectl delete namespace dev-${SLOT}

init:
	kubectl create namespace dev-${SLOT}
	SLOT=${SLOT} ./scripts/init_dev_env.sh
