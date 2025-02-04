#ifndef CONFIG_H
#define CONFIG_H

// String used to delimit block outputs in the status.
#define DELIMITER ""

// Maximum number of Unicode characters that a block can output.
#define MAX_BLOCK_OUTPUT_LENGTH 45

// Control whether blocks are clickable.
#define CLICKABLE_BLOCKS 0

// Control whether a leading delimiter should be prepended to the status.
#define LEADING_DELIMITER 0

// Control whether a trailing delimiter should be appended to the status.
#define TRAILING_DELIMITER 0

// Define blocks for the status feed as X(icon, cmd, interval, signal).
#define BLOCKS(X)             \
    X("|\x01", "~/.config/dwmblocks/sb-date", 1, 0) \
    X("|\x01", "~/.config/dwmblocks/sb-netbars", 2, 0) \
    X(";|\x02", "~/.config/dwmblocks/sb-battery", 1, 0) \
    X(">\x01", "~/.config/dwmblocks/sb-brightness", 0, 6) \
    X(">\x02", "~/.config/dwmblocks/sb-volume", 0, 1) \
    X(">\x01", "~/.config/dwmblocks/sb-xkeyboard", 0, 7) \
    X(";|\x01", "~/.config/dwmblocks/sb-disk", 0, 0) \
    X("<\x02", "~/.config/dwmblocks/sb-cpubars", 2, 0) \
    X("<\x01", "~/.config/dwmblocks/sb-cputemp", 2, 0) \
    X("<\x02", "~/.config/dwmblocks/sb-ram", 4, 0) \

#endif  // CONFIG_H
