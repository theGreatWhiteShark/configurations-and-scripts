My bash configuration [.bashrc](bash/.bashrc) and some bash scripts I find quite useful.

## Scripts
#### [git_remove.sh](bash/git_remove.sh)

A function I picked up in the web some years ago. It provides a graphical interface in the command line listing the ten biggest files in the cache of a git repository and it enables you to remove several/all of these objects.
This is quite handy when you end up with a very big cache of your repository after a while and want to clean is up.

#### [job.sh](bash/job.sh)

Bash function to handle the local queuing system at the institute I am working at. 

In case you are wondering why I define a function I never call, I will source this file in the [.bashrc](bash/.bashrc) and link it via an alias.

It does the following things:

1. It generates an envelop specifying your requirements towards the queuing system.
2. It will copy the file supplied as the first argument to the workers /scratch hard disk.
3. It will create a log file containing not only the returned output, but also a copy of the supplied script and place a copy of all the log files it generates into a hidden folder in your home. (It's a nice way to keep track of all the calculation you have done throughout the years).
4. After finishing, it will copy all generated files in a distinct folder in to the point you called the function at.

In order to use the script with other languages than *R*, just apply the following changes

```
cat job.sh | sed 's/.R/<EXTENSION OF THE SCRIPT TYPE YOU ARE USING>/g' > job.sh
cat job.sh | sed 's/RScript/<THE TERMINAL COMMAND TO EXECUTE YOUR SCRIPT>/g' > job.sh
```

e.g. when you use Matlab
```
cat job.sh | sed 's/.R/.m/g' > job.sh
cat job.sh | sed 's/matlab -nodisplay -nodesktop -nosplash/<THE TERMINAL COMMAND TO EXECUTE YOUR SCRIPT>/g' > job.sh
```
