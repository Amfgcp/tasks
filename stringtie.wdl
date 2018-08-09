version 1.0

task Stringtie {
    input {
        String? preCommand
        File alignedReads
        File? referenceGtf
        Int threads = 1
        String assembledTranscriptsFile
        Boolean? firstStranded
        Boolean? secondStranded
        String? geneAbundanceFile
    }

    command {
        set -e -o pipefail
        mkdir -p $(dirname ~{assembledTranscriptsFile})
        ~{preCommand}
        stringtie \
        ~{"-p " + threads} \
        ~{"-G " + referenceGtf} \
        ~{true="--rf" false="" firstStranded} \
        ~{true="fr" false="" secondStranded} \
        -o ~{assembledTranscriptsFile} \
        ~{"-A " + geneAbundanceFile} \
        ~{alignedReads}
    }

    output {
        File assembledTranscripts = assembledTranscriptsFile
        File? geneAbundance = geneAbundanceFile
    }

    runtime {
        cpu: threads
    }
}