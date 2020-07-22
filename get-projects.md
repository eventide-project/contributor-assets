<img src="https://s3.amazonaws.com/media.eventide-project.org/eventide-icon-100.png" />

# Downloading the Eventide Project Code

The `get-projects.sh` script will clone or pull all project repositories to your device.

## Clone or Pull

If the working copy directory is not in the project directory, the repository will be downloaded via `git clone`. If there is a corresponding working copy, the working copy will be updated via `git pull`.

## Eventide Directory

Create a directory that will be the parent directory for all of the Eventide libraries and tools. All repositories will be cloned into this directory.

It's common to use the directory name, "eventide", but it can be any name you like.

The rest of this document assumes that the directory is named, "eventide".

Create the directory:

`mkdir eventide`

And then change directory into this new directory.

`cd eventide`

## PROJECTS_HOME Environment Variable

In order for the `get-projects.sh` script to work, you must set am environment variable.

The `PROJECTS_HOME` environment variable must contain the path to the "eventide" directory that you created (above).

For example, for a project directory in your home folder:

`PROJECTS_HOME=~/eventide`

You can set the variable in your current shell, on the command line when you execute the script, or in your shell profile scripts using `export`:

`export PROJECTS_HOME=~/eventide`

## Clone the "contributor-assets" Repository

From the "eventide" directory

`git clone git@github.com:eventide-project/contributor-assets.git`

## Change Directory to the contributor-assets Directory

`cd contributor-assets`

## Run the Script

From the command line, within the "eventide" directory:

`./get-projects.sh`
