`parallel -j 3 -a commands.txt`
`-j` max nr. of active jobs
`-a` list of commands to run, separated by newline



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