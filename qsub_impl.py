import subprocess
import os
import errno
import sys



def submit_single_qsub_job2(v, script):
	command = 'qsub -q atlas -l nodes=1:ppn=1 -v %s %s' % (v, script)

	os.system(command)


if __name__ == "__main__":   
    #mscnn_and_regionlets_with_score_intervals
    # for num_particles in NUM_PARTICLES_TO_TEST:
    #     submit_single_experiment(use_regionlets=True, use_mscnn=True, num_particles=num_particles, 
    #                             include_ignored_gt=False, include_dontcare_in_gt=False, 
    #                             sort_dets_on_intervals=True)
	for i in range(20):
        v = 'n=%i,fname=%s' % (50, str(i))
		submit_single_qsub_job2(v, 'shscrpt.sh')