# Bioinformatics-tools-docker

# Docker-образ с биоинформатическими инструментами

Этот репозиторий содержит Dockerfile для сборки Docker-образа с следующими биоинформатическими инструментами:
- `samtools`
- `htslib`
- `libdeflate`
- `bcftools`
- `vcftools`


## Требования

- [Docker](https://www.docker.com/get-started)

## Сборка Docker-образа

Для сборки Docker-образа клонируйте этот репозиторий и перейдите в его директорию:

```bash
git clone https://github.com/Porolo-V/Bioinformatics-tools-docker.git
cd Bioinformatics-tools-docker
```
## Сборка docker-build
```bash
docker build -t bioinformatics-tools .
```
## Запуск Docker-образа
```bash
docker run -it bioinformatic-tools /bin/bash
```
## --version/ --help - команды 
```bash
samtools --version/ --help
vcftools --version/ --help
bcftools --version/ --help
htsfile --version/ --help
libdeflate-gzip -V/ --help
libdeflate-gunzip -V/ --help
```
