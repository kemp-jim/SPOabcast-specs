#!/bin/bash -l 


# createlts.sh MCRL2FILE N         – Create an lts from the specification in MCRL2FILE and then reduce it modulo dp branching bisimulation. N is the number of threads used.

# Flags for mcrl22lps
mcrl22lpsflags="--verbose"

# Flags for lps2lts
# with the --no-info option, states do not carry information labels
lps2ltsflags="--cached --rewriter=jitty --threads=$2 --verbose --no-info"

# Flags for ltsconvert
# --no-state removes state labels
ltsconvertflags="-edpbranching-bisim --no-state"

# Name of the .lts file.
mcrl2file="$1"

# Name of the .lts file.
lpsfile="spec.lps"

# Name of the .lts file.
ltsfile="spec.lts"

# Name of the reduced lts.
reducedlts="reduced.lts"

metricsfile="metrics.txt"
logfile="logs.log"



# create and copy files into new dir

mcrl2file=$(realpath $mcrl2file)


# Create a dir for the files
cdate="$(date '+%Y-%m-%d--%H-%M')"
dirname="C_"$(basename "$mcrl2file" .mcrl2)"_${cdate}"
mkdir -p "$dirname"

# copy everything into this dir
cp $mcrl2file $dirname
cp createlts.sh $dirname

# go into the dir
cd $dirname
new_mcrl2file="$(basename "$mcrl2file")"


# create the lts

start=`date +%s`

mcrl22lps $mcrl22lpsflags $new_mcrl2file $lpsfile 2>&1 | tee -a $logfile 
lps2lts $lps2ltsflags $lpsfile $ltsfile 2>&1 | tee -a $logfile 

end=`date +%s`
runtime=$((end-start))

echo "mcrl22lps + lps2lts runtime: $runtime" >> $metricsfile

# reduce the lts

start=`date +%s`
ltsconvert $ltsconvertflags $ltsfile $reducedlts 2>&1 | tee -a $logfile
end=`date +%s`
runtime=$((end-start))

echo "ltsconvert runtime: $runtime" >> $metricsfile

# append info of reduced lts to metricsfile

start=`date +%s`

ltsinfo $reducedlts 2>&1 | tee -a $logfile

end=`date +%s`
runtime=$((end-start))

echo "ltsinfo runtime: $runtime" >> $metricsfile
