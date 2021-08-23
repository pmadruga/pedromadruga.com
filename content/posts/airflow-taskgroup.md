---
title: "Getting started with Task Groups"
description: "A simple pipeline with two groups of tasks, using the @taskgroup decorator of the TaskFlow API from Airflow 2."
tags: ["airflow", "raspberry pi", "data engineering"]
date: 2021-08-22T11:30:03+00:00
draft: false
cover:
  image: "https://pedromadruga.com/posts/2021/08/taskgroup.png"
  # can also paste direct link from external site
  # ex. https://i.ibb.co/K0HVPBd/paper-mod-profilemode.png
  alt: "Airflow 2"
  caption: "What we're building today"
  relative: read # To use relative path for cover image, used in hugo Page-bundles
---

## Background

This post is part of the [ETL series](/posts/ETL-pipeline/) tutorial. This was originally posted on [pedromadruga.com](https://pedromadruga.com).

The complete code is available [here](https://github.com/pmadruga/airflow-dags/blob/main/taskgroup.py).

## Intro

Before Task Groups in Airflow 2.0, Subdags were the go-to API to group tasks. With Airflow 2.0, SubDags [are being relegated](https://www.astronomer.io/guides/subdags) and now replaced with the Task Group feature. The TaskFlow API is simple and allows for a proper code structure, favoring a clear separation of concerns.

What we're building today is a simple pipeline with two groups of tasks, using the `@taskgroup` decorator from the TaskFlow API from Airflow 2. The graph view is:

![taskgroup - graphview](https://pedromadruga.com/posts/2021/08/taskgroup.png)

What this pipeline does is different manipulations to a given initial value. The `init()` task instantiates a variable with the value `0`. It then passes to a group of subtasks (`group_1`) that manipulate that initial value. `group_2` will aggregate all the values into one. Finally, the `end()` subtask will print out the final result.

Let's get started by breaking the pipeline down into parts.

## Grouping tasks - breakdown

As you can see in the image above, there's an `init()` and `end()` task. In between, there are two groups of tasks, but let's start with the first and last task of the pipeline.

### `init()` task and `end()` task

![taskgroup - init+end](https://pedromadruga.com/posts/2021/08/taskgroup_2.png)

The `init()` task is the starting point for this pipeline - it returns the initial value that will be manipulated throughout the pipeline: 0. The `end()` task will print out all the manipulations in the pipeline, to the console.

Let's look at the code for the `init()` task:

```python
@task
def init():
  return 0
```

That's it. Now the code for the `end()` task:

```python
@task
def end(value):
    print(f'this is the end: {value}')
```

It's also quite simple to define the flow of the whole pipeline, returned by the function that wraps everything:

```python
return end(group_2(group_1(init())))
```

Looking at the code above it's possible to see that:

1. The `init()` function "feeds" `group_1`;
2. The result of `group_1` is "sent" to `group_2`;
3. `end()` receives the outcome of `group_2`.

### Task Group #1 (`group_1`)

![taskgroup - group_1](https://pedromadruga.com/posts/2021/08/taskgroup_group_1.png)

`group_1` has a set of three tasks that manipulate the original number:

```python
# This task group has three subtasks:
# each subtask will perform an operation on the initial value
# this group will return a list with all the values of the subtasks
@task_group(group_id='group_1')
def group_1(value):

  # The @tasks below can be defined outside function `group_1`
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

# sending this list to `group_2`
return [task_1_result, task_2_result, task_3_result]
```

The `group_1` function receives the result from the `init()` task.
And notice what's being returned here: a list of the three values. Each of the value stems from `subtask_1`, `subtask_2` and `subtask_3`. This list of values is what's going to be sent to `group_2`.

### Task Group #2 (`group_2`)

![taskgroup - group_2](https://pedromadruga.com/posts/2021/08/taskgroup_group_2.png)

`group_2` is rather simple. It receives the list sent from `group_1` and sums all values (`subtask_4` does it) and then `subtask_5` just multiplies by two the result from task_4:

```python
@task_group(group_id='group_2')
def group_2(list):

  @task(task_id='subtask_4')
  def task_4(values):
    return sum(values)

  @task(task_id='subtask_5')
  def task_5(value):
    return value*2

  # task_4 will sum the values of the list sent by group_1
  # task_5 will multiply it by two.
  task_5_result = task_5(task_4(list))

  return task_5_result
```

That's it - the next task is the `end()`, and it has been handled before in this post. Again, it's possible to see the full code [here](https://github.com/pmadruga/airflow-dags/blob/main/taskgroup.py).

If you check the log of the `end()` task (see my previous post to know how to check for task logs), you'll see the result printed. The final result should be `12`.

Success! 🎉

## Conclusion

Creating task groups in Airflow 2 is easy - it removes complexity that existed before and allows creating pipelines with clean code.
