---
title: "From PoC to 3.5M documents"
date: 2021-07-21T11:30:03+00:00
pinned: true
draft: true
---

# From PoC to 3.5M documents 

deacription: how I created, scaled and lead a genAI legal assistant that is now being used by major law firms in denmark and sweden, and has been festured in major newspapers.

# Intro

I have been busy.

It has been a fantastic journey creating and seeing a proof-of-concept going all the way to being adopted by thousands of users, major law firms, being featured in major danish newspapers. But there's a story behind it and, as a typical reader and lister, I felt like this was worth sharing.

A bit of context:

In 2022, I returned to Karnov - a 150 year-old company with offices throughout Europe and over a thousand employees. Karnov is a leader in providing information for the legal industry. 

Fast-forward to the age of industrialized Generative AI - when Karnov dived in. 

It has been an incredible experience being part of the transformation of the company towards AI, especially with so many competitors out there. Several POC's were created leading up to the first large-scale company-wide AI-product: Karnov AI Legal Assistant - KAILA.

This blogpost is about KAILA. The following is a recollection of events, challenges and learnings that led to KAILA and where it is today.

# 2023

### The first lines of code

ChatGPT came out in November 2022, powered by GPT3.5, and it changed everything. Suddenly, there was worldwide awareness of Generative AI and its capabilities. Of course, the hype came along but in the legal industry there were first signs of actual value generated. 

