# terragrunt-polkadot

This is a reference architecture for deploying API nodes for Polkadot. Users can deploy infrastructure on one of
 several supported clouds and can customize the network topology per their needs. This work was done per the
 [Load Balanced Endpoints](https://github.com/w3f/Web3-collaboration/pull/250) grant proposal and is intended to be a
 long term development project where new features and optimizations will be built in over time. 

Currently the API nodes themselves run on VMs with the supporting infrastructure running on kubernetes. In the future
 , options will be exposed to run the on either VMs, k8s, or some unique combination of both depending on what your
 infrastructure needs are. 

### Getting started 

To get started with an interactive CLI to configure node deployments: 

```bash
git clone https://github.com/insight-w3f/terragrunt-polkadot
cd terragrunt-polkadot
pip3 install nukikata  # A tool we designed to do interactive code templating
nukikata .
```

By walking through the steps in the CLI, users should be able to fully customize the deployment of the cluster in any
 cloud provider. Configuration settings are self-documented in the CLI or can be done manually by editing the
  deployment files per the architecture described below. 

### How it works 

This reference architecture is built with `terragrunt`, a wrapper to terraform, which under the hood calls Ansible
 and Packer to configure VMs and Helm to configure kubernetes clusters. All aspects of the deployment are immutable
 and thus, the main challenge with using all of these tools in combination with one another is exposing the right
 options to the user that allow the customization of the deployment.  For that, we have built our own declarative CLI
 codenamed [`nukikata`](https://github.com/insight-infrastructure/nukikata), japanese for cookie cutter, which is a
  fork of the most popular code templating tool called `cookiecutter`.  With this tool, we prompt the user to fillout 
  the appropriate config files to then run the underlying terragrunt commands to deploy the stack. 

A critical element in understanding the deployment methodology is understanding how the parameters are handled within
 the scope of a deployment to a provider. Normally with terragrunt, modules are structured in a heirarchial folder
 format per the conventions of various [reference implementations](https://github.com/gruntwork-io/terragrunt-infrastructure-live-example) 
 recommended by [industry experts](https://github.com/antonbabenko/terragrunt-reference-architecture). 
 When running nodes in many regions across many providers, this
 convention has a draw back of having many files and folders to keep track of. To simplify this, we take a so called
 "deployment centric" approach where each deployment consists of a file per namespace, stack, network name, environment
 , and cloud provider region to hold all the parameters needed to inform a properly running stack. These files are
 currently stored locally in the `deployments` folder within each provider and soon, users will have the option of
 storing the files and running the stack remotely. To run the deployment, we template the parent `terragrun.hcl` file
  with the proper parameters that we need to deploy and then run terragrunt to deploy the infrastructure. Currently
   deployments are executed sequentially and in the future the user will be able to deploy to multiple regions in
    parallel. 
  
To manage this complex process, we developed nukikata as we felt that managing a declarative CLI in this context
 would be more manageable as an organization.  We also want to make sure to allow features to be used across multiple
  different implementations and hence see this approach as being more manageable in the long term as we build in new
   features and expose unique decision tree like configuration options to allow users to easily navigate complex
    deployments. We see many applications of nukikata and are excited to have this project be the intial proving
     ground of this process that we hope to expand on for the years to come. 

### Network Topologies 

The current architecture is based on a hybrid VM and kubernetes setup options are exposed to adopt either or
 methodologies. 
 
VMs are used for the fully archived nodes and are deployed in autoscaling groups behind a network load
balancer.  To optimize the syncing of nodes, a source of truth node architecture is implemented where a single node
is consistently syncing the latest chain data to a CDN that subsequent nodes sync off of directly. This reduces
 scaling time down to ~5 minutes which is a major improvement on the normal scaling time. 
 
Kubernetes is used for monitoring with prometheus, and logging with elasticsearch, and an nginx reverse proxy layer for
 routing down to the archival nodes. Further optimizations are being planned on the reverse proxy layer to support
  caching of near head queries and other types of pre-indexed query optimizations. We will also soon support a
   kubernetes only deployment architecture. 

![](./static/architecture-overview.png)

### Build Status

| module | AWS | GCP | Azure | DigitalOcean | Packet|
|:---:|:---:|:---:|:---:|:---:|:---:|
|network    | [![CircleCI](https://circleci.com/gh/insight-w3f/terraform-polkadot-aws-network.svg?style=svg)](https://circleci.com/gh/insight-w3f/terraform-polkadot-gcp-network) | [![CircleCI](https://circleci.com/gh/insight-w3f/terraform-polkadot-gcp-network.svg?style=svg)](https://circleci.com/gh/insight-w3f/terraform-polkadot-gcp-network) | [![CircleCI](https://circleci.com/gh/insight-w3f/terraform-polkadot-azure-network.svg?style=svg)](https://circleci.com/gh/insight-w3f/terraform-polkadot-azure-network) | [![CircleCI](https://circleci.com/gh/insight-w3f/terraform-polkadot-do-network.svg?style=svg)](https://circleci.com/gh/insight-w3f/terraform-polkadot-do-network) | n/a| 
|api-lb     | [![CircleCI](https://circleci.com/gh/insight-w3f/terraform-polkadot-aws-api-lb.svg?style=svg)](https://circleci.com/gh/insight-w3f/terraform-polkadot-aws-api-lb) | [![CircleCI](https://circleci.com/gh/insight-w3f/terraform-polkadot-gcp-api-lb.svg?style=svg)](https://circleci.com/gh/insight-w3f/terraform-polkadot-gcp-api-lb) | [![CircleCI](https://circleci.com/gh/insight-w3f/terraform-polkadot-azure-api-lb.svg?style=svg)](https://circleci.com/gh/insight-w3f/terraform-polkadot-azure-api-lb) | n/a | n/a | 
|asg        | [![CircleCI](https://circleci.com/gh/insight-w3f/terraform-polkadot-aws-asg.svg?style=svg)](https://circleci.com/gh/insight-w3f/terraform-polkadot-aws-asg) | [![CircleCI](https://circleci.com/gh/insight-w3f/terraform-polkadot-gcp-asg.svg?style=svg)](https://circleci.com/gh/insight-w3f/terraform-polkadot-gcp-asg) | [![CircleCI](https://circleci.com/gh/insight-w3f/terraform-polkadot-azure-asg.svg?style=svg)](https://circleci.com/gh/insight-w3f/terraform-polkadot-azure-asg) | n/a | n/a | 
|node       | [![CircleCI](https://circleci.com/gh/insight-w3f/terraform-polkadot-aws-node.svg?style=svg)](https://circleci.com/gh/insight-w3f/terraform-polkadot-aws-node) | [![CircleCI](https://circleci.com/gh/insight-w3f/terraform-polkadot-gcp-node.svg?style=svg)](https://circleci.com/gh/insight-w3f/terraform-polkadot-gcp-node) | [![CircleCI](https://circleci.com/gh/insight-w3f/terraform-polkadot-azure-node.svg?style=svg)](https://circleci.com/gh/insight-w3f/terraform-polkadot-azure-node) | [![CircleCI](https://circleci.com/gh/insight-w3f/terraform-polkadot-do-node.svg?style=svg)](https://circleci.com/gh/insight-w3f/terraform-polkadot-do-node) | [![CircleCI](https://circleci.com/gh/insight-w3f/terraform-polkadot-packet-node.svg?style=svg)](https://circleci.com/gh/insight-w3f/terraform-polkadot-packet-node) | 
|k8s-cluster| [![CircleCI](https://circleci.com/gh/insight-w3f/terraform-polkadot-aws-k8s-cluster.svg?style=svg)](https://circleci.com/gh/insight-w3f/terraform-polkadot-aws-k8s-cluster) | [![CircleCI](https://circleci.com/gh/insight-w3f/terraform-polkadot-gcp-k8s-cluster.svg?style=svg)](https://circleci.com/gh/insight-w3f/terraform-polkadot-gcp-k8s-cluster) | [![CircleCI](https://circleci.com/gh/insight-w3f/terraform-polkadot-azure-k8s-cluster.svg?style=svg)](https://circleci.com/gh/insight-w3f/terraform-polkadot-azure-k8s-cluster) | [![CircleCI](https://circleci.com/gh/insight-w3f/terraform-polkadot-do-k8s-cluster.svg?style=svg)](https://circleci.com/gh/insight-w3f/terraform-polkadot-do-k8s-cluster) | n/a

### AWS 
- [terraform-polkadot-aws-network](https://github.com/insight-w3f/terraform-polkadot-aws-network)
- [terraform-polkadot-aws-node](https://github.com/insight-w3f/terraform-polkadot-aws-node)
- [terraform-polkadot-aws-asg](https://github.com/insight-w3f/terraform-polkadot-aws-asg)
- [terraform-polkadot-aws-api-lb](https://github.com/insight-w3f/terraform-polkadot-aws-api-lb)
- [terraform-polkadot-aws-k8s-cluster](https://github.com/insight-w3f/terraform-polkadot-aws-k8s-cluster)

### GCP 
- [terraform-polkadot-gcp-network](https://github.com/insight-w3f/terraform-polkadot-gcp-network)
- [terraform-polkadot-gcp-node](https://github.com/insight-w3f/terraform-polkadot-gcp-node)
- [terraform-polkadot-gcp-asg](https://github.com/insight-w3f/terraform-polkadot-gcp-asg)
- [terraform-polkadot-gcp-api-lb](https://github.com/insight-w3f/terraform-polkadot-gcp-api-lb)
- [terraform-polkadot-gcp-k8s-cluster](https://github.com/insight-w3f/terraform-polkadot-gcp-k8s-cluster)

### Azure 

- [terraform-polkadot-azure-network](https://github.com/insight-w3f/terraform-polkadot-azure-network)
- [terraform-polkadot-azure-node](https://github.com/insight-w3f/terraform-polkadot-azure-node)
- [terraform-polkadot-azure-asg](https://github.com/insight-w3f/terraform-polkadot-azure-asg)
- [terraform-polkadot-azure-api-lb](https://github.com/insight-w3f/terraform-polkadot-azure-api-lb)
- [terraform-polkadot-azure-k8s-cluster](https://github.com/insight-w3f/terraform-polkadot-azure-k8s-cluster)

### DigitalOcean

- [terraform-polkadot-do-network](https://github.com/insight-w3f/terraform-polkadot-do-network)
- [terraform-polkadot-do-node](https://github.com/insight-w3f/terraform-polkadot-do-node)
- [terraform-polkadot-do-k8s-cluster](https://github.com/insight-w3f/terraform-polkadot-do-k8s-cluster)

### Polkadot 
- [terraform-polkadot-user-data](https://github.com/insight-w3f/terraform-polkadot-user-data)

### General 
- [terraform-ansible-playbook](https://github.com/insight-infrastructure/terraform-aws-ansible-playbook) ![](https://img.shields.io/github/v/release/insight-infrastructure/terraform-aws-ansible-playbook?style=svg)
- [terraform-packer-build](https://github.com/insight-infrastructure/terraform-packer-build) ![](https://img.shields.io/github/v/release/insight-infrastructure/terraform-packer-build?style=svg)


![](./static/w3f_badge.png)
