# Spinnaker for AWS EKS

## Setup
You can use this module like below. This shows how to create the resources for spinnaker. This module will create IAM policies and kubernetes cluster.

Run terraform, you can use the `--var-file` option for customized paramters when you run the terraform plan/apply command.:
```
terraform init
terraform plan 
terraform apply 
```
After then you will see so many resources like EKS, IAM and others on AWS. 

## Clean up

Run terraform:
```
$ terraform destroy 
```
## Blue-Green Deployment Strategy In Spinnaker For Kubernetes Deployments
Blue/Green is to deploy a new version of your application alongside the existing version(s), send client traffic to the new version, and then disable traffic to the existing version in the cluster.

## Possible approaches to design Blue-Green strategy for Kubernetes deployments

![BGdeploy](https://user-images.githubusercontent.com/37261883/114395469-08df3400-9bba-11eb-9e00-de450cd2fa3b.jpg)

               Spinnaker pipeline deployment on Kubernetes

In my scenario, I will design a Spinnaker pipelines using the simple web app image. And here I am going to use the Spinnaker expressions feature on Spinnaker, to develop this solution. This solution uses Kubernetes service object as Load Balancer to switch traffic from blue to green or vice versa, based on matching selector labels in service object to that of spec.template.metadata.labels in deployment object.

## Configuring Spinnaker For Blue/Green Deployment

* To manage versions, use of parameterized deployment manifest such as given below:
```
apiVersion: apps/v1
kind: Deployment
metadata:
  labels:
    release: '${parameters.release}'
  name: 'crpdemo-${parameters.release}'
  namespace: default
spec:
  minReadySeconds: 5
  selector:
    matchLabels:
      app: crp
  replicas: 2
  template:
    metadata:
      labels:
        app: crp
        release: '${parameters.release}'
    spec:
      containers:
      - name: crpdemo
        image: subinmt1991/simpleapp:${parameters.release}
        ports:
        - containerPort: 80
```

* Assuming service object pre-exist with “release” as one of the selector labels such as given below, and holding the “release” value same as mentioned in first deployment release:

```
apiVersion: v1
kind: Service
metadata:
  name: crpdemo-svc
  namespace: default
  labels:
    app: crp
spec:
  ports:
  - port: 80
    protocol: TCP
  selector:
    app: crp
    release: '${parameters.release}'
  type: LoadBalancer
```

## Step By Step Guidelines to Design Spinnaker Pipeline for Blue-Green

## Spinnaker Pipeline – 1:

* The Spinnaker pipeline should consist of all required parameters for release and stage.
* Deploy Stage for Blue Deployment

## Spinnaker Pipeline – 2:

* In this scenario, the Spinnaker pipeline should consist of 3 stages.
* Patch Stage for service to share traffic between existing blue and upcoming green.
* Deploy Stage for Green deployment.
* Patch Stage for service to switch traffic completely on Green deployment.
```
app: remove
path: /spec/selector/release
```

```
spec:
  selector:
    release: '${parameters.release}'
```

* With both approaches, rollout and rollback can be achieved with parameters of the given choice. While going for the second design, we can achieve a blue-green strategy with smooth transitioning of traffic as well as non-live deployment to achieve a quick rollback.
* The above-discussed pipelines can be extended to use Git/Bitbucket-based Kubernetes artifacts instead of text-based. And further can be parameterized to use as a pipeline template for different teams.

## Destroy Old Spinnaker Deployment
* The older deployments can be removed by executing either of the below two options:
  - By deleting Deployments from UI (Infrastructure tab > Clusters sub-tab)
  - By creating a separate pipeline, which contains delete manifest stage and release parameter.
* This approach also assumes a robust external versioning system for release management.

## Step By Step Guidelines to Design destroy older deployments. 
To ensure users traffic is routed to the correct pod (the one deployed with your latest version of the app), we need to remove the older versions.  
Here I am use release version as one of the labels for my pods. In addition, the version label gives us a distinction between old and latest.

* Create a new pipeline for destroy older deployments.
* Then click ‘Add Stage’, select Delete Manifest.
* In the Manifest section
 - Provide Account, Namespace,selector, kind and Labels
 
In the 'Settings' section, check the checkbox labeled ‘Cascading’ to eliminate having orphaned resources.

## Conclusion
The deployment strategies play a vital role in achieving faster continuous delivery (CD). The blue-green strategy is one of the prominent production deployment strategies, used by organizations. The above steps help in understanding as well as achieving a blue-green strategy in a containerized production environment using Kubernetes objects and Spinnaker pipelines.
