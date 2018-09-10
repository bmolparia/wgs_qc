#!/usr/bin/env cwl-runner

cwlVersion: v1.0

class: CommandLineTool

baseCommand: [picard, -Xmx16g, -Djava.io.tmpdir=`pwd`/tmp, MergeBamAlignment]

inputs:

  sample_name:
    type: string

  picard_ref:
    type: string
    inputBinding:
      position: 1
      prefix: REFERENCE_SEQUENCE=
      separate: false

  paired:
    type: string
    inputBinding:
      position: 2
      prefix: PAIRED_RUN=
      separate: false

  unmapped_bam:
    type: File
    inputBinding:
      position: 3
      prefix: UNMAPPED_BAM=
      separate: false

  aligned_bam:
    type: File
    inputBinding:
      position: 4
      prefix: ALIGNED_BAM=
      separate: false

arguments: [OUTPUT=$(inputs.sample_name).merged.sam]

outputs:

  merged_sam:
    type: File
    outputBinding:
      glob: $(inputs.sample_name).merged.sam
