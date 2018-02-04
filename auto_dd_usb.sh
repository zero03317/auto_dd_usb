#!/bin/bash
echo "Check network now......"
ping -q -c 5 "Iuput your server ip" >/dev/null
if [ "$?" = 0 ]
then
  echo "Host found,start upgrade fw!"
else
  echo "Host not found,pls check your network!!!"
  exit 1
fi
/usr/sbin/mount.cifs "CIFS server"
RESULT=$?
if [ $RESULT -eq 0 ]; then
echo "mount success!!"
else
echo "mount fail"
exit 1
fi

echo "-----------copy fw to usb starting---------------"
ls -l /sys/block/* | grep "usb" | awk 'BEGIN {FS="/"}; {print $15}' > /root/usb.txt
usb=$(sed '1q;d' usb.txt)
usb2="/dev/$usb"
echo "---------start dd fw to usb----------------------usb path="$usb2
cd "file path"
flash=$(find . -name "*.flash.gz" | awk 'BEGIN {FS="./"}; {print $2}')
/bin/zcat "flash file path" | dd of=${usb2}
RESULT=$?
if [ $RESULT -eq 0 ]; then
  echo "make usb fw usccess!!!"
else
  echo "make usb fw fail!! pls try again!!!"
fi
