version 1.0

task getStats {
    input {
        File vcf
        File script
        String sample
    }

    command <<<
        python3 ~{script} ~{vcf} ~{sample} ~{sample}.UpSet.csv
    >>>

    output {
        File stats = "~{sample}.UpSet.csv"
    }
}