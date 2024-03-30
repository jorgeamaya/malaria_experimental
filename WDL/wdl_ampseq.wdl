version 1.0

workflow ampseq {
	input {	
		#General commands
		Array[File] path_to_r1
		Array[File] path_to_r2
		File path_to_flist
		File pr1
		File pr2
		File reference1
		File reference2
		File path_to_snv

		String pattern_fw = "*_L001_R1_001.fastq.gz"
		String pattern_rv = "*_L001_R2_001.fastq.gz"

		#Commands for AmpSeq
		String Class = "parasite"
		String maxEE = "5,5"
		String trimRight = "0,0"
		Int minLen = 30
		String truncQ = "5,5"
		String matchIDs = "0"
		Int max_consist = 10
		Float omegaA = 0.000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000001
		String saveRdata = ""
		Int justConcatenate = 0
		Int maxMismatch = 0
		String no_ref = 'False'
		String adjust_mode = "absolute"
		String strain = "3D7"
		String strain2 = "DD2"
		String polyN = "5"
		String min_reads = "0"
		String min_samples = "0"
		String max_snv_dist = "-1"
		String max_indel_dist = "-1"
		String include_failed = "False"
		String exclude_bimeras = "False"
		String adapter = "None"

		#Command for the decontamination pipeline
		Int minreads_threshold = 1000
		Float contamination_threshold = 0.5
		String verbose = "False"		
	}

	call ampseq_pipeline {
		input:
			path_to_r1 = path_to_r1,
			path_to_r2 = path_to_r2,
			path_to_flist = path_to_flist,
			pr1 = pr1,
			pr2 = pr2,
			reference1 = reference1,
			reference2 = reference2,
			path_to_snv = path_to_snv,
			pattern_fw = pattern_fw,
			pattern_rv = pattern_rv,
			Class = Class,
			maxEE = maxEE,
			trimRight = trimRight,
			minLen = minLen,
			truncQ = truncQ,
			matchIDs = matchIDs,
			max_consist = max_consist,
			omegaA = omegaA,
			saveRdata = saveRdata,
			justConcatenate = justConcatenate,
			maxMismatch = maxMismatch,
			no_ref = no_ref,
			adjust_mode = adjust_mode,
			strain = strain,
			strain2 = strain2,
			polyN = polyN,
			min_reads = min_reads,
			min_samples = min_samples,
			max_snv_dist = max_snv_dist,
			max_indel_dist = max_indel_dist,
			include_failed = include_failed,
			exclude_bimeras = exclude_bimeras,
			minreads_threshold = minreads_threshold,
			contamination_threshold = contamination_threshold,
			verbose = verbose,
			adapter = adapter
	}

#	output {
#		File? ASVBimeras_f = ampseq_pipeline.ASVBimeras
#		File? CIGARVariants_Bfilter_f = ampseq_pipeline.CIGARVariants_Bfilter
#		File? ASV_to_CIGAR_f = ampseq_pipeline.ASV_to_CIGAR
#		File? seqtab_f = ampseq_pipeline.seqtab
#		File? ASVTable_f = ampseq_pipeline.ASVTable
#		File? ASVSeqs_f = ampseq_pipeline.ASVSeqs
#		File? missing_files_f = ampseq_pipeline.missing_files
#		File? decontamination_sample_cards_f = ampseq_pipeline.decontamination_sample_cards
#		File? decontamination_report_f = ampseq_pipeline.decontamination_report
#	}
}

