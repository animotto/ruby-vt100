require "io/console"

class VT100
  CSI       = "\x1b[" # Control Sequence Introducer
  SEP       = ";"     # Parameters separator

  CSI_CUU   = "A" # Cursor Up
  CSI_CUD   = "B" # Cursor Down
  CSI_CUF   = "C" # Cursor Forward
  CSI_CUB   = "D" # Cursor Back
  CSI_CNL   = "E" # Cursor Next Line
  CSI_CPL   = "F" # Cursor Previous Line
  CSI_CHA   = "G" # Cursor Horizontal Absolute
  CSI_CUP   = "H" # Cursor Position
  CSI_ED    = "J" # Erase Data
  CSI_EL    = "K" # Erase in Line
  CSI_SGR   = "m" # Select Graphic Rendition
  CSI_SCP   = "s" # Save Cursor Position
  CSI_RCP   = "u" # Restore Cursor Position

  CSI_DSR_CUP           = "6n"  # Cursor position
  CSI_DSR_CUP_RESPONSE  = "R"   # Cursor position response

  CSI_CURSOR_HIDE   = "?25l"  # Hide cursor
  CSI_CURSOR_SHOW   = "?25h"  # Show cursor

  ED_DOWN     = 0 # Clear screen from cursor down
  ED_UP       = 1 # Clear screen from cursor up
  ED_ENTIRE   = 2 # Clear entire screen

  EL_RIGHT    = 0 # Clear line from cursor right
  EL_LEFT     = 1 # Clear line from cursor left
  EL_ENTIRE   = 2 # Clear entire line

  A_RESET            = 0
  A_BOLD             = 1
  A_UNDER            = 4
  A_BLINK            = 5
  A_REVERSE          = 7
  A_STRIKE           = 9
  A_NOBOLD           = 21
  A_NORMAL           = 22
  A_NOUNDER          = 24
  A_NOBLINK          = 25
  A_NOREVERSE        = 27
  A_NOSTRIKE         = 29
  A_COLOR_FG         = 30
  A_COLOR_BG         = 40
  A_COLOR_8BIT       = 5
  A_COLOR_24BIT      = 2

  C_BLACK   = 0
  C_RED     = 1
  C_GREEN   = 2
  C_YELLOW  = 3
  C_BLUE    = 4
  C_MAGENTA = 5
  C_CYAN    = 6
  C_WHITE   = 7
  C_ADVANCE = 8
  C_DEFAULT = 9

  ##
  # Creates new VT100 object
  def initialize(stdin = $stdin, stdout = $stdout)
    @stdin = stdin
    @stdout = stdout
  end

  ##
  # Moves cursor up
  def move_up(pos = 1)
    write(CSI, pos, CSI_CUU)
  end

  ##
  # Moves cursor down
  def move_down(pos = 1)
    write(CSI, pos, CSI_CUD)
  end

  ##
  # Moves cursor forward
  def move_forward(pos = 1)
    write(CSI, pos, CSI_CUF)
  end

  ##
  # Moves cursor back
  def move_back(pos = 1)
    write(CSI, pos, CSI_CUB)
  end

  ##
  # Moves cursor next line
  def move_next_line(line = 1)
    write(CSI, line, CSI_CNL)
  end

  ##
  # Moves cursor previous line
  def move_prev_line(line = 1)
    write(CSI, line, CSI_CPL)
  end

  ##
  # Moves cursor in column
  def move_to_col(col)
    write(CSI, col, CSI_CHA)
  end

  ##
  # Moves cursor in position
  def move_to(row, col)
    write(CSI, row, SEP, col, CSI_CUP)
  end

  ##
  # Moves cursor to upper left corner
  def move_to_home
    write(CSI, CSI_CUP)
  end

  ##
  # Clears entire screen
  def clear_screen
    write(CSI, ED_ENTIRE, CSI_ED)
  end

  ##
  # Clears entire line
  def clear_line
    write(CSI, EL_ENTIRE, CSI_EL)
  end

  ##
  # Sets attributes
  def attr(*attrs)
    write(CSI, attrs.join(SEP), CSI_SGR)
  end

  ##
  # Sets foreground color
  def color_fg(color)
    write(CSI, A_COLOR_FG + color, CSI_SGR)
  end

  ##
  # Sets background color
  def color_bg(color)
    write(CSI, A_COLOR_BG + color, CSI_SGR)
  end

  ##
  # Sets foreground 8-bit color
  def color8_fg(color)
    write(CSI, A_COLOR_FG_ADVANCE, SEP, A_COLOR_8BIT, SEP, color, CSI_SGR)
  end

  ##
  # Sets background 8-bit color
  def color8_bg(color)
    write(CSI, A_COLOR_BG_ADVANCE, SEP, A_COLOR_8BIT, SEP, color, CSI_SGR)
  end

  ##
  # Sets foreground 24-bit color
  def color24_fg(r, g, b)
    write(CSI, A_COLOR_FG_ADVANCE, SEP, A_COLOR_24BIT, r, SEP, g, SEP, b, CSI_SGR)
  end

  ##
  # Sets background 24-bit color
  def color24_bg(r, g, b)
    write(CSI, A_COLOR_BG_ADVANCE, SEP, A_COLOR_24BIT, r, SEP, g, SEP, b, CSI_SGR)
  end

  ##
  # Saves cursor position
  def cursor_save
    write(CSI, CSI_SCP)
  end

  ##
  # Retores cursor position
  def cursor_restore
    write(CSI, CSI_RCP)
  end

  ##
  # Hides cursor
  def cursor_hide
    write(CSI, CSI_CURSOR_HIDE)
  end

  ##
  # Shows cursor
  def cursor_show
    write(CSI, CSI_CURSOR_SHOW)
  end

  ##
  # Gets cursor position
  def pos
    data = String.new
    @stdin.raw do
      write(CSI, CSI_DSR_CUP)
      while data != CSI do
        data << read
      end
      data.clear
      while (char = read) != CSI_DSR_CUP_RESPONSE
        data << char
      end
    end
    return data.split(";", 2).map(&:to_i)
  end

  ##
  # Gets terminal size
  def size
    save
    move_to(999, 999)
    row, col = pos
    restore
    return row, col
  end

  ##
  # Reads data from I/O object
  def read
    @stdin.readchar
  end

  ##
  # Writes data to I/O object
  def write(*data)
    @stdout.write(data.join)
    @stdout.flush
  end
end

