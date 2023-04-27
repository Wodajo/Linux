you pass static IP as "alias"

ZFS
	- wykorzystuje RAM (**L1 ARC**) jako pamiec podreczna do **zapisu i odczytu** -> znacznie wieksza predkosc niz w hdd ofc
	- mozna tez dodac **L2 ARC** (w freenas - cache vdev) - czyli ssd sluzacy jako przyspieszenie **odczytu** (kopia najczesciej uzywanych danych)
	- **ZIL** (log vdev) - SSD posrednik miedzy RAM a pula zfs (hdd) - aby apklikacja mogla szbciej dostac informacje zwrotną "dane zapisane" BEZ ryzyka, ze przy awarii pradu dane przejsciowo w RAM znikną
**vdevy ZIL lub L2ARC mozna dodac do istniejacj puli ^^**

### vdev&pula zfs
vdev - RAID partition
pula zfs - zbior vdev. Jak chcesz rozszerzyc pule - najlepiej jest dodac vdev.
	vdev moga roznic sie RAID level
	ALE
	najgorszy vdev puli jest waskim gardlem wydajnosci - najlepiej jest tworzenie spojnych vdev
	NIE powinno byc wiecej niz 10 dyskow/vdev
	pula zarzadza dystrybucja danych miedzy vdevami.

### SMB

start and enable smb
create dataset
	- sync -> disable (bo inaczej synchroniczny zapis danych i bd opoznienie zapisu do predkosci hdd)
	- mozna zrobic quoty
	- mozna ustalic blocksize

credentials -> add group
	samba auth
add user
	unset create primary group -> set added group as primary group (od razu bd do niej nalezal)

shares -> add -> ... ACL ...


