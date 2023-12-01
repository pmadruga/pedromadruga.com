---
title: "A simple ETL pipeline in Airflow 2.0"
description: "Extracting data from Upwork.com, transforming it and loading it into a MySQL database."
tags: ["airflow", "data engineering", "etl pipeline"]
date: 2021-10-27
draft: true
cover:
  image: "/posts/2021/10/graphview.png"
#   # can also paste direct link from external site
#   # ex. https://i.ibb.co/K0HVPBd/paper-mod-profilemode.png
#   alt: "Airflow 2"
#   caption: "Airflow 2"
#   relative: read # To use relative path for cover image, used in hugo Page-bundles
---

##############
Tasks

- [ ]

##############

---

This blogpost was originally posted at **[pedromadruga.com](https://pedromadruga.com/posts/ETL-pipeline)**. For more posts, follow me on **[twitter](https://twitter.com/pmadruga_)** and/or subscribe to my **[newsletter](https://pedromadruga.com/newsletter)**.

This is part of a [series](https://pedromadruga.com/posts/ETL-pipeline/). The code is **here**.

---

## Context

### What we're trying to solve

If you're a freelancer, or looking for freelancers, you've probably heard of [Upwork](https://upwork.com) before. In the past I've used to find Data Science and Data Engineering jobs. When searching for work, Upwork allows access to two feeds, acessible via a RSS url: the "most recent" feed and the "best match" feed.

![upwork](https://posts/2021/10/upwork.png)

It would be great to have a place where the data from these two feeds could be easily accessible - both for current data but also for historical. Personally, I find it easier to filter certain jobs using SQL. In this project, we're extracting the data from both of these feeds, parsing and transforming the data into and loading into SQL. Here's the Graph View:

![graphview](https://posts/2021/10/graphview.png)

We have two streams: the "most recent" and the "best match", which are fetched and transformed concurrently and then loaded into a MySQL db.

### What you'll learn

By the end of this post you'll be able to know:

- How to fetch data
- How to transform data
- How to connect to a SQL database
- How to use Airflow's variables to hide sensitive data

All of the above is achieved using the newest TaskFlow API from Airflow 2.0, just like the other blogposts in these series. Although the data transformation is happening directly in Airflow, it's usually best practice to do it somewhere (i.e., Apache Spark), since Airflow is an orchestration tool. Nonetheless, for the sake of simplicity, and because the volume of data being handled each time is not so intensive, all the transform we'll happen in place.

## Before getting started

### What you'll need

- Database running and accessible
- Create a table (schema is below)
- Airflow (already setup in the previous posts)

### Project structure

The goal of the project structure is to mimic the task groups of this Airflow dag: Extract, Load and Transform. Thus, three python files where created, named `transform.py`, `load.py` and `__init__.py` (which includes the extract part of the pipeline). This allows for better code separation.

## Extracting

Before extracting data, we'll be adding the RSS URLs from Upwork as Airflow variables. We'll be grabbing the URLs as seen in the image below:

![How to grab the RSS url](/posts/2021/10/upwork2.png)

and afterwards, adding them as variables in Airflow, as follows:

![airflow variables](/posts/2021/10/airflow-variables.png)

The reason is because the URLs contain authentication data that is private. This task is now quite simple: using the `feedparser` python library, we're fetching and parsing data provided by the URL. Simply put, we're doing:

```python
@task_group(group_id='Extract')
    def group_1():

        @task(task_id='fetch_recommended')
        def get_recommended():
            recommended_feed_url = Variable.get('upwork_feed_recommended')
            recommended = feedparser.parse(recommended_feed_url)
            return recommended

        @task(task_id='fetch_best_match')
        def get_best_match():
            best_match_feed_url = Variable.get('upwork_feed_best_match')
            best_match = feedparser.parse(best_match_feed_url)

            return best_match

        recommended_jobs = get_recommended()
        best_match_jobs = get_best_match()

        return [recommended_jobs, best_match_jobs]
```

Each of the URLs has its own task, and both of these tasks are wrapped by a task group, called `Extract`. Notice that I've named `fetch_recommended` the task to fetch the most recent job tasks. The tasks occur concurrently, since they don't depende on each other.

An example of the raw data is given below, so we can inspect what data can we extract out of the box and what needs to be parsed and transformed:

```json
{
    "title": "Unsupervised Deep Learning for Anomaly Detection - Upwork",
    "title_detail": {
        "type": "text/plain",
        "language": null,
        "base": "https://www.upwork.com/ab/feed/topics/rss?securityToken=26e45fcbe7a32a075990013cd72c6acaf979a1e2a5e41e343c6fb47bceae84a1ac096f6357fba8370094a50b507f9bb9462f82f0b57b6aeddf833cb7c41544bf&userUid=790521884263325696&orgUid=790521884267520001&topic=high-chance",
        "value": "Unsupervised Deep Learning for Anomaly Detection - Upwork"
    },
    "links": [
        {
            "rel": "alternate",
            "type": "text/html",
            "href": "https://www.upwork.com/jobs/Unsupervised-Deep-Learning-for-Anomaly-Detection_%7E01ca9b14306d23deeb?source=rss"
        }
    ],
    "link": "https://www.upwork.com/jobs/Unsupervised-Deep-Learning-for-Anomaly-Detection_%7E01ca9b14306d23deeb?source=rss",
    "summary": "This is a short task that could only take a few hours or a day to complete. The main goal of this project is to build a deep learning model for anomaly detection using unsupervised transaction data. <br /><br />\nThe data has already been cleaned and is quite ready for modeling. You will be creating a deep learning model using the given data and also performing evaluation of the model. <br /><br />\nThis has a tight deadline so someone who is available now will be ideal. The script must be written in Python using a package like TensorFlow.<br /><br />\nPlease feel free to reach out to me, if you are familiar with this type of project. <br /><br /><b>Budget</b>: $60\n<br /><b>Posted On</b>: October 27, 2021 06:35 UTC<br /><b>Category</b>: Deep Learning<br /><b>Skills</b>:TensorFlow,     Deep Learning,     Keras,     Neural Networks,     Python,     Deep Neural Networks    \n<br /><b>Country</b>: Hong Kong\n<br /><a href='https://www.upwork.com/jobs/Unsupervised-Deep-Learning-for-Anomaly-Detection_%7E01ca9b14306d23deeb?source=rss'>click to apply</a>",
    "summary_detail": {
        "type": "text/html",
        "language": null,
        "base": "https://www.upwork.com/ab/feed/topics/rss?securityToken=26e45fcbe7a32a075990013cd72c6acaf979a1e2a5e41e343c6fb47bceae84a1ac096f6357fba8370094a50b507f9bb9462f82f0b57b6aeddf833cb7c41544bf&userUid=790521884263325696&orgUid=790521884267520001&topic=high-chance",
        "value": "This is a short task that could only take a few hours or a day to complete. The main goal of this project is to build a deep learning model for anomaly detection using unsupervised transaction data. <br /><br />\nThe data has already been cleaned and is quite ready for modeling. You will be creating a deep learning model using the given data and also performing evaluation of the model. <br /><br />\nThis has a tight deadline so someone who is available now will be ideal. The script must be written in Python using a package like TensorFlow.<br /><br />\nPlease feel free to reach out to me, if you are familiar with this type of project. <br /><br /><b>Budget</b>: $60\n<br /><b>Posted On</b>: October 27, 2021 06:35 UTC<br /><b>Category</b>: Deep Learning<br /><b>Skills</b>:TensorFlow,     Deep Learning,     Keras,     Neural Networks,     Python,     Deep Neural Networks    \n<br /><b>Country</b>: Hong Kong\n<br /><a href='https://www.upwork.com/jobs/Unsupervised-Deep-Learning-for-Anomaly-Detection_%7E01ca9b14306d23deeb?source=rss'>click to apply</a>"
    },
    "content": [
        {
            "type": "text/html",
            "language": null,
            "base": "https://www.upwork.com/ab/feed/topics/rss?securityToken=26e45fcbe7a32a075990013cd72c6acaf979a1e2a5e41e343c6fb47bceae84a1ac096f6357fba8370094a50b507f9bb9462f82f0b57b6aeddf833cb7c41544bf&userUid=790521884263325696&orgUid=790521884267520001&topic=high-chance",
            "value": "This is a short task that could only take a few hours or a day to complete. The main goal of this project is to build a deep learning model for anomaly detection using unsupervised transaction data. <br /><br />\nThe data has already been cleaned and is quite ready for modeling. You will be creating a deep learning model using the given data and also performing evaluation of the model. <br /><br />\nThis has a tight deadline so someone who is available now will be ideal. The script must be written in Python using a package like TensorFlow.<br /><br />\nPlease feel free to reach out to me, if you are familiar with this type of project. <br /><br /><b>Budget</b>: $60\n<br /><b>Posted On</b>: October 27, 2021 06:35 UTC<br /><b>Category</b>: Deep Learning<br /><b>Skills</b>:TensorFlow,     Deep Learning,     Keras,     Neural Networks,     Python,     Deep Neural Networks    \n<br /><b>Country</b>: Hong Kong\n<br /><a href='https://www.upwork.com/jobs/Unsupervised-Deep-Learning-for-Anomaly-Detection_%7E01ca9b14306d23deeb?source=rss'>click to apply</a>"
        }
    ],
    "published": "Wed, 27 Oct 2021 06:35:39 +0000",
    "id": "https://www.upwork.com/jobs/Unsupervised-Deep-Learning-for-Anomaly-Detection_%7E01ca9b14306d23deeb?source=rss",
    "guidislink": null,
    "published_parsed": time.struct_time(tm_year=2021, tm_mon=10, tm_mday=27, tm_hour=6, tm_min=35, tm_sec=39, tm_wday=2, tm_yday=300, tm_isdst=0),
}
```

The most data-rich item in the response is the `value` inside `content` (and repeated in other fields). In the example above, it has the following content, in an html markup format:

```html
This is a short task that could only take a few hours or a day to complete. The
main goal of this project is to build a deep learning model for anomaly
detection using unsupervised transaction data. <br /><br />\nThe data has
already been cleaned and is quite ready for modeling. You will be creating a
deep learning model using the given data and also performing evaluation of the
model. <br /><br />\nThis has a tight deadline so someone who is available now
will be ideal. The script must be written in Python using a package like
TensorFlow.<br /><br />\nPlease feel free to reach out to me, if you are
familiar with this type of project. <br /><br /><b>Budget</b>: $60\n<br /><b
  >Posted On</b
>: October 27, 2021 06:35 UTC<br /><b>Category</b>: Deep Learning<br /><b
  >Skills</b
>:TensorFlow, Deep Learning, Keras, Neural Networks, Python, Deep Neural
Networks \n<br /><b>Country</b>: Hong Kong\n<br /><a
  href="https://www.upwork.com/jobs/Unsupervised-Deep-Learning-for-Anomaly-Detection_%7E01ca9b14306d23deeb?source=rss"
  >click to apply</a
>
```

Most of the relevant metadata lives inside html markup, which we need to detangle. This metadata contains information such as `Category`, `Skills`, `Country` and sometimes it has `Budget` and other features. Thus, the data returned in the requests now needs to be transformed into a more readable format and information needs to be parsed.

## Transforming

Each of the entries parsed using `feedparsers` have to be transformed such that:

1. Metadata from the HTML content is extracted successfully
2. Metadata is stored in a way that it's easier to write into a DB

For this, we'll create a dictionary with all the properties. Namely, the properties being extracted are:

- **type_of_entry**: wether it's a "recommended" or "best match"
- **title**: Title of the task
- **href**: Upwork URL of the task
- **description**: description of the task
- **published_on**: date when the task was published
- **range_max**: maximum range of the hourly rate
- **range_min**: minimum range of the hourly rate
- **budget**: budget of the task
- **skills**: required skills

Not all the tasks contain the above properties, but most tasks do. Moreover, `budget` is mutually exclusive to any of the `range` properties (because some projects are hourly rated and some have a fixed budget).

In order to parse the HTML contained in the `description` property, we'll use `BeautifulSoup` library. Here's an example of how this property is being parsed:

```python
    def extract_info(self, entry, type):

        properties = {}

        properties['type_of_entry'] = type
        properties['title'] = self.extract_title(entry).rsplit(' - Upwork')[0]
        properties['href'] = self.extract_href(entry)
        properties['description'] = self.extract_description(entry)
        properties['published_on'] = self.convert_time(entry)
        properties['published_on_raw'] = entry.published

        properties['range_max'] = None
        properties['range_min'] = None
        properties['budget'] = None

        properties['skills'] = None

        soup = BeautifulSoup(entry.summary, features="html.parser")

        for x in soup.findAll('b'):

            property = x.get_text().lower()
            value = x.next_sibling.get_text().replace(
                ':', '').lstrip(' ')

            if (property == 'posted on'):
                properties['posted_on'] = value

            if (property == 'category'):
                properties['category'] = value

            if(property == 'country'):
                properties['country'] = value.replace("\n", "")

            if(property == 'skills'):
                properties['skills'] = value.replace(
                    "\n", "").replace("  ", "")

            if (property == 'hourly range'):
                range = value.split('-')

                properties['range_min'] = float(
                    range[0].lstrip('$').replace("\n", ""))

                if (len(range) > 1):
                    properties['range_max'] = float(range[1].lstrip(
                        '$').replace("\n", ""))

            if(property == 'budget'):
                properties['budget'] = int(value.lstrip(
                    '$').replace("\n", "").replace(",", ""))

        return properties
```

As a reminder, the full code can be seen **HERE**.

We also need to convert the `published` text property into a date format, by doing:

```python
    def convert_time(self, entry):
        dt_format = dt.strptime(entry.published, '%a, %d %b %Y %H:%M:%S %z')
        # YYYY-MM-DD hh:mm:ss
        return f'{dt_format.year}-{dt_format.month}-{dt_format.day} {dt_format.hour}:{dt_format.minute}:{dt_format.second}'
```

Now we have a dictionary with all the properties ready to be written into a Database. That's what we'll be handling in the **Loading** chapter below.

## Loading

This assumes an already created DB and table with the right schema.
Share the schema below

## Conclusion and possible improvements

- Transform data using Apache Spark
