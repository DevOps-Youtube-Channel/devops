# /etc/keepalived/keepalived.conf

```
vrrp_instance VI_1 {
    state MASTER
    interface ens4
    virtual_router_id 51
    priority 101
    advert_int 1
    authentication {
        auth_type PASS
        auth_pass parolingiz
    }
    virtual_ipaddress {
        10.162.0.10/32  # vip айпи адрес
    }
    track_interface {
        ens4
    }
}
```