In February 2023, I started experimenting with doing Information Retrieval on law-related documents within Karnov. I was using [Haystack](https://haystack.deepset.ai/) at the time, and the term Retrieval Augmented Generation (RAG) wasn't even [popular](https://trends.google.com/trends/explore?date=today%205-y&q=retrieval%20augmented%20generation&hl=en-US) by then - despite the term RAG being coined [in a paper during 2020](https://www.patricklewis.io/publication/rag/) by the very talented Dr. Patrick Lewis. The number of vector databases was exploding and, at the time, I experimented with PineCone and FAISS. Both were great for the scale I was working on, although in the end I opted for different database (Qdrant) - something I'll leave for another blogpost.

The work continued as a side project for a few months. Around the summer of 2023, this project was close to go into the “cemitery of the dead experiments”. 

But in a hot summer afternoon in August of the same year, I joined forces with Gustav (then, working with Business Innovation at Karnov Denmark) and we decided to embrace our "healthy disregard for the status quo" and revived the project. In hindsight, Gustav's words "let's do it" were a catalyst for this story to happen. That decision to revive this proof-of-concept marked the birth of "KAILA - Karnov AI Legal Assistant". That same afternoon is where I suggested Gustav the name of the project, which ended up being the official name of the final product (in Sweden, the final product was renamed to JUNO AI).

This collaboration between business and tech set a fundamental standard that is essential to successful products. No silos, just the eternal curiosity for the uncertain.

Before the project had an internal green light, Gustav and I reached out to a couple of developers who helped building a UI as well as a Ruby backend which wrapped a Python API. The developers also helped in creating what came to be the embeddings pipeline. They were nothing short of amazing and embraced this incredibly uncertain project from the moment we pitched it to them. 

By then, and even before being a priority, this proof-of-concept was drawing voluntary interest: novelty, curiosity and working with AI became the drawing factors to collaborate in this project. This delegation of responsibilities by onboarding new people allowed me to work on the most critical part: the Information Retrieval Engine - and engine responsible for fetching the correct documents.

Then, the proof-of-concept was pitched to management in late 2023, and in early 2024 the project kick-started officially, with the goal of launching in September 2024.

Looking back, and understanding that this project was almost shelved, made me realize that it's healthy to listen to gut feelings. 

# 2024

## A scalability and factuality challenge, with a tight deadline

Early in 2024, one extra AI developer was added to the project - the project was scaling in resources. It also became clear that KAILA had several questions to be answered, such as:

- **How to go from 5k to 3.5M documents, where none of the infrastructure was in place**? 
- **How to reach the highest levels of factuality**? 
- **But why did we move so fast**? 

---

I realised that an Architect was needed as well as close collaboration with the Operations team, since they'd be responsible for the infrastructure needed (setting up pipelines, databases, authentication, etc). 

But the most revealing part was that embeddings alone where not enough for a _large_ set of documents. It might have worked for a small set of documents but not for the entire pool of documents. It was time to think a bit outside the box and use all resources possible: such as the usage of metadata and other techniques. Which worked quite well and set the foundation for every thing done after that.

- **How to reach the highest levels of factuality**? 

The main reason to use different techniques was to achieve the highest levels of factuality. By the time of the early steps of KAILA, the main question internally was about hallucinations. 

This became the core of KAILA's identify: factuality above anything else. In other words, users had to be able to get correct answers where documents where the source of truth for all the answers. And for that we needed domain knowledge - a lot of it.

So we started collaboration with domain and content experts. This collaboration became a foundational aspect of all AI development in Karnov. The bridge between the KAILA AI development team and the experts was as close as possible: no meetings, no JIRA tickets, no protocols - just sitting in a room and getting instant feedback on how KAILA was performing. 

In hindsight, this was our first evaluation method - completely made by humans. Only further down the road we included automated evaluation pipelines, because it doesn't scale that well for obvious reasons. But even the evaluation pipelines have carefully human curated benchmarks which allows the team to move fast.  

- **So wow did we move fast**? 

This was essential due to the timeline and, for that, we had to disregard some of the common conventions of product development. I realized that the conventional software development approach - and its ceremonies - hinder AI development.

An incredible dosage of pragmatism, near-perfect silo-free collaboration between business and development created a very smooth product delivery, despite general skepticism outside the collaborators of KAILA at this point. 

---

## Breaking silos and the importance of domain knowledge

When the development officially started, in March 2024, the main focus was factuality - answers had to be as close to the truth as possible, complete, coherent while hallucinations had to be reduced to a minimum. In fact, without factuality there was no point in having a product - it was a deal breaker to launch. To this day, our constant and daily strife for factuality remains the core of our AI-based products' identity.

But the best answers were limited to the AI developers' knowledge in regards to the legal domain. In other words, we didn't know when an answer was actually good or not. 

It was clear we needed domain knowledge. Thus, a close collaborationb between AI devloeprs and domain and content experts was essential. 

And "close collaboration" was taken to heart: there were periods where I sat down and coded live in front of two (wonderful) domain and content experts. I couldn't understand whether an answer from KAILA was good - but they did. 

And that changed everything for the better. It became a lesson and a foundation of AI development that domain expertise is fundamental for any AI-based products we (and possibly, many many other companies) develop and release. 

I spent weeks trying to understand the legal method, the type of documents Karnov has, the metadata it has, how a lawyer approaches research, etc. I had the advantage to have dedicated people helping me getting domain knowledge - essential for the success of a data science project -, even before lines of code were written. And when code was written, it was *with* them.

Around April we had the first breakthrough. Something that we understood and evaluated internally as a leap in terms of quality of not only the retrieved documents but also the quality of the answers.

This close collaboration between tech and business, with domain knowledge as the core of AI development within the legal industry, set the standard to how we approach every AI-based product in Karnov today.

Moreover, I don't see KAILA being successful without these two colleagues and I'm very thankful for having learned so much. We had an incredible time together, something I'll never forget throughout my career.

---

In March 2024, when we officially began development, our main focus was on ensuring factuality. Our answers needed to be as accurate, complete, and coherent as possible, with minimal inaccuracies. Without this commitment to factuality, the product wouldn't have been viable—it was essential for our launch. To this day, our constant pursuit of factuality remains central to our AI-based products.

However, the quality of our answers was limited by our knowledge of the legal domain. We couldn't always determine if an answer was truly good or not, making it clear that we needed domain expertise. Thus, close collaboration between AI developers and domain/content experts became essential.

We took "close collaboration" seriously. There were times when I coded live in front of two amazing domain and content experts. While I couldn't judge the quality of KAILA's answers, they could, which changed everything for the better. This collaboration became a foundational lesson in AI development: domain expertise is crucial for any AI-based products we develop and release.

I spent weeks learning about the legal method, the types of documents Karnov has, their metadata, and how lawyers approach research. I was fortunate to have dedicated people helping me gain this essential domain knowledge, even before writing any code. And when we did write code, it was alongside them.

Around April, we had our first breakthrough—a significant leap in the quality of both the retrieved documents and the answers. This close collaboration between tech and business, with domain knowledge at the core of AI development in the legal industry, set the standard for how we approach every AI-based product at Karnov today.

Moreover, I don't see KAILA being successful without these two colleagues, and I'm very thankful for everything I learned from them. We had an incredible time together, something I'll never forget throughout my career.

### The first tests with external users

Around June, the close collaboration was then extended to outside. We needed feedback beyond our internal expertise in order to get KAILA to another new level of quality.

Before this happened, we had to make sure that KAILA was as factual as possible. As I wrote above, this is still the core identity of KAILA. There was no amount of user validation and testing that was going to happen before KAILA performed to a level that Karnov customers have been used to.  
Therefore, we had to disregard certain conventions of product development. I'll elaborate more on this in upcoming blog posts.

### The importance of support by upper management

Along the way, it was clear that a lot of the barriers where being removed in such a way that we development could happen smoothly. There was also support when we needed to pivot hard, for several different reasons, along the way.

This was essential for the launch of KAILA and beyond and, while it's obvious that support from management is critical, it became another standard within Karnov for the upcoming future.

### Scaling (and leading) the team

Nonetheless, as time progressed, both the team grew as well as the people involved. In the projected kicked off we were two AI developers. I was working on the retrieval engine but also spent a lot of time managing stakeholders, giving status updates, assisting in building infrastructure, etc. In fact, "etc" is carrying a lot of weight here. In May, we were already 5 people in the AI team.

Nonetheless, scaling the team allowed taking KAILA to an entire new level of quality. Which keeps on happening and I'm very fortunate to see KAILA's quality exponentially growing over the time.

Not only the team grew, as well as the people involved outside the team but within Karnov. We learned to collaborate with other software development teams, with sales department, marketing department, business department and so forth. 

Communication is a fundamental pilar of the AI team and its something that we strive to maintain and improve. I have worked in Data Science teams working in silos before and it was important to not make the same mistake. It's a quality that I'll take to any team in the future.  

The identity of being approachable from the outside is something that is taken for granted nowadays, but it took time and careful consideration to reach this point. For example, when recruiting new AI developer candidates, communication - and the skills to communicate complicated things simply - became an essential and deciding factor for a given candidate. 

### The launch of KAILA

In September 2024, KAILA / JUNO AI was launched. The feedback was incredibly positive. To this day, it still is. KAILA is consistently being sold at a very high pace, is being used by top lawyer firms in Denmark and Sweden, as well as courts. It has been featured in major newspapers in Denmark. It has now around 50 people working in it. It has been responsible for generating millions in revenue. There has been numerous talks, webinars and interviews.  
  
In October I was officially promoted to Principal AI Developer and alongside came a shift in what my focus was. From then on, and looking at the early success of KAILA, I wanted to avoid complacency - both from a technological but also from a competitive standpoint. I invested a lot of time in making sure we're working on State of the Art AI while giving space for new features and products coming in. It was also very important in my new role to share the credit with the people I've worked with along the way. Having my team members doing talks and interviews in order to see them flourish and prepare them for future leadership was a personal goal of mine. I let others do the talking and take the spotlight - and I'd do it again since I'd like my type of leadership to be *silent but effective*.

# 2025 and beyond

Fast forward to April 2025, this proof-of-content turned official that has been adopted by a few of the largest lawyer companies, both in Denmark and Sweden, as well as major courts. It has generated dozens of millions in revenue for [Karnov Group](<https://www.karnovgroup.com/en/wp-content/uploads/sites/2/2025/02/karnovgroup-publication-of-karnov-groups-annual-report-and-sustainability-report-2024-250331.pdf> "Karnov Group") and has been featured in major media in the Nordics, such as [Børsen](<https://borsen.dk/nyheder/tech/dansk-virksomhed-fra-1867-gar-i-offensiven-med-ai> "Børsen") and [Berlingske](<https://www.berlingske.dk/virksomheder/kunstig-intelligens-er-for-alvor-rykket-ind-paa-advokatkontoret-vi-er>).

### Keep doing research while incorporating with product development

We're moving beyong RAG towards DeepSearch.

### An ongoing incredible respect for competitors

Competitors - old and new - keep us on our toes. They keep us down to earth. While we have had successes along the way, we are far from being perfect and, most importantly, we don't want to be complacent. We want to keep moving forward, listen to our clients' needs while bringing the best AI technology we can provide.

When I see competitors from an outside perspective, I see their value, their expertise and their fire in trying to beat Karnov. I'm personally fascinated by how some competitors move, what technologies are they bringing in their demos, which features do they decide to launch, etc.

It's only fair.

In the end, we're all doing this because we believe that society benefits from a competitive legal industry. And we'll keep our core identity throughout changes.



### success is a blessing and a curse



# Conclusion

This blogpost only brings to light a very small set of everything that happened. Of course somethings are kept in private while others would make this blogpost even longer. These learnings I wrote above, and many others, I'll carry them for life. As well as some wonderful people that I was lucky to be able to work with.

KAILA will always be a work in progress. As I like to say: "what you're seeing today, is still the worst version of it" - because it keeps getting better and better.





---





this article is about Kaila , karnov legal research assistant and an overall view of my learnings since I started developing it’s first lines

As one can imagine, there's a lot to unpack that happened within this period of close to two years. Below, I'm giving a summarized version of the main learnings and how the path to were we are now. In the upcoming months, I'm planning to post in detail about these (feel free to follow my [newsletter](<https://pedromadruga.com/newsletter> "newsletter")).

## The path to success 

(Define success)

Before this i was obssessed on what makes a data science project successfull



- Domain expertise

    - achieved via close collaboration with experts from multiple departments

    - Along the way I have learned a lot about the legal domain. I benefited a lot from incredible talented and knowledgeable people which were easy to get access to in Karnov

- Disregarding the status quo of product develoment (this is something I will dive deep and continuously in my blog)

- Incredible respect for competitors

    - We follow the competition closely which keeps our feet close to the ground. Although Karnov is a major player in the legal industry for the last 150 years, we recognized that the techniques that powered the tools being developed by us and competitors falls into the same spectrum of AI techniques.

    - Alongside it's long life in the market, Karnov having a size of 1500 employees spread over Europe, needs to move in different ways than of startups, for example.

- Do homework before jumping into a project.

# Scaling

## From 5k to 3.5 million documents

In this proof-of-concept, I experimented doing augmented retrieval with a few thousand documents.



From one pwrson to two people to 50 people

-

## AI Team

- Before members started, I had a plan on what part of Kaila they were going to be working on. We had to move fast.

- Knowing the application would grow in size and complexity, it was also important to have delegated ownership.

- It started with me writing thr first lines of Kaila since I was the only data scientist in Karnov



## Number of userS



# Success is a blessing and a curse



# Acknowledgements

People who have reviewed to this blogpost.

-



---



# Final

- **\`\`\`\`\`\`\`\`\`\`\`\`JUNO**

- **60K+ users\`\`**

- **50 users**

- **30 million swedish crowns in revenue over a single quarter**

# Draft

- What started as a proof-of-content in 2023, for a legal chatbot

- Kaila stands for Karnov AI Legal Assistant.

- I've been leading it
- There's has been a lot of learnings
- Officially it's 50 people working on it now
- Some statistics on where it is now (Joachim)
- A lot of lessons arised regarding AI development in the legal industry, product development,
- Lessons that I'll be sharing in my blog
- Suddenly we had to figure out things such as: how to scale from 5000 docs in a POC to 3.5M (and keeping factuality levels the highest possible), how to handle factuality (and at scale!) how to do continuous research and innovation, how product development has changed in the GenAI age; but also technical about Agents, tools,
-



---



- Linkedin: from a side-project to the cover of Berlingske, to the biggest lawyer firm in DK and the Swedish supreme courts: a 2024 recap. Got promoted to Principal Data Scientist (and we're hiring!) along the journey.

- What started as a side-project for a AI-based legal assistant and ended up being used by top lawyer firms and supreme courts.

- This date is important since March 2024 marked the official development kick-off of what came to be Kaila - a legal research assistant released in Denmark and Sweden (under the name Juno AI).

In the course of just over a year, a lot has happened. Quite a few things can be shared - hence why I'm resuming this blog.

## Here's a bit a story:

- In June I was promoted to Lead AI Scientist in Karnov

- In July I want for summer holidays followed by parental leave

- In September the product launched both in Sweden and in Denmark

---

Outro/conclusion:

With this process, I've learned a lot about generative information retrieval in production and at scale, about technical leadership, about AI-based product development (and how it completely differs from traditional product development), about mantaining an innovation mindset for existing and new products in production, etc.

If you're interested in the topics above, visit [pedromadruga.com](<http://pedromadruga.com>). I'm restarting my blog after a few years of hiatus.



---



- What started as a proof-of-content in 2023, for a legal chatbot

- I've been leading it

- There's has been a lot of learnings

- Officially it's 50 people working on it now

- Some statistics on where it is now (Joachim)

- A lot of lessons regarding AI development in the legal industry, product development,

- Lessons that I'll be sharing in my blog

- lessons like: how to scale, how to do continuous research,

- Kaila stands for Karnov AI Legal Assistant.



