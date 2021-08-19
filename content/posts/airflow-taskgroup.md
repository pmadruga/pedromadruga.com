---
title: "Getting started with Task Groups in Airflow 2.0"
tags: ["airflow", "raspberry pi", "data engineering"]
date: 2021-08-15T11:30:03+00:00
draft: true
cover:
  image: "/posts/2021/08/taskgroup.png"
  # can also paste direct link from external site
  # ex. https://i.ibb.co/K0HVPBd/paper-mod-profilemode.png
  alt: "Airflow 2"
  caption: "What we're building today"
  relative: read # To use relative path for cover image, used in hugo Page-bundles
---

## Background

This post is part of the [ETL series](/posts/ETL-pipeline/) tutorial. This was originally posted on [pedromadruga.com](https://pedromadruga.com).

<!-- TODO: Link to github -->

The full code is avaiable [here]()

## Intro

Before Task Groups in Airflow 2.0, Subdags were the go-to API to group tasks. With Airflow 2.0, SubDags [are avoided](https://www.astronomer.io/guides/subdags) and now replaced with the Task Group feature. The TaskGroup's API is simple and allows for a proper code structure, favoring a clear separation of concerns.

What we're building today is a simple pipeline with two groups of tasks, using the `@taskgroup` decorator from the TaskFlow API, from Airflow 2. The graph view is:

![taskgroup - graphview](/posts/2021/08/taskgroup.png)

What this pipeline does is different manipulations to a given initial value. The `init` task instantiates a variable with value `0`. It then passes to a group of subtasks that manipulate that initial value - this is `group_1`. `group_2` will aggregate all the values into one. Finally, the `end` subtask will just print out the final result.

Let's get started but breaking it down into parts.

## Grouping tasks - breakdown

In order to make it easier to understand, we're going to break this down into parts. As you can see in the image above, there's an `init` and `end` task. In between, there are two groups of tasks.

### `init` and `end` task

![taskgroup - init+end](/posts/2021/08/taskgroup_2.png)

The `init` task is the starting point for this pipeline - it returns the initial value that will be manipulated throughout the pipeline: 0. The `end` task will just print out the result of all the manipulations in the pipeline, to the console.

Let's look the code for the `init` task:

```python
@task
  def init():
return 0
```

That's it. Now the code for the `end` task:

```python
@task
  def end(value):
print(f'this is the end: {value}')
```

It's also quite simple to define the flow of the whole pipeline, returned by the function that wraps everything:

```python
return end(section_2(section_1(init())))
```

### `group_1` and `group_2`

![taskgroup - group_1+group_2](/posts/2021/08/taskgroup_3.png)

`group_1` has a set of three tasks that manipulate the original number:

```python
# This task group has three subtasks:
# each subtask will perform an operation on the initial value
# this group will return a list with all the values of the subtasks
@task_group(group_id='group_1')
def section_1(value):

  # The @tasks below can be defined outside function `section_1`
  # What matters is where they are referenced
  @task(task_id='subtask_1')
  def task_1(value):
    task_1_result = value + 1
    return task_1_result

  @task(task_id='subtask_2')
  def task_2(value):
    task_2_result = value + 2
    return task_2_result

  @task(task_id='subtask_3')
  def task_3(value):
    task_3_result = value + 3
    return task_3_result

  # tasks are referenced here
  task_1_result = task_1(value)
  task_2_result = task_2(value)
  task_3_result = task_3(value)

return [task_1_result, task_2_result, task_3_result]
```

The `section_1` function receives the result from the `init` task.
And notice what's being returned here: a list of of the three values. This is what's going to be sent to `group_2`.
