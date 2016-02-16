# chpython

Changes the current Python.

It's useful when you have multiple Python installations that you want to
seamlessly switch between.

## What does it do?

**chpython** lets you switch easily between different versions of Python that
you have installed in `~/.pythons`. It switches between them by:

* Updating `$PATH`.
* Aliasing `*3` bins to their basename (e.g., `python3` can be called using
  `python`) _(not implemented yet)_.
* Calling `hash -r` to update the command-lookup hashtable.

You can return to the default (system) Python by calling:

    $ chpython system

Calling `chpython system` will completely restore the environment you had
before calling `chpython VERSION`.

You can also execute a command using any installed version of Python, without
updating `$PATH` or any other environment variables, by calling:

    $ chpython exec VERSION args...

For example, you can call `python -V` on an ancient version of Python you have
installed for some reason:

    $ chpython 2.5 python -V

**chpython** supports fuzzy matching of Python versions, so `chpython 2.7`
will execute the latest version of Python 2.5 it can find. You can also
specify a full version: `chpython 2.7.10`.

## What does it not do?

**chpython** does not:

* Hook into `cd`.
* Install executable shims (like [pyenv]).
* Does not muck with your prompt or anything but the `$PATH` variable.

## What does it require?

* bash (it may work with zsh, but I haven't tested it)

## How do I install it?

1. Clone the repository (`git clone
   https://github.com/mdippery/chpython.git`).
2. Copy or symlink `share/chpython/chpython.sh` to
   `/usr/local/share/chpython`, or anywhere else you feel like putting it. Or
   keep it where it is after cloning the repo, I don't care.
3. Add `source /where/you/put/share/chpython/chpython.sh` somewhere in
   `~/.bashrc`.
4. Optionally, set a Python version by adding `chpython VERSION` to your
   `~/.bashrc` file. If you don't do this, your system's Python will be used
   by default, but you can use a different Python on a per-shell basis by
   calling `chpython VERSION` manually.

## Why not virtualenv?

Virtualenv is a great solution for setting up a specific Python version to use
on a per-project basis, but I have never liked using it to set a default
python to use for "everyday" scripts in my shell, since it involves setting up
a "global" virtualenv anyway.  I also don't like how the default virtualenv
`activate` scripts mucks with things in my environment, such as `$PS1` (and
virtualenv's default `$PS1` is _ugly_). Generally speaking, pointing your
shell to a "new" Python is as simple as adding its `bin` directory to your
`$PATH`; nothing else is needed if you installed it normally.

I compile versions of Python to use by default in my shell to `~/.pythons`. I
wanted a quick way to switch between different versions, and was inspired by
[chruby] to write a bash script to handle that switching seamlessly for me.

  [chruby]: https://github.com/postmodern/chruby
  [pyenv]:  https://github.com/yyuu/pyenv
