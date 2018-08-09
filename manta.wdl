version 1.0

task Somatic {
    input {
        File tumorBam
        File tumorIndex
        File? normalBam
        File? normalIndex
        File refFasta
        File refFastaIndex
        String runDir
        File? callRegions
        File? callRegionsIndex
        Boolean exome = false
        String? preCommand
        String? installDir

        Int cores = 1
        Int memory = 4
    }

    String toolCommand = if defined(installDir)
        then installDir + "bin/configMata.py"
        else "configManta.py"

    command {
        set -e -o pipefail
        ~{preCommand}
        ~{toolCommand} \
        ~{"--normalBam " + normalBam} \
        ~{"--tumorBam " + tumorBam} \
        --referenceFasta ~{refFasta} \
        ~{"--callRegions " + callRegions} \
        --runDir ~{runDir} \
        ~{true="--exome" false="" exome}

        ~{runDir}/runWorkflow.py \
        -m local \
        -j ~{cores} \
        -g ~{memory}
    }

    output {
        File condidateSmallIndels = runDir + "/results/variants/candidateSmallIndels.vcf.gz"
        File condidateSmallIndelsIndex = runDir +
            "/results/variants/candidateSmallIndels.vcf.gz.tbi"
        File candidateSV = runDir + "/results/variants/candidateSV.vcf.gz"
        File candidateSVindex = runDir + "/results/variants/candidateSV.vcf.gz.tbi"
        File tumorSV = if defined(normalBam)
            then runDir + "/results/variants/somaticSV.vcf.gz"
            else runDir + "/results/variants/tumorSV.vcf.gz"
        File tumorSVindex = if defined(normalBam)
            then runDir + "/results/variants/somaticSV.vcf.gz.tbi"
            else runDir + "/results/variants/tumorSV.vcf.gz.tbi"
        File? diploidSV = "/results/variants/diploidSV.vcf.gz"
        File? diploidSVindex = "/results/variants/diploidSV.vcf.gz.tbi"
    }

    runtime {
        cpu: cores
        memory: memory
    }
}