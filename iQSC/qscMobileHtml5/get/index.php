<?php
// 判断useragent
$ua = _SERVER['HTTP_USER_AGENT'];

if (stripos( $ua, 'Windows Phone' ) !== FALSE) {
    header('https://build.phonegap.com/apps/245666/download/winphone');
} elseif (stripos( $ua, 'Apple-iPhone' ) !== FALSE) {
    
} elseif (stripos( $ua, 'Apple-iPad' ) !== FALSE) {

} else {
    header('Location: mobile_QSC.apk');
}

exit();