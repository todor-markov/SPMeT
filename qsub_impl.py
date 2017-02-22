import subprocess
import os
import errno
import sys



def submit_single_qsub_job2(v, script):
    command = 'qsub -q atlas -l nodes=1:ppn=1 -v %s %s' % (v, script)

    os.system(command)


if __name__ == "__main__":
    for i in range(2):
        var = 'n=%i,fname=%s' % (50, str(i))
        submit_single_qsub_job2(var, 'shscrpt.sh')