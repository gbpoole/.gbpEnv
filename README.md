[![Build Status](https://travis-ci.org/gbpoole/.gbpEnv.svg?branch=master)](https://travis-ci.org/gbpoole/.gbpEnv) 
[![Codacy Badge](https://api.codacy.com/project/badge/Grade/75e7e351b3f447d1925bfbc5f0d35b96)](https://www.codacy.com/app/gbpoole/.gbpEnv?utm_source=github.com&amp;utm_medium=referral&amp;utm_content=gbpoole/.gbpEnv&amp;utm_campaign=Badge_Grade)
[![codecov](https://codecov.io/gh/gbpoole/.gbpEnv/branch/master/graph/badge.svg)](https://codecov.io/gh/gbpoole/.gbpEnv)

.gbpENV
=======
This project packages all of my Linux/OSX configuration files which I want to stay constant across all environments.

Instructions for configuring an account:
----------------------------------------
- Identify a directory into which you want to install this repository (let's call it $REPO_INSTALL_PATH; usually ~, or $HOME).  For example (assuming you are using `bash` or `zsh`):
```bash
export REPO_INSTALL_PATH=$HOME
```
- Identify a directory into which you want to install this home directory configuration (let's call it $INSTALL_PATH; usually ~, or $HOME ... although it does not need to be; see below). For example (assuming you are using `bash` or `zsh`):
```bash
export INSTALL_PATH=$HOME
```
- Clone the repo (n.b.: you may need to make sure that your ssh keys are in order before executing these lines):
```bash
cd $REPO_INSTALL_PATH
git clone git@github.com:gbpoole/.gbpEnv.git
```
- Make sure that any old or default config files are moved out of the way:
```bash
cd $INSTALL_PATH
mkdir .default_config; mv .bash* .zsh* .default_config
```
- Move to the install directory (important!) and perform the install:
```bash
cd $INSTALL_PATH
make -f $REPO_INSTALL_PATH/.gbpEnv/Makefile
```

Some advantages of this setup:
------------------------------
- In instances where you are sharing an account (eg. SHARED_LOGIN) with someone else on a system (eg. IP_ADDRESS), you can have your own configuration somewhere other than $HOME and have your own defaults by logging in like this:
```bash
ssh -t -Y -l SHARED_LOGIN IP_ADDRESS "cd INSTALL_PATH; bash --rcfile .bashrc"
```
- You don't have your home directory managed by git, which can create unnecessary overhead with tools (like zsh) which monitor the current directory's repository status
- Clear separation of files which are part of this repository (all indicated as links) and those which are not.
- When managing dot files with Stow, you have more fine-grained control over your install.  You can install different applications to different systems
- System branching can be handled by the repository and it's install, reducing complexity

___

Contact info: [Personal Homepage][1] | [Email Me][2]
  
[1]: http://www.astronomy.swin.edu.au/~gpoole/
[2]: mailto:gbpoole@gmail.com
