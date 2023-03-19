
nextflow - `DSL` for scalable and reproducible scientific workflows using software containers
`DSL2` (domain specific language) - field-specific language

### installation
it's best to use `bioconda` (for java >=11 && <= 18 sake)

enable bioconda repo:
`conda config --add channels defaults`
`conda config --add channels bioconda`
`conda config --add channels conda-forge`
`conda config --set channel_priority strict`
`conda create -n nextflow nextflow`
OR docker:
`docker pull quay.io/biocontainers/nextflow:<tag>`

`conda activate nextflow`