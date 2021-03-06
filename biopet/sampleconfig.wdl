version 1.0

import "../common.wdl" as common

task SampleConfig {
    input {
        File? toolJar
        String? preCommand
        Array[File]+ inputFiles
        String keyFilePath
        String? sample
        String? library
        String? readgroup
        String? jsonOutputPath
        String? tsvOutputPath

        Int memory = 4
        Float memoryMultiplier = 2.0
    }

    String toolCommand = if defined(toolJar)
        then "java -Xmx" + memory + "G -jar " +toolJar
        else "biopet-sampleconfig -Xmx" + memory + "G"

    command {
        set -e -o pipefail
        ~{preCommand}
        mkdir -p . ~{"$(dirname " + jsonOutputPath + ")"} ~{"$(dirname " + tsvOutputPath + ")"}
        ~{toolCommand} \
        -i ~{sep="-i " inputFiles} \
        ~{"--sample " + sample} \
        ~{"--library " + library} \
        ~{"--readgroup " + readgroup} \
        ~{"--jsonOutput " + jsonOutputPath} \
        ~{"--tsvOutput " + tsvOutputPath} \
        > ~{keyFilePath}
    }

    output {
        File keysFile = keyFilePath
        File? jsonOutput = jsonOutputPath
        File? tsvOutput = tsvOutputPath
    }

    runtime {
        memory: ceil(memory * memoryMultiplier)
    }
}

task SampleConfigCromwellArrays {
    input {
        File? toolJar
        String? preCommand
        Array[File]+ inputFiles
        String outputPath

        Int memory = 4
        Float memoryMultiplier = 2.0
    }

    String toolCommand = if defined(toolJar)
        then "java -Xmx" + memory + "G -jar " + toolJar
        else "biopet-sampleconfig -Xmx" + memory + "G"

    command {
        set -e -o pipefail
        ~{preCommand}
        mkdir -p $(dirname ~{outputPath})
        ~{toolCommand} CromwellArrays \
        -i ~{sep="-i " inputFiles} \
        ~{"-o " + outputPath}
    }

    output {
        File outputFile = outputPath
    }

    runtime {
        memory: ceil(memory * memoryMultiplier)
    }
}

task CaseControl {
    input {
        File? toolJar
        String? preCommand
        Array[File]+ inputFiles
        Array[File]+ inputIndexFiles
        Array[File]+ sampleConfigs
        String outputPath
        String controlTag = "control"

        Int memory = 4
        Float memoryMultiplier = 2.0
    }

    String toolCommand = if defined(toolJar)
        then "java -Xmx" + memory + "G -jar " + toolJar
        else "biopet-sampleconfig -Xmx" + memory + "G"

    command {
        set -e -o pipefail
        ~{preCommand}
        mkdir -p $(dirname ~{outputPath})
        ~{toolCommand} CaseControl \
        -i ~{sep=" -i " inputFiles} \
        -s ~{sep=" -s " sampleConfigs} \
        ~{"-o " + outputPath} \
        ~{"--controlTag " + controlTag}
    }

    output {
        File outputFile = outputPath
        CaseControls caseControls = read_json(outputFile)
    }

    runtime {
        memory: ceil(memory * memoryMultiplier)
    }
}
