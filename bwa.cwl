#!/usr/bin/env cwl-runner

cwlVersion: v1.0

class: CommandLineTool

baseCommand: [bwa, mem]

stdout: $(inputs.sample_name).sam

inputs:

  num_cpus:
    type: int
    inputBinding:
      position: 1
      prefix: -t

  bwa_index:
    type: string
    inputBinding:
      position: 2

  fastq_file_1:
    type: File
    inputBinding:
      position: 3

  fastq_file_2:
    type: File?
    inputBinding:
      position: 4

  sample_name:
    type: string

outputs:

  sam_output:
    type: stdout
