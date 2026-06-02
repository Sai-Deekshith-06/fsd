# SDLC (S/w Dev Life Cycle)

1. Requirements Gathering
	- SRS (S/w Requirement System)
2. Design
	- Types:
		1. LLD (Low Level Design) => How exactly will each part work?
			- Class Diagram, DB tables, API endpoints, Function-level logic
		2. HLD (High Level Design) => How the entire system organised?
			- Architecture Diagram, System Flowcharts
3. Development
	- Actual coding of the app takes place here.
4. Testing
	- Verify and validate the developed s/w to ensure it is free from bugs and meets the requirements.
	- Objectives
		+ Identify and fix bugs
		+ Ensure system meets requirements
		+ Validate functionality and performance
		+ Improve s/w quality
	- Unit testing, Integration testing, Acceptance testing (done by clients)
5. Deployment
	- User acceptance testing (Alpha testing, Beta testing)

# Version Control Systems

- Version is a saved snapshot(state) of your file/project at a particular point of time.
- Types: 
	1. Local(RCS-Revision Control System)
	2. Centralised(Subversion-SVN, Perforce-Helix Core)
	3. Distributed(GitHub, Bit Bucket)

# Git
- Git is a distributed version control system that allows multiple developers to work on a project simultaneously, tracking changes and managing versions efficiently.
- Stages of Git:
	1. Untracked: Files that are not being tracked by Git.
	2. Tracked: Files that are being tracked by Git.
	3. Staged(buffer zone): Files that have been added to the staging area and are ready to be committed.
	4. Committed(snapshot): Files that have been committed to the local repository.

- Working Dir -> Stagging area -> Remote Dir
- push, pull, add, commit, merge, switch, status, log, checkout
- `git log --oneline`

# Day 2

## Rollback:

- reverting to a previous state, undoing commits that have been made. It is used to fix mistakes, recover from errors, or undo unwanted changes.
- HEAD points to the provided commit-hash.

1. Reset: moves the HEAD to a specified commit, discarding all commits that come after it. It can be used to permanently undo changes.
a. Temp Rollback:
	`git checkout <commit-hash>`
b. Permanent Rollback:
	- Soft: changes are kept in staging area and working directory
		`git reset --soft <commit-hash>`
	- Mixed:changes are kept in working directory but not in staging area
		`git reset --mixed <commit-hash>`
	- Hard: changes are not kept in staging area and working directory
		`git reset --hard <commit-hash>`

2. Revert: creates a new commit that undoes the changes made in a previous commit
	`git revert <commit-hash>`

- Revert vs Reset:
	- Revert is a safe way to undo changes, as it creates a new commit that can be easily undone if needed. Reset, on the other hand, permanently discards commits and can lead to data loss if not used carefully.

## Fetch and Merge: