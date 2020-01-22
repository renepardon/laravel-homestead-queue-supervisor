#!/bin/bash

echo -e "Install supervisor for Laravel queue worker"

while true; do
    read -p "What is the path to the laravel project's artisan file? (e.g. /home/vagrant/projectx): " path

    if [ ! -d $path ]; then
        echo "\e[1mPath not found!\e[21m"
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
php $path/artisan --timeout=240 queue:listen" > /usr/local/bin/run-laravel-queue.sh

            chmod +x /usr/local/bin/run-laravel-queue.sh

            echo -e "\e[1mQueue worker will start automatically from now on\e[21m"
            break

        else

            if grep -q "$path" /usr/local/bin/run-laravel-queue.sh
                then
                    echo -e "\e[1mSupervisor queue already configured for the given path\e[21m"
            else
                echo "php $path --timeout=300 queue:listen" >> /usr/local/bin/run-laravel-queue.sh
            fi

        fi

    fi

  break

done
