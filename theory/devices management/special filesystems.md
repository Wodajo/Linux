special filesystem - doesn't reside on a physical storage device & doesn't store actual files
	- provides a way to access&manipulate various system resources
	- aka pseudo fs

virtual filesystem (`VFS`) is a software layer that allows OS to **`access&manipulate various fs as if they where a single fs`** (it's a special fs)


`/proc/` - processes&kernel files - contains info about `systems processes` & allow user-space programs to access&control `kernel features`
	historically it was the only one virtual fs -> for backwards compatibility contain stuff that could logically be in `/sys/`
	- `VFS`

`/sys/` - kernel files - allow user-space programs to access&manipulate `kernel subsytems`&`hardware dev configs`
	e.g. system's power management settings, configuration of network interfaces
	neatly orginized BUT doesn't contain that much
	- `VFS`
```
block  bus  class  dev  devices  firmware  fs  hypervisor  kernel  module  power
```


`/dev/` - device files - allow user-space programs to interact with `kernel's device drivers`
	- NOT `VFS` (doesn't provide a way to access different file systems)