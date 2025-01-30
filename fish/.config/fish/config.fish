fish_add_path ~/.local/bin
fish_add_path ~/.local/share/npm/bin

set -Ux WAKATIME_HOME ~/.wakatime
set -Ux XDG_RUNTIME_DIR /tmp/runtime-$USER
set -Ux npm_config_cache ~/.cache/npm
set -Ux npm_config_prefix ~/.local/share/npm
set -Ux npm_config_userconfig ~/.config/npm/config

if status is-interactive
	source ~/.config/aliasrc

	# vi mode
	function fish_user_key_bindings
	    # Execute this once per mode that emacs bindings should be used in
	    fish_default_key_bindings -M insert

	    # Then execute the vi-bindings so they take precedence when there's a conflict.
	    # Without --no-erase fish_vi_key_bindings will default to
	    # resetting all bindings.
	    # The argument specifies the initial mode (insert, "default" or visual).
	    fish_vi_key_bindings --no-erase insert
	end
	set fish_cursor_default block
	set fish_cursor_insert line
	set fish_cursor_replace_one underscore
	set fish_cursor_visual block

    # # tmux
    # if test -z "$TMUX"
    #     exec tmux
    # end
end

if status is-login
	pgrep Xorg || sx
end

fish_add_path /home/salastro/.spicetify
