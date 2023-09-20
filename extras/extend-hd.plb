#extend hd on vsphere

`cfdisk`
select disk you want to add new space too and hit resize
type `yes` and hit `enter`
select `write` type `yes` hit `enter` then `q`

run `pvresize /dev/<disk>`
run `lvextend -l +100%FREE /dev/ubuntu-vg/ubuntu-lv`
increase filesystem `resize2fs /dev/mapper/ubuntu--vg-ubuntu--lv`

oneliner
`pvresize /dev/sda3 && lvextend -l +100%FREE /dev/ubuntu-vg/ubuntu-lv && resize2fs /dev/mapper/ubuntu--vg-ubuntu--lv && df -h`


