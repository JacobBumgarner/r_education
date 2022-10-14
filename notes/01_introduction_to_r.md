# Introduction to R

## Getting R Installed on VSCode
Here are the steps that it took for me to get R installed on my Mac and working with VSCode. I'm working here from a Mac that already has Python installed and managed via `homebrew` -> `pyenv`.
1. Install R
2. Install the following VSCode Extensions
    - R (REditorSupport)
    - R Debugger
3. Install `radian` in a clean Python environment
    - I've created a 3.10.2 shell
4. Toggle the following settings for the R extension ("cmd+," to view settings")
    - Enable R: Always Use Active Terminal (important for radian)
    - Enable R: Bracketed Paste


## Project Workflow
Typical data science projects have the general model below. Data are first input, organized (tidied), understood iteratively, and then communicated.

1. Import
2. Tidy
3. Understand
    1. Transform
    2. Visualize
    3. Model
4. Communicate

## Running R Code
I'm planning on writing all of my R code into .R scripts and then sending the code to a `radian` terminal.

Prior to writing and running any code, a terminal should be opened, the R python shell should be activated, and the `radian` console should be opened.

To run a single line from a script, I use the following command:

 - "cmd+;"

To run an entire script in the active terminal, I use the following command:

- "cmd+shift+;"