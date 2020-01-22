# Laravel Homestead Queue Supervisor

This bash script sets up a queue listener with supervisor on homestead in a breeze. It will listen for your queue's automatically when you run vagrant up.

## Installation

SSH into homestead first:

```bash
homestead ssh
```

The second and last step is to run the script. It will ask the path to your project's root on homestead.

```bash
sudo su
source <(curl -s https://raw.githubusercontent.com/renepardon/laravel-homestead-queue-supervisor/master/homestead_queue_supervisor.sh)
```

### Artisan queue command

Supervisor will execute the following command:

```bash
php artisan --timeout=300 queue:listen
```

You can add options to the command or change the command in `/usr/local/bin/run_queue.sh`

## Future work

This bash script is very basic at the moment. Extending the script with options in order to specify things like timeouts, env, retry etc. is on the roadmap.

## License

Laravel Homestead Queue Supervisor is open-sourced software licensed under the MIT license
Original work done by @gmooren
