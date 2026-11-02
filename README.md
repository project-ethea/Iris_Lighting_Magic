Iris’s Lighting Magic
=====================

This is a small [Wesnoth](https://www.wesnoth.org/) game modification add-on that allows you to apply the `[color_adjust]` and `[screen_fade]` effects to the game map directly through a context menu option, without needing to reload WML/Lua every time.

## Purpose

This modification only deals with visual effects. It does not impact gameplay in any way, and is specifically aimed at content authors who want to quickly test visual effects in the middle of a scenario without editing their code and restarting. In particular, I wanted to make up for the fact that these days the Map Editor only lets you preview ToD shift effects when editing a **scenario** (as opposed to a pure `.map` file).

## Usage

When enabled in single or multiplayer mode **with debug mode enabled** (`:debug` or the `-d/--debug` command line switch), this modification adds a context menu entry that can be used to access a dialog with options to alter the game map effects. Use the ✓ button to apply the change immediately, and the × button to close the dialog.
