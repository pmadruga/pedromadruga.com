---
title: "Thick Harness vs Thin Harness"
description: "This is a summary."
showtoc: true
tocopen: false
draft: true
date: "2026-09-10"
---






---

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
