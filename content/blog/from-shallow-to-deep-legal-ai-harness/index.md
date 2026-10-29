---
title: 'From Shallow to Deep: Building a Legal AI Harness'
description: 'Agentic coding brought us harnesses and harness engineering. Can that translate to the legal industry? An analysis on legal harness - both deep and shallow - and which properties compose these. As usual no AI was used to write this article.'
showtoc: true
tocopen: false
numberedHeadings: true
draft: true
date: '2026-09-30'
lastmod: '2026-10-28'
---

## Intro

When we first saw ChatGPT's launch in November 2022, we were able to interact with it via a chat interface. Today, the interfaces where we interact with LLMs seem different, despite at the surface looking similar to what it was back then.

These interfaces seem more complex now - a surface reflex of what they have become under the hood. There are agents, subagents, connectors, memory and so on. The breadth of capabilities around the model has increased exponentially whereas at the same time the models' quality (ie, depth) has also gone up over the years.

In this post, I'm diving deeper into the differences between systems that, while they have historically improved in depth, have now moved to systems that have breadth **and** depth.

Let's talk about harnesses.

## Harness

### What is it?

You've probably seen the "Harness" term before. Within agentic coding  it's a new concept but exponentially increasing in popularity.

You're not alone if you're confused about what it actually means. So let's start with defining a harness in the context of agentic coding.

