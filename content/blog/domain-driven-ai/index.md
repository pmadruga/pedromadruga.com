---
title: "Domain Driven AI"
date: 2026-08-20T07:30:03+00:00
draft: false
---

Early 2023 had me obsessing about why AI-based products fail. There were so many unanswered questions back then: why do they rarely leave the proof-of-concept stage? And the ones who do, why do they fail afterwards?

If you were also doing Data Science & AI for some years like me, you'd quickly realize that the existing research on failed products confirmed reality: most AI projects fail. And I wanted to know why, exactly.

My quest for understanding the reasons behind failed projects was straightforward: 2022 saw the launch of ChatGPT, and we all saw that the age of GenAI-based products arrived.

And that changed everything, especially in the legal industry where the value proposition was obvious. It then became clear that the lawyers would benefit from a dramatic increase in speed when performing legal tasks, such as research. That also meant the market was about to be flooded with startups that catered to the legal industry.

The race for a successful product was on. And I was hunting for its formula.

{{< inline-svg "domain-driven-ai-card-3.svg" >}}

## Why AI-based projects fail?

Digging through several research papers about successful data science and AI projects (written up until 2023), I confirmed that there's a multitude of reasons for a project to die even before they're born. Wrong processes, lack of proper data, wrong people, you name it. Nothing new here because AI products are a combination of multiple factors, that require a well-tuned orchestration in order to succeed.

Some factors matter more than others but, to make it even more complex, "there's no [process] model with wide acceptance"[^1] - what works in one domain/project/product/company doesn't translate to others.

Truth is, there is no exact formula for success. However...

Despite these papers presenting cases with different methodologies and processes, with different reasons to fail and succeed, there was sort of a needle in the haystack, that kept appearing over and over.  It presented itself with slightly different terms but the overlapping existed and the message was clear: understand the business, especially the domain.

In a paper that analyzed 26 other papers, "business understanding"[^2] was mentioned in 68% of those, as something that can benefit teams and projects, and its absence was a major factor in a project's failure. [^3] In Martinez et al (2021) the authors include that knowing "barely some domain information" and expecting the "team will do the 'magic' by itself" [^4] is another cause of failure. In the same paper, "describing precisely stakeholders' needs" was the number one factor for a project success.

This research is no exception in the legal domain too, since it's quite often that the stakeholders are domain experts already. Translating their needs into how the AI is developed is fundamental for better outcomes of projects and products.

It's 2023, I had read the papers so by the time I was creating the first legal assistant in my company, it was time to put knowledge into practice. I had to understand what Domain Driven AI really meant in practice.

## Domain Driven AI

