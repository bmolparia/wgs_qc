#!/usr/bin/env cwl-runner

cwlVersion: v1.0

class: CommandLineTool

baseCommand: [picard, -Xmx16g, -Djava.io.tmpdir=`pwd`/tmp, ValidateSamFile]

inputs:

  sample_name:
    type: string

  sam_input:
    # Sam file with duplicates marked
    type: File
    inputBinding:
      position: 1
      prefix: INPUT=
      separate: false

arguments: [OUTPUT=$(inputs.sample_name).validation.summary.txt,
            MODE=SUMMARY]

outputs:

  validation_summary_file:
    type: File
    outputBinding:
      glob: $(inputs.sample_name).validation.summary.txt
