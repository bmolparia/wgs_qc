#!/usr/bin/env cwl-runner

cwlVersion: v1.0

class: CommandLineTool

baseCommand: [picard, -Xmx16g, -Djava.io.tmpdir=`pwd`/tmp, MarkDuplicates]

inputs:

  sample_name:
    type: string

  merged_sam:
    type: File
    inputBinding:
      position: 1
      prefix: INPUT=
      separate: false

arguments: [OUTPUT=$(inputs.sample_name).duplicates_marked.sam,
            METRICS_FILE=$(inputs.sample_name).metrics.txt,
            REMOVE_DUPLICATES=false,
            VALIDATION_STRINGENCY=SILENT,
            MAX_FILE_HANDLES=4000]

outputs:

  duplicates_marked_sam:
    type: File
    outputBinding:
      glob: $(inputs.sample_name).duplicates_marked.sam

  duplication_metrics:
    type: File
    outputBinding:
      glob: $(inputs.sample_name).metrics.txt
