`parallel -j 3 -a commands.txt`
`-j` max nr. of active jobs
`-a` list of commands to run, separated by newline

1. ~~make room in root&big data ~~
2. ~~find out WHY did this memory-shortage happened~~ - **logs**
3. ~~prevent this from happening again~~ - `docker run --log-driver none <image>`
czy problem z pamiecia na rootcie byl taki sam jak na big data?

4. ~~czy eventalign ma prawo byc tak duzy?~~ (+17G - fast5 have ~43G)  `du -h`
5. ~~create documentation of eventalign output~~
6. run tests for faster eventalign execution
   jezeli bd dzialalo -> niech dziala w tle,  a komendy beda zapuszczone ze skryptu^^

7. what tech for NAS? (nfs for now)


`docker run -it --rm -v "$PWD":/media/twardovsky/sda/Mateusz_Kurzyński --log-driver none ca64a695154d bash`

`cd nanopolish`

`./nanopolish eventalign --reads /media/twardovsky/sda/Mateusz_Kurzyński/covid1/covid1.fq --bam /media/twardovsky/sda/Mateusz_Kurzyński/covid1/covid1.bam --genome /media/twardovsky/sda/Mateusz_Kurzyński/ref.fa --scale-events --signal-index --summary /media/twardovsky/sda/Mateusz_Kurzyński/covid1/final_summary.txt -t 30 > /media/twardovsky/sda/Mateusz_Kurzyński/covid1/eventalign.txt`


### docker
it creates MEGA SPECIFIC `json.log` files - they eat up storage ridiculusly fast
`docker run --log-driver none <image>` - supress docker logs creation for given container
OR
`docker run --log-driver syslog <image>` - for `syslog` (you can also use `journald`) logging driver

APPEND `--rm` - otherwise it get's messy fast (in `docker ps -a`)

`docker container prune` - delete all stopped containers
`docker rm -f $(docker ps -aq)` - delete all containers, including running
`docker rmi image_id image_id` - delete images

`docker inspect my_container` - info about container configuration
`docker history --no-trunc my_image` - history of **image**, including commands used to create it

`-u $(whoami)` - append this flag for easy management of permissions
	won't work e.g. in case of opening privileged port


### eventalign output
MinION detect events per 5-mers passing through.
That means 1024 combinations for ~40-70pA range
- normal distribution of 5-mers overlap BUT solution must respect overlaps between subsequent 5-mers
`eventalign` - takes in a set of nanopore reads aligned according to base sequence of reference sequence (what read is where in reference) and re-aligns the reads in event space (what read was infered from that signal)
```
contig                         position  reference_kmer  read_index  strand  event_index  event_level_mean  event_length  model_kmer  model_mean  model_stdv
gi|556503834|ref|NC_000913.3|  10000     ATTGC           1           c       27470        50.57             0.022         ATTGC       50.58       1.02
gi|556503834|ref|NC_000913.3|  10001     TTGCG           1           c       27471        52.31             0.023         TTGCG       51.68       0.73
gi|556503834|ref|NC_000913.3|  10001     TTGCG           1           c       27472        53.05             0.056         TTGCG       51.68       0.73
gi|556503834|ref|NC_000913.3|  10001     TTGCG           1           c       27473        54.56             0.011         TTGCG       51.68       0.73
gi|556503834|ref|NC_000913.3|  10002     TGCGC           1           c       27474        65.56             0.012         TGCGC       66.96       2.91
gi|556503834|ref|NC_000913.3|  10002     TGCGC           1           c       27475        69.97             0.071         TGCGC       66.96       2.91
gi|556503834|ref|NC_000913.3|  10004     GCGCT           1           c       27476        67.11             0.017         GCGCT       68.08       2.20
```
- output has one row for every event. If a reference 5-mer was skipped, there will be a gap in the output where no signal was observed
event 27470
	- had a measured current level of 50.57 pA
	- aligns to the reference 5-mer ATTGC at position 10,000 of the reference
	- pore model indicates that events measured for 5-mer ATTGC should come from N(50.58,1.022) -> matches the observed data very well
events 27471, 27472, 27473
	- all aligned to the same reference 5-mer (TTGCG) -> event detector erroneously called 3 events where only one should have been emitted
	- expected distribution N(51.68,0.732) -> not really accurate match





- Zainstaluj GPU [nvidia drivers](https://www.nvidia.com/Download/index.aspx), [nvidia runtime](https://nvidia.github.io/nvidia-container-runtime/)   (GeForce GTX 750 Ti)
- OGARNIJ TMUXa !!


1. `--threads 40` - nie dziala (?) w nanopolish poniewaz:
	- za malo miejsca w docker root dir (`docker info`) -> slaba optymalizacja?
	- default cpu limit?
		  `vmstat` - info about mem,cpu,io,swap
		- wysoki `id` idle time -> czyli **NIE zuzywa cpu**
	- blad dzialania threadingu programu -> uzyj parallel
- `docker stats` - cpu/mem of docker containers
`docker ps`, `docker inspect`
2. 

Docker manual:
```
By default, a container has no resource constraints and can use as much of a given resource as the host’s kernel scheduler allows
```

ChatGPT:
```
The default CPU limit for a container is one CPU, and the default memory limit is 2GB. These limits can be changed when creating a container by specifying the e.g. `--cpus-"1.5"` and `--memory="5g"` (max hard memory limits) options with the `docker run` command.
	`-m` / `--memory=""` b,k,m,g for bytes, kilo, mega, gigabytes
```



```
twardovsky@twardovsky:/media/twardovsky/sda/Mateusz_Kurzyński$ vmstat
procs -----------memory---------- ---swap-- -----io---- -system-- ------cpu-----
 r  b   swpd   free   buff  cache   si   so    bi    bo   in   cs us sy id wa st
 4  0  45824 39683144 6230036 400434528    0    0     4    31    0    0  5  4 91  0  0
twardovsky@twardovsky:/media/twardovsky/sda/Mateusz_Kurzyński$ docker stats --no-stream
CONTAINER ID   NAME              CPU %     MEM USAGE / LIMIT     MEM %     NET I/O       BLOCK I/O     PIDS
0237217916ea   epic_hugle        23.12%    1.734GiB / 440.8GiB   0.39%     986kB / 0B    3.61GB / 0B   2
89fe6a1f4c42   eloquent_carver   21.47%    2.041GiB / 440.8GiB   0.46%     987kB / 0B    3.28GB / 0B   2
b07ad26795d9   sleepy_boyd       0.00%     2.949MiB / 440.8GiB   0.00%     1.78MB / 0B   0B / 0B       1
```