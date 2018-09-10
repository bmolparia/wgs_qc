#!/usr/bin/env cwl-runner

cwlVersion: v1.0

class: Workflow

inputs:

  sample_id:
    type: string
  read_file_1:
    type: File
  read_file_2:
    type: File?

  is_paired:
    # string because this is an input to picard
    type: string

  bwa_index:
    # Path to bwa index
    type: string

  picard_index:
      # Path to picard index
      type: string

  num_cpus:
    type: int

outputs:

  sam:
    type: File
    outputSource: BWA/sam_output

  unal_sam:
    type: File
    outputSource: FastqToSam/unaligned_sam

  merged_sam:
    type: File
    outputSource: MergeBamAlignment/merged_sam

  duplicates_marked_sam:
    type: File
    outputSource: MarkDuplicates/duplicates_marked_sam

  duplication_metrics:
    type: File
    outputSource: MarkDuplicates/duplication_metrics

  bam_file:
    type: File
    outputSource: ConvertToBam/bam_file

  # validation_summary_file:
  #   type: File
  #   outputSource: ValidateSamFile/validation_summary_file

  library_complexity_file:
    type: File
    outputSource: EstimateLibraryComplexity/library_complexity_file

  base_dist_metircs_files:
    type: File[]
    outputSource: CollectBaseDistributionByCycle/base_dist_metircs_files

  insert_size_files:
    type: File[]
    outputSource: CollectInsertSizeMetrics/insert_size_files

  coverage_metric_files:
    type: File[]
    outputSource: CollectCoverageMetrics/coverage_metric_files

  gcbias_metric_files:
    type: File[]
    outputSource: CollectGcBiasMetrics/gcbias_metric_files

  quality_score_metircs_files:
    type: File[]
    outputSource: QualityScoreDistribution/quality_score_metircs_files

  quality_by_cycle_metircs_files:
    type: File[]
    outputSource: MeanQualityByCycle/quality_by_cycle_metircs_files

steps:

  BWA:
    run: bwa.cwl
    in:
      fastq_file_1: read_file_1
      fastq_file_2: read_file_2
      sample_name: sample_id
      bwa_index: bwa_index
      num_cpus: num_cpus
    out: [sam_output]

  FastqToSam:
    run: picard_FastqToSam.cwl
    in:
      fastq_file_1: read_file_1
      fastq_file_2: read_file_2
      sample_name: sample_id
    out: [unaligned_sam]

  MergeBamAlignment:
    run: picard_MergeBamAlignment.cwl
    in:
      sample_name: sample_id
      picard_ref: picard_index
      paired: is_paired
      unmapped_bam: FastqToSam/unaligned_sam
      aligned_bam: BWA/sam_output
    out: [merged_sam]

  MarkDuplicates:
    run: picard_MarkDuplicates.cwl
    in:
      sample_name: sample_id
      merged_sam: MergeBamAlignment/merged_sam
    out: [duplicates_marked_sam, duplication_metrics]

  ConvertToBam:
    run: convert_to_bam.cwl
    in:
      sample_name: sample_id
      sam_file: MarkDuplicates/duplicates_marked_sam
    out: [bam_file]

  ## NOTE: This won't work with  OpenJDK 64-Bit. 
 
  # ValidateSamFile:
  #   run: picard_ValidateSamFile.cwl
  #   in:
  #     sample_name: sample_id
  #     sam_input: MarkDuplicates/duplicates_marked_sam
  #   out: [validation_summary_file]

  EstimateLibraryComplexity:
    run: picard_EstimateLibraryComplexity.cwl
    in:
      sample_name: sample_id
      bam_input: ConvertToBam/bam_file
    out: [library_complexity_file]

  CollectBaseDistributionByCycle:
    run: picard_CollectBaseDistributionByCycle.cwl
    in:
      sample_name: sample_id
      bam_input: ConvertToBam/bam_file
      picard_ref: picard_index
    out: [base_dist_metircs_files]

  CollectInsertSizeMetrics:
    run: picard_CollectInsertSizeMetrics.cwl
    in:
      sample_name: sample_id
      bam_input: ConvertToBam/bam_file
    out: [insert_size_files]

  CollectCoverageMetrics:
    run: picard_CollectCoverageMetrics.cwl
    in:
      sample_name: sample_id
      picard_ref: picard_index
      bam_input: ConvertToBam/bam_file
    out: [coverage_metric_files]

  CollectGcBiasMetrics:
    run: picard_CollectGcBiasMetrics.cwl
    in:
      sample_name: sample_id
      picard_ref: picard_index
      bam_input: ConvertToBam/bam_file
    out: [gcbias_metric_files]

  QualityScoreDistribution:
    run: picard_QualityScoreDistribution.cwl
    in:
      sample_name: sample_id
      bam_input: ConvertToBam/bam_file
    out: [quality_score_metircs_files]

  MeanQualityByCycle:
    run: picard_MeanQualityByCycle.cwl
    in:
      sample_name: sample_id
      bam_input: ConvertToBam/bam_file
    out: [quality_by_cycle_metircs_files]
