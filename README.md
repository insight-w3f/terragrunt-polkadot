# terragrunt-polkadot

> WIP - Do not use. Very early in development.

This is a multi-cloud reference architecture for deploying multiple different node topologies for Polkadot.

This work is very early stage and only meant to demonstrate broad architectural decisions in building out the
terragrunt scaffolding for the grant proposal [Load Balanced Endpoints](https://github.com/w3f/Web3-collaboration/pull/250).

See also these underlying repos for more context.

### AWS 
- [terraform-polkadot-aws-network](https://github.com/insight-w3f/terraform-polkadot-aws-network)
- [terraform-polkadot-aws-node](https://github.com/insight-w3f/terraform-polkadot-aws-sentry-node)
- [terraform-polkadot-aws-asg](https://github.com/insight-w3f/terraform-polkadot-aws-asg)
- [terraform-polkadot-aws-api-lb](https://github.com/insight-w3f/terraform-polkadot-aws-api-lb)

### GCP 
- [terraform-polkadot-gcp-network](https://github.com/insight-w3f/terraform-polkadot-gcp-network)
- [terraform-polkadot-gcp-node](https://github.com/insight-w3f/terraform-polkadot-gcp-sentry-node)
- [terraform-polkadot-gcp-asg](https://github.com/insight-w3f/terraform-polkadot-gcp-asg)
- [terraform-polkadot-gcp-api-lb](https://github.com/insight-w3f/terraform-polkadot-gcp-api-lb)

### Azure 

- [terraform-polkadot-azure-network](https://github.com/insight-w3f/terraform-polkadot-azure-network)
- [terraform-polkadot-azure-node](https://github.com/insight-w3f/terraform-polkadot-azure-sentry-node)
- [terraform-polkadot-azure-asg](https://github.com/insight-w3f/terraform-polkadot-azure-asg)
- [terraform-polkadot-azure-api-lb](https://github.com/insight-w3f/terraform-polkadot-azure-api-lb)

### Polkadot 
- [terraform-polkadot-user-data](https://github.com/insight-w3f/terraform-polkadot-user-data)

### General 
- [terraform-ansible-playbook](https://github.com/insight-infrastructure/terraform-aws-ansible-playbook) ![](https://img.shields.io/github/v/release/insight-infrastructure/terraform-aws-ansible-playbook?style=svg)
- [terraform-packer-build](https://github.com/insight-infrastructure/terraform-packer-build) ![](https://img.shields.io/github/v/release/insight-infrastructure/terraform-packer-build?style=svg)


## Build Status
|       |                                                                                                                       Network                                                                 |                                                                                                                      Node                                                               |                                                                                                                    ASG                                                                |                                                                                                                     LB                                                                      |
|:-----:|:---------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------:|:---------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------:|:-------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------:|:-------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------:|
|  AWS  |   [![CircleCI](https://circleci.com/gh/insight-w3f/terraform-polkadot-aws-network.svg?style=svg)](https://circleci.com/gh/insight-w3f/terraform-polkadot-aws-network)   |   [![CircleCI](https://circleci.com/gh/insight-w3f/terraform-polkadot-aws-node.svg?style=svg)](https://circleci.com/gh/insight-w3f/terraform-polkadot-aws-node)   | [![CircleCI](https://circleci.com/gh/insight-w3f/terraform-polkadot-aws-asg.svg?style=svg)](https://circleci.com/gh/insight-w3f/terraform-polkadot-aws-asg)     | [![CircleCI](https://circleci.com/gh/insight-w3f/terraform-polkadot-aws-api-lb.svg?style=svg)](https://circleci.com/gh/insight-w3f/terraform-polkadot-aws-api-lb)     |
|  GCP  |   [![CircleCI](https://circleci.com/gh/insight-w3f/terraform-polkadot-gcp-network.svg?style=svg)](https://circleci.com/gh/insight-w3f/terraform-polkadot-gcp-network)   |   [![CircleCI](https://circleci.com/gh/insight-w3f/terraform-polkadot-gcp-node.svg?style=svg)](https://circleci.com/gh/insight-w3f/terraform-polkadot-gcp-node)   | [![CircleCI](https://circleci.com/gh/insight-w3f/terraform-polkadot-gcp-asg.svg?style=svg)](https://circleci.com/gh/insight-w3f/terraform-polkadot-gcp-asg)     | [![CircleCI](https://circleci.com/gh/insight-w3f/terraform-polkadot-gcp-api-lb.svg?style=svg)](https://circleci.com/gh/insight-w3f/terraform-polkadot-gcp-api-lb)     |
| Azure | [![CircleCI](https://circleci.com/gh/insight-w3f/terraform-polkadot-azure-network.svg?style=svg)](https://circleci.com/gh/insight-w3f/terraform-polkadot-azure-network) | [![CircleCI](https://circleci.com/gh/insight-w3f/terraform-polkadot-azure-node.svg?style=svg)](https://circleci.com/gh/insight-w3f/terraform-polkadot-azure-node) | [![CircleCI](https://circleci.com/gh/insight-w3f/terraform-polkadot-azure-asg.svg?style=svg)](https://circleci.com/gh/insight-w3f/terraform-polkadot-azure-asg) | [![CircleCI](https://circleci.com/gh/insight-w3f/terraform-polkadot-azure-api-lb.svg?style=svg)](https://circleci.com/gh/insight-w3f/terraform-polkadot-azure-api-lb) |
| DO  |    [![CircleCI](https://circleci.com/gh/insight-w3f/terraform-polkadot-do-network.svg?style=svg)](https://circleci.com/gh/insight-w3f/terraform-polkadot-do-network)    |    [![CircleCI](https://circleci.com/gh/insight-w3f/terraform-polkadot-do-node.svg?style=svg)](https://circleci.com/gh/insight-w3f/terraform-polkadot-do-node)    | [![CircleCI](https://circleci.com/gh/insight-w3f/terraform-polkadot-do-asg.svg?style=svg)](https://circleci.com/gh/insight-w3f/terraform-polkadot-do-asg)       | [![CircleCI](https://circleci.com/gh/insight-w3f/terraform-polkadot-do-api-lb.svg?style=svg)](https://circleci.com/gh/insight-w3f/terraform-polkadot-do-api-lb)       |
| Packet | n/a |   [![CircleCI](https://circleci.com/gh/insight-w3f/terraform-polkadot-packet-node.svg?style=svg)](https://circleci.com/gh/insight-w3f/terraform-polkadot-do-node)    |n/a  | n/a | 



