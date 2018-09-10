#!/usr/bin/env cwl-runner

cwlVersion: v1.0

class: CommandLineTool

baseCommand: [picard, -Xmx16g, -Djava.io.tmpdir=`pwd`/tmp, MeanQualityByCycle]

inputs:

  sample_name:
    type: string

  bam_input:
    type: File
    inputBinding:
      position: 1
      prefix: I=
      separate: false

arguments: [O=$(inputs.sample_name).quality.by.cycle.metrics.txt,
            CHART=$(inputs.sample_name).quality.by.cycle.metrics.pdf]

outputs:

  quality_by_cycle_metircs_files:
    type: File[]
    outputBinding:
      glob: "*quality.by.cycle*"
