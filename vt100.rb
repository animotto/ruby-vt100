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

  ED_DOWN     = 0 # Clear screen from cursor down
  ED_UP       = 1 # Clear screen from cursor up
  ED_ENTIRE   = 2 # Clear entire screen

  EL_RIGHT    = 0 # Clear line from cursor right
  EL_LEFT     = 1 # Clear line from cursor left
  EL_ENTIRE   = 2 # Clear entire line

  SGR_RESET            = 0
  SGR_BOLD             = 1
  SGR_UNDER            = 4
  SGR_BLINK            = 5
  SGR_REVERSE          = 7
  SGR_STRIKE           = 9
  SGR_NOBOLD           = 21
  SGR_NORMAL           = 22
  SGR_NOUNDER          = 24
  SGR_NOBLINK          = 25
  SGR_NOREVERSE        = 27
  SGR_NOSTRIKE         = 29
  SGR_COLOR_FG_BLACK   = 30
  SGR_COLOR_FG_RED     = 31
  SGR_COLOR_FG_GREEN   = 32
  SGR_COLOR_FG_YELLOW  = 33
  SGR_COLOR_FG_BLUE    = 34
  SGR_COLOR_FG_MAGENTA = 35
  SGR_COLOR_FG_CYAN    = 36
  SGR_COLOR_FG_WHITE   = 37
  SGR_COLOR_FG_ADVANCE = 38
  SGR_COLOR_FG_DEFAULT = 39
  SGR_COLOR_BG_BLACK   = 40
  SGR_COLOR_BG_RED     = 41
  SGR_COLOR_BG_GREEN   = 42
  SGR_COLOR_BG_YELLOW  = 43
  SGR_COLOR_BG_BLUE    = 44
  SGR_COLOR_BG_MAGENTA = 45
  SGR_COLOR_BG_CYAN    = 46
  SGR_COLOR_BG_WHITE   = 47
  SGR_COLOR_BG_ADVANCE = 48
  SGR_COLOR_BG_DEFAULT = 49
  SGR_COLOR_8BIT       = 5
  SGR_COLOR_24BIT      = 2

  ##
  # Creates new VT100 object
  def initialize(out = $stdout)
    @out = out
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
  # Sets graphic rendition
  def sgr(*params)
    write(CSI, params.join(SEP), CSI_SGR)
  end

  ##
  # Sets foreground 8-bit color
  def color8_fg(color)
    write(CSI, SGR_COLOR_FG_ADVANCE, SEP, SGR_COLOR_8BIT, SEP, color, CSI_SGR)
  end

  ##
  # Sets background 8-bit color
  def color8_bg(color)
    write(CSI, SGR_COLOR_BG_ADVANCE, SEP, SGR_COLOR_8BIT, SEP, color, CSI_SGR)
  end

  ##
  # Sets foreground 24-bit color
  def color24_fg(r, g, b)
    write(CSI, SGR_COLOR_FG_ADVANCE, SEP, SGR_COLOR_24BIT, r, SEP, g, SEP, b, CSI_SGR)
  end

  ##
  # Sets background 24-bit color
  def color24_bg(r, g, b)
    write(CSI, SGR_COLOR_BG_ADVANCE, SEP, SGR_COLOR_24BIT, r, SEP, g, SEP, b, CSI_SGR)
  end

  ##
  # Saves cursor position
  def save
    write(CSI, CSI_SCP)
  end

  ##
  # Retores cursor position
  def restore
    write(CSI, CSI_RCP)
  end

  private

  ##
  # Writes data to I/O object
  def write(*data)
    @out.write(data.join)
    @out.flush
  end
end

