import subprocess
import os
import errno
import sys



def submit_single_qsub_job(use_regionlets, use_mscnn, num_particles, include_ignored_gt=False, include_dontcare_in_gt=False, 
    sort_dets_on_intervals=True, run_idx=-1, seq_idx=-1):
    if not run_complete(run_idx, seq_idx, num_particles, include_ignored_gt, include_dontcare_in_gt, 
                        sort_dets_on_intervals, use_regionlets, use_mscnn):

        command = 'qsub -q atlas -l nodes=1:ppn=1 -v num_particles=%d,include_ignored_gt=%s,' \
                'include_dontcare_in_gt=%s,use_regionlets=%s,use_mscnn=%s,sort_dets_on_intervals=%s,' \
                'RUN_IDX=%d,NUM_RUNS=%d,SEQ_IDX=%d setup_rbpf_anaconda_venv.sh' \
                 % (num_particles, include_ignored_gt, include_dontcare_in_gt, use_regionlets, use_mscnn, \
                 sort_dets_on_intervals, run_idx, NUM_RUNS, seq_idx)
        os.system(command)

def submit_single_qsub_job2(n, fname):
	command = 'qsub -q atlas -l nodes=1:ppn=1 -v n=%i,fname=%s shscrpt.sh' % (n, fname)

	os.system(command)


if __name__ == "__main__":   
    #mscnn_and_regionlets_with_score_intervals
    # for num_particles in NUM_PARTICLES_TO_TEST:
    #     submit_single_experiment(use_regionlets=True, use_mscnn=True, num_particles=num_particles, 
    #                             include_ignored_gt=False, include_dontcare_in_gt=False, 
    #                             sort_dets_on_intervals=True)
	for i in range(1):
		submit_single_qsub_job2(50, str(i))