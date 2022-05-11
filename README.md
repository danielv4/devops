
![grab-landing-page](https://user-images.githubusercontent.com/75636579/167926415-13897cdc-deea-4ad8-9584-d7a879d703ca.gif)


## Install Terraform
```
$ curl -fsSL https://apt.releases.hashicorp.com/gpg | sudo apt-key add -
$ sudo apt-add-repository "deb [arch=$(dpkg --print-architecture)] https://apt.releases.hashicorp.com $(lsb_release -cs) main"
$ sudo apt update
$ sudo apt install terraform
```


## Init to add the necessary plugins
```
$ terraform init
```


## Verifies that the syntax of main.tf
```
$ terraform plan
```


## To create the VM, run terraform apply
```
$ terraform apply -var="credentials=gcp_service_file.json" -var="instance_name=db" -var="zone=us-west1-a"
```


## Update deps if needed
```
$ terraform init -upgrade
```

