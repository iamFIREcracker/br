# br

Simple tool to send a URL to your default browser -- it works from within SSH
sessions too!

# Backgroud

My life as a developer is a mess: at work I have a laptop with Windows 7 and
Cygwin installed; I also have a Vagrant box, running Ubuntu, that I use to do
the most of my development work.  At home I have a Macbook Air, with Mac OS
Sierra.

I have been a Vim user for years, but only recently I discovered the `:Gbrowse`
command from the awesome [vim-fugitive](https://github.com/tpope/vim-fugitive)
-- but of course it wasn't working from within a remote session as which
browser should it try to open the URL with?

Wouldn't it be nice if I could read from the OS clipboard, or write to it,
using a single command line tool? And wouldn't it awesome if the same tool
worked on various operating systems? (at least the ones I use on a daily basis)

I had already built [cb](https://github.com/iamFIREcracker/cb) in the past, so
I thought maybe I can re-use some if it and build something that would make
`:Gbrowse` work fine, even when working remotely.

_enters `br`.._

# Installation

Clone the repo, and run `make install`:

    mkdir -p ~/opt/
    cd ~/opt
    git clone https://github.com/iamFIREcracker/br.git
    cd br
    PREFIX=~/local/bin make install

# Usage

Opening a URL from the command-line is as simple as:

    > br https://google.com

Fucking A...but haven't `open`, `cygstart`, `xdg-open` been doing this for
like, years?  Correct, and from this point of view, `br` is just a wrapper that
based on the OS would call the right command.  However, this is not the reason
why `br` was born; the following is:

    > br --listen

This will start a daemon, listening on port 5557 (it's the default, but you can
change it by overriding the `BR_REMOTE_PORT` env variable) for commands to
_open_ a given URL with the default browser.  You might wonder: what's so good
about it?  Well, you can run it on your host machine (ie. the one with a OS
clipboard), change the ssh commands you use to log into your remote dev boxes
to do some port forwarding magic:

    > ssh -R 5557:localhost:5557 devbox ...

And that's it, running `br https://google.com` from the remote host (well, you
will have to get `br` installed there too..) will now get the specified URL
opened in the default browser on the host machine.

# Git integration

Want `git web--browse` to run `br`?  Add the following to your .gitconfig:

```
[web]
    browser = br

[browser "br"]
    cmd = br
```

# Vim integration

Adding the following to your `.vimrc`, to get `<leader>O` to send to `br` the
selected text (you better select a URL):

```vimscript
function! g:FuckingOpenTheUrlPlease()
    let view = winsaveview()
    let old_z = @z
    normal! gv"zy
    let url = @z
    echom url
    call system('br '.url)
    let @z = old_z
    call winrestview(view)
endfunction

vnoremap <leader>O :<c-u>call g:FuckingOpenTheUrlPlease()<cr>
```

While the following sets the default `netrw` browser command to be `br` --
finally `:Gbrowse` will start behaving again, even inside remote sessions:

```vimscript
let g:netrw_browsex_viewer = "br"
```
