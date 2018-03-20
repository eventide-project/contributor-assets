<img src="https://s3.amazonaws.com/media.eventide-project.org/eventide-icon-100.png" />

# Eventide Contributor Guide

## Getting Started

### Community Protocols

Review the Eventide community protocols:

[https://github.com/eventide-project/contributor-assets/blob/master/community-protocols.md](https://github.com/eventide-project/contributor-assets/blob/master/community-protocols.md)

### Contributor Bill of Rights

Read the Eventide project's contributors' bill of rights:

[https://github.com/eventide-project/contributor-assets/blob/master/bill-of-rights.md](https://github.com/eventide-project/contributor-assets/blob/master/bill-of-rights.md)

### Get to Know the People in the Community

The members of the Eventide community are the best resource for getting oriented to making contributions to the project. The members of the community gather on the project's Slack workspace. Join the workspace at:

[https://eventide-project-slack.herokuapp.com](https://eventide-project-slack.herokuapp.com)

### Familiarize Yourself with Eventide Concepts

The Eventide website lists the principal features and parts of the toolkit. Familiarize yourself with the terminology and concepts of Eventide and evented, autonomous services:

[https://eventide-project.org/features](https://eventide-project.org/features)

The website also provides some basic examples of using the toolkit's features:

[https://eventide-project.org/introduction](https://eventide-project.org/introduction)

A complete list of Eventide's constituent libraries and tools can also be found in the project's website:

[https://eventide-project.org/libraries](https://eventide-project.org/libraries)

### Get the Contributor Assets Tools

We maintain a set of tools and scripts to help work with Eventide's constituent libraries and tools.

The repository for these tools is `contributor-assets`, and can be browsed on GitHub:

[https://github.com/eventide-project/contributor-assets](https://github.com/eventide-project/contributor-assets)

First, get the `contributor-assets` tools:

Make a parent directory, `eventide` for example, into which you will clone the Eventide repositories, including `contributor-assets`.

`mkdir eventide`

And then change directories into this new directory.

`cd eventide`

Clone the `contributor-assets` repository:

`git clone git@github.com:eventide-project/contributor-assets.git`

### Get All the Code

Read the for instructions on how to use the `contributor-assets` tools to get all of the Eventide code onto your machine:

[get-projects.md](https://github.com/eventide-project/contributor-assets/blob/master/get-projects.md)

## Expectations

### Standards Aren't Optional

There's very little in the Eventide project codebase that doesn't adhere to standards and practices. Everything you see is the code is done purposefully. The code isn't a patchwork of individual styles, and new contributors don't have license to inject personal style.

The project's standards are not written down. They can be learned through observation and from the guidance of the project principals that you will work with at the outset of your contributions.

Do your best and learn as you go from the observations you're making about the code and libraries that you're working with.

### Get Familiar With the Code Style

Take a look at some of the projects, and take note of the file system structure, namespacing, loader files, executable objects, class interfaces, object interfaces, initializers, meta programming style, and more.

The consistency of the style isn't accidental. Familiarize yourself with how code is constructed throughout the Eventide toolkit.

There is some amount of drift with libraries written in different periods of the project's maturation, and we prefer to address these inconsistencies as problems rather than be permissive with them.

If you find inconsistencies, bring them up. They may be subjects for improvement. If you can improve the standards, bring that up, too.

### Get Familiar with the Test Style

Eventide's project principals have considerable experience in software testing above and beyond just the subset of testing that is "developer testing". If you see things that are not familiar to you in your work in developer testing, dig in and endeavor to expand your understanding of testing beyond what you might have been exposed to so far.

If you have no exposure to semi-automation and "autonomation", doing some study in this area of production engineering will serve you well - and not just in your work in the Eventide project.

There are many more things to become aware of than you will have been exposed to in, for example, Ruby on Rails work. We are often wont to say that if you learned software testing - and even developer testing - in the context of Ruby on Rails, then you have learned only a bare minimum.

Pay attention to how testing is categorized as "automated" and "interactive". Explore the "controls" namespaces and their use. And note that there are no mock objects used in the construction of the Eventide toolkit. That's not because we don't understand and have extensive experience with these things, but that the patterns and practices of Eventide development represent a level of maturity and experience that comes after things like "mock objects", "factories", "fixtures", and the like.

## Your First Contribution to an Eventide Issue

### Know the Meanings of the Issue Labels

All of the Eventide repositories use a standardized set of issue labels that are the same in each of the repositories.

Read the labels document:

[https://github.com/eventide-project/contributor-assets/blob/master/contributor-guide/labels.md](https://github.com/eventide-project/contributor-assets/blob/master/contributor-guide/labels.md)

### The "entry level" Label

Issues that we _presume_ to be a good fit for someone new to the project are labeled "entry level".

This label is just a hint. You might find another issue that is a better fit for you that is not labeled "entry level".

You're not restricted to just the issues that we think are a good for you. Your contributions are still subject to approval, after all, and project principals attention is of course subject to availability.

### Review Outstanding Work Items

The Eventide Project uses GitHub issues to track current work.

You can see the "entry level" work items for the whole of the Eventide project at:

[https://github.com/issues?q=is%3Aopen+is%3Aissue+user%3Aeventide-project+archived%3Afalse+label%3Aentry%20level](https://github.com/issues?q=is%3Aopen+is%3Aissue+user%3Aeventide-project+archived%3Afalse+label%3Aentry%20level)

You can view all of Eventide's work items at:

[https://github.com/issues?user=eventide-project](https://github.com/issues?user=eventide-project)

### Communicate Your Interest in a Work Item

Talk to the project principals either on the project's Slack workspace, or by commenting on the GitHub issue.

If you're using the Slack workspace, use the #development channel on Slack for these kinds of conversations.

Project principals will provide detailed explanations and background for the item.

Principals will also provide any necessary guidance, as well as on-going and final review.

## Process

### Development

- Create a fork of the library (or libraries) that the issue that you're working on affects
- Work on your fork
- Communicate progress through the Eventide Slack workspace
- You'll receive guidance and support from project principals, including pairing via remote screen sharing, chat sessions, email, and whatever media supports momentum
- When the work is complete, submit a pull request
- Final review will be done on the pull request, but since review has been taking place incrementally and progressively, the final review should be low-impact

### Release

- Work with the project principals to write up a description of the changes that your work introduces
- When the change is ready for release, the project principal will increase the version, and commit that change
- Version number changes are always made in their own commits with no other changes
- The project principal will create a new Gem package and publish it to RubyGems.org

## More Reading

The following resources are not required reading, but you may find them helpful.

### Doctrine of Useful Objects

The overall design and implementation ethos is explained in the Doctrine of Useful Objects article. The article is published in a repository that includes example code.

Read the article at:

[https://github.com/sbellware/useful-objects/blob/master/README.md](https://github.com/sbellware/useful-objects/blob/master/README.md)

### Project History

Read more about the project's history on the Eventide website:

[https://eventide-project.org/history](https://eventide-project.org/history)
