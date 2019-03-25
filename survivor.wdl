version 1.0

task merge {
    input {
        File sampleCallersList
        Int breakpointDistance
        Int suppVecs
        Int svType
        Int strandType
        Int distanceBySvSize
        Int minSize
        String sample
    }

    command <<<
        SURVIVOR merge \
        ~{sampleCallersList} \
        ~{breakpointDistance} \
        ~{suppVecs} \
        ~{svType} \
        ~{strandType} \
        ~{distanceBySvSize} \
        ~{minSize} \
        ~{sample}.merged.vcf
    >>>

    output {
        File merged = "~{sample}.merged.vcf"
    }
}