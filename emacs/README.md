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
git submodule update --init --recursive
```

# Hints

In order to run **org-mode**, you have to change to the submodule's folder after updating and compile its lisp code.

```
cd org-mode
make
make autoloads
```
