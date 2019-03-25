version 1.0


task discover {
    input {
        File bam
        String caller
    }

    command <<<

    cat ~{bam} > ~{caller}.vcf

    >>>

    output {
        Pair[String, File] cleverPair = ("~{caller}", "~{caller}.vcf")
    }
}