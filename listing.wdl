version 1.0


task listing {
    input {
        Array[File] reheaded_vcfs
        File script
        String sample
    }

    command <<<
        bash ~{script} ~{sep=" " reheaded_vcfs} > "~{sample}.CallersPaths.txt"
    >>>

    output {
        File paths = "~{sample}.CallersPaths.txt"
    }
}
