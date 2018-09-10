#!/usr/bin/env cwl-runner

cwlVersion: v1.0

class: CommandLineTool

baseCommand: [picard, -Xmx16g, -Djava.io.tmpdir=`pwd`/tmp, CollectInsertSizeMetrics]

inputs:

  sample_name:
    type: string

  bam_input:
    type: File
    inputBinding:
      position: 1
      prefix: I=
      separate: false

arguments: [O=$(inputs.sample_name).insert_size.metrics.txt,
            H=$(inputs.sample_name).insert_size.histogram.pdf]

outputs:

  insert_size_files:
    type: File[]
    outputBinding:
      glob: "*insert_size*"
