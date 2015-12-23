#!/bin/bash

if [[ ! "$DESKTOP" =~ ^(true|yes|on|1|TRUE|YES|ON])$ ]]; then
  exit
fi

SSH_USER=${SSH_USERNAME:-ubuntu}

configure_ubuntu1204_autologin()
{
    USERNAME=${SSH_USER}
    LIGHTDM_CONFIG=/etc/lightdm/lightdm.conf

    echo "==> configuring lightdm autologin"
    if [ -f $LIGHTDM_CONFIG ]; then
        echo "" >> $LIGHTDM_CONFIG
        echo "autologin-user=${USERNAME}" >> $LIGHTDM_CONFIG
        echo "autologin-user-timeout=0" >> $LIGHTDM_CONFIG
    fi
}

echo "==> checking version of ubuntu"
. /etc/lsb-release

if [[ $DISTRIB_RELEASE == 12.04 ]]; then
    configure_ubuntu1204_autologin
elif [[ $DISTRIB_RELEASE == 14.04 || $DISTRIB_RELEASE == 15.04 ]]; then
    echo "==> installing ubunutu-desktop"
    apt-get install -y ubuntu-desktop

    USERNAME=${SSH_USER}
    LIGHTDM_CONFIG=/etc/lightdm/lightdm.conf
    GDM_CUSTOM_CONFIG=/etc/gdm/custom.conf

    mkdir -p $(dirname ${GDM_CUSTOM_CONFIG})
    echo "[daemon]" >> $GDM_CUSTOM_CONFIG
    echo "# enabling automatic login" >> $GDM_CUSTOM_CONFIG
    echo "AutomaticLoginEnable=True" >> $GDM_CUSTOM_CONFIG
    echo "AutomaticLoginEnable=${USERNAME}" >> $GDM_CUSTOM_CONFIG

    echo "==> configuring lightdm autologin"
    echo "[SeatDefaults]" >> $LIGHTDM_CONFIG
    echo "autologin-user=${USERNAME}" >> $LIGHTDM_CONFIG
fi
