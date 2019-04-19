## Usage

Directories in here are meant be symlinked to the HOME directory with [`stow`](https://www.gnu.org/software/stow/):

```
$ cd project/root
$ stow -t ~ vim
```

## Changing color scheme

Color schemes are configured in many places. I should probably DRY that up at some point (perhaps through templates), but in the meantime here is a list for reference:
  * termite
  * vim
  * sway
  * waybar
  * rofi
