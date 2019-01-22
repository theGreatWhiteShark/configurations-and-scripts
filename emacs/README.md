All configuration files concerning Emacs.

**Tip**: Just link your *.emacs* file in your using a symbolic link to the one in a Git repository. This way it's very easy to have your latest configurations on all the computers your are working at.

``` bash
# In the root of the repository
ln -s emacs/.emacs ~/.emacs
```

# Emacs packages as submodules

It is especially useful to introduce of the Emacs packages you use via Github into your repository via submodules. This way you can update them all at once and the setup of a new system can a couple of commands.

Before using, be sure to initialize and update your submodules. This way all the required code will be downloaded on your computer.

``` bash
# Recursively in order to get the code of the submodules of submodules
# as well.
git submodule update --init --recursive --remote
```

# Hydrogen

In the *elisp/hydrogen.el* file I wrote some functions that help with
migrating from one drum kit to another in the
[Hydrogen](https://github.com/hydrogen-music/hydrogen) drum machine.

# SuperCollider

When working with
[SuperCollider](https://github.com/supercollider/supercollider)
*without* installing the **supercollider-emacs** in Debian-based
systems, you have to introduce the lisp in the [scel](emacs/scel/el)
folder to the *load-path* in the **.emacs** file. This is already done
in the version present in this repository.

In addition, you also have to create the folder for the Emacs
extension of SuperCollider and copy all .sc files but the Document.sc
one in there.

``` bash
# Create a subfolder for the SuperCollider extension of Emacs
sudo mkdir /usr/share/SuperCollider/Extensions/scide_scel

# Copy all but the Document.sc files in there
sudo cp emacs/scel/sc/* /usr/share/SuperCollider/Extensions/scide_scel/
sudo rm /usr/share/SuperCollider/Extensions/scide_scel/Document.sc
```

# Hints

## General

When customizing the **.emacs** file you can move to a closing bracket and evaluate its content using `C-x C-e` (displays the result in the bottom line/echo area) or `C-j` (inserts the result in the next line). In case there is a syntax error a new buffer called **Backtrace** will pop up. So no need to start a new Emacs instance every time you wrote some lines in your configuration file.

As a very practical example you can use any Emacs buffer as a calculator by pressing `C-x C-e` after e.g.

``` lisp
(log (+ 3 4 1 (* 3 20)))
```
> 4.219507705176107


## Org-mode

In order to run **org-mode**, you have to change to the submodule's folder after updating and compile its lisp code.

``` bash
cd org-mode
make
make autoloads
```

## python-mode

Lately I migrated to `elpy` since it is much more faster, stable and
easy to use than `anaconda-mode` or
[this](https://gitlab.com/python-mode-devs/python-mode)
`python-mode`. But, still, there are some requirements/packages you
need to install to make it work.

Inside `Emacs` install the following packages: `elpy`, `pyvenv`
(e.g. using **M-x package-list-packages**).

First of all, it uses `virtualenv`. I will create a folder called
*.virtualenvironments* in my home, which will contain all the
environments. Feel free to adjust the name as you please.

``` bash
# Install the necessary packages
sudo apt install virtualenv python3-virtualenv
# Create a folder to store all environments
mkdir $HOME/.virtualenvironments
cd $HOME/.virtualenvironments
```

Now, we will create a new virtual environment, which will use
`python3` instead of `python2`

``` bash
virtualenv elpy_env -p /usr/bin/python3
```

To tell `Emacs` about the changes, you have to add the following lines
to your *.emacs*

``` lisp
(require 'elpy)
(add-hook 'python-mode-hook (lambda() (elpy-mode)))
(setenv "WORKON_HOME" "~/.virtualenvironments/")
```

Inside `Emacs` we have to run the following commands to set up the
environment properly: 
- **M-x pyvenv-workon elpy_env**
- **M-x elpy-config**

If you wish to use `ipython3` as interpreter, add to following lines
to your *.emacs*.

``` lisp
(setenv "IPY_TEST_SIMPLE_PROMPT" "1")
(setq python-shell-interpreter "ipython3"
      python-shell-intepreter-args "-i")
```

## aspell

For spell checking I will use **flyspell** using an underlying **aspell** process. The default dictionary used is English one.

I also define a function to change the current dictionary to the German one using the shortcut *F8*. In order for this one to work, you have to install the corresponding German dictionary first.

``` bash
sudo apt install aspell-de
```

In addition to the system-wide dictionary, I also want to use a personal dictionary holding all the keywords I adding using the spell checking. Here it is important, that the personal one belongs to the same language than the current (global) one. The language of the personal dictionary is defined in its first line.

For replacing the German dictionary with any other one you have therefore to 1. install the corresponding aspell-X package and 2. replace the second word in *//emacs/.emacs.d/.aspell.de.pws* by X.