I first saw this term in a [Claude blogpost](https://claude.com/resources/articles/building-agents-with-the-claude-agent-sdk) September 2025, although a LangChain [blogpost](https://www.langchain.com/blog/the-anatomy-of-an-agent-harness) from March 2026 defines a harness as:

>"Agent = Model + Harness. If you're not the model, you're the harness."

In other words, a harness is everything *around* the model, and it can have several layers.

My favourite definition of harness lives in a blogpost at [Martin Fowler's website](https://martinfowler.com), by [Birgitta Böckeler](https://birgitta.info/) and called "[Harness engineering for coding agent users](https://martinfowler.com/articles/harness-engineering.html)". That article dives into the complexity of these harnesses and also refers to a new term called "harness engineering" - but that's out of scope here.

In order to explain what a harness is, the author creates a visualization of the different layers around the model:

![](harness-boundaries-dark-v2.svg)

The harness gets broken down into two layers: "harness outer layer" and harness built by the builders - which I'm naming here as "harness inner layer". Let's define what each of these layers of the harness is.  

### Harness inner layer

From an agentic coding standpoint, Claude Code and Codex are good examples of a builder's harness - or "harness inner layer". This layer may contain several distinct properties. Per the same [LangChain post](https://www.langchain.com/blog/the-anatomy-of-an-agent-harness), it can have:

> - System Prompts
> - Tools, Skills, MCPs + and their descriptions
> - Bundled Infrastructure (filesystem, sandbox, browser)
> - Orchestration Logic (subagent spawning, handoffs, model routing)
> - Hooks/Middleware for deterministic execution (compaction, continuation, lint checks)

The list goes on. This layer contains all the tooling necessary for the harness to function as a whole and it's the layer closest to the model for a reason: it interacts the most with it.

### Harness outer layer

On the other hand, a harness outer layer plays a different role: it works as a two-way feedback mechanism between the user's interactions and the entire harness combined. As the author mentions, there are feedforward and feedback mechanisms that "ultimately it should reduce the review toil and increase the system quality".

In other words, the harness outer layer is capable of increasing a system's quality as a result of consistent human steering of the system itself, plus the properties mentioned above.


### Shallow and Deep Harness in agentic coding

We've dived into the different layers of a harness and it's now obvious that different layers have different depth: some are shallow, some are deep.

The volume and complexity of properties and mechanisms in a harness determine its depth. If the inner layer and the outer layer are deep enough, then the difference in what the AI system is capable becomes noticeable.

The layers - and their depth - are what make applications like ChatGPT, Codex, Claude Code and others rich in terms of functionality, despite the UI being "just" a conversational interface.

Up until now, I've been mentioning harnesses in the context of agentic coding (and harness engineering). In the following chapters, we're looking under the hood of legal harnesses with different depths - and how this difference in depth creates fundamentally distinct harnesses.

We need a bridge between agentic coding and legal harnesses.

## Legal Harness

### The lawyer's flow

In order for this bridge between agentic coding and legal domain to happen, a brief intro to the lawyer's flow is needed: it's imperative to understand how a lawyer works because it sets the foundation of how the legal harness is set up, how its depth varies. Specially when comparing a single tool that a lawyer uses compared to an entire set of workflow tools, the difference is night and day.

So how does a lawyer work? What's their flow?

For the sake of simplicity, and because not everyone reading this has legal domain expertise, I'm keeping the explanation at a high level.

Typically, the main phases of the work of a legal practitioner are defined as: intake, planning, research and drafting.

For example, let's assume a lawyer is working on a case. The lawyer needs to collect all the information relevant to that case (that's typically information that is provided by the client but not exclusive). That's intake.

In the planning phase, the lawyer is building a plan for subsequent actions like legal research and drafting.

When in the legal research phase, the lawyer looks at the different legal sources (laws, verdicts, directives, etc) that can be applicable to a case.

The drafting phase is where the lawyer produces a document, which can include information from all the other phases. It's the combination of all the accumulated knowledge within this case. Ultimately, the lawyer will take this (or these) documents to court. Again, I'm simplifying here.

Again, this is a very high-level explanation of the lawyer's flow and it's also important to know that it's not a linear flow: the lawyers go back and forth between the different phases.

Most importantly, this flow serves as the foundation of the legal harness. After all, as I've written before here, Domain Driven AI means that the AI follows the domain: in order to produce better results in such knowledge-heavy industry as the legal, it's necessary to build AI systems that reflect that knowledge.

It's now time to transpose this knowledge and create a legal harness.

### Legal Harness

Because the lawyer's flow has different phases - and because we're using a Domain Driven AI approach -, it's necessary to understand how to build harnesses that reflect that flow.

The two layers that compose the agentic coding harness - the inner layer (the builder's layer) and the outer layer (the user's layer) differ substantially when creating a legal harness. This is because these layers need to reflect which phase(s) of the lawyer's flow is in.

By now, it's becoming clear that an AI system whose harness is built for a legal research phase is completely different than an AI system built to power an entire workflow (ie, all the phases). What we're missing so far is exactly what those differences are. Something addressed later on in this article.

Let's look at how different they are.

### Shallow Legal Harness

In the legal industry almost all the companies dipped their foot in the Generative AI world by launching a legal assistant. It was the natural first step: using a conversational assistant to fetch legal sources, and generate answers based on these same sources.

A legal assistant was able to leverage companies' content compared to the embedded knowledge of LLMs and, because LLMs tend to hallucinate quite a lot and, in an industry where factuality is critical, it only made sense to have a legal research assistant. Something trustworthy.

A conversational legal research assistant works in a mostly unidirectional flow: user asks a question and gets an answer, based on sources. And that works well for that specific use-case: a user needs clarification.

If the goal is to extend it to create entire documents then the flow starts having flaws because the answer's intent is not to generate a document to be created. It may create a document with several pages - potentially even at double digits - but it doesn't scale to large documents. This is because a conversational assistant's goal is to generate answers - more than that is out of the initial intent.

Nowadays, UIs have improved and there are editing tools inline as well as several other strategies that *try* to improve the process. But even generating documents

Nonetheless, from a legal domain tooling standpoint, a conversational legal research assistant is simply one small piece of the lawyer's workflow. In reality, as discussed before in this blogpost, this workflow is composed of many tools.

![](legal-shallow-harness-v4.svg)

A single tool in this workflow is disconnected from the entire workflow. The legal research tool is fundamentally important and central to the rest of the workflow but lawyer's workflow is very much interconnected between the different phases. We'll get to that in a bit.

Recalling the diagram from before with the different layers of a harness, the legal harness's outer layer of a single workflow tool like the legal research assistant is rather shallow since the interaction with the system is mostly via an input and a chat history of this single-layered conversation: it's lacking the richness of the user harness that other tools provide (when properly connected).

Next, let's see how it looks like when (almost) all the tools are present. But most importantly, let's see an AI system's architecture that has been contemplated from the ground up in order to reflect the lawyer's workflow as closely as possible.


### Deep Legal Harness

On the other hand, a complete Deep Legal Harness contains everything that a lawyer's flow includes. And it's more than just a set of different agents. In this harness, the user layer is much more present and impactful to the system itself.

This is because the user can now interact with many different tools (typically represented by agents and sub-agents). Most importantly, the changes in one side of the system need to be propagated to the rest of the system, and then the system returns back: the feedforward and feedback mechanisms we've talked before.

How to make this system communicate between these tools - and to the user?

This is where the knowledge-base comes in, and it's probably the major defining factor between a deep and a shallow harness - within a legal context, of course.
This is what a deep legal harness looks like, from a high-level perspective.

![](legal-deep-harness-v3.svg)

For the sake of simplicity, there are parts (agents) being omitted in this chart, because it's much more complex than this. There are many more variables at hand that make the harness deep.

But even at a high-level, this chart is not enough to explain how the Deep Legal Harness works. We have to deconstruct into smaller parts to understand what makes a deep legal harness actually be considered deep.


## Knowledge-base: a third-dimension in data sources

In industries that rely heavily on proprietary content, there are typically two data sources:

- 1{{< sup "st" >}} data source: This includes proprietary but also non-proprietary content. In the legal industry the non-proprietary content can be laws, directives, verdicts and so on. The proprietary content may vary in this industry but it can include books from certain authors as well as notes from experts.
- 2{{< sup "nd" >}} data source: This includes the documents that users upload and then become part of the system.

Any harness can merge these two into the system, despite not being a trivial task when done right.

For example, an agent might want just *some* information from the 1{{< sup "st" >}} data source and *some* information from the second data source. That requires a refined selection of the most relevant information as well as a merge of these, by the agent. The output then becomes either the answer in a shallow harness or a document plus an answer in the deep harness.

But in an orchestrated workflow there's a new set of content being created. That's the content being created while the user interacts with this harness, including inputs, outputs and all communication between the different parts of a system. These parts of the system can be chat responses and generated documents.

This is the 3{{< sup "rd" >}} data source: the knowledge-base.

It contains **everything** that both the AI and the user have created in the harness. **Everything** means: all the queries by the user, all the answers by the AI system in every single phase, all the follow-up questions suggested, all the selections of the follow-up questions by the user, all the logic and internal decisions by the agents.

Only a deep harness with a well-thought knowledge-base has a complete picture of the system at a given point in time.

In the lawyer's flow, where they have to plan, do legal research, draft documents, it's impossible to keep track of all the changes to all the documents that have been done.

But in a deep legal harness, the AI has that capability, thus opening the road for an even better understanding of the system - superior to what a human has.

This creates an entire new world of possibilities that the AI can provide to the user. Here are some examples of what it can do:

1. Understand the user in a way that helps them find blind spots (for example) in the documents produced in that workflow;
2. Provide transparency to the user on the decisions by the system. For example, the reasoning in the answers to the user becomes much more concrete (and [verifiable](https://www.anthropic.com/research/reasoning-models-dont-say-think)).  
3. Provide much better suggestions resulting in a drastically more powerful and all-knowing human-in-the-loop;
4. Create "adversarial lawyering" scenarios where (for example) a defence lawyer can generate the documents a prosecution lawyer would create - and then compare and improve its own documents.

The list goes on.

The main take is that the knowledge-base handles a cognitive model bigger than the human. In this scenario, the AI system becomes a true companion to the user.


## Memory: a knowledge-base over time

I keep using Claude, and especially Claude Code, because of how it handles memory. It's a personal feature of that harness that simplifies and speeds up my work a lot. It has an ability to "understand" the most important parts of my interaction with the harness - and use it to improve my experience. Again, the feedforward and feedback mechanism visibly at play here.

If we think of the knowledge base as a picture of the system at a given time, then memory is the combination of all the pictures. It's a movie of everything that has happened over time.

![](legal-deep-harness-perspective-v4.svg)


In a shallow harness such as an assistant, the memory is usually the chat history of a session. Chat history can be considered a 3rd data source but it's a very thin data source. And it's limited to single-task shallow harnesses.

An assistant in a shallow harness has a narrow way of determining what the user wants by being limited to the chat history. The shallow harness may work in depth (ie, in a single task of a single tool), but rarely in breadth (ie, in several tasks over multiple tools).

A deep legal harness goes both in depth and in breadth: it's a complete understanding of the system.

An analogy to this depth and breadth is GitHub Copilot and Claude Code. In GitHub Copilot the user is typically editing a single file. Of course, the user can increase the scope of other files in order to edit a single file, but that's not memory. That's just context.

This is why Claude Code is so appealing: it's not just context but rather a combination of all the properties of a harness, working well together.

## Retrieval is different between sources

We saw before the three types of sources in a deep legal harness. Because sources are so different from one another, it's necessary to have different informational retrieval logic for each source.

This is because each type of source is parsed, indexed, and enriched in different ways. And that makes sense because they serve different purposes: an uploaded document serves a different purpose than the knowledge base, and so on.

In the diagram of the deep harness from before, there are retrieval steps (typically performed by agents) that have been omitted, in order to keep the simplicity of the document.

The reality is that those retrieval steps exist and they're essential. But most importantly, in a deep harness they have to be well-connected among them, since they need to retrieve content in the context of the harness, and not isolated from one another.

## Specialized agents

In the deep harness, the AI system becomes a combination of smaller, specialized agents. As each agent becomes more and more specialized, it narrows the need for larger and generic models.

For example: why have Claude Fable when potentially Sonnet or an open model can do the same task, potentially better, and even reducing costs?

For shallow harness, it's quite normal that there's a "large model" that does the heavy lifting of its tasks. But this does not scale in a workflow for two reasons:

1. You cannot put the content of three data sources into the context of an LLM and assume it scales.

2. In a legal workflow, the agents are very specialized. This means that there's no need for very big models to perform simple tasks. This is also why some companies (Harvey, Thomson Reuters, Noxtua, etc) are fine-tuning their own models. It's possible to get better answers for a fraction of the price (which  includes hosting and inference).

In a shallow harness, where the system is not composed of several agents specialized in smaller tasks, there's a heavy reliance on a large model to do the task. It would be an over-engineering task to try to fit smaller models to handle a relatively simple output.


## Communication is key

In a deep legal harness where there are several agents at play, it’s essential to have proper communication between them.

I find it interesting that, in the OpenAI hack of Hugging Face, the agents communicated among themselves via a message board that they found. Albeit a very different purpose, the agents used this message board as their knowledge base. And it worked quite well (for the agents).

A well-orchestrated set of agents in a deep legal harness AI system requires the communication to function properly - but not only: it's also how they operate. In other words, should they have a democratic decision process by using a voting mechanism for decisions or should it be a top-down approach where one agent decides and others just communicate status to the main agent? And these are to name a few options.

This problem is almost inexistent in a shallow harness too. There are so few agents in the system already that the operation mode is not a problem. At most, there’s a routing agent redirecting tasks to the right agent, but the flow happens in a unidirectional way, as we’ve mentioned before in this blogpost.

A side note: the OpenAI hack was very interesting, despite being a case where the agents went completely out-of-control. It gave a peek on how these agents would operate in a scenario like this but it was also a good lesson on how to implement even further guardrails on how to secure AI systems. I recommend this video/podcast episode: a +2hour talk with a researcher on the details of the attack. https://www.youtube.com/watch?v=X50zezLFWWI


## Evaluation

For a large majority of systems, evaluation is typically made by scoring the inputs and outputs of the AI system, based on a golden dataset with questions and answers.

In a deep legal harness AI system, evaluation needs to be compartmentalized in order to be evaluated. And at the same time, the system needs to be evaluated as a whole.

So how can a system be evaluated in a compartmentalized way? You have to break the system into a 1000 pieces - and only then evaluate each part and the system as a whole.  

The agents should be evaluated at an individual level: their inputs, their outputs, and every step in-between. Even every decision process needs to be evaluated. Luckily, some of these processes can be automated and scored in a deterministic way. Others rely on LLMs for these evals. And lastly, some rely on human manual supervision.

The rule of thumb I have been using is to identify the critical parts of the system (ie, agents that have more complexity and responsibility) and set a higher number of safeguards around those: deterministic, non-deterministic and manual.

Because AI-based legal applications are domain knowledge-heavy, I expose legal domain experts to be as comfortable as possible to tools like LangFuse in order for them to understand the system - both as a whole as well as each individual part of it.


## Conclusion

I've now created and worked with harnesses in production that are both shallow and deep. One obvious learning is that, in the legal domain where the application needs to mimic lawyer's flow, we're looking at a complete shift from going from a shallow harness into a deep harness. One thing is to work in a single step of the lawyer's flow; another completely different is to work on the entire workflow mostly because it's the result of the interaction of the tools (and the tools with the user).

Another learning is that the deep harness AI systems are capable of an understanding of the user that is potentially even higher than the user itself. This opens the road for several risks and opportunities. That's why a deep focus on evaluation and inclusion of stakeholders in that process is fundamental for the understanding and control of these systems.

Lastly, there's a lot of value in building a custom harness. It provides an understanding of the system that a generic harness cannot give - regardless of being shallow or deep.

