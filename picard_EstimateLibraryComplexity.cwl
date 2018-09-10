#!/usr/bin/env cwl-runner

cwlVersion: v1.0

class: CommandLineTool

baseCommand: [picard, -Xmx16g, -Djava.io.tmpdir=`pwd`/tmp, EstimateLibraryComplexity]

inputs:

  sample_name:
    type: string

  bam_input:
    type: File
    inputBinding:
      position: 1
      prefix: I=
      separate: false

arguments: [O=$(inputs.sample_name).library.complexity.txt]

outputs:

  library_complexity_file:
    type: File
    outputBinding:
      glob: $(inputs.sample_name).library.complexity.txt
