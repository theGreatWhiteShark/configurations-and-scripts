All configuration files concerning Emacs.

**Tip**: Just link your *.emacs* file in your using a symbolic link to the one in a Git repository. This way it's very easy to have your latest configurations on all the computers your are working at.

```
# In the root of the repository
ln -s emacs/.emacs ~/.emacs
```

# Emacs packages as submodules

It is especially useful to introduce of the Emacs packages you use via Github into your repository via submodules. This way you can update them all at once and the setup of a new system can a couple of commands.

Before using, be sure to initialize and update your submodules. This way all the required code will be downloaded on your computer.

```
# Recursively in order to get the code of the submodules of submodules
# as well.
git submodule update --init --recursive --remote
```

# Hints

## General

When customizing the **.emacs** file you can move to a closing bracket and evaluate its content using `C-x C-e` (displays the result in the bottom line/echo area) or `C-j` (inserts the result in the next line). In case there is a syntax error a new buffer called **Backtrace** will pop up. So no need to start a new Emacs instance every time you wrote some lines in your configuration file.

As a very practical example you can use any Emacs buffer as a calculator by pressing `C-x C-e` after e.g.

(log (+ 3 4 1 (* 3 20)))
> 4.219507705176107


## Org-mode

In order to run **org-mode**, you have to change to the submodule's folder after updating and compile its lisp code.

```
cd org-mode
make
make autoloads
```

## python-mode

Since this mode is lacking a proper documentation, I might write some lines about it.

Per default **ipython3.5** will be called when running the whole Python script. If it is instead Python2.7 based, run **M-x py-choose-shell** *before* evaluating the script.

The mode features a nice function **py-smart-indentation** which figures out the indentation width of a document. While this is quite handy for collaboration, I usually want to reindent the script before modifying it. Therefore this function is disabled and has to be activated using **M-x py-toggle-smart-indentation**.

## jedi

In order to use the Python autocompletion tool **jedi** in combination with **Python3** and not the default Python2.7, I used the trick from [this](https://archive.zhimingwang.org/blog/2015-04-26-using-python-3-with-emacs-jedi.html) blog post.

First one has to set up the virtual environment outside of Emacs
```
## Since I ignore the .python-environments folder in this repository
## you have to create it first.
mkdir -p ~/.emacs.d/.python-environments
virtualenv -p /usr/bin/python3 ~/.emacs.d/.python-environments/jedi

## Insert your correct version number in the next one
~/.emacs.d/.python-environments/jedi/bin/pip install --upgrade ~/.emacs.d/elpa/jedi-core-20170121.610/
```
Afterwards one has to set the environment root folder to the one just created within the *.emacs*.

```
(setq jedi:environment-root "jedi")
```

## aspell

For spell checking I will use **flyspell** using an underlying **aspell** process. The default dictionary used is English one.

I also define a function to change the current dictionary to the German one using the shortcut *F8*. In order for this one to work, you have to install the corresponding German dictionary first.

```
sudo apt install aspell-de
```

In addition to the system-wide dictionary, I also want to use a personal dictionary holding all the keywords I adding using the spell checking. Here it is important, that the personal one belongs to the same language than the current (global) one. The language of the personal dictionary is defined in its first line.

For replacing the German dictionary with any other one you have therefore to 1. install the corresponding aspell-X package and 2. replace the second word in *//emacs/.emacs.d/.aspell.de.pws* by X.
