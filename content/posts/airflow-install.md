---
title: "Install Airflow 2 on a Raspberry Pi (using Python 3.x)"
date: 2021-07-21T11:30:03+00:00
cover:
  image: "/posts/airflow2.png"
  # can also paste direct link from external site
  # ex. https://i.ibb.co/K0HVPBd/paper-mod-profilemode.png
  alt: "Airflow 2"
  caption: "Airflow 2"
  relative: read # To use relative path for cover image, used in hugo Page-bundles
---

Airflow is a tool commonly used for Data Engineering. It's great to orchestrate workflows. Version 2 of Airflow only supports Python 3+ versions, so we need to make sure that we use Python 3 to install it. We could probably install this on another Linux distribution, too.

This is the first post of a series, where we'll build an **entire Data Engineering pipeline**. To follow this series, just **subscribe to the [newsletter](https://pedromadruga.com/newsletter)**.

## Install dependencies

Let's make sure our OS is up-to-date.

```bash
sudo apt-get update -y
sudo apt-get upgrade -y
```

Now, we'll install Python 3.x and Pip on the Raspberry Pi.

```bash
sudo apt-get install python3 python3-pip
```

Airflow relies on **numpy**, which has its own dependencies. We'll address that by installing the necessary dependencies:

```bash
sudo apt-get install python-dev libatlas-base-dev
```

We also need to ensure Airflow installs using Python3 and Pip3, so we'll set an alias for both. To do this, edit the `~/.bashrc` by adding:

```bash
alias python=$(which python3)
alias pip=pip3
```

Alternatively, you can install using `pip3` directly. For this tutorial, we'll assume aliases are in use.

## Install Airflow

### Create folders

We need a placeholder to install Airflow.

```bash
cd ~/
mkdir airflow
```

### Install Airflow package

Finally, we can install Airflow safely. We start by defining the airflow and python versions to have the correct constraint URL. The constraint URL ensures that we're installing the correct airflow version for the correct python version.

```bash
# set airflow version
AIRFLOW_VERSION=2.1.2

# determine the correct python version
PYTHON_VERSION="$(python --version | cut -d " " -f 2 | cut -d "." -f 1-2)"

# build the constraint URL
CONSTRAINT_URL="https://raw.githubusercontent.com/apache/airflow/constraints-${AIRFLOW_VERSION}/constraints-${PYTHON_VERSION}.txt"

# install airflow
pip install "apache-airflow==${AIRFLOW_VERSION}" --constraint "${CONSTRAINT_URL}"
```

### Initialize database

Before running Airflow, we need to initialize the database. There are several different options for this setup: 1) running Airflow against a separate database and 2) running a simple SQLite database. The SQLite database is in use in this tutorial, so there's not much to do other than initializing the database.

So let's initialize it:

```bash
airflow db init
```

## Run Airflow

It's now possible to run both the server and the scheduler:

```
airflow webserver -p 8080 & airflow scheduler
```

Now open `http://localhost:8080` on a browser. If you need to log in, you'll need to create a new user. Here's an example:

```bash
airflow users create \
    --username admin \
    --firstname Peter \
    --lastname Parker \
    --role Admin \
    --email spiderman@superhero.org
```

Once authenticated, it's now possible to see the main screen:

![Airflow main](/posts/airflow1.png)

**And that's it - you've now installed Airflow!** Optionally, you can take extra steps.

## Optional

### Start airflow automatically

In order to start both the webserver and the scheduler automatically on system boot, we'll need three files: `airflow-webserver.service`, `airflow-scheduler.service`, and an `environment` file. Let's break this into parts:

1. Go to [Airflow's github repo](https://github.com/apache/airflow/tree/master/scripts/systemd) and download the `airflow-webserver.service` and the `airflow-scheduler.service`

2. Paste them on the `/etc/systemd/system` folder.

3. Edit both files. Firstly, `airflow-webserver.service` should look like:

```bash
[Unit]
Description=Airflow webserver daemon
After=network.target postgresql.service mysql.service redis.service rabbitmq-server.service
Wants=postgresql.service mysql.service redis.service rabbitmq-server.service

[Service]
EnvironmentFile=/home/pi/airflow/env
User=pi
Group=pi
Type=simple
ExecStart=/bin/bash -c 'airflow webserver --pid /home/pi/airflow/webserver.pid'
Restart=on-failure
RestartSec=5s
PrivateTmp=true

[Install]
WantedBy=multi-user.target
```

Now moving on to edit `airflow-scheduler.service` file, which should look like:

```bash
[Unit]
Description=Airflow scheduler daemon
After=network.target postgresql.service mysql.service redis.service rabbitmq-server.service
Wants=postgresql.service mysql.service redis.service rabbitmq-server.service

[Service]
EnvironmentFile=/home/pi/airflow/env
User=pi
Group=pi
Type=simple
ExecStart=/bin/bash -c 'airflow scheduler'
Restart=always
RestartSec=5s

[Install]
WantedBy=multi-user.target
```

Notice that the `user` and `Group` have changed, as well as the `ExecStart`. You'll also notice that there's an `EnvironmentFile` that hasn't been created yet. That's what we'll do now.

4. Create an environment file. You can call it any name. I chose to call it `env` and placed it on the `/home/pi/airflow` folder. In other words:

```
cd ~/airflow
touch env
```

Edit the `env` file and place the contents:

```
AIRFLOW_CONFIG=/home/pi/airflow/airflow.cfg
AIRFLOW_HOME=/home/pi/airflow/
```

5. Lastly, let's reload the system daemons:

```bash
sudo systemctl daemon-reload
sudo systemctl enable airflow-webserver.service
sudo systemctl enable airflow-scheduler.service
sudo systemctl start airflow-webserver.service
sudo systemctl start airflow-scheduler.service
```

## That's it! What's next?

In the next blog post of this Data Engineering series, we'll create our first Directed Acyclic Graph (DAG) using Airflow. Subscribe to the [newsletter](https://pedromadruga.com), and don't miss out!

## Sources

1. https://airflow.apache.org/docs/apache-airflow/stable/installation.html
2. https://medium.com/the-kickstarter/apache-airflow-running-on-a-raspberry-pi-2e061f6c3655
3. http://www.thecrustyengineer.com/home/post/setting_up_airflow_on_a_raspberry_pi_4_part_1
