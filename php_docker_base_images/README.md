```
#!/bin/bash
docker build -t reg.xxxxxxxx.net/common/alpine_php_with_swoole:v1_p7.2.16_s4.3.1 -f Dockerfile.php_swoole .
docker build -t reg.xxxxxxxx.net/common/php_base -f Dockerfile.php_all .
docker build -t reg.xxxxxxxx.net/common/php_base_sup -f Dockerfile.php_all_sup .

docker build -t reg.xxxxxxxx.net/common/alpine_php_with_swoole_yaf:v1_p7.2.16_s2.2.0_y3.0.8 -f Dockerfile.php7.2_swoole2_yaf .
docker build -t reg.xxxxxxxx.net/common/php7.2_base_24k -f Dockerfile.php7.2_all_24k .
 
docker build -t reg.xxxxxxxx.net/common/alpine_php_with_swoole_yaf:v1_p7.0.33_s2.0.9_y3.0.4_hc -f Dockerfile.php7.0_swoole2_yaf_hc .
docker build -t reg.xxxxxxxx.net/common/php7.0_base_24k -f Dockerfile.php7.0_all_24k .
docker build -t reg.xxxxxxxx.net/common/php-fpm7.0_nginx_24k -f Dockerfile.php-fpm7.0_nginx_24k .
```
