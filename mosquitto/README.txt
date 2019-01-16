create passwd file
mosquitto_passwd -b pwfile admin admin
mosquitto_passwd -c pwfile admin
mosquitto_passwd pwfile admin


mosquitto_sub -d \
    -k 30 \
    -h localhost -p 8080 \
    -t gateway/test0 \
    -u admin -P admin

mosquitto_pub -d \
    -h localhost -p 8080 \
    -t gateway/test0 \
    -u admin -P admin \
    -m {"Version":"2.0"}
