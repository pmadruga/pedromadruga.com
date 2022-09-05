---
title: "Newsletter" # in any language you want
summary: "5 minutes of Data Science"
description: "5 minutes of data science"
showtoc: false
weight: 1
ShowReadingTime: false
# cover:
#   image: "https://images.unsplash.com/photo-1499750310107-5fef28a66643?ixid=MnwxMjA3fDB8MHxwaG90by1wYWdlfHx8fGVufDB8fHx8&ixlib=rb-1.2.1&auto=format&fit=crop&w=1500&q=80"
---

{{< rawhtml >}}

<div class="newsletter-form-wrapper">

    <form
    class="newsletter-placeholder"
    action="https://buttondown.email/api/emails/embed-subscribe/pmadruga"
    method="post"
    target="popupwindow"
    onsubmit="window.open('https://buttondown.email/pmadruga', 'popupwindow')"
    class="embeddable-buttondown-form"
    >
        <label for="bd-email"></label>
        <input type="email" name="email" id="bd-email" class="button" placeholder="e-mail" />
        <input type="hidden" value="1" name="embed" />
        <input type="submit" class="button button-newsletter" value="Subscribe" />

    </form>

</div>
{{< /rawhtml >}}

**5 minutes of Data Science** is a newsletter with a weekly recap of all things Data Science and Machine Learning. It aggregates last week's data from:

- **research blogs**, _from OpenAI, DeepMind, Amazon Science, Apple Machine Learning, etc_. 
- **podcasts**, *like Data Skeptic, DataFramed, etc*.
- **youtube channels**, *such as DataSkeptic*. 
- **reddit community top posts**, *such as r/DataScience, r/MachineLearning, etc*.
- **github repository trends**.

It's [opensource](https://github.com/pmadruga/etl-newsletter) and built as a pipeline using airflow. 
If you have any feedback and/or suggestions, write them [here](https://github.com/pmadruga/ETL-newsletter/issues).

View preview issues in the 🏛 [Archive](https://buttondown.email/pmadruga/archive/).
