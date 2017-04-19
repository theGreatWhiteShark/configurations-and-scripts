function_qjob() { 
### A function to produce a envelop for the batch job system in the current folder and transmitting a script to this system. The name of the script to be transmitted has to be passed to this function as the first input parameter. This script has to be located in the current working directory!

## checks if supplied script is present in local folder
if [ $(ls | grep $1 | wc -w ) -eq 0 ];then
    echo "Provided script is not located in the current folder. Check for right spelling!"
    return
fi

## checking if the right type of script is supplied. This function is only capable of running R scripts. The awk command is checking if the string .R is contained in the name of the supplied file
if [ $(echo $1 | awk 'BEGIN {check=0}; /.R/ {check=1}; END {print check}') -eq 0 ];then
    echo "The supplied script is not a R script! (Or at least it got no .R extension) Supply a script of the right language!"
    return
fi
    
## Generates a name of the job assuming a R script is provided. But function will work for other kind of scripts too. The name of the job consists of the name of the supplied script and the current time.
JobName=$(echo $(echo $1 | sed 's/.R//g')"_"$(date +%D | sed 's/\//-/g')"_"$(date | awk '{print $4}' | sed 's/:/-/g'))

## Mirrors current folder at /scratch for performance issues
HomeDir=$(pwd)
WorkingDir=$(pwd | sed 's/home/scratch/g')

## All the results will be transmitted to the folder 'results' in the current working directory and the log files are transmitted to a folder $HOME/.job.logs which contains all logfiles

## Generating a submission script
cat >.job.sh <<EOF
#!/bin/bash -i
## http://arc.liv.ac.uk/SGE/htmlman/manuals.html
##
### Arguments passed to the queuing system
## default interpreter shell
#$ -S /bin/bash
## required hardware resources (default options. should be enough for the moment)
#$ -l h_rss=2000M,h_fsize=10000M,h_cpu=20:00:00,hw=x86_64,proc_surname=broadwell
## name of the job
#$ -N $JobName
## starting directory for the job
#$ -wd $HomeDir
## Split stdout and stderr
#$ -j n
## redirecting the standard output and error (something like a log file for the job)
#$ -o $(echo "log_"$JobName".log")
#$ -e $(echo "err_"$JobName".err")

## OpenSuSe has a strange way of handling threading
export OMP_NUM_THREADS=\$NSLOTS

module load sge62

## If there is already a visible log and error file -> hide them
for ll in \$(ls $HomeDir | grep ^log);do
    if [ "\$ll" != $(echo "log_"$JobName".log") ];then
        mv $(echo $HomeDir"/"\$ll) $(echo $HomeDir"/."\$ll)
    fi
done
for ll in \$(ls $HomeDir | grep ^err);do
    if [ "\$ll" != $(echo "err_"$JobName".err") ];then
        mv $(echo $HomeDir"/"\$ll) $(echo $HomeDir"/."\$ll)
    fi
done


date

## Copying the script on the /scratch of the local host
if [ -d $WorkingDir ];then
    cp $(echo $HomeDir"/"$1) $(echo $WorkingDir"/"$1)
else
    mkdir -p $WorkingDir
    cp $(echo $HomeDir"/"$1) $(echo $WorkingDir"/"$1)
fi

cd $WorkingDir

## Running the script
/usr/local/R/3.3.2/bin/Rscript $1

## some output for a more detailed log file

echo "####################################################################"
echo "####################################################################"
echo "The script "$1" was running on host "$(hostname)" in the directory "$(pwd)
echo "####################################################################"
echo "running the following script:"
cat $1

date

## cleaning up the scratch
if [ -d $HOME/.job.logs ];then
    cp $(echo $HomeDir"/log_"$JobName".log") $(echo $HOME"/.job.logs/"$JobName".log")
    cp $(echo $HomeDir"/err_"$JobName".err") $(echo $HOME"/.job.logs/"$JobName".err")
else
    mkdir $(echo $HOME"/.job.logs")
    cp $(echo $HomeDir"/log_"$JobName".log") $(echo $HOME"/.job.logs"/$JobName".log")
    cp $(echo $HomeDir"/err_"$JobName".err") $(echo $HOME"/.job.logs"/$JobName".err")
fi

if [ -d $(echo $HomeDir"/results") ];then
    cp $WorkingDir/* $(echo $HomeDir"/results")
else
    mkdir $(echo $HomeDir"/results")
    cp $WorkingDir/* $(echo $HomeDir"/results")
fi

EOF

qsub ./.job.sh

}
