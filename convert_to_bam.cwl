#!/usr/bin/env cwl-runner

cwlVersion: v1.0

class: CommandLineTool

baseCommand: [samtools, view, -b]

stdout: $(inputs.sample_name).bam

inputs:

  sample_name:
    type: string

  sam_file:
    type: File
    inputBinding:
      position: 1

outputs:

  bam_file:
    type: stdout
