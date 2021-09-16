#!/bin/bash
# Bash Menu Script Example
function menutj(){
clear
echo "Installatie script door Ryan Coppens"
echo " "

PS3='Kies een optie: '
options=("Installeer Webserver" "Installeer Nextcloud" "Installeer PHP" "Install fail2ban" "Configuratie" "Aanpassen Firewall" "Verlaat Script")
select opt in "${options[@]}"
do
    case $opt in
        "Installeer Webserver")
        clear
            echo "Wilt u Apache2 of Nginx installeren? (Apache/Nginx)"
            read answer0 
            if [ "$answer0" == "Apache" ] ;then
                clear
                echo "U gaat Apache installeren!"
                sudo apt-get install apache2
                a2ensite nextcloud.conf
                a2enmod rewrite
                a2enmod headers
                a2enmod env
                a2enmod dir
                a2enmod mime
                a2enmod setenvif
                service apache2 restart
                systemctl start apache2.service
                echo "Apache is geïnstalleerd... (druk op enter)"
                read pause
                clear
                menutj

            elif [ "$answer0" == "Nginx" ] ;then
                clear
                echo "U gaat Nginx installeren!"
                read pause
                sudo mysql_secure_installation
                sudo apt install nginx
                sudo apt install mariadb-server
                sudo mysql_secure_installation
                sudo systemctl start nginx
                sudo systemctl enable nginx
                echo "Nginx is geïnstalleerd... (druk op enter)"
                read pause
                clear
                menutj
            else
                clear
                echo "Er ging iets mis (Druk op enter om door te gaan)"
                read pause
                clear
                menutj
            fi
            
            ;;
        "Installeer Nextcloud")
            echo "Wilt u nextcloud installeren? (y/n)"
            read answer1
                if [ "$answer1" == "y" ] ;then
                        echo "Nextcloud installeren..."
                        sudo wget https://download.nextcloud.com/server/releases/nextcloud-21.0.2.zip
                        sudo unzip nextcloud-21.0.2.zip -d /var/www/
            
                elif [ "$answer1" == "n" ] ;then
                        echo "exit"
                        clear
                        menutj
                    
            
                else          
                        clear
                        echo "Er ging iets mis probeer het nog een keer."
                        read pause
                        clear
                        menutj
            
                fi
            ;;
            
        "Installeer PHP")
        clear
        echo "Installeer PHP voor (Apache/Nginx)"
        read answer4
        if [ "$answer4" == "Apache" ] ;then
        clear
        sudo apt install apache2 libapache2-mod-php7.4 openssl php-imagick php7.4-common php7.4-curl php7.4-gd php7.4-imap php7.4-intl php7.4-json php7.4-ldap php7.4-mbstring php7.4-mysql php7.4-pgsql php-ssh2 php7.4- sqlite3 php7.4-xml php7.4-zip
        clear
        echo "Installatie voltooid (Druk op ENTER om door te gaan)"
        read pause
        clear
        menutj
        
        elif [ "$answer4" == "Nginx" ] ;then
        sudo apt install imagemagick php-imagick php7.4-common php7.4-mysql php7.4-fpm php7.4-gd php7.4-json php7.4-curl  php7.4-zip php7.4-xml php7.4-mbstring php7.4-bz2 php7.4-intl php7.4-bcmath php7.4-gmpsudo apt install mariadb-server
        
        else
        echo "Er is iets mis gegaan, probeer het nog eens (Drup op enter om door te gaan)"
        reas pause
        menutj
        fi
        ;;
        "Install fail2ban")
            clear
            echo "Installeer fail2ban? (y/n)"
            read answer3
        if [ "$answer3" == "y" ] ;then
                sudo apt-get install fail2ban
                sudo systemctl enable fail2ban
                sudo systemctl start fail2ban
                clear
                echo "fail2ban is geïnstalleerd... (druk op enter)"
                read pause
                clear
                menutj

            else
                clear
                echo "Er ging iets mis (Druk op enter om door te gaan)"
                read pause
                clear
                menutj
            fi

           
            ;;
        "Configuratie")
        clear
        echo "Configureer PHP (Druk op ENTER om door te gaan)"
        read pause
        sudo nano /etc/php/7.4/cli/php.ini
        clear
        echo "Configureer apache (Druk op ENTER om door te gaan)"
        read pause
        sudo nano /etc/apache2/sites-available/nextcloud.conf
        sudo chmod 775 -R /var/www/nextcloud/
        sudo chown www-data:www-data /var/www/nextcloud/ -R
        clear
        echo "Configureer Nginx (Druk op ENTER om door te gaan)"
        read pause
        sudo nano /etc/nginx/conf.d/nextcloud.conf
        sudo chown www-data:www-data /usr/share/nginx/nextcloud/ -R
        clear
        echo "Voeg uitzondering toe:"
        sudo systemctl stop apache2.service
        sudo nano /var/www/nextcloud/config/config.php
        sudo systemctl restart apache2.service
        echo "Configuratie voltooid... (Druk op ENTER om door te gaan)"
        read pause
        clear
        menutj
        
        ;;
        "Verlaat Script")
        clear
            break
            ;;
        "Aanpassen Firewall")
        clear
        sudo iptables -I INPUT -p tcp --dport 80 -j ACCEPT
        sudo iptables -I INPUT -p tcp --dport 443 -j ACCEPT
        clear
        echo "Firewall Aangepast... (Druk op ENTER om door te gaan)"
        read pause
        clear
        menutj
        ;;
        
        *) echo "invalid option $REPLY";;
    esac
done
}
clear
menutj