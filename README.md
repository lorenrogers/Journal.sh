# Journal.sh
## Description

This is a simple helper script that makes journal entries in your Jekyll
blog. All it does is create a new post with today's date and pre-populates
some YAML. The neat part about it is that you can add it to your shell
and call it from anywhere. (E.g. using an alias or something.)
I set up `j` to call this script, so I can get right to todays entry in two
keystrokes!

The script handles all the logic for you, so you don't need to worry about
whether or not you've already made an entry for today. It'll open it if 
it already exists.

## Installation

Just clone this repo (or download the script) and edit the user variables
at the top. (Instructions are included in the comments.)

If you're starting from scratch, you'll need a 
[Jekyll blog](http://jekyllrb.com/) first.
Then you can link up this script to wherever you keep your blog.

### Alias for awesomeness

You'll probably want a dead-simple way of opening your journal.
Thankfully, this already exists. Just set up an alias in your shell's
config folder. 
If you don't know what this is, you're probably using BASH. 
In which case this would be `~/.bashrc`.

Personally, I like ZSH, which adds some nice functions to BASH.
Here's what my `.zshrc` file currently looks like.

    alias j="journal.sh"
    PATH=$PATH:/home/lorentrogers/bin/journal.sh

Or, a simple way to include this would be:

    alias j="/path/to/journal.sh/journal.sh"

## Usage

(TODO: Add output from --help)

## Contributing

It's still a work in progress, so much of the script is hard-coded for my
setup. If you feel like contributing, please help generalize things!
(E.g. pulling things out into config variables, etc.)

## LICENSE

The MIT License (MIT)

Copyright (c) 2015 lorentrogers

Permission is hereby granted, free of charge, to any person obtaining a copy
of this software and associated documentation files (the "Software"), to deal
in the Software without restriction, including without limitation the rights
to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
copies of the Software, and to permit persons to whom the Software is
furnished to do so, subject to the following conditions:

The above copyright notice and this permission notice shall be included in
all copies or substantial portions of the Software.

THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN
THE SOFTWARE.


