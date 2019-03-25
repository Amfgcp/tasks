version 1.0

task getUpSet{
    input {
        File csv
        File script
        String sample
        String outDir
    }

    command <<<
        mkdir ~{outDir}
        Rscript --vanilla \
        ~{script} \
        ~{csv} \
        ~{sample} \
        ~{outDir}~{sample}.UpSet.pdf
    >>>

    output {
        File pdf = "~{outDir}~{sample}.UpSet.pdf"
    }
}