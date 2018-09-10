#!/usr/bin/env cwl-runner

cwlVersion: v1.0

class: CommandLineTool

baseCommand: [picard, -Xmx16g, -Djava.io.tmpdir=`pwd`/tmp, CollectBaseDistributionByCycle]

inputs:

  sample_name:
    type: string

  bam_input:
    type: File
    inputBinding:
      position: 1
      prefix: I=
      separate: false

  picard_ref:
    type: string
    inputBinding:
      position: 2
      prefix: R=
      separate: false

arguments: [O=$(inputs.sample_name).base.dist.metrics.txt,
            ASSUME_SORTED=false,
            CHART=$(inputs.sample_name).base.dist.metrics.pdf]

outputs:

  base_dist_metircs_files:
    type: File[]
    outputBinding:
      glob: "*base.dist*"
