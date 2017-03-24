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

## aspell

For spell checking I will use **flyspell** using an underlying **aspell** process. The default dictionary used is English one.

I also define a function to change the current dictionary to the German one using the shortcut *F8*. In order for this one to work, you have to install the corresponding German dictionary first.

```
sudo apt install aspell-de
```

In addition to the system-wide dictionary, I also want to use a personal dictionary holding all the keywords I adding using the spell checking. Here it is important, that the personal one belongs to the same language than the current (global) one. The language of the personal dictionary is defined in its first line.

For replacing the German dictionary with any other one you have therefore to 1. install the corresponding aspell-X package and 2. replace the second word in *//emacs/.emacs.d/.aspell.de.pws* by X.
