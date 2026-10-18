---
title: 'Thick Harness vs Thin Harness'
summary: 'While the industry is moving from single-action assistants to orchestrated workflows. No AI was used to write this article.'
showtoc: true
tocopen: false
draft: true
date: '2026-09-10'
---

## Intro

When we first saw ChatGPT's launch in November 2022, we were able to interact with it via a chat interface. Today, we've gotten used to interfaces that, while still being somewhat conversational, they're much richer than before. Richer means that there's many more integrations to systems and also even within the same system it's much more complex. We have agents and subagents, connectors, memory and so on.

In this post, I'm diving deeper into the differences between systems that, while have historically improved in depth, have now moved to systems that have breadth **and** depth.

Let's talk about harnesses. While this post is focused on legal harnesses, it includes an introduction to the term and functionaly of these.


## Harness

If you work with AI, you've probably seen the "Harness" term before. Even in the context of AI engineering it's a relatively new concept and you're not alone if you're confused on what does it actually mean.

Within this context, it's possible to trace this term back to a LangChain [blogpost](https://www.langchain.com/blog/the-anatomy-of-an-agent-harness) which defines it as:

>"Agent = Model + Harness. If you're not the model, you're the harness."

In other words, a harness is everything *around* the model. Some authors have extended this definition to: "Without a harness, you have a chatbot. With one, you have an agent." [source](https://happycapy.ai/blog/harness-engineering-guide).

Nonetheless, my favourite definition of harness lives in a blogpost at [Martin Fowler's website](https://martinfowler.com), by [Birgitta Böckeler](https://birgitta.info/) and called "[Harness engineering for coding agent users](https://martinfowler.com/articles/harness-engineering.html)". More than words, the following visualization helps distinguish the different layers of an agent:

![sup](https://camo.githubusercontent.com/9fd17bdd8fe60c51a31a9224d1c6563cc04935f16213088955afe450a55e6c4f/68747470733a2f2f6d617274696e666f776c65722e636f6d2f61727469636c65732f6861726e6573732d656e67696e656572696e672f6861726e6573732d626f756e6465642d636f6e74657874732e706e67)

The main reason why this visualization is particularly on point is the distinction between "user harness" and "builders harness". This distinction is particularly important in this blogpost, since it determines the value of the user harness in the context of the legal domain-oriented harness. I'll get to that later on.

### User harness

This outer harness has the goal of increasing the system quality, by implementing feedback mechanisms which in return "increase the system quality, all with the added benefit of fewer wasted tokens along the way." In other words, the user harness is capable of increasing a system quality as a result of consistent human steering of the system itself.

If this still sounds complex, keep reading. It will make sense later on, I promise.

### Inner harness

Claude Code is a good example of a builders harness. This inner harness may contain several distinct properties. Per the LangChain post, it can have:

> - System Prompts
> - Tools, Skills, MCPs + and their descriptions
> - Bundled Infrastructure (filesystem, sandbox, browser)
> - Orchestration Logic (subagent spawning, handoffs, model routing)
> - Hooks/Middleware for deterministic execution (compaction, continuation, lint checks)

This volume of properties in a harness determines its "thickness", meaning more properties are the foundation of a thicker harness. And despite some of these properties are for an agentic coding context, some of them can be generalized to other fields.

That's why I'm taking the freedom to bridge this into the legal domain field.

## Legal Harness

### The lawyer's flow

In order for this bridge between agentic coding and legal domain to happen, a brief intro to the the laywer's flow is needed.

Typically, the main phases of the work of a legal practicioner are intake, planning, research and drafting.

For example, let's assume a lawyer is working on a case. The lawyer needs to collect all the information relevant to that case (that's typically information that is provided by the client but not exclusive). That's intake.

In the planning phase, the lawyer is building a plan for subsequent actions like legal research and drafting.

When in the legal research phase, the lawyer looks at the different legal sources (laws, verdicts, directives, etc) that can be applicable to a case. Once ChatGPT came out, there was a clear use-case for legal assistants - and this is were the boom for startups in the legal industry started. A GenAI legal assistant was the obvious route in the beginning.

The drafting phase is where the lawyer produces a document, which can include information from all the other phases. It's the combination of all the accumulated knowledge whithin this case.

This is not a linear flow: the lawyers go back and forth between the different phases.


## Legal Thin Harness

In the legal domain, products tend to reflect different phases of the legal practicioner. Just like the legal practioner which starts its cases typically with the legal research, most of the products offered by companies did start with legal assistants, which typically

- Single trajectory of decisions
- Unidirectional flow
-

## Legal Thick Harness

- Diagram of the all the phases of the lawyers workflow: intake, planning, research and drafting all talking to each others.
- Diagram should include the data source for proprietary content

## Knowledge-base: a third-dimension in data sources

In industries that rely heavily on proprietary content, there are typically two data sources: the proprietary content itself and the content the user uploads. Both in thic

But in an orchestracted workflow there's a new set of content being created. That's the content being created while the user interacts with this harness, including inputs, outputs and all communication between the different parts of a system.

Here's a comparison between the thin harness and the thick harness (diagram):


## Specialized agents and subagents - the end of the "larger models"

There's no large model but rather having small specialized agents. You don't see this in the image but there are more agents which would split the tasks of the larger agents into smaller ones. This is why you can start thinking about smaller models and move away from the "you need larger models" - which you don't. This mindset of subagents is also responsible for enabling the possibility of smaller models - including local models - being used for these smaller tasks. It's only when there has been exposure to these subagents which are specialized (menaning, low amount of tools) that one can understand that larger models are not needed anymore - it's a thing of the past.

## Communication is key

When having all these agents and sub-agents, it's essential to have proper communication between. I find it interesting that, in the OpenAI hack of Hugging Face, the agents found a way to communicate among themselves via a message board that they found. Albeit a very different purpose, in this case the knowledge-base is that message board. But the communication between agents is still a tough nut to crack. There are several frameworks that can do that but at the same time there are papers saying that we should be careful with this -- explain why and which paper(s) --.

## Memory: a knowledge-base over time

When a system made of interactions between it's different components, it becomes obvious on why memory becomes relevant. As a personal anecdote, I find it interesting that one of the things that makes me stay using Claude and especially Claude Code is memory. It's a personal feature of that harness that simplifies and speeds up my work a lot.

As a human, it's very hard to keep a mental model of everything that has happened within a given session. That means all the changes that happened for every single file change, at any moment in time.

In a thin harness such as an assistant, the memory is usually either the chat history or the combined chat history. But an assistant is a narrow way of determining what the user wants. It goes in depth and less in breadth.

A thick harness goes both in depth and in breadth. And a memory now has a birds eye view.

A good example of this is Github Copilot vs Claude Code. In Github Copilot the user is typically editing a single file. of course, the user can increase the scope of other files in order to edit a single file, but that's not memory. That's just context.

## Evaluation

In a thin harness, because it's a unidirectional and unidimensional flow

## Information retrieval

All interactions between the user and all the content produced and edited in a thick harness - what call in this post the "Third dimension of data source" can be used to fetch more information from the two primary sources of information. From a legal accuracy standpoint this creates a system that understands what the user is doing and potentially help where the user needs to go. All this by understanding what the user did while interacting with this thick harness.

## Conclusion

All these things combined create a thickness of the harness that not only improves the system by looking at it as whole, but also creates intelectual property that other harnesses cannot have, especially thin ones. Simply because they don't have t

---

<!-- markdownlint-disable MD024 -->

## Loose Notes

When all you have done is work in a single assistant, youll miss the benefit of memory and even local models.
12:20 PM

it only works from the ground up, not when an assistant is expanded into a workflow tools. that would be the same as building an isolated component and try to force every other tool into this component

evaluation is unidimensional in the assistant

an assistant is reactive

a workflow tool is proactive - many tasks can be done offline, where it can analyse the system as whole
8:27 PM

when comparing a thin harness vs a thick harness think of copilot vs claude code; think of claude.ai answers VS claude cowork
8:34 PM

the thick harness is a bi-directional path of decisions whereas the single agent is a unidirectional path of a single decision

---

## Definitions

- Define the context
  - legal industry
  - although a few things generalize from the legal industry to the rest
  - A legal workflow tool contains (at least) a research, drafting, a planning and an intake tools

### Assistant

- Conversational assistant, mostly for research
- One LLM for the heaviest task, often using a typical loop-call

### What is a harness

### Orchestrated tool

- Think when claude code spawns a team of agents
- introduce graph engineering

## Changing the mindset

- from single-task assistant to workflow tool
- It's a comparison between

## There is no planning in a legal assistant, so it's not a harness

## The 3rd data source

- Explain what other sources are there first
- Explain what is the 3rd data source
- They create, change and interact with generated artifacts
- Include a diagram
- moat creation

## Specialized coordinated agents vs one-size-tries-all agent

## Memory

- Memory compression is, in a single task assistant, most of the times unnecessary. And when it exists, it's not necessary complex. In an orchestrated set of agents

## The single-task mindset

- Because one big model is used, it's a misconception that large models cannot be replaced with local models. But in a workflow, agents are way more specialized
- When you have a single-tasked set of agents it's easy to rely on one big model to basically do the heaviest task. In an orchestrated set of agents, the tasks are much more specialized, so the need for heavier models
- The ones who don't understand orchestrated agents missunderstand the power of specialized models, which then opens the road for the usage of local small finetuned models. The single-taskers are typically against local models and are usually the reason why local models' proponents

## Conclusion

- Workflow allows for better depth and bredth
- The complexity increase comes by nature, but when you isolate components it becomes actually easier understand each of the agents, specially if they can be traced properly - something that I'll write about in the future.
