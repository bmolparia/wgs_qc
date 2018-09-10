#!/usr/bin/env cwl-runner

cwlVersion: v1.0

class: CommandLineTool

baseCommand: [picard, -Xmx16g, -Djava.io.tmpdir=`pwd`/tmp, FastqToSam]

inputs:

  sample_name:
    type: string
    inputBinding:
      position: 1
      prefix: SAMPLE_NAME=
      separate: false

  fastq_file_1:
    type: File
    inputBinding:
      position: 2
      prefix: FASTQ=
      separate: false

  fastq_file_2:
    type: File?
    inputBinding:
      position: 3
      prefix: FASTQ2=
      separate: false

arguments: [OUTPUT=$(inputs.sample_name).unal.sam]

outputs:

  unaligned_sam:
    type: File
    outputBinding:
      glob: $(inputs.sample_name).unal.sam