Domain Driven AI draws inspiration from the term "[Domain Driven Design](https://en.wikipedia.org/wiki/Domain-driven_design)", coined by Eric Evans in his 2003 [book with the same name](https://www.goodreads.com/en/book/show/179133.Domain_Driven_Design). Domain Driven AI follows similar principles.

Domain Driven AI is about gathering every possible piece of information about a given domain, and then translating that into AI development, such that it helps building or improving AI-systems and AI-based products.

It's important to recognize that you, as an AI practitioner, probably don't have knowledge of the domain you are in. If you studied subject matter *and* AI development, then you're probably a unicorn. But for the rest of us who have been in different organizations and industries, we need to hunt that knowledge.

This is something I realized when working in the legal industry. I'm not a lawyer, I know nothing about legal systems - especially the Danish legal system. Back in 2023, I had to start from nothing. I was lucky to be part of a well-established organization like [Karnov Group](https://www.karnovgroup.com/en/), one with abundance of domain experts who bore with my simple questions - and to this day they still do. It's a catastrophic misconception that domain knowledge can be acquired within 6 months, especially in a domain like legal.

It's not hard to find this knowledge. In fact, within an organization, this information is everywhere: customers, colleagues from other departments, internal and external literature, and so on.

It depends on factors such as size and age of the company but if you're working in a company in a given domain, chances are that someone else knows something. And that something is very valuable because if done right, from an AI development standpoint, it will influence technical decisions such as architecture, infrastructure, evals, etc.

{{< inline-svg "domain-driven-ai-card-2.svg" >}}

## How does domain knowledge impact AI development?

Looking back, after being the co-creator (alongside two domain experts I mention further on in this post) and AI lead for two successful GenAI-based products in the legal industry, it's now possible to say with certainty that domain knowledge was a crucial factor to reach this success. AI development is generic without domain knowledge.

In practical terms, when I was building [KAILA](https://www.karnovgroup.dk/produkt/kaila-karnovs-ai-assistent) back in 2023/2024, Karnov's legal research AI assistant, I couldn't assess what a good answer was; all the answers seemed correct to me since I was only looking from a semantic standpoint - not a legal one. The domain experts had a completely different opinion from me.

So I listened.

During the following weeks, I live-coded in front of two content and legal domain experts, so that the code reflected the domain expertise. Until then, the results were plain at best. With the domain expertise translated into the AI, the results were so good that the foundation of KAILA's engine remains the same to this day. KAILA was a success at its launch, as it still is today.

Domain knowledge drove AI.

It was not about a state-of-the-art model nor the shiniest vector database. It was about converting that knowledge into AI. Technology listened to the domain, not the other way around.

Fast-forward to August 2026, and a completely [new product called FLOW](https://www.karnovgroup.dk/produkt/ai/kaila-flow) successfully launched again in June, I can confidently say that, in an industy like legal (where trust is essential), a true connection between domain and technology is a fundamental step to achieve a successful product, in all its stages: from idea to production.

{{< inline-svg "domain-driven-ai-card-1.svg" >}}

## Structuring around Domain Knowledge

In practical terms, Domain Driven AI influences not only how the AI should be architected and engineered but also other aspects of an organization.

If done right, the entire organization is set to promote domain knowledge sharing, from building teams that include domain experts as part of the team and processes, to making sure the experts are available to work *with* AI developers.

Futhermore, an organization should not use the traditional software development processes and traditions to do AI development. AI development requires a level of domain knowledge in order to succeed that is unparalleled with traditional software development.

With the research out there aligned with my personal experience, it's possible to say without a doubt that projects that ignore domain knowledge (and focus too much on classical development and flashy engineering) are doomed to fail - or at least plateau at a mediocre level.

As demonstrated in this article, it's well-documented that there is not a single methodology that fits all. But it's certain that every company needs to adapt: their technical stack, architecture and approach should adapt to their domain.

The days of having a hammer in the search of a nail are over.

{{< video src="domain-driven-ai.mp4" poster="domain-driven-ai-poster.jpg" caption="Me talking about Domain Driven AI within Karnov's FLOW product launch, in June 2026">}}


## Disclaimer

- Due to time where I've consulted papers (2023), some of the papers use different terminology for projects, such as data science, data analytics and big data. I took the liberty of generalizing across domains.
- Projects and products can be used interchangeably, because all projects I worked were products.

## References

[^1]: Saltz, J. S., & Shamshurin, I. (2019). [Achieving Agile big data science: The evolution of a team's Agile process methodology](https://doi.org/10.1109/BigData47090.2019.9005493). *2019 IEEE International Conference on Big Data (Big Data)*, 3477–3485.
[^2]: Saltz, J. S., & Krasteva, I. (2022). [Current approaches for executing big data science projects—a systematic literature review](https://doi.org/10.7717/peerj-cs.862). *PeerJ Computer Science*, *8*, Article e862.
[^3]: Panda, B. (2023). [*Why data science projects fail*](https://doi.org/10.48550/arXiv.2308.04896) [Preprint]. arXiv.
[^4]: Martinez, I., Viles, E., & Olaizola, I. G. (2021b). [A survey study of success factors in data science projects](https://doi.org/10.1109/BigData52589.2021.9671588). *2021 IEEE International Conference on Big Data (Big Data)*, 2313–2318.

