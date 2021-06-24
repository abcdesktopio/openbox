# openbox notify patch

## To get more informations

Please, read the public documentation web site:
* [https://www.abcdesktop.io](https://www.abcdesktop.io)
* [https://abcdesktopio.github.io/](https://abcdesktopio.github.io/)

## about openbox notify patch

Notify patch for openbox window manager and send to another process when a window change event occurs.
This patch is only required to send message (Create/Close) to the abcdesktop backend stack (spawner.js).

abcdesktop use [openbox](http://openbox.org/) as X11 window manager.

This patch add notification when X11/window change :

The notify patch send signals SIGUSR1 and SIGUSR2 to a process (pid)

```
#define SIG_MANAGED_WINDOW   SIGUSR1
#define SIG_UNMANAGED_WINDOW SIGUSR2
```

* SIGUSR1: when a new window is created
* SIGUSR2: when a window is closed 

The patch apply to the ```openbox/client.c``` file 
When a new window is open

```
void client_startup(gboolean reconfig)
...
  // call
  send_signal_notify( SIG_MANAGED_WINDOW ); 
```

When a new window is close

```
ObClient *client_fake_manage(Window window)
...
  // call
   send_signal_notify( SIG_UNMANAGED_WINDOW );
```

The send_signal_notify is just a kill send to the current_pid 
n=kill( current_pid, sig );


The patch read the pid process in configuration file.
The ```rx.xml``` add new entry 

```<notify><filenamepid>PATH TO PID FILE</filenamepid></notify>```

In rc.xml
```
<notify>
        <filenamepid>/var/run/desktop/spawner.pid</filenamepid>
</notify>
```

The pid file can change, it will be reload if kill system call failed.
When spwaner process recieve SIGUSR1 or SIGUSR2, it will send a broadcast window list call, to each browser connected.


To build the notify patch :

The quick and dirty way, to apply patch and build the new debian package for openbox 
> Change the directory name ```cd openbox-3.6.1``` with the correct name

```
# set non interactive
# echo 'debconf debconf/frontend select Noninteractive' | debconf-set-selections
# enable source list
# sed -i '/deb-src/s/^# //' /etc/apt/sources.list 
# run update
# apt update
# install dep
apt-get install -y --no-install-recommends devscripts binutils wget
apt-get source openbox
apt-get build-dep -y openbox
wget https://raw.githubusercontent.com/abcdesktopio/openbox/main/openbox.title.patch
cd openbox-3.6.1
patch -p2 < ../openbox.title.patch 
# dch --local abcdesktop_sig_usr
dch -n abcdesktop_sig_usr
# dpkg-source --commit
EDITOR=/bin/true dpkg-source -q --commit . abcdesktop_sig_usr
debuild -us -uc
cd ..
ls -la # you should see deb file here
# copy your new deb to the oc.user directory 
# then rebuild your oc.user image 
```


