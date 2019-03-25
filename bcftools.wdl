version 1.0

task rehead {
    input {
        Pair[String, File] pair
    }
    String caller = pair.left
    File vcf = pair.right

    command <<<
        oldName=$(egrep CHROM ~{vcf} | awk '{print $NF}')
        echo ${oldName} ~{caller} > newSampleName.txt
        bcftools reheader -s newSampleName.txt ~{vcf} -o ~{caller}.reheaded.vcf
    >>>

    output {
        File reheaded = "~{caller}.reheaded.vcf"
    }
}