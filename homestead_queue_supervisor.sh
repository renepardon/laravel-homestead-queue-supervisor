#!/bin/bash

bold=$(tput bold)
normal=$(tput sgr0)

echo -e "${bold}Install supervisor for Laravel queue worker${normal}"

while true; do
    read -p "${bold}What is the path to the laravel project's artisan file? (e.g. /home/vagrant/projectx): ${normal}" path

    if [ ! -d $path ]; then
        echo -e "${bold}Path not found!${normal}"
    else
        if [ ! -f /etc/supervisor/conf.d/laravel-queue-worker.conf  ]; then
            echo "[program:laravel-queue-worker]
process_name=%(program_name)s_%(process_num)02d
command=/usr/local/bin/run-laravel-queue.sh
user=vagrant
numprocs=1
autostart=true
autorestart=true
stderr_logfile=/var/log/laraqueue.err.log
stdout_logfile=/var/log/laraqueue.out.log" > /etc/supervisor/conf.d/laravel-queue-worker.conf
        fi

        if [ ! -f /usr/local/bin/run-laravel-queue.sh ]; then
            # Remember to use queue:work on production for better performance!
            echo "#!/bin/bash
php $path/artisan --timeout=300 queue:listen" > /usr/local/bin/run-laravel-queue.sh

            chmod +x /usr/local/bin/run-laravel-queue.sh

            echo -e "${bold}Queue worker will start automatically from now on!${normal}"
            break
        else
            if grep -q "$path" /usr/local/bin/run-laravel-queue.sh; then
                echo -e "${bold}Supervisor queue already configured for the given path${normal}"
            else
                echo "php $path/artisan --timeout=300 queue:listen" >> /usr/local/bin/run-laravel-queue.sh
            fi
        fi
    fi

  break

done
