
#!/usr/bin/env cwl-runner

cwlVersion: v1.0

class: CommandLineTool

baseCommand: [picard, -Xmx16g, -Djava.io.tmpdir=`pwd`/tmp, CollectWgsMetricsWithNonZeroCoverage]

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

arguments: [O=$(inputs.sample_name).wgs.non_zero.metrics.txt,
            CHART=$(inputs.sample_name).wgs.non_zero.metrics.pdf]

outputs:

  coverage_metric_files:
    type: File[]
    outputBinding:
      glob: "*wgs.non_zero*"
