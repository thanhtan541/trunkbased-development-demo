k8s-update:
	kubectl apply -f react-deployment.yaml
	kubectl apply -f react-service.yaml

k8s-status:
	"Listing deployments"
	kubectl get deployments
	echo "=========End========="
	echo "Listing pods"
	kubectl get pods
	echo "=========End========="
	echo "Listing services"
	kubectl get services
	echo "=========End========="
