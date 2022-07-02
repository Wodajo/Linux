`ip a`
```
1: lo: <LOOPBACK,UP,LOWER_UP> mtu 65536 qdisc noqueue state UNKNOWN group default qlen 1000
    link/loopback 00:00:00:00:00:00 brd 00:00:00:00:00:00
    inet 127.0.0.1/8 scope host lo
       valid_lft forever preferred_lft forever
    inet6 ::1/128 scope host 
       valid_lft forever preferred_lft forever
2: enp3s0: <NO-CARRIER,BROADCAST,MULTICAST,UP> mtu 1500 qdisc fq_codel state DOWN group default qlen 1000
    link/ether 50:b7:c3:03:0b:a3 brd ff:ff:ff:ff:ff:ff
3: wlp2s0: <BROADCAST,MULTICAST,UP,LOWER_UP> mtu 1500 qdisc mq state UP group default qlen 1000
    link/ether c4:85:08:d3:4a:00 brd ff:ff:ff:ff:ff:ff
    inet 192.168.1.107/24 brd 192.168.1.255 scope global dynamic noprefixroute wlp2s0
       valid_lft 40272sec preferred_lft 40272sec
    inet6 fe80::2643:7864:1a20:ac6f/64 scope link noprefixroute 
       valid_lft forever preferred_lft forever
4: wlp0s26u1u2: <NO-CARRIER,BROADCAST,MULTICAST,UP> mtu 1500 qdisc noqueue state DOWN group default qlen 1000
    link/ether 1a:85:58:6a:e5:26 brd ff:ff:ff:ff:ff:ff permaddr 1c:bf:ce:94:92:2d
```
`wlp0s26u1u2` - rtl NIC

`nmcli` - just to see what it gives
```
wlp2s0: connected to HH71VM_7C47_5G
        "Intel Centrino Advanced-N 6235"
        wifi (iwlwifi), C4:85:08:D3:4A:00, hw, mtu 1500
        ip4 default
        inet4 192.168.1.107/24
        route4 192.168.1.0/24 metric 600
        route4 default via 192.168.1.1 metric 600
        inet6 fe80::2643:7864:1a20:ac6f/64
        route6 fe80::/64 metric 1024

wlp0s26u1u2: disconnected
        "Realtek RTL88x2bu"
        wifi (rtw_8822bu), A2:5C:36:CC:5F:B0, hw, mtu 1500

enp3s0: unavailable
        "Realtek RTL8111/8168/8411"
        ethernet (r8169), 50:B7:C3:03:0B:A3, hw, mtu 1500

lo: unmanaged
        "lo"
        loopback (unknown), 00:00:00:00:00:00, sw, mtu 65536

DNS configuration:
        servers: 192.168.1.1
        interface: wlp2s0

Use "nmcli device show" to get complete information about known devices and
"nmcli connection show" to get an overview on active connection profiles.
```
it gives some NIC info

`iw dev wlp0s26u1u2 info`
```
Interface wlp0s26u1u2
	ifindex 4
	wdev 0x100000001
	addr 82:f0:ae:a1:cb:f8
	type managed
	wiphy 1
	txpower 20.00 dBm
	multicast TXQ:
		qsz-byt	qsz-pkt	flows	drops	marks	overlmt	hashcol	tx-bytes	tx-packets
		0	0	0	0	0	0	0	00

```
`wlp0s26u1u2` is in managed mode

`sudo pacman -S wifite` - contains `aircrack-ng` which contains `airmon-ng`
`sudo airmon-ng check kill`
To kill any confliting processes

`sudo ip link wlp0s26u1u2 down`
`sudo iw dev wlp0s26u1u2 set type monitor`
`sudo ip link wlp0s26u1u2 up`
? `sudo iw wlp0s26u1u2 set txpower fixed 3000` - tx transmission power
`iw wlp0s26u1u2 info`
```
Interface wlp0s26u1u2
	ifindex 4
	wdev 0x1
	addr ce:91:2e:eb:53:a2
	type monitor
	wiphy 0
	channel 1 (2412 MHz), width: 20 MHz (no HT), center1: 2412 MHz
	txpower 20.00 dBm
	multicast TXQ:
		qsz-byt	qsz-pkt	flows	drops	marks	overlmt	hashcol	tx-bytes	tx-packets
		0	0	0	0	0	0	0	0		0
```
in monitor mode