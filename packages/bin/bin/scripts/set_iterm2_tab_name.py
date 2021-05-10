#!/usr/bin/env python
import argparse

import iterm2

def get_args():
    parser = argparse.ArgumentParser(description='Set the tab name')
    parser.add_argument('name')
    return parser.parse_args()

ARGS = get_args()

async def main(connection):
    app = await iterm2.async_get_app(connection)
    window = app.current_terminal_window
    if window is not None:
        tab = window.current_tab
        await tab.async_set_title(ARGS.name)
    else:
        # You can view this message in the script console.
        print("No current window")

iterm2.run_until_complete(main)

