---
layout: post
title: "Continuous Integration - Setting webhooks and deploy keys on gitlab"

meta:
  nav: blog
  author: morpheyesh
  pygments: true
  mathjax: true
---

You have your own CI tool in place? Or planning to build some kinda of a internal build system?  Ever wondered how CI tools like travis, drone and jenkins work when you do a git push? This post will talk about setting up webhooks and deploy keys on gitlab.

<!-- more -->


## What the heck is a webhook?

Well, webhook is a simple event-driven HTTP notification system. When a particular event is triggered, the system does a HTTP POST to a given endpoint. This is a powerful HTTP Push API that is useful in systems that does not need a constant poll and it is asynchronous. This is generally called a reverse API, since you provide a URL to the system and when an event occurs, an action triggers the webhook and the JSON is received and processed.  You can go to setting on github or gitlab, look for webhook and you can create one there.

If you are still confused, write a basic http server and run it on a cloud instance, go to github and create a webhook, provide the URL of your instance and then do an action like `git push` to the repo, make sure you decode the json and print it on your server. You should be able to see that the server has sent data about the repo you just pushed along with the `Event: Push`. Webhooks can be used to build event-driven systems. Example: you could write a bot which is connected to n number of repos on github, and for every action that is made like pull request, code push, issues, etc., the webhook system triggers a HTTP call to the bot's API, and the bot then depending on the event, can perform what ever is necessary.

Webhooks are a great API design patterns, we will look at extending gitlab API to create a webhook on gitlab. We will be using `github.com//go-gitlab` API to do so. I implemented this in one of the automation tools I built for a company which involved complex CI flows.

### Creating a webhook

Lets cut to the chase, the following code example is used to create a webhook,

```go

func createGitLabHook(opts *webhookOpts) (string, error) {

	client := gitlab.NewClient(nil, opts.token)

	log.Debugf(" [gitLab] client (%s)", opts.token)

	p := &gitlab.AddProjectHookOptions{
		URL:        opts.triggurl,
		PushEvents: true,
	}
	_, _, err := git.Projects.AddProjectHook(opts.fullname, p)
	if err != nil {
		log.Printf("[gitlab] Error in creating webhook")
	}

```

The `createGitLabHook` takes an `webhookOpts` struct object which contains all the necessary data for creating the webhook. On line 3, new client is created by passing the gitlab access token with which the webhook on the private repo can be created. `AddProjectHookOptions` takes various options, but the most important is trigger url. Remember, the trigger url is used by the system to send the request.
The repo's full name - `morpheyesh/randomproject` and the project hook opts are two arguments passed to `AddProjectHook`for the webhook to be created.


### Deploy keys

TBD


### creating deploy keys


TBD
