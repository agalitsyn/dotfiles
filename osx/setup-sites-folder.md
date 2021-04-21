# Setup sites folder

```bash
mkdir ~/Sites
```

OSX comes up with apache2 and mod_php, which can be useful.

Control commands:
```bash
$ sudo apachectl -k {start|stop|restart}
```

Edit config

```bash
$ sudo vim /etc/apache2/httpd.conf

- Options FollowSymLinks Multiviews
+ Options FollowSymLinks Multiviews Indexes

-#LoadModule userdir_module libexec/apache2/mod_userdir.so
+LoadModule userdir_module libexec/apache2/mod_userdir.so

-#LoadModule php7_module libexec/apache2/libphp7.so
+LoadModule php7_module libexec/apache2/libphp7.so

-#Include /private/etc/apache2/extra/httpd-userdir.conf
+Include /private/etc/apache2/extra/httpd-userdir.conf
```

Uncomment
```bash
$ sudo vim /etc/apache2/extra/httpd-userdir.conf

-#Include /private/etc/apache2/users/*.conf
+Include /private/etc/apache2/users/*.conf
```

```bash
$ sudo vim /etc/apache2/users/anton.conf

<Directory "/Users/anton/Sites/">
    Options FollowSymLinks Multiviews Indexes
    MultiviewsMatch Any
    AllowOverride All
    Require all granted
</Directory>
```

```bash
$ sudo apachectl -k restart
```
