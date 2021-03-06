# Changelog
All notable changes to this project will be documented in this file.

The format is based on [Keep a Changelog](https://keepachangelog.com/en/1.0.0/),
and this project adheres to [Semantic Versioning](https://semver.org/spec/v2.0.0.html).

## [Unreleased]

## [2.0.0] - 2019-10-22
### Added 
- Support for parameters for ingress Helm deployment
- Support for EKS logs

### Changed
- Updated Kentrikos EKS module to 4.0.0

### BC
- Variable type changed for `map_users` and `map_roles` to align with upstream eks module

## [1.0.0] - 2019-07-30
### Changed
- Required terraform version updated to `>= 0.12`
- Updated Kentrikos EKS module to 3.0.0

## [0.6.0] - 2019-07-04
### Added 
- Maps for roles, users and account
- Default roles to assume for EKS
- Flag enable_default_roles to enable creation of default role; default false 

## [0.5.1] - 2019-05-27
### Fixed
- Pin vpc module version to ~> 1.66 because is terraform 0.11 compatible 

## [0.5.0] - 2019-05-21
### Added
- Support for deploying Kubernetes ingress controller

## [0.4.2] - 2019-05-08
### Added
- Added outputs from eks module

## [0.4.1] - 2019-04-16
### Fixed
- Solved gp2 storage creation in EKS module
  
## [0.4.0 - 2019-04-09]
### Changed
- Changed minor version due to dependency change in upward and downward repo.

## [0.3.1] - 2019-03-20
### Added
- Input for cluster scaling variables
- Input for public subnets (cluster tagging)
- Input for installation of Helm
### Changed
- Incremented version of EKS module

## [0.3.0] - 2019-03-06
### Changed
- Common tag set created
- Replaced KOPS cluster with EKS
- Removed 'commented out' items for pending logging enhancements

## [0.2.0] - 2019-02-25
### Changed
- Cluster name contain region

## [0.1.0] - 2019-02-05
### Added
- Pining versions
- This CHANGELOG file


