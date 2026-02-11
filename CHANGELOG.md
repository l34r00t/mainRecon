# Changelog for Docker image

### All notable changes to the “mainRecon” will be documented in this file.

### [1.1.0] 2024-12-05

#### Mainrecon.sh
- ADDED: New flags: exclude and strict scope
- FIXED: Paramspider adapted to it new release
- FIXED: Dirsearch new flags (new release changed it)
- CHANGED: alpine has not tput. Replaced with ANSI escape codes.

#### Dockerfile

- ADDED: new params tool: Gospider.
- ADDED: Install Grep, libmagic, termcolor.
- ADDED: Go bin path to PATH
- CHANGED: ubuntu 18.04 image (deprecated) for python:3.11-alpine (stable)
- CHANGED: Move ENV variable to top.
- CHANGED: Use apk. Also python is preinstalled now.
- CHANGED: Go from 1.17.6 to latest.
- CHANGED: Findomain from 5.1.1 to latest.
- CHANGED: Amass from 3.5.5 to latest.
- CHANGED: Aquatone from shelld3v to 1.7.0.
- CHANGED: mainrecon.sh configuration moved to the bottom.

### [1.0.0] 2020-09-19

- Release for Bug Bounty Space Ekoparty <3

### [0.1.0] 2020-07-24

- Public beta release.