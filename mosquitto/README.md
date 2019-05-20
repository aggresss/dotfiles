# mosquitto operation

## create passwd file

```shell
mosquitto_passwd -b pwfile admin admin
mosquitto_passwd -c pwfile admin
mosquitto_passwd pwfile admin
```

## insecure sub

```shell
mosquitto_sub -d \
    -k 30 \
    -h localhost -p 8080 \
    -t gateway/test0 \
    -u admin -P admin
```

## insecure pub

```shell
mosquitto_pub -d \
    -h localhost -p 8080 \
    -t gateway/test0 \
    -u admin -P admin \
    -m {"message":"THIS_IS_A_TEST_MESSAGE"}
```

## secure pub one-way no check CA common name

```shell
mosquitto_pub -d \
    -h link.router7.com -p 8883 \
    -t gateway/test0 \
    -u admin -P admin \
    --cafile ca.crt \
    --insecure \
    -m {"message":"THIS_IS_A_TEST_MESSAGE"}
```

## secure pub two-way

```shell
mosquitto_pub -d \
    -h link.router7.com -p 8883 \
    -t gateway/test0 \
    -u admin -P admin \
    --cafile ca.crt \
    --cert client.crt --key client.key \
    -m {"message":"THIS_IS_A_TEST_MESSAGE"}
```


