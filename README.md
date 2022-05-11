# [output](https://user-images.githubusercontent.com/75636579/167926415-13897cdc-deea-4ad8-9584-d7a879d703ca.gif)


Install Terraform
```
$ curl -fsSL https://apt.releases.hashicorp.com/gpg | sudo apt-key add -
$ sudo apt-add-repository "deb [arch=$(dpkg --print-architecture)] https://apt.releases.hashicorp.com $(lsb_release -cs) main"
$ sudo apt update
$ sudo apt install terraform
```
