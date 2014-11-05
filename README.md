# autosrc
Script for zsh/bash to automatically run commands based on which directory you are in. An example of this being useful is managing multiple Python virtual environments.


### Installation

#### zsh
Add to your `~/.zshrc`:
```
source /path/to/autosrc.zsh
```

#### bash
Add to your `~/.bashrc`:
```
source /path/to/autosrc.bash
```
(This is not as well tested since I don't use bash often. Please let me know if
you find a bug.)

### Usage

Then, create a file called `.autosrc` in the directory/directories you want to use autosrc. Specify `autosrc_enter()` and `autosrc_exit()` functions to be called on enter and exit events.

Here is an example `.autosrc` file for Python venv:
```shell
# Called when you first enter the directory (or its children)
autosrc_enter() {
	source <your_venv>/bin/activate
}

# Called when you exit the directory
autosrc_exit() {
	deactivate
}
```

### Parent/children directories

If no `.autosrc` file is found in the current directory, autosrc will try to find/use one in the parent directory, then grandparent directory, etc.

If you enter a child directory that has a different `.autosrc`, then `autosrc_exit()` for the current directory and `autosrc_enter()` in the child directory will be called. If there exists no `.autosrc` in the child directory, nothing will happen.

This will allow you to stay in the same environment even if you visit child directories, but enter new child environments if you need.

### License

Do whatever you want with it :)
