#!/bin/bash


echo -e "Install supervisor for Laravel queue worker"

echo -e "\e[92m"

while true; do
    read -p "What is the path to the laravel project's artisan file? (e.g. /home/vagrant/projectx): " path

    if [ ! -d $path ]; then
        echo "\e[39mPath not found!"
    else

        if [ ! -f /etc/supervisor/conf.d/laravel_queue.conf  ]; then

            echo "[program:laravel_queue]
command=/usr/local/bin/run_queue.sh
autostart=true
autorestart=true
stderr_logfile=/var/log/laraqueue.err.log
stdout_logfile=/var/log/laraqueue.out.log" > /etc/supervisor/conf.d/laravel_queue.conf

        fi
        
        if [ ! -f /usr/local/bin/run_queue.sh ]; then

            echo "#!/bin/bash
php $path/artisan --timeout=240 queue:listen" > /usr/local/bin/run_queue.sh

            chmod +x /usr/local/bin/run_queue.sh

            echo -e "\e[39mQueue worker will start automatically from now on"
            break

        else

            if grep -q "$path" /usr/local/bin/run_queue.sh
                then
                    echo -e "\e[91mSupervisor queue already configured for the given path\e[39m"
            else
                echo "php $path --timeout=240 queue:listen" >> /usr/local/bin/run_queue.sh
            fi

        fi

    fi
    
  break
    
done
