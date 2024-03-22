# fzf_interactive_cd
Interactive 'cd' powered by fzf

# Demo
![](https://github.com/Kyle0923/fzf_interactive_cd/blob/main/fzf_cd.gif)

# Prerequisite
This script requires the following binaries:  
- fzf: https://github.com/junegunn/fzf, I am using version 0.48.1  
- fd: https://github.com/sharkdp/fd  
- bat: https://github.com/sharkdp/bat  
- tree: Linux tree tool, e.g., on Ubuntu `sudo apt-get install tree`  

Special thanks to these open source projects that enables this tool

# Installation
Add the companion script `fzf_previewer` to path and add executable permission  
Source the fzf_interactive_cd.bash script

# Usage
## `c` - A Supercharged `cd`
`c` is a wrapper of `cd`  
When no parameter is provided, it goes into "Direct execuation mode" where you can to interactively travel through the directory tree and `cd` into the directory you choose  
Auto-completion is also provided if you prefer to take a look at the directory before you hit the Enter  
On top of that, `c` can also "cd to the file", that is `cd` into the directory that contains the file

## Auto-completion mode
type `c \` and hit `tab`  
the auto completion trigger can be customized by the `FZF_COMPLETION_TRIGGER` variable (fzf feature)
## Direct execution mode
type `c` and hit `enter`

## Key bindings
`Alt+Enter` select the path and exit, in auto-completion mode, the path is added to command line, in direct execution mode, cd into the selected directory  
`Ctrl+W` pop the last level of directory  
`Alt+A` recursively find all files under current directory, useful when you have a good idea of the file/directory you are after but can be noisy  
`Enter` if the selection is a directory, enter the directory, if it is a file, select the file and exit  
`left` / `right` when the current search word is empty, `left` and `right` can be use to go up or down in the directory tree  
`Alt + arrow keys` scroll up/down page-up/down in the preview window  
`Ctrl+/` change preview window postion or turn it off  

## FZF search syntax
see [FZF manual](https://github.com/junegunn/fzf?tab=readme-ov-file#search-syntax)

# rgf - An rg-fzf Integration
A search tool powered by both rg and fzf  
You can toggle between rg and fzf  
And you can also perform nested search - rg 'w{3}' => fzf 'google' => rg '[Cc]om' will match 'www.google.Com' and 'www.google.com'
![](https://github.com/Kyle0923/fzf_interactive_cd/blob/main/rgf.png)

## Prerequisites
In addition to the prerequisites listed above for fzf-interactive-cd, it also requires [rg](https://github.com/BurntSushi/ripgrep)

## Usage
`rgf` similar to `rg | fzf`, search through all files  
`rgf [filename]` search in a file, similar to `less`  
`CMD | rgf` pipe the output of CMD to `rgf`  

Key bindings and options are documented in `rgf --help`
