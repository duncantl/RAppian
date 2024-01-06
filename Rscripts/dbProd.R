if(exists("k.prod")) {
    url.prod = "https://ucdavis.appiancloud.com/database/index.php?route=/export"
    db.prod = dbDump(cookie = k.prod, url = url.prod)
}