task ampseq_pipeline {
	input {
		Array[File] path_to_r1
		Array[File] path_to_r2
		File path_to_flist
		File pr1
		File pr2
		File reference1
		File reference2
		File path_to_snv
		String pattern_fw = "*_L001_R1_001.fastq.gz"
		String pattern_rv = "*_L001_R2_001.fastq.gz"
		String Class = "parasite"
		String maxEE = "5,5"
		String trimRight = "0,0"
		Int minLen = 30
		String truncQ = "5,5"
		String matchIDs = "0"
		Int max_consist = 10
		Float omegaA = 0.000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000001
		String saveRdata = ""
		Int justConcatenate = 0
		Int maxMismatch = 0
		String no_ref = 'False'
		String adjust_mode = "absolute"
		String strain = "3D7"
		String strain2 = "DD2"
		String polyN = "5"
		String min_reads = "0"
		String min_samples = "0"
		String max_snv_dist = "-1"
		String max_indel_dist = "-1"
		String include_failed = "False"
		String exclude_bimeras = "False"
		Int minreads_threshold = 1000
		Float contamination_threshold = 0.5
		String verbose = "False"
		String adapter = "None"
	}

	Map[String, String] in_map = {
		"path_to_fq": "fq_dir",
		"path_to_flist": sub(path_to_flist, "gs://", "/cromwell_root/"),
		"pr1": sub(pr1, "gs://", "/cromwell_root/"),
		"pr2": sub(pr2, "gs://", "/cromwell_root/"),
		"reference1": sub(reference1, "gs://", "/cromwell_root/"),
		"reference2": sub(reference2, "gs://", "/cromwell_root/"),
		"path_to_snv": sub(path_to_snv, "gs://", "/cromwell_root/"),
		"pattern_fw": pattern_fw,
		"pattern_rv": pattern_rv,
		"Class": Class,
		"maxEE": maxEE,
		"trimRight": trimRight,
		"minLen": minLen,
		"truncQ": truncQ,
		"matchIDs": matchIDs,
		"max_consist": max_consist,
		"omegaA": omegaA,
		"saveRdata": saveRdata,
		"justConcatenate": justConcatenate,
		"maxMismatch": maxMismatch,
		"no_ref": no_ref,
		"adjust_mode": adjust_mode,
		"strain": strain,
		"strain2": strain2,
		"polyN": polyN,
		"min_reads": min_reads,
		"min_samples": min_samples,
		"max_snv_dist": max_snv_dist,
		"max_indel_dist": max_indel_dist,
		"include_failed": include_failed,
		"exclude_bimeras": exclude_bimeras,
		"minreads_threshold": minreads_threshold,
		"contamination_threshold": contamination_threshold,
		"verbose": verbose,
		"adapter": adapter
	}
	File config_json = write_json(in_map)
	command <<<
	set -euxo pipefail
	#set -x
	mkdir fq_dir

	echo "Processing files: ~{sep = ' ' path_to_r1}"
	echo "Processing files: ~{sep = ' ' path_to_r2}"

	#Download fastq files
	#cp ~{sep = ' ' path_to_r1} fq_dir/.
	#cp ~{sep = ' ' path_to_r2} fq_dir/.
#	gsutil -m cp -r ~{sep = ' ' path_to_r1} fq_dir/
#	gsutil -m cp -r ~{sep = ' ' path_to_r2} fq_dir/
#
#	#Move reference files to the main level	
#	# Check if the first line in barcodes_matches.csv indicates the presence of inline barcodes
#	if grep -q "," ~{path_to_flist} ; then
#		echo "Sequencing run with inline barcodes. Performing analysis of combinatorial indices followed by denoising"
#		find . -type f
#		python /Code/Amplicon_TerraPipeline.py --config ~{config_json} --terra --meta --adaptor_removal --contamination --separate_reads --primer_removal --dada2 --postproc_dada2 --asv_to_cigar
#		Rscript /Code/render_report.R -d /cromwell_root/Report/Merge/ -o /cromwell_root/Report/ -p ~{path_to_flist} -m 1000 -c 0.5 -mf /cromwell_root/Results/missing_files.tsv
#		tar -czvf Report_Cards.tar.gz /cromwell_root/Report
#		find . -type f
#	else
#		echo "Sequencing run without inline barcodes. Skipping analysis of combinatorial indices and performing only denoising"
#		find . -type f
#		python /Code/Amplicon_TerraPipeline.py --config ~{config_json} --terra --meta --adaptor_removal --separate_reads --primer_removal --dada2 --postproc_dada2 --asv_to_cigar
#		find . -type f
#	fi	
	>>>
#	output {
#		File? ASVBimeras = "Results/ASVBimeras.txt"
#		File? CIGARVariants_Bfilter = "Results/CIGARVariants_Bfilter.out.tsv"
#		File? ASV_to_CIGAR = "Results/ASV_to_CIGAR/ASV_to_CIGAR.out.txt"
#		File? seqtab = "Results/seqtab.tsv"
#		File? ASVTable = "Results/PostProc_DADA2/ASVTable.txt"
#		File? ASVSeqs = "Results/PostProc_DADA2/ASVSeqs.fasta"
#		File? missing_files = "Results/missing_files.tsv"
#		File? decontamination_sample_cards = "Report_Cards.tar.gz"
#		File? decontamination_report = "Results/ci_report_layouting.html"
#	}
	runtime {
		cpu: 1
		memory: "15 GiB"
		disks: "local-disk 10 HDD"
		bootDiskSizeGb: 10
		preemptible: 3
		maxRetries: 1
		docker: 'jorgeamaya/ampseq'
	}
}

